#!/bin/bash
# make.event_list
#   hyhsiao, 2024/05/06 Created.
#####################################################
# Variable definition
root_path=D:/1122_DeepLearning/Final/
target_path=D:/1122_DeepLearning/Final/preprocess/errts
model_name=ConvNeXt

event_file=${root_path}/models/$model_name/event_list.txt
touch $event_file

cd $target_path

folder_list=(s*)

for filelist in "${folder_list[@]}";
do
	
	num_subbricks=336
	
	for (( i=1; i<${num_subbricks}+1; i++ ))
	do
		file_location="../../preprocess/errts/$filelist/$filelist+beta+event_$(printf "%03d" $i)+tlrc.BRIK"
		
		echo "$file_location" >> $event_file
		
	done
	
	
	# remove the comma (last character) at the last line
	# sed -i '$ s/.$//' $event_file
done

