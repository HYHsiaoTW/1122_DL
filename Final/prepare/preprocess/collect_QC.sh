#!/bin/bash
# collect_errts.sh
#   modified and rename for OTCG OpenNeuro data by hyhsiao, 2024/04/26
#   ver. 1a1 update: 2023/09/05 for PGG
#   Der-Yow Chen, 2023/4/29 Created.
#####################################################
# Variable definition
data_path=/media/sf_D_DRIVE/1122_DeepLearning/Final/preprocess/subject_results/group.all
target_path=/media/sf_D_DRIVE/1122_DeepLearning/Final/preprocess/QC_reports
mkdir -p ${target_path}

cd $data_path
folder_list=(sub-*)

for filelist in "${folder_list[@]}";
do
    cd $target_path
	mkdir -p ${filelist:4:4}
	cd ${filelist:4:4}
	
	echo "Copy QC files of $filelist"
	
	cp -r $data_path/$filelist/$filelist.results/QC_$filelist/* ./
	
done

