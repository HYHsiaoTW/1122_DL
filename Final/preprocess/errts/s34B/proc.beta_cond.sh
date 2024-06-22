#!/bin/bash
# proc.beta.sample
#   hyhsiao, 2024/06/10 Created.
#####################################################

# run the regression analysis
subj=$(basename "$(pwd)")

# Find all 1D files in the current directory
stim_files=($(ls co*.1D))

# Initialize variables for the 3dDeconvolve command
num_stimts=${#stim_files[@]}
stim_times=""
stim_labels=""
index=1

# Loop through each 1D file to construct the command parameters
for file in "${stim_files[@]}"; do
    label=$(basename "$file" .1D)
    stim_times+=" -stim_times $index $file 'BLOCK(3,1)'"
    stim_labels+=" -stim_label $index $label"
    ((index++))
done

# Construct the 3dDeconvolve command
command="3dDeconvolve \\
    -input ${subj}+errts+tlrc \\
    -censor ${subj}+motion_censor.1D \\
    -polort 0 \\
    -num_stimts $num_stimts \\
    $stim_times \\
    $stim_labels \\
    -x1D X.beta_cond.xmat.1D -xjpeg X.beta_cond.jpg \\
    -x1D_uncensored X.nocensor.xmat.1D \\
    -bucket stats.beta_cond.$subj"

# Print and execute the command
echo "Executing command:"
echo "$command"
eval "$command"
