#!/bin/bash
# proc.beta_series.sample
#   hyhsiao, 2024/05/06 Created.
#####################################################

# run the regression analysis
cd ../
subj=$(basename "$(pwd)")

cd ./glm_trick
trick_num=2

3dDeconvolve                                                             \
	-input ../$subj+errts+tlrc                                              \
    -censor ../$subj+motion_censor.1D                                       \
    -polort 0                                                            \
    -num_stimts 18                                                        \
	-stim_times_IM 1 '1D: 205.0551 563.1373 1213.1383' 'BLOCK(3,1)' -stim_label 1 comp-lie-test          \
	-stim_times_IM 2 '1D: 1411.036 2337.0968' 'BLOCK(3,1)' -stim_label 2 comp-truth-test          \
	-stim_times_IM 3 '1D: 369.0905 1389.0266 2316.0919' 'BLOCK(3,1)' -stim_label 3 coop-truth-test          \
	-stim_times 4 '1D: 1504.0563 941.0747 1118.118' 'BLOCK(3,1)' -stim_label 4 comp-truth-train${trick_num}1          \
	-stim_times 5 '1D: 1972.007 1598.0772 1865.1396' 'BLOCK(3,1)' -stim_label 5 comp-truth-train${trick_num}2          \
	-stim_times 6 '1D: 670.0063 2059.035 2152.0552' 'BLOCK(3,1)' -stim_label 6 comp-truth-train${trick_num}3          \
	-stim_times 7 '1D: 477.1157 299.0752 388.0952' 'BLOCK(3,1)' -stim_label 7 comp-lie-train${trick_num}1          \
	-stim_times 8 '1D: 1030.0952 757.0336 850.0543' 'BLOCK(3,1)' -stim_label 8 comp-lie-train${trick_num}2          \
	-stim_times 9 '1D: 2247.076 1687.0982 1774.119' 'BLOCK(3,1)' -stim_label 9 comp-lie-train${trick_num}3          \
	-stim_times 10 '1D: 113.0348 2428.1177 2519.1392' 'BLOCK(3,1)' -stim_label 10 comp-lie-train${trick_num}4          \
	-stim_times 11 '1D: 275.0698 90.0247 182.0502' 'BLOCK(3,1)' -stim_label 11 coop-truth-train${trick_num}1          \
	-stim_times 12 '1D: 650 455.1106 543.1318' 'BLOCK(3,1)' -stim_label 12 coop-truth-train${trick_num}2          \
	-stim_times 13 '1D: 916.0693 736.0243 827.049' 'BLOCK(3,1)' -stim_label 13 coop-truth-train${trick_num}3          \
	-stim_times 14 '1D: 1190.1333 1007.0903 1097.1126' 'BLOCK(3,1)' -stim_label 14 coop-truth-train${trick_num}4          \
	-stim_times 15 '1D: 1574.0717 1300.0001 1483.0514' 'BLOCK(3,1)' -stim_label 15 coop-truth-train${trick_num}5          \
	-stim_times 16 '1D: 1842.1341 1665.0929 1754.114' 'BLOCK(3,1)' -stim_label 16 coop-truth-train${trick_num}6          \
	-stim_times 17 '1D: 2127.0504 1950 2036.0252' 'BLOCK(3,1)' -stim_label 17 coop-truth-train${trick_num}7          \
	-stim_times 18 '1D: 0 2224.0707 2407.1127 2500.1337' 'BLOCK(3,1)' -stim_label 18 coop-truth-train${trick_num}8          \
    -x1D X.glm_trick${trick_num}.xmat.1D -xjpeg X.glm_trick${trick_num}.jpg                  \
    -x1D_uncensored X.glm_trick${trick_num}.nocensor.xmat.1D                                   \
    -bucket stats.glm_trick${trick_num}.$subj
	# -fout -tout 


             