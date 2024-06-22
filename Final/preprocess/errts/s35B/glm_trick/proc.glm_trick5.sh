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
	-stim_times_IM 1 '1D: 1907.5315 1461.155' 'BLOCK(3,1)' -stim_label 1 comp-lie-test          \
	-stim_times_IM 2 '1D: 345.3848 1166.4551 2200.2356' 'BLOCK(3,1)' -stim_label 2 comp-truth-test          \
	-stim_times_IM 3 '1D: 1142.4373 1799.4383 1884.5131' 'BLOCK(3,1)' -stim_label 3 coop-truth-test          \
	-stim_times 4 '1D: 157.242 2383.3849 434.4593' 'BLOCK(3,1)' -stim_label 4 comp-lie-train${trick_num}1          \
	-stim_times 5 '1D: 1074.382 251.3132 1550.2274' 'BLOCK(3,1)' -stim_label 5 comp-lie-train${trick_num}2          \
	-stim_times 6 '1D: 2104.1628 1256.5346 2560.5409' 'BLOCK(3,1)' -stim_label 6 comp-lie-train${trick_num}3          \
	-stim_times 7 '1D: 69.1704 805.1631 604.6079' 'BLOCK(3,1)' -stim_label 7 comp-truth-train${trick_num}1          \
	-stim_times 8 '1D: 714.0637 1366.0635 893.2344' 'BLOCK(3,1)' -stim_label 8 comp-truth-train${trick_num}2          \
	-stim_times 9 '1D: 984.3094 1819.4564 1643.3049' 'BLOCK(3,1)' -stim_label 9 comp-truth-train${trick_num}3          \
	-stim_times 10 '1D: 1732.3796 521.5333 2014.0653' 'BLOCK(3,1)' -stim_label 10 comp-truth-train${trick_num}4          \
	-stim_times 11 '1D: 1236.5166 133.2248 228.294' 'BLOCK(3,1)' -stim_label 11 coop-truth-train${trick_num}1          \
	-stim_times 12 '1D: 1529.2093 410.4398 499.5153' 'BLOCK(3,1)' -stim_label 12 coop-truth-train${trick_num}2          \
	-stim_times 13 '1D: 2081.1431 690.0435 783.1435' 'BLOCK(3,1)' -stim_label 13 coop-truth-train${trick_num}3          \
	-stim_times 14 '1D: 2358.367 962.2899 1055.3642' 'BLOCK(3,1)' -stim_label 14 coop-truth-train${trick_num}4          \
	-stim_times 15 '1D: 46.1515 1343.0431 1435.1375' 'BLOCK(3,1)' -stim_label 15 coop-truth-train${trick_num}5          \
	-stim_times 16 '1D: 320.3677 1711.3616 1994.0443' 'BLOCK(3,1)' -stim_label 16 coop-truth-train${trick_num}6          \
	-stim_times 17 '1D: 583.5891 2174.2181 2268.2923' 'BLOCK(3,1)' -stim_label 17 coop-truth-train${trick_num}7          \
	-stim_times 18 '1D: 872.2173 2452.4418 2540.5227 0' 'BLOCK(3,1)' -stim_label 18 coop-truth-train${trick_num}8          \
    -x1D X.glm_trick${trick_num}.xmat.1D -xjpeg X.glm_trick${trick_num}.jpg                  \
    -x1D_uncensored X.glm_trick${trick_num}.nocensor.xmat.1D                                   \
    -bucket stats.glm_trick${trick_num}.$subj
	# -fout -tout 


             