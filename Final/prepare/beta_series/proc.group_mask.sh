#!/bin/bash
# proc.group_mask
#   hyhsiao, 2024/06/06 Created.
#####################################################
# Variable definition
sample_path=/media/sf_D_DRIVE/1122_DeepLearning/Final/prepare/scripts/beta_series
target_path=/media/sf_D_DRIVE/1122_DeepLearning/Final/preprocess/errts
# sample_path=D:/1122_DeepLearning/Final/prepare/scripts/beta_series
# target_path=D:/1122_DeepLearning/Final/preprocess/errts

# Apply threshold to create group mask (e.g., include voxels present in at least 50% of subjects)
threshold = 0.8
voxel_expand = 0

cd $target_path

# List of individual mask files (replace with your actual files)
individual_masks=(s*/s*+mask+tlrc.HEAD)

# Sum individual masks
3dMean -prefix group_sum_mask "${individual_masks[@]}"

3dcalc -a group_sum_mask+tlrc -expr "step(a - $threshold)" -prefix group_mask

# Expand the group mask by 1 voxel
3dmask_tool -input group_mask+tlrc -dilate_inputs $voxel_expand -prefix group_mask_expanded

echo "Expanded group mask created: group_mask_expanded+tlrc"

