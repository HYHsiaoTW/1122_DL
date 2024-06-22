# README of preprocess
# updated: 20230430
#################################################################################
# Preprocessing OVERVIEW: 4 Steps
#   Step 1: Quickly run preprocessing on all subjects in subject_list.json using default configuration.
#   Step 2: Open QC webpage for those subjects. Check their alignment.
#   Step 3: Run alignment test on those BAD subjects using Complete configuration.
#   Step 4: Run preprocessing again on those BAD subjects using best align_options.


#################################################################################
# Step 1: Quickly run preprocessing on all subjects in subject_list.json using default configuration.
#################################################################################
# Go to the preprocessing directory
cd /media/Data_10TB/fMRI/VolleyB/preprocess/

# Manually edit the subject list using 'vi' editor.
# After finished, press ESCAPE key then wq ENTER, to save the file and quit vi editor.
# If anything goes wrong, press ESCAPE key then q! ENTER, to quit vi editor without saving the file.
vi subject_list.json

# or you can use sublime text to edit it.
subl subject_list.json

# Edit the default configuration json file, modify some variables.
subl preprocess_config.json

# Run multiple subjects preprocessing using default configuration.
tcsh multi_preprocess_afni_proc.py.csh
or
tcsh multi_preprocess_afni_proc.py.csh -subject_list subject_list_m21-40.json 

#################################################################################
# Step 2: Open QC webpage for those subjects. Check their alignment.
#         Write down those BAD subjects whos alignment is not good.
#         They should be run the align test for complete configurations to get the best alignment options.
#################################################################################
tcsh open_all_QC.csh 

#################################################################################
# Step 3: Run alignment test on those BAD subjects using Complete configuration.
#################################################################################
# Go to the align_test directory, make a copy of subject list for complete align test from all subjects.
cd /media/Data_10TB/fMRI/VolleyB/align_test
cp subject_list.json subject_list_complete_align_test.json

# NOTE: Important!!
# Manually edit the subject list using 'vi' editor.
# Delete those already OK subject using dd (press d key twice quickly!)
# After finished, press ESCAPE key then wq ENTER, to save the file and quit vi editor.
# If anything goes wrong, press ESCAPE key then q! ENTER, to quit vi editor without saving.
vi subject_list_complete_align_test.json

# or you can use sublime text to edit it.
subl subject_list_complete_align_test.json

# Split the list to 3 parts, so that only about 3 subjects will be run the test each time.
cp subject_list_complete_align_test.json subject_list_complete_1.json
cp subject_list_complete_align_test.json subject_list_complete_2.json
cp subject_list_complete_align_test.json subject_list_complete_3.json
vi subject_list_complete_1.json
vi subject_list_complete_2.json
vi subject_list_complete_3.json


# Run multiple align test for complete alignment for these subjects.
# CAUTION: May be VERY VERY LONG! (18 tests for each subjects.)
tcsh multi_align_test.csh -subject_list subject_list_complete_1.json  -config align_test_config_complete.json
tcsh multi_align_test.csh -subject_list subject_list_complete_2.json  -config align_test_config_complete.json
tcsh multi_align_test.csh -subject_list subject_list_complete_3.json  -config align_test_config_complete.json
tcsh multi_align_test.csh -subject_list subject_list_complete_4.json  -config align_test_config_complete.json
tcsh multi_align_test.csh -subject_list subject_list_complete_5.json  -config align_test_config_complete.json
tcsh multi_align_test.csh -subject_list subject_list_complete_6.json  -config align_test_config_complete.json

# NOTE: Important!!!
#       Check summary directory for each subject, pick the best alignment image and move it to 'OK'.

# Collect align options 
# They will be saved to align_options.json under summary directory.
tcsh collect_align_options.csh 


#################################################################################
# Step 4: Run preprocessing again on those BAD subjects using best align_options.
#################################################################################
# Go to Preprecess directory, then copy subject_list of complete alignment 
cd ~/hypercomm_fMRI/preprocess/
cp ~/hypercomm_fMRI/align_test/subject_list_complete*.json .

# Run complete alignment test for these subjects.
# May be VERY VERY LONG!
tcsh multi_preprocess_afni_proc.py.csh -subject_list subject_list_complete_1.json -config preprocess_config.json -align_opt ../align_test/summary/align_options.json

tcsh multi_preprocess_afni_proc.py.csh -subject_list subject_list_complete_2.json -config preprocess_config.json -align_opt ../align_test/summary/align_options.json

tcsh multi_preprocess_afni_proc.py.csh -subject_list subject_list_complete_3.json -config preprocess_config.json -align_opt ../align_test/summary/align_options.json

tcsh multi_preprocess_afni_proc.py.csh -subject_list subject_list_complete_4.json -config preprocess_config.json -align_opt ../align_test/summary/align_options.json

tcsh multi_preprocess_afni_proc.py.csh -subject_list subject_list_complete_5.json -config preprocess_config.json -align_opt ../align_test/summary/align_options.json

tcsh multi_preprocess_afni_proc.py.csh -subject_list subject_list_complete_6.json -config preprocess_config.json -align_opt ../align_test/summary/align_options.json

# Open QC webpage for those subjects, check if they are OK.
tcsh open_all_QC.csh -subject_list subject_list_complete_1.json
tcsh open_all_QC.csh -subject_list subject_list_complete_2.json
tcsh open_all_QC.csh -subject_list subject_list_complete_3.json
tcsh open_all_QC.csh -subject_list subject_list_complete_4.json
tcsh open_all_QC.csh -subject_list subject_list_complete_5.json
tcsh open_all_QC.csh -subject_list subject_list_complete_6.json

# or open all subject for complete align test
# tcsh open_all_QC.csh -subject_list subject_list_complete_align_test.json
