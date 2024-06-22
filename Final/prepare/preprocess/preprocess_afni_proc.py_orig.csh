#!/bin/tcsh -xef
# preprocess_afni_proc.py.csh 
# prepocessing using afni_proc.py for multiple subjects
# version: 1g
# updated: 20230930
# created: 20210701
# written by Der-Yow Chen
# usage example:
#   tcsh preprocess_afni_proc.py.csh -subj sub-007 |& tee output.preprocess.sub-007.txt
#   tcsh preprocess_afni_proc.py.csh -subj sub-007 -config preprocess_config.json |& tee output.preprocess.sub-007.txt
################################################
# Change log:
#   20230930, 1g: check duplicated T1w
#   20230905, 1f: automatic slice timing, and deoblique afterwards.
#   20210706, 1e: fix bug for modified date.
#   20210705, 1d: rename existing subject directory accroding to it's last modified dated.
################################################
#Variable Definition
# default values:
set subj=$1
set json_config_file=preprocess_config.json
set out_dir=outputs
set align_option_file=align_options_${subj}.json
set preprocess1_dir=preprocess_step1 # tshift & deoblique

# Parsing arguments for subject and JSON config
if ( $# == 0 ) then
  echo "Using default subject: ${subj}" 
  echo "  and default config: $json_config_file"
  echo "If you want to use other subject or config file, please run:"
  echo "  $0 -subj <subj> -config <config_file>  -align_opt <align_option_file>"
else
  set Narg = $#
  set cnt = 1
  while ($cnt <= $Narg)
    set donext = 1
    if ($donext && "$argv[$cnt]" == "-subj") then
      set pLoc = $cnt      
      if ($pLoc >= $Narg) then
         echo "Need subject after -subj"
         exit(-1)
      else
         @ cnt ++
         set subj = ($argv[$cnt])
         set donext = 0   
      endif
    endif
    if ($donext && "$argv[$cnt]" == "-config") then
      set pLoc = $cnt      
      if ($pLoc >= $Narg) then
         echo "Need config file after -config"
         exit(-1)
      else
         @ cnt ++
         set json_config_file = ($argv[$cnt])
         set donext = 0   
      endif
    endif
    if ($donext && "$argv[$cnt]" == "-align_opt") then
      set pLoc = $cnt      
      if ($pLoc >= $Narg) then
         echo "Need align_option file after -align_opt"
         exit(-1)
      else
         @ cnt ++
         set align_option_file = ($argv[$cnt])
         set donext = 0   
      endif
    endif
    if ($donext == 1) then
      echo "Error: Option or parameter '$argv[$cnt]' not understood"
      exit(-1)
    endif
    @ cnt ++   
  end
endif

# Check if jq exist or not. jq is a tool to parse JSON file.
if ( `where jq` == "") then
  echo "jq does not exist!"
  echo "please install jq to parse JSON file. For example, in debian/ubuntu:"
  echo "  sudo apt-get install jq"
  exit
endif

################################################
# Read Variable Definition from JSON config file
# simple variables
foreach key (`jq '. | keys | .[]' -r $json_config_file`)
  set value=`jq -r ".${key}" $json_config_file`
  eval "set ${key}='${value}'"
  #echo $key = $value
end

# read array variables
set array_variables_list = ( func_list)
foreach array_var ($array_variables_list)
  set tmp_list=()
  foreach item (`jq -r .${array_var}'[]' $json_config_file`)
    set tmp_list = ( $tmp_list:q $item )
  end 
  eval "set ${array_var}='${tmp_list}'"
end

if ( -f $align_option_file ) then
  foreach key (`jq '. | keys | .[]' -r $align_option_file`)
    set value=`jq -r ".${key}" $align_option_file`
    eval "set ${key}='${value}'"
    #echo $key = $value
  end
else
  echo "no align_option_file: $align_option_file"
endif

# Display list variables for debug
# foreach item ($func_list)
#    echo $item
# end

#########################################
# Start time 
set script_start_time=`date`
echo "Script Execution started: $script_start_time"

###############################################
# Preprocess Step 1: for slice timing & de-oblique
# make preprocess step1 directory 
set curr_dir=`pwd`
set step1_dir=${root_dir}/${preprocess_dir}/${preprocess1_dir}/${subj}
if ( -d $step1_dir ) then
  echo "preprocess step1 directory (for slice timing & de-oblique) already exists! "
  set modified_date=`date  -r ${step1_dir} +%Y%m%d_%H%M%S`
  set step1_dir_old=${step1_dir}_${modified_date}
  echo "It will be renamed to ${step1_dir_old}"
  mv ${step1_dir} ${step1_dir_old}
endif
mkdir -p $step1_dir
cd $step1_dir
mkdir anat
mkdir func

#####################
# check if anat file exists, or duplated.
cd ${nii_Rawdata_dir}/${subj}/anat
if (! -f ${subj}_${anat_suffix} ) then
  # use the last serial number (sn) as the anat file
  set last_anat_file=`ls -v *[0-9].nii.gz | tail -n 1`  # -v: natural sort order
  if ("$last_anat_file" == "") then
    echo "[Error]: no anatomy files exists!"
    exit -1
  else  
    ln -s $last_anat_file ${subj}_${anat_suffix} 
  endif
endif

#####################
# de-oblique anatomy
cd $step1_dir/anat
3dWarp -deoblique -prefix ${subj}_${anat_suffix} ${nii_Rawdata_dir}/${subj}/anat/${subj}_${anat_suffix}

#####################
# extract EPI slice timing infomation from JSON file
cd $step1_dir/func
set func_json_file=`ls ${nii_Rawdata_dir}/${subj}/func/*.json | head -n 1`
abids_json_tool.py -json2txt -input $func_json_file -prefix junk.txt
grep SliceTiming junk.txt | sed -e 's/^SliceTiming *://' > SliceTimes.1D
rm -f junk.txt

# slice timing & de-oblique of EPI
set tmp_file1=__tmp1.nii.gz
set tmp_file2=__tmp2.nii.gz
foreach func_name ( $func_list )
  rm -f $tmp_file1 $tmp_file2
  set func_file=${nii_Rawdata_dir}/${subj}/func/${subj}_${func_name} 
  3dcopy $func_file $tmp_file1

  # write slice timing info to header
  3drefit -Tslices `cat SliceTimes.1D` $tmp_file1

  # slice timing correction
  3dTshift -prefix $tmp_file2 $tmp_file1

  # deoblique
  3dWarp -deoblique -prefix ${subj}_${func_name}  $tmp_file2
end
rm -f $tmp_file1 $tmp_file2
cd $curr_dir

###############################################
# Preprocess Step 2: using afni_proc.py
# make target directory
#set curr_dir=`pwd`
set group=${defualt_group}
set target_dir=${root_dir}/${preprocess_dir}/subject_results/group.${group}/${subj}
#echo $target_dir
if ( -d $target_dir ) then
  echo "Target directory already exists! "
  set modified_date=`date  -r ${target_dir} +%Y%m%d_%H%M%S`
  set target_dir_old=${target_dir}_${modified_date}
  echo "It will be renamed to ${target_dir_old}"
  mv ${target_dir} ${target_dir_old}
endif
mkdir -p $target_dir
cd $target_dir
 
# check if target afni_proc.py script exists or not.
set afni_proc_script=cmd.ap.${subj}
set overwrite='y'
if ( -f $afni_proc_script ) then
  echo "afni_proc.py script exist. Do you want to overwrite it? (y:yes, others: no)"
  set overwrite = $<
  if ( $overwrite == 'y') then
    echo "overwrite file!"
    rm $afni_proc_script
  else
    echo "rename original file to ${afni_proc_script}_old"
    mv $afni_proc_script ${afni_proc_script}_old
  endif
endif

# prepare special characters
set lc="{"
set rc="}"
set dollar=\$

##########################################
# make target afni_proc.py script
touch $afni_proc_script
echo '#\!/usr/bin/env tcsh' > $afni_proc_script
echo "" >> $afni_proc_script
echo "# to execute via tcsh:" >> $afni_proc_script
echo "#    tcsh cmd.ap.${subj} |& tee output.cmd.ap.${subj}" >> $afni_proc_script
echo "" >> $afni_proc_script
echo "# to execute via bash:" >> $afni_proc_script
echo "#    tcsh -xef cmd.ap.${subj} 2>&1 | tee output.cmd.ap.${subj}" >> $afni_proc_script
echo "" >> $afni_proc_script
echo "# created by $0" >> $afni_proc_script
set creation_time=`date`
echo "# creation date: ${creation_time}"  >> $afni_proc_script
echo "" >> $afni_proc_script
echo "# set subject and group identifiers" >> $afni_proc_script
echo "set subj  = ${subj}" >> $afni_proc_script
echo "set gname = ${group}" >> $afni_proc_script
echo "" >> $afni_proc_script
echo "# set data directories" >> $afni_proc_script
echo "set top_dir = ${step1_dir}" >> $afni_proc_script
#echo "set top_dir = ${nii_Rawdata_dir}/${subj}" >> $afni_proc_script
echo 'set anat_dir  = $top_dir/anat' >> $afni_proc_script
echo 'set epi_dir   = $top_dir/func' >> $afni_proc_script
echo "" >> $afni_proc_script
echo '# run afni_proc.py to create a single subject processing script' >> $afni_proc_script
echo 'afni_proc.py -subj_id $subj                                       \' >> $afni_proc_script
echo '        -script proc.$subj -scr_overwrite                         \' >> $afni_proc_script
echo '        -blocks align tlrc volreg blur mask scale regress  \' >> $afni_proc_script
#echo '        -blocks tshift align tlrc volreg blur mask scale regress  \' >> $afni_proc_script
echo "        -copy_anat ${dollar}${lc}anat_dir${rc}/${dollar}${lc}subj${rc}_${anat_suffix} \\" >> $afni_proc_script
echo '        -dsets                                                    \' >> $afni_proc_script

# prepare functional datasets
foreach func_name ( $func_list )
   echo "            ${dollar}${lc}epi_dir${rc}/${subj}_${func_name} \\" >> $afni_proc_script
end

echo "        -tcat_remove_first_trs ${dummy_scans}                                  \\" >> $afni_proc_script
echo "        -align_epi_strip_method ${epi_strip}                   \\" >> $afni_proc_script
echo "        -align_opts_aea -cost ${cost}  ${other_align_opt}             \\" >> $afni_proc_script
if ( "${move}" != "-normal_move"  ) then
  echo "                       ${move}              \\" >> $afni_proc_script
endif



echo "        -tlrc_base ${template}                  \\" >> $afni_proc_script
echo '        -tlrc_opts_at -OK_maxite -init_xform AUTO_CENTER -warp_orig_vol \' >> $afni_proc_script

echo "        -volreg_base_ind ${volreg_base_dset_no} ${volreg_base}  \\" >> $afni_proc_script
echo '        -volreg_align_e2a                                         \' >> $afni_proc_script
echo '        -volreg_tlrc_warp                                         \' >> $afni_proc_script

echo "        -blur_size ${blur_size}                                            \\" >> $afni_proc_script
echo "        -regress_censor_motion ${censor_motion}                                \\" >> $afni_proc_script
echo '        -regress_motion_per_run                                   \' >> $afni_proc_script
echo '        -regress_est_blur_epits                                   \' >> $afni_proc_script
echo '        -regress_est_blur_errts' >> $afni_proc_script

################################################
# execute afni_proc.py script
if ( -f cmd.ap.${subj} ) then
  echo "################################################"
  echo "Execute afni_proc.py script: cmd.ap.${subj}"
  tcsh cmd.ap.${subj} |& tee output.cmd.ap.${subj}
else
  echo "Error: cmd.ap.${subj} was not created. Please check parameters & files."
endif

################################################
# execute proc script
if ( -f proc.${subj} ) then
  echo "################################################"
  echo "Execute afni_proc.py script: cmd.ap.${subj}"
  tcsh proc.${subj} |& tee output.proc.${subj}
else
  if ( -f cmd.ap.${subj} ) then
    echo "Error: proc.${subj} was not created. Please check parameters & files."
  else
    echo "       therefore no proc.${subj} was created."
  endif
endif

################################################
cd $curr_dir
echo "============================================="
echo 'Finished!'
echo "Script Execution started: $script_start_time"
echo "       Execution end    : `date`"