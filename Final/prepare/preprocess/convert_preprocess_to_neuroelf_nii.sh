#!/bin/bash
# convert_preprocess_to_neuroelf.nii.sh
#   This script convert preprocessed afni files to NII.gz format,
#      which could be used in neuroelf.
#   There were resampled into 57x67x53 matrix size 
#      using a bound_box file as template/master.
# version: 1c
# updated: 20230521
# created: 20210510
# written by Der-Yow Chen
##########################################################
# Variables
preprocess_root_dir=/media/Data_10TB/fMRI/VolleyB/preprocess
preprocess_subject_results_dir=${preprocess_root_dir}/subject_results/group.all
converted_target_dir=${preprocess_root_dir}/preprocessed_nii

bound_box_file=${preprocess_root_dir}/EPI_57x67x53_box.nii
temp_file=__tt_temp+tlrc
TR=2

player_list="A B C"

##########################################################
# Check if match list file is given as argument
if [ $# -ne 0  ]; then
    match_list_file=$1
else
    echo "Usage: \"$0 <match_list_file> \"";
    exit
fi

##########################################################
# create target dir if not exist
[ -d ${converted_target_dir} ] || mkdir -p ${converted_target_dir}

# for each match, for each player
while read match_ID; do 
  for player in $player_list ; do    
    # skip empty lines in match_list_file
    if [ -z "$match_ID" ]; then continue; fi

    # prepare variables for the subject
    subj_ID=m${match_ID}${player}
    subj_preprocessed_dir=${preprocess_subject_results_dir}/sub-${subj_ID}/sub-${subj_ID}.results
    
    converted_target_subj_dir=${converted_target_dir}/sub-${subj_ID}
    [ -d ${converted_target_subj_dir} ] || mkdir -p ${converted_target_subj_dir}
    cd ${converted_target_subj_dir}
    
    # Anatomical image
    anat_file=anat_final.sub-${subj_ID}
    3dbucket -prefix ${anat_file}.nii.gz  ${subj_preprocessed_dir}/${anat_file}+tlrc
    
    mask_file=${subj_preprocessed_dir}/full_mask.sub-${subj_ID}+tlrc
    # Functional runs
    for run_id in {1..6}; do
      afni_preprocessed_file=${subj_preprocessed_dir}/pb04.sub-${subj_ID}.r0${run_id}.scale+tlrc
      converted_target_file=${converted_target_subj_dir}/pb04.sub-${subj_ID}.r0${run_id}.scale.nii.gz
        
      # masking
      3dcalc -prefix ${temp_file} \
          -a ${afni_preprocessed_file}  -b ${mask_file} \
          -expr 'a*step(b)' 
      
      # modify TR (header info)
      3drefit -TR ${TR} ${temp_file} 
      
      # resample to bound_box, and convert to nii
      3dresample -prefix ${converted_target_file} -master ${bound_box_file} \
           -input ${temp_file}
      
      # delete temp file
      rm -f ${temp_file}.*
    done

  done  # end of each player(ABCD)
done < $match_list_file

###################
echo "Finished!"
