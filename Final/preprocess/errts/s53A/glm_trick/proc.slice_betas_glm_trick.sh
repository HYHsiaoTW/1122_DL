#!/bin/bash
# proc.beta_series.sample
#   hyhsiao, 2024/05/06 Created.
#####################################################

cd ../
subj=$(basename "$(pwd)")

cd ./glm_trick

raw_dataset="stats.beta_cond.$subj+tlrc"
3dcalc -a stats.glm_trick1.$subj+tlrc -b ../../group_mask+given+tlrc -expr 'a*b' -prefix rm.stats.glm_trick1.$subj+mask
3dcalc -a stats.glm_trick2.$subj+tlrc -b ../../group_mask+given+tlrc -expr 'a*b' -prefix rm.stats.glm_trick2.$subj+mask
3dcalc -a stats.glm_trick3.$subj+tlrc -b ../../group_mask+given+tlrc -expr 'a*b' -prefix rm.stats.glm_trick3.$subj+mask
3dcalc -a stats.glm_trick4.$subj+tlrc -b ../../group_mask+given+tlrc -expr 'a*b' -prefix rm.stats.glm_trick4.$subj+mask
3dcalc -a stats.glm_trick5.$subj+tlrc -b ../../group_mask+given+tlrc -expr 'a*b' -prefix rm.stats.glm_trick5.$subj+mask


for (( ii=1; ii<6; ii++ )); do
	input_file="rm.stats.glm_trick$ii.$subj+mask+tlrc"
	echo "$input_file"

	# Extract labels of the sub-bricks
	labels_string=$(3dinfo -label $input_file)

	# Split the labels string into an array using '|' as the delimiter
	IFS='|' read -r -a labels <<< "$labels_string"

	# Get the total number of sub-bricks
	num_bricks=$(3dinfo -nv $input_file)

	echo "$labels"

	# Check if labels and number of sub-bricks are consistent
	if [ ${#labels[@]} -ne $num_bricks ]; then
	  echo "Number of labels (${#labels[@]}) does not match number of sub-bricks ($num_bricks)"
	  exit 1
	fi

	# Loop through each sub-brick
	for (( i=1; i<$num_bricks; i++ )); do
	  # Get the label of the sub-brick
	  label="${labels[$i]}"
	  
	  # Remove the "#0_Coef" suffix from the label
	  sanitized_label=$(echo "$label" | sed 's/_Coef//')

	  # Replace spaces with underscores in the label (if any)
	  sanitized_label=$(echo "$sanitized_label" | tr ' ' '_')
	  sanitized_label=$(echo "$sanitized_label" | tr '#' '_')
	  sanitized_label=$(echo "$subj+beta+$sanitized_label")
	  
	  # Define the output filename using the label
	  output_file="${sanitized_label}+tlrc"

	  # Use 3dbucket to save the sub-brick into a new file
	  3dbucket -prefix "$output_file" "${input_file}[$i]"
	done
done

echo "All sub-bricks have been extracted and saved."

rm rm.stats.glm_trick*
