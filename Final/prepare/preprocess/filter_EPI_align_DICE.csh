#!/bin/tcsh 
# filter_EPI_align_DICE.csh
# Filter EPI/Anatomy alignment DICE coefficient less than criterion in summary_result.txt.
# version: 1a
# updated: 20230502
# created: 20230501
# written by Der-Yow Chen
################################################
#Variable Definition
set summary_file="summary_result.txt"
set header="subj_ID, TR_censored, censor_fraction, TR_total_origin, TR_total_censored, template_dice_coef, EPI_dice_coef"
set criterion=0.8
set EPI_DICE_file="EPI_align_DICE_${criterion}.txt"

############
# remove header in summary file
tail -n +2 $summary_file > tmp1.txt

# EPI/Anatomy alignment DICE coefficient is column 7
#    filter if this column is less than criterion.
awk -F, -v OFS=, -v crit="$criterion" '$7 < crit' tmp1.txt > tmp2.txt

# Sort and add header
echo $header > $EPI_DICE_file
sort -k 7 tmp2.txt >> $EPI_DICE_file
set num_subj=`cat tmp2.txt | wc -l`
echo Number of subjects: $num_subj
cat $EPI_DICE_file

rm -f tmp?.txt