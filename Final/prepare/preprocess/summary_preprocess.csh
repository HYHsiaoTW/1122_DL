#!/bin/tcsh 
# summary_preprocess.csh
# summary preprocess of all subjects, showing TR censored and more.
# version: 1b
# updated: 20230906
# created: 20230430
# written by Der-Yow Chen
################################################
# Change log:
#   20230906, 1b: set preprocess dir
#   20230430, 1a: basic output.
################################################
#Variable Definition
set preprocess_dir='../../preprocess/subject_results/group.all'
set summary_file="summary_result.txt"
set header="subj_ID, TR_censored, censor_fraction, TR_total_origin, TR_total_censored, template_dice_coef, EPI_dice_coef"
set temp_file=tmp.txt

############
# Initialize summary file 
rm -f $summary_file $temp_file

# Find out.ss_review.<subj>.txt for all subjects
set file_list=`find $preprocess_dir -name "out.ss_review.*.txt"`

# loop for each subject
foreach subj_review_file ($file_list)
  # set subj_review_file="./subject_results/group.all/sub-m41B/sub-m41B.results/out.ss_review.sub-m41B.txt"
  set subj_ID=`cat $subj_review_file | grep "subject ID" | cut -d- -f2`
  set TR_censored=`cat $subj_review_file | grep "TRs censored" | cut -d: -f2`
  set censor_fraction=`cat $subj_review_file | grep "censor fraction" | cut -d: -f2`
  set TR_total_origin=`cat $subj_review_file | grep "TRs total (uncensored)" | cut -d: -f2`
  set TR_total_censored=`cat $subj_review_file | grep "TRs total     " | cut -d: -f2`
  set EPI_dice_coef=`cat $subj_review_file | grep "anat/EPI mask Dice coef" | cut -d: -f2`
  set template_dice_coef=`cat $subj_review_file | grep "anat/templ mask Dice coef" | cut -d: -f2`
  
  #######################
  #echo subj_ID = $subj_ID
  #echo TR_censored = $TR_censored
  #echo censor_fraction = $censor_fraction
  #echo TR_total_origin = $TR_total_origin
  #echo TR_total_censored = $TR_total_censored
  #echo EPI_dice_coef = $EPI_dice_coef
  #echo template_dice_coef = $template_dice_coef
  
  #######################
  printf "%s, %4d, %6.4f, %s, %s, %6.4f, %6.4f\n" \
    ${subj_ID} ${TR_censored} ${censor_fraction} ${TR_total_origin} ${TR_total_censored} ${template_dice_coef} ${EPI_dice_coef}\
    >> $temp_file
end

# Sort and add header
echo $header > $summary_file
sort $temp_file >> $summary_file
rm -f $temp_file
cat $summary_file


