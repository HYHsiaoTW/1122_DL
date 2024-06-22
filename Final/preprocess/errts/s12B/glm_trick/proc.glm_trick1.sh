#!/bin/bash
# proc.beta_series.sample
#   hyhsiao, 2024/05/06 Created.
#####################################################

# run the regression analysis
cd ../
subj=$(basename "$(pwd)")

cd ./glm_trick
trick_num=1

3dDeconvolve                                                             \
	-input ../$subj+errts+tlrc                                              \
    -censor ../$subj+motion_censor.1D                                       \
    -polort 0                                                            \
    -num_stimts 18                                                        \
	-stim_times_IM 1 '1D: 1320.0356 1774.6839 2059.1816' 'BLOCK(3,1)' -stim_label 1 comp-lie-test          \
	-stim_times_IM 2 '1D: 563.839 1598.4341 2428.7166' 'BLOCK(3,1)' -stim_label 2 comp-truth-test          \
	-stim_times_IM 3 '1D: 275.4368 1389.1388 2224.4034' 'BLOCK(3,1)' -stim_label 3 coop-truth-test          \
	-stim_times 4 '1D: 113.1921 388.5905 757.183' 'BLOCK(3,1)' -stim_label 4 comp-lie-train${trick_num}1          \
	-stim_times 5 '1D: 850.3058 941.43 1118.6821' 'BLOCK(3,1)' -stim_label 5 comp-lie-train${trick_num}2          \
	-stim_times 6 '1D: 1504.3096 1687.5591 1865.8105' 'BLOCK(3,1)' -stim_label 6 comp-lie-train${trick_num}3          \
	-stim_times 7 '1D: 1972.0362 2247.4345 2519.8457' 'BLOCK(3,1)' -stim_label 7 comp-lie-train${trick_num}4          \
	-stim_times 8 '1D: 23.0349 299.467 477.7164' 'BLOCK(3,1)' -stim_label 8 comp-truth-train${trick_num}1          \
	-stim_times 9 '1D: 670.0339 1030.5528 1213.807' 'BLOCK(3,1)' -stim_label 9 comp-truth-train${trick_num}2          \
	-stim_times 10 '1D: 1411.1839 2152.3097 2337.5901' 'BLOCK(3,1)' -stim_label 10 comp-truth-train${trick_num}3          \
	-stim_times 11 '1D: 5e-04 90.1358 182.3156' 'BLOCK(3,1)' -stim_label 11 coop-truth-train${trick_num}1          \
	-stim_times 12 '1D: 369.56 455.6844 543.8089' 'BLOCK(3,1)' -stim_label 12 coop-truth-train${trick_num}2          \
	-stim_times 13 '1D: 650.0002 736.1364 827.2754' 'BLOCK(3,1)' -stim_label 13 coop-truth-train${trick_num}3          \
	-stim_times 14 '1D: 916.3989 1007.5218 1097.6512' 'BLOCK(3,1)' -stim_label 14 coop-truth-train${trick_num}4          \
	-stim_times 15 '1D: 1190.7761 1300.0006 1483.2793' 'BLOCK(3,1)' -stim_label 15 coop-truth-train${trick_num}5          \
	-stim_times 16 '1D: 1574.403 1665.5282 1754.6529' 'BLOCK(3,1)' -stim_label 16 coop-truth-train${trick_num}6          \
	-stim_times 17 '1D: 1842.7792 1950.0003 2036.1392' 'BLOCK(3,1)' -stim_label 17 coop-truth-train${trick_num}7          \
	-stim_times 18 '1D: 2127.2766 2316.5584 2407.6854 2500.8141' 'BLOCK(3,1)' -stim_label 18 coop-truth-train${trick_num}8          \
    -x1D X.glm_trick${trick_num}.xmat.1D -xjpeg X.glm_trick${trick_num}.jpg                  \
    -x1D_uncensored X.glm_trick${trick_num}.nocensor.xmat.1D                                   \
    -bucket stats.glm_trick${trick_num}.$subj
	# -fout -tout 


             