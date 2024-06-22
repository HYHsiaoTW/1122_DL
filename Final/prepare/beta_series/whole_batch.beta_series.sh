#!/bin/bash
# whole_batch.beta_series
#   hyhsiao, 2024/05/06 Created.
#####################################################
# Variable definition
sample_path=/media/sf_D_DRIVE/1122_DeepLearning/Final/prepare/scripts/beta_series
target_path=/media/sf_D_DRIVE/1122_DeepLearning/Final/preprocess/errts
# sample_path=D:/1122_DeepLearning/Final/prepare/scripts/beta_series
# target_path=D:/1122_DeepLearning/Final/preprocess/errts

./proc.group_mask

cd $target_path

# mkdir $target_path/collect
# mkdir $target_path/collect/regressor_mat
# mkdir $target_path/collect/beta_maps
# mkdir $target_path/collect/beh_info

folder_list=(s*)

for filelist in "${folder_list[@]}";
do
	cd $filelist
	
	# cp $filelist+beh_infos.csv ../collect/beh_info/
	
	rm stats.$filelist+tlrc.*
	
	echo "Preparing beta series with 3dDeconvolve"
	# cp "$sample_path/proc.beta_series.sample.sh" "./proc.beta_series.sh"
	# ./proc.beta_series.sh
	cp "$sample_path/proc.beta_cond.sample.sh" "./proc.beta_cond.sh"
	./proc.beta_cond.sh
	echo "3dDeconvolve for $filelist is Done!"
	
	# cp X.beta_series.jpg ../collect/regressor_mat/$filelist+X.beta_series.jpg
	cp X.beta_cond.jpg ../collect/regressor_mat/$filelist+X.beta_cond.jpg
	
	rm *+beta+event_*
	
	echo "Slicing beta series BRIK"
	# cp "$sample_path/proc.slice_betas_series.sample.sh" "./proc.slice_betas_series.sh"
	# ./proc.slice_betas_series.sh
	cp "$sample_path/proc.slice_betas_cond.sample.sh" "./proc.slice_betas_cond.sh"
	./proc.slice_betas_cond.sh
	echo "Beta maps of $filelist is all dumped!"
	
	# echo "Compressing beta series BRIKs"
	# zip $filelist+beta_maps.zip *+beta+event_*
	# echo "Compression is done!"
	
	# mv $filelist+beta_maps.zip ../collect/beta_maps/
	
	
	cd ../
done

