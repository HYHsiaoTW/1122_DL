#!/bin/bash
# whole_batch_preprocess.sh
#   modified and rename for OTCG OpenNeuro data by hyhsiao, 2024/04/26
#   ver. 1a1 update: 2023/09/05 for PGG
#   Der-Yow Chen, 2023/4/29 Created.
#####################################################
# Variable definition
config_file=preprocess_config.json

#########################################
# Variable Definitions
#input_root_dir=/media/Data_10TB/fMRI_rawdata/PGG
proprocess_script=multi_preprocess_afni_proc.py.csh

#########################################
# Load config file
# Check if jq exist or not. jq is a tool to parse JSON file.
if ! which jq > /dev/null; then
  echo "jq does not exist!"
  echo "please install jq to parse JSON file. For example, in debian/ubuntu:"
  echo "  sudo apt-get install jq"
  exit
fi

# Read Variable Definition from JSON config file
for key in `jq '. | keys | .[]' -r $config_file`; do	
  value=`jq -r ".${key}" $config_file`
  eval_string=`echo "${key}='${value}'" | tr -d ' '`
  eval $eval_string
  #echo $key = $value
done

#########################################
# create subject list for each match under nii directory
working_dir=`pwd`
# # # # # subject_list_file=${working_dir}/subject_list.json
# # # # # echo "{" > $subject_list_file
# # # # # echo "    \"subject_list\": [" >> $subject_list_file

# # # # # cd ${nii_Rawdata_dir}
# # # # # for match in */; do
   # # # # # echo "Createing $match subject list..."
   # # # # # cd ${working_dir}
   # # # # # match_id=${match:5:3}
   # # # # # echo "        \"sub-s${match_id}\"," >> $subject_list_file
   # # # # # match_list="${match_list} ${match_id}"
# # # # # done

# # # # # # remove the comma (last character) at the last line
# # # # # sed -i '$ s/.$//' $subject_list_file

# # # # # # finishing
# # # # # echo "    ]" >> $subject_list_file
# # # # # echo "}" >> $subject_list_file

#########################################
# batch preprocessing all subjects
echo "#################################"
echo "Start preprocessing"
date
start_time=`date +%s`

cd ${working_dir}
tcsh $proprocess_script -subject_list subject_list.json -config $config_file
echo "#####################################################"
echo Finished...
date
stop_time=`date +%s`
conversion_time=`echo "scale=2; ($stop_time - $start_time)/60" | bc`
echo "Total preprocessing time: ${conversion_time} minutes."
echo "#####################################################"
