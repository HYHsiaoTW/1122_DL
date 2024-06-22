#!/bin/bash
# proc.beta_series.sample
#   hyhsiao, 2024/05/06 Created.
#####################################################

# run the regression analysis
cd ../
subj=$(basename "$(pwd)")

cd ./glm_trick
trick_num=3

3dDeconvolve                                                             \
	-input ../$subj+errts+tlrc                                              \
    -censor ../$subj+motion_censor.1D                                       \
    -polort 0                                                            \
    -num_stimts 17                                                        \
	-stim_times_IM 1 '1D: 2014.0641 805.1584 1166.4562' 'BLOCK(3,1)' -stim_label 1 comp-lie-test          \
	-stim_times_IM 2 '1D: 1461.1637 345.3039 2476.4606 2292.3081' 'BLOCK(3,1)' -stim_label 2 comp-truth-test          \
	-stim_times_IM 3 '1D: 1711.3665 1055.3635 2452.4402' 'BLOCK(3,1)' -stim_label 3 coop-truth-test          \
	-stim_times 4 '1D: 1819.4605 434.378 604.5265' 'BLOCK(3,1)' -stim_label 4 comp-lie-train${trick_num}1          \
	-stim_times 5 '1D: 69.0637 1366.064 1550.2348' 'BLOCK(3,1)' -stim_label 5 comp-lie-train${trick_num}2          \
	-stim_times 6 '1D: 1256.5339 1907.535 2560.5365' 'BLOCK(3,1)' -stim_label 6 comp-lie-train${trick_num}3          \
	-stim_times 7 '1D: 1074.3814 251.2311 521.4497' 'BLOCK(3,1)' -stim_label 7 comp-truth-train${trick_num}1          \
	-stim_times 8 '1D: 2104.1612 893.2302 984.307' 'BLOCK(3,1)' -stim_label 8 comp-truth-train${trick_num}2          \
	-stim_times 9 '1D: 157.1618 1643.311 1732.3844' 'BLOCK(3,1)' -stim_label 9 comp-truth-train${trick_num}3          \
	-stim_times 10 '1D: 714.0631 2200.2338 2383.3833' 'BLOCK(3,1)' -stim_label 10 comp-truth-train${trick_num}4          \
	-stim_times 11 '1D: 783.1392 228.2126 410.3584' 'BLOCK(3,1)' -stim_label 11 coop-truth-train${trick_num}1          \
	-stim_times 12 '1D: 1142.4381 583.5075 690.0431' 'BLOCK(3,1)' -stim_label 12 coop-truth-train${trick_num}2          \
	-stim_times 13 '1D: 1435.144 872.2126 962.2862' 'BLOCK(3,1)' -stim_label 13 coop-truth-train${trick_num}3          \
	-stim_times 14 '1D: 1799.4398 1236.5145 1343.0438' 'BLOCK(3,1)' -stim_label 14 coop-truth-train${trick_num}4          \
	-stim_times 15 '1D: 2081.142 1529.2171 1619.2912' 'BLOCK(3,1)' -stim_label 15 coop-truth-train${trick_num}5          \
	-stim_times 16 '1D: 2358.3648 1884.5169 1994.0434' 'BLOCK(3,1)' -stim_label 16 coop-truth-train${trick_num}6          \
	-stim_times 17 '1D: 46.0436 2174.2161 2268.2896' 'BLOCK(3,1)' -stim_label 17 coop-truth-train${trick_num}7          \
    -x1D X.glm_trick${trick_num}.xmat.1D -xjpeg X.glm_trick${trick_num}.jpg                  \
    -x1D_uncensored X.glm_trick${trick_num}.nocensor.xmat.1D                                   \
    -bucket stats.glm_trick${trick_num}.$subj
	# -fout -tout 


             