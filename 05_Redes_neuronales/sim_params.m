
k_params = k_means_clustering([Refer,dRefer],2);

k_params.sigma = 2*k_params.C_k_dist_mean;