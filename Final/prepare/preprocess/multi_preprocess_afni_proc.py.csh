#!/bin/tcsh -xef
# multi_preprocess_afni_proc.py.csh 
# prepocessing using afni_proc.py for multiple subjects
# version: 1b
# updated: 20210703
# created: 20210701
# written by Der-Yow Chen
# usage example:
#   tcsh multi_preprocess_afni_proc.py.csh -subject_list subject_list.json -config preprocess_config.json -align_opt ../align_test/summary/align_options.json
################################################
# Change log:
#   
################################################
#Variable Definition
# default values:
set preprocess_1subj_script=preprocess_afni_proc.py.csh
set json_config_file=preprocess_config.json
set json_subject_list_file=subject_list.json
set align_option_file=align_options.json
#set align_option_file=../align_test/summary/align_options.json
set out_dir=outputs

# Parsing arguments for subject and JSON config
if ( $# == 0 ) then
  echo "Using default subject list: ${json_subject_list_file}" 
  echo "  and default config: $json_config_file"
  echo "If you want to use other subject or config file, please run:"
  echo "  $0 -subject_list <subj> -config <config_file>  -align_opt <align_option_file>"
else
  set Narg = $#
  set cnt = 1
  while ($cnt <= $Narg)
    set donext = 1
    if ($donext && "$argv[$cnt]" == "-subject_list") then
      set pLoc = $cnt      
      if ($pLoc >= $Narg) then
         echo "Need subject after -subj_list"
         exit(-1)
      else
         @ cnt ++
         set json_subject_list_file = ($argv[$cnt])
         set donext = 0   
      endif
    endif
    if ($donext && "$argv[$cnt]" == "-config") then
      set pLoc = $cnt      
      if ($pLoc >= $Narg) then
         echo "Need subject after -config"
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
# Read subject list from JSON subject list file
################################################
set subject_list=()
foreach subj (`jq -r '.subject_list[]' $json_subject_list_file`)
	set subject_list = ( $subject_list $subj ) 
end

######################################
if ( -d $out_dir ) then
    echo "output dir already exists! Don't have to create again." 
else
    mkdir -p $out_dir
endif

if ( -f $json_config_file ) then
  echo "config using $json_config_file"
else
  echo "config file: $json_config_file does not exist. Please check again."
  exit
endif

if ( -f $align_option_file ) then
  echo "align options will be retrieved from: $align_option_file"
  set search_align_opt=1
else
  echo "align option file: $align_option_file does not exist."
  echo "      Defualt values in config file $json_config_file will be used."
  set search_align_opt=0
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



#####################################
foreach subj ($subject_list)
  echo "###########################################################"
  echo Start ${subj}:
  if ( $search_align_opt ) then
    set found_subj_align_opt=0
    grep $subj $align_option_file > align_option_${subj}.json
    if ( -z align_option_${subj}.json ) then
      echo "subject $subj cannot be found in ${align_option_file}."
      echo "      Defualt values in config file $json_config_file will be used."
      rm align_option_${subj}.json
    else
      echo "subject $subj specific options were found in ${align_option_file}."
      set found_subj_align_opt=1
    endif
  endif 

  tcsh -xef $preprocess_1subj_script                \
              -subj $subj                           \
              -config $json_config_file             \
              -align_opt align_option_${subj}.json  \
       |& tee ${out_dir}/output.preprocess.${subj}.txt

  # move align option file to subject's directory      
  if ( $found_subj_align_opt ) then
    echo "move align_option_${subj}.json to subject directory."
    mv align_option_${subj}.json ${root_dir}/${preprocess_dir}/subject_results/group.${defualt_group}/${subj}
  endif
end

