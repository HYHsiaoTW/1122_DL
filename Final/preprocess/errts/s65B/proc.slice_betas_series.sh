#!/bin/bash
# proc.beta_series.sample
#   hyhsiao, 2024/05/06 Created.
#####################################################

# run the regression analysis
subj=$(basename "$(pwd)")

raw_dataset="stats.beta_series.$subj+tlrc"
3dcalc -a $raw_dataset -b ../group_mask+given+tlrc -expr 'a*b' -prefix rm.stats.beta_series.$subj+mask

source_dataset="rm.stats.beta_series.$subj+mask+tlrc"

# Get the number of sub-bricks in the dataset
# num_subbricks=$(3dinfo -nv ${source_dataset})
num_subbricks=336

# Loop through each sub-brick
for (( i=1; i<${num_subbricks}+1; i++ ))
do
  # Define the prefix for the output dataset
  output_prefix="${subj}+beta+event_$(printf "%03d" $i)"

  # Use 3dbucket to extract each sub-brick into a new dataset
  3dbucket -prefix ${output_prefix} ${source_dataset}"[${i}]"

  # echo "Extracted sub-brick $i into ${output_prefix}+orig.BRIK"
done

echo "All sub-bricks have been extracted into separate files."

rm rm.stats.beta_series.$subj+mask+tlrc.*