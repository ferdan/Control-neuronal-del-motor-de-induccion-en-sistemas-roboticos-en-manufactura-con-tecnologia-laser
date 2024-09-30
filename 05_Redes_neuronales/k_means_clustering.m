function k_params = k_means_clustering(kmeans_data,k)
    [idx,C,sumd,D] = kmeans(kmeans_data,k);
    
    k_params.k = k;
    k_params.idx = idx;
    k_params.C = C;
    k_params.sumd = sumd;
    k_params.D = D;    

    radius_kdata_max = zeros(k,1);
    radius_kdata_mean = zeros(k,1);
    C_k_dist = zeros(sum(1:(k-1)),1);

    ii = 1;
    for i = 1:k
        radius_kdata_max(i) = max(D(idx==i,i));
        radius_kdata_mean(i) = sumd(i)/size(find(idx==i),1);
        for j = i:k
            if i ~= j
                C_k_dist(ii) = norm(k_params.C(i,:)'-k_params.C(j,:)',2);
                ii = ii + 1;
            end
        end
    end

    k_params.radius_kdata_max = radius_kdata_max;
    k_params.radius_kdata_mean = radius_kdata_mean;

    k_params.C_k_dist = C_k_dist;

    k_params.C_k_dist_max = max(C_k_dist);
    k_params.C_k_dist_mean = mean(C_k_dist,"all");

    %k_params = rmfield(k_params,"D");
end