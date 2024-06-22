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
	-stim_times_IM 1 '1D: 345.3821 1166.4607 1550.2402' 'BLOCK(3,1)' -stim_label 1 comp-lie-test          \
	-stim_times_IM 2 '1D: 604.6042 1074.3842 2476.4512' 'BLOCK(3,1)' -stim_label 2 comp-truth-test          \
	-stim_times_IM 3 '1D: 228.2898 1799.4469 1142.4407' 'BLOCK(3,1)' -stim_label 3 coop-truth-test          \
	-stim_times 4 '1D: 251.3069 714.0639 805.164' 'BLOCK(3,1)' -stim_label 4 comp-truth-train${trick_num}1          \
	-stim_times 5 '1D: 893.2359 1256.5374 1366.0655' 'BLOCK(3,1)' -stim_label 5 comp-truth-train${trick_num}2          \
	-stim_times 6 '1D: 1732.3894 1819.4657 2200.2185' 'BLOCK(3,1)' -stim_label 6 comp-truth-train${trick_num}3          \
	-stim_times 7 '1D: 69.1618 434.4557 521.5304' 'BLOCK(3,1)' -stim_label 7 comp-lie-train${trick_num}1          \
	-stim_times 8 '1D: 984.3105 1461.1653 1643.3146' 'BLOCK(3,1)' -stim_label 8 comp-lie-train${trick_num}2          \
	-stim_times 9 '1D: 1907.5437 2014.0501 2104.1433' 'BLOCK(3,1)' -stim_label 9 comp-lie-train${trick_num}3          \
	-stim_times 10 '1D: 2292.2949 2383.3733 2560.5293' 'BLOCK(3,1)' -stim_label 10 comp-lie-train${trick_num}4          \
	-stim_times 11 '1D: 46.1446 133.2166 320.3625' 'BLOCK(3,1)' -stim_label 11 coop-truth-train${trick_num}1          \
	-stim_times 12 '1D: 410.4377 499.5104 583.586' 'BLOCK(3,1)' -stim_label 12 coop-truth-train${trick_num}2          \
	-stim_times 13 '1D: 690.0433 783.145 872.2182' 'BLOCK(3,1)' -stim_label 13 coop-truth-train${trick_num}3          \
	-stim_times 14 '1D: 962.2917 1055.3663 1236.5179' 'BLOCK(3,1)' -stim_label 14 coop-truth-train${trick_num}4          \
	-stim_times 15 '1D: 1343.0447 1435.1474 1529.2226' 'BLOCK(3,1)' -stim_label 15 coop-truth-train${trick_num}5          \
	-stim_times 16 '1D: 1619.2945 1711.3713 1884.5252' 'BLOCK(3,1)' -stim_label 16 coop-truth-train${trick_num}6          \
	-stim_times 17 '1D: 1994.0269 2081.1256 2174.1997' 'BLOCK(3,1)' -stim_label 17 coop-truth-train${trick_num}7          \
	-stim_times 18 '1D: 2268.2754 2358.3547 2452.4324 2540.5104' 'BLOCK(3,1)' -stim_label 18 coop-truth-train${trick_num}8          \
    -x1D X.glm_trick${trick_num}.xmat.1D -xjpeg X.glm_trick${trick_num}.jpg                  \
    -x1D_uncensored X.glm_trick${trick_num}.nocensor.xmat.1D                                   \
    -bucket stats.glm_trick${trick_num}.$subj
	# -fout -tout 


             