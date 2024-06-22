#!/bin/tcsh -xef
# open_all_QC.csh 
# Open all QC files using web browser to open QC html web page.
# version: 1b
# updated: 20210706
# created: 20210704
# written by Der-Yow Chen
# usage example:
#   tcsh open_all_QC.csh
#   tcsh open_all_QC.csh -subject_list subject_list.json 
################################################
# Change log:
#  20210706, 1b: use tmp_file_list under ${HOME}, not under current dir. 
################################################
#Variable Definition
# default values:
set browser=firefox
set json_subject_list_file=''
#set json_subject_list_file=subject_list.json
set all_found_files=1
set tmp_file_list="${HOME}/__tmp_filelist.txt"

# Parsing arguments for subject and JSON config
if ( $# == 0 ) then
  echo "Check for all subjects under current directory."
  #echo "Using default subject list: ${json_subject_list_file}" 
  echo "If you want to use other subject list file, please run:"
  echo "  $0 -subject_list <subject_list_file>   "
else
  set Narg = $#
  set cnt = 1
  while ($cnt <= $Narg)
    set donext = 1
    if ($donext && "$argv[$cnt]" == "-subject_list") then
      set pLoc = $cnt      
      if ($pLoc >= $Narg) then
         echo "Need subject after -subject_list"
         exit(-1)
      else
         @ cnt ++
         set json_subject_list_file = ($argv[$cnt])
         set all_found_files=0
         set donext = 0   
      endif
    endif
    if ($donext == 1) then
      echo "Error: Option or parameter '$argv[$cnt]' not understood"
      exit(-1)
    endif
    @ cnt ++   
  end
endif

# Check if jq exist or not. jq is a tool to parse JSON file.
if ( `where jq` == "") then
  echo "jq does not exist!"
  echo "please install jq to parse JSON file. For example, in debian/ubuntu:"
  echo "  sudo apt-get install jq"
  exit
endif

################################################
# Read subject list from JSON subject list file
################################################
if ( ! $all_found_files ) then
  set subject_list=()
  foreach subj (`jq -r '.subject_list[]' $json_subject_list_file`)
	  set subject_list = ( $subject_list $subj ) 
  end
endif

#####################################
# Open QC files in browser
if ( $all_found_files ) then 
  # for all subjects
  set dirs=`find . -name 'index.html'`
  echo $dirs
  foreach filename ($dirs)
     echo "  $browser $filename"
     $browser $filename
  end
else
  # for each subject in subject list
  echo "for each subject in subject_list_file: $json_subject_list_file"
  find . -name 'index.html' >> $tmp_file_list
  foreach subj ($subject_list)
    set filename=`grep $subj $tmp_file_list`
    #echo Start ${subj}:
    echo "  $browser $filename"
    $browser $filename
  end
  rm $tmp_file_list
endif




