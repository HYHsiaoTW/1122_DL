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
	-stim_times_IM 1 '1D: 521.3141 1256.2533 2200.1124' 'BLOCK(3,1)' -stim_label 1 comp-lie-test          \
	-stim_times_IM 2 '1D: 1074.1818 2383.1828' 'BLOCK(3,1)' -stim_label 2 comp-truth-test          \
	-stim_times_IM 3 '1D: 1529.1017 499.3061' 'BLOCK(3,1)' -stim_label 3 coop-truth-test          \
	-stim_times 4 '1D: 157.1824 251.2146 345.2475' 'BLOCK(3,1)' -stim_label 4 comp-truth-train${trick_num}1          \
	-stim_times 5 '1D: 893.1135 984.1481 1366.0429' 'BLOCK(3,1)' -stim_label 5 comp-truth-train${trick_num}2          \
	-stim_times 6 '1D: 1461.077 1643.1487 2292.1466' 'BLOCK(3,1)' -stim_label 6 comp-truth-train${trick_num}3          \
	-stim_times 7 '1D: 434.2814 604.3473 714.0465' 'BLOCK(3,1)' -stim_label 7 comp-lie-train${trick_num}1          \
	-stim_times 8 '1D: 805.08 1166.2177 1550.1143' 'BLOCK(3,1)' -stim_label 8 comp-lie-train${trick_num}2          \
	-stim_times 9 '1D: 1732.1828 1819.2173 1907.2518' 'BLOCK(3,1)' -stim_label 9 comp-lie-train${trick_num}3          \
	-stim_times 10 '1D: 2014.0412 2104.0748 2476.2173' 'BLOCK(3,1)' -stim_label 10 comp-lie-train${trick_num}4          \
	-stim_times 11 '1D: 46.1327 133.1709 228.2061' 'BLOCK(3,1)' -stim_label 11 coop-truth-train${trick_num}1          \
	-stim_times 12 '1D: 320.2396 410.2722 583.3392' 'BLOCK(3,1)' -stim_label 12 coop-truth-train${trick_num}2          \
	-stim_times 13 '1D: 690.0385 783.0714 872.1053' 'BLOCK(3,1)' -stim_label 13 coop-truth-train${trick_num}3          \
	-stim_times 14 '1D: 962.1392 1055.1739 1142.2091' 'BLOCK(3,1)' -stim_label 14 coop-truth-train${trick_num}4          \
	-stim_times 15 '1D: 1343.035 1435.0682 1619.1397' 'BLOCK(3,1)' -stim_label 15 coop-truth-train${trick_num}5          \
	-stim_times 16 '1D: 1711.174 1799.2086 1884.2434' 'BLOCK(3,1)' -stim_label 16 coop-truth-train${trick_num}6          \
	-stim_times 17 '1D: 1994.0327 2081.0666 2174.1035' 'BLOCK(3,1)' -stim_label 17 coop-truth-train${trick_num}7          \
	-stim_times 18 '1D: 2268.1382 2358.1744 2452.2086 2540.2437' 'BLOCK(3,1)' -stim_label 18 coop-truth-train${trick_num}8          \
    -x1D X.glm_trick${trick_num}.xmat.1D -xjpeg X.glm_trick${trick_num}.jpg                  \
    -x1D_uncensored X.glm_trick${trick_num}.nocensor.xmat.1D                                   \
    -bucket stats.glm_trick${trick_num}.$subj
	# -fout -tout 


             