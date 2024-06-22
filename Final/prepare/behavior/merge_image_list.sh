#!/bin/bash
# whole_batch.beta_series
#   hyhsiao, 2024/05/06 Created.
#####################################################
# Variable definition
target_path=/media/sf_D_DRIVE/1122_DeepLearning/Final/preprocess/errts
model_path=/media/sf_D_DRIVE/1122_DeepLearning/Final/models/ConvNeXt/full

##### train
cd $target_path
folder_list=(s*/full+train.txt)
echo $folder_list

cd $model_path

# Define the output file
output_file="full+train.txt"

# Empty the output file if it exists, or create it if it doesn't
> "$output_file"

for filelist in "${folder_list[@]}";
do
	# Append the contents of the current file to the output file
	cat "$target_path/$filelist" >> "$output_file"
done

echo "All files have been merged into $output_file"


##### val
cd $target_path
folder_list=(s*/full+val.txt)
echo $folder_list

cd $model_path

# Define the output file
output_file="full+val.txt"

# Empty the output file if it exists, or create it if it doesn't
> "$output_file"

for filelist in "${folder_list[@]}";
do
	# Append the contents of the current file to the output file
	cat "$target_path/$filelist" >> "$output_file"
done

echo "All files have been merged into $output_file"