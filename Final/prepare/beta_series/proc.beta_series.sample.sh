#!/bin/bash
# proc.beta_series.sample
#   hyhsiao, 2024/05/06 Created.
#####################################################

# run the regression analysis
subj=$(basename "$(pwd)")

3dDeconvolve                                                             \
	-input $subj+errts+tlrc                                              \
    -censor $subj+motion_censor.1D                                       \
    -polort 0                                                            \
    -num_stimts 1                                                        \
	-stim_times_IM 1 onset.1D 'BLOCK(3,1)' -stim_label 1 events          \
    -x1D X.beta_series.xmat.1D -xjpeg X.beta_series.jpg                  \
    -x1D_uncensored X.nocensor.xmat.1D                                   \
    -bucket stats.beta_series.$subj -mask ../group_mask_expanded+tlrc
	# -fout -tout 


             