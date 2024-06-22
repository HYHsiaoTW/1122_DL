#!/bin/bash
# collect_errts.sh
#   modified and rename for OTCG OpenNeuro data by hyhsiao, 2024/04/26
#   ver. 1a1 update: 2023/09/05 for PGG
#   Der-Yow Chen, 2023/4/29 Created.
#####################################################
# Variable definition
data_path=/media/Minas_fMRIdata/fMRI/OTCG/preprocess/subject_results/group.all
target_path=/media/Minas_fMRIdata/fMRI/OTCG/preprocess/errts
mkdir -p ${target_path}

cd $data_path
folder_list=(sub-*)

for filelist in "${folder_list[@]}";
do
    cd $target_path
	mkdir -p ${filelist:4:4}
	cd ${filelist:4:4}
	
	echo "Copy errts data file of $filelist"
	
	cp "$data_path/$filelist/$filelist.results/errts.$filelist.tproject+tlrc.BRIK" "./${filelist:4:4}+errts+tlrc.BRIK"
	cp "$data_path/$filelist/$filelist.results/errts.$filelist.tproject+tlrc.HEAD" "./${filelist:4:4}+errts+tlrc.HEAD"
	
	cp "$data_path/$filelist/$filelist.results/motion_${filelist}_censor.1D" "./${filelist:4:4}+motion_censor.1D"
	
	cp "$data_path/$filelist/$filelist.results/mask_epi_anat.$filelist+tlrc.BRIK.gz" "./${filelist:4:4}+mask+tlrc.BRIK.gz"
	cp "$data_path/$filelist/$filelist.results/mask_epi_anat.$filelist+tlrc.HEAD" "./${filelist:4:4}+mask+tlrc.HEAD"
	
	echo "Done!"
done


