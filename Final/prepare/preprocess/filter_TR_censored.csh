#!/bin/tcsh 
# filter_TR_censored.csh
# Filter TR_censored greater than criterion in summary_result.txt.
# version: 1a
# updated: 20230502
# created: 20230501
# written by Der-Yow Chen
################################################
#Variable Definition
set summary_file="summary_result.txt"
set header="subj_ID, TR_censored, censor_fraction, TR_total_origin, TR_total_censored, template_dice_coef, EPI_dice_coef"
set criterion=100
set TR_censored_file="TR_censored_${criterion}.txt"

############
# remove header in summary file
tail -n +2 $summary_file > tmp1.txt

# TR_censored is column 2, filter if this column is greater than criterion
awk -F, -v OFS=, -v crit="$criterion" '$2 > crit' tmp1.txt  > tmp2.txt

# Sort and add header
echo $header > $TR_censored_file
sort -k 2 -r tmp2.txt >> $TR_censored_file
set num_subj=`cat tmp2.txt | wc -l`
echo Number of subjects: $num_subj
cat $TR_censored_file

rm -f tmp?.txt