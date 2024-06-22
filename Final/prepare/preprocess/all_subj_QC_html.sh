#!/bin/bash
# all_subj_QC_html.sh
#   generate html file for all subj's QC html page.
# version: 1a
# created: 20231101
# written by Der-Yow Chen
################################################
# Change log:
################################################
#Variable Definition
QC_root=../../../preprocess/QC_reports_Nb/
QC_htmlname=index.html
output_file=${QC_root}/QC_all_subj.html

link_prefix='<a href="file://'
link_connect='">'
link_suffix='</a>'
################################################
# Main
# generate header of output file
cat > $output_file << "EOF"
<!doctype html>
<html>
  <head>
    <meta charset="utf-8" />
    <title>QC files of all subjects</title>
  </head>

  <body>
  <p>QC files of all subjects</p>    
EOF

# find QC files and add to output file
all_QC_files=`find $QC_root -name $QC_htmlname | sort`
previous_match=''
for subj_QC in $all_QC_files; do
  subj_ID=`echo $subj_QC | sed -e 's/.*\/QC_//g' -e 's/\/index.html//g'`
  subj_QCpath=`realpath $subj_QC`
  link_string=${link_prefix}${subj_QCpath}${link_connect}${subj_ID}${link_suffix}
  curr_match=`echo $subj_ID | sed -e 's/sub_m//g' -e 's/[ABC]$//g'`

  # break if match has been changed.
  if [ ! "$curr_match" == "$previous_match" ]; then
      echo '<BR>' >> $output_file
      previous_match=$curr_match 
  fi
  echo $link_string >> $output_file  	
done

# generate ending part of output file
cat >> $output_file << "EOF"
    <footer>
      <p>Footer of all subj QC html.</p>
    </footer>
  </body>
</html>
EOF

echo $output_file has been generated.