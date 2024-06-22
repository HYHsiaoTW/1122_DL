#!/bin/bash
# proc.beta_series.sample
#   hyhsiao, 2024/05/06 Created.
#####################################################

# run the regression analysis
cd ../
subj=$(basename "$(pwd)")

cd ./glm_trick
trick_num=5

3dDeconvolve                                                             \
	-input ../$subj+errts+tlrc                                              \
    -censor ../$subj+motion_censor.1D                                       \
    -polort 0                                                            \
    -num_stimts 18                                                        \
	-stim_times_IM 1 '1D: 563.1914' 'BLOCK(3,1)' -stim_label 1 comp-lie-test          \
	-stim_times_IM 2 '1D: 1598.0778 2152.0617 1411.0354' 'BLOCK(3,1)' -stim_label 2 comp-truth-test          \
	-stim_times_IM 3 '1D: 1389.026 2036.0318 2407.1206' 'BLOCK(3,1)' -stim_label 3 coop-truth-test          \
	-stim_times 4 '1D: 113.0916 1030.0948 670.0064' 'BLOCK(3,1)' -stim_label 4 comp-lie-train${trick_num}1          \
	-stim_times 5 '1D: 757.0332 299.132 1972.0132' 'BLOCK(3,1)' -stim_label 5 comp-lie-train${trick_num}2          \
	-stim_times 6 '1D: 2428.1258 1320.0081 2059.0414' 'BLOCK(3,1)' -stim_label 6 comp-lie-train${trick_num}3          \
	-stim_times 7 '1D: 23.0605 941.0735 477.172' 'BLOCK(3,1)' -stim_label 7 comp-truth-train${trick_num}1          \
	-stim_times 8 '1D: 850.0536 1504.0559 1118.1158' 'BLOCK(3,1)' -stim_label 8 comp-truth-train${trick_num}2          \
	-stim_times 9 '1D: 1213.1364 1865.1417 1687.0985' 'BLOCK(3,1)' -stim_label 9 comp-truth-train${trick_num}3          \
	-stim_times 10 '1D: 1774.1205 205.1117 2247.0835' 'BLOCK(3,1)' -stim_label 10 comp-truth-train${trick_num}4          \
	-stim_times 11 '1D: 1097.1105 90.0867 182.1064' 'BLOCK(3,1)' -stim_label 11 coop-truth-train${trick_num}1          \
	-stim_times 12 '1D: 1483.0508 369.1471 455.1666' 'BLOCK(3,1)' -stim_label 12 coop-truth-train${trick_num}2          \
	-stim_times 13 '1D: 1754.1145 650 736.0239' 'BLOCK(3,1)' -stim_label 13 coop-truth-train${trick_num}3          \
	-stim_times 14 '1D: 2127.0569 916.0686 1007.0893' 'BLOCK(3,1)' -stim_label 14 coop-truth-train${trick_num}4          \
	-stim_times 15 '1D: 6e-04 1190.1315 1300' 'BLOCK(3,1)' -stim_label 15 coop-truth-train${trick_num}5          \
	-stim_times 16 '1D: 275.1269 1574.0725 1665.0934' 'BLOCK(3,1)' -stim_label 16 coop-truth-train${trick_num}6          \
	-stim_times 17 '1D: 543.1865 1842.1363 1950' 'BLOCK(3,1)' -stim_label 17 coop-truth-train${trick_num}7          \
	-stim_times 18 '1D: 827.0485 2224.078 2316.0998 2500.1442' 'BLOCK(3,1)' -stim_label 18 coop-truth-train${trick_num}8          \
    -x1D X.glm_trick${trick_num}.xmat.1D -xjpeg X.glm_trick${trick_num}.jpg                  \
    -x1D_uncensored X.glm_trick${trick_num}.nocensor.xmat.1D                                   \
    -bucket stats.glm_trick${trick_num}.$subj
	# -fout -tout 


