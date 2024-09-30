function NN = setup_RBF_nets(ndof,kmeans_data,unc_sel)
    %kmeans_data = q';%r';
    
    %k = ndof+1;
    k = 8;
    
    k_params = k_means_clustering(kmeans_data,k);
    
    % k = determine_best_k_clusters(kmeans_data);
    % plot_2dim_kmeans(k,kmeans_data,k_params)
    
    % k_params.sigma = k_params.C_k_dist_max/sqrt(k);
    % k_params.sigma = 2*k_params.C_k_dist_mean;
    k_params.sigma = norm(k_params.C);

    
    % [93.4374,1.55728,7778.642]

    % 3dof, k = 5
    
    % Conjuntos de parametros [Wc,Zc,Pc]
    % Observaciones de la sintonizacion del controlador
    % Wc = Alcanzar la referencia. Entre mas alto, mejor -> menor error,
    %      pero puede volverse inestable. 
    % Zc = Amortiguamiento. Que tan subamortiguada es la respuesta. Varia
    %      en relacion inversa a Wc. Entre menor valor, menor -> menos
    %      sobretiro, a expensas de que oscile. 
    % Pc = Tambien alcanza referencia junto con Wc. 

    % sizes of variables --------------------------------------------------
    % weights (num_outputs x num_rbfs x dim_inputs)
    % specify 1-by-(num_outputs x num_rbfs x dim_inputs) vector
    % Ej. For GPI(Wn,Zn,Pc), k=2, 6dof-robot: 
    % specify 1-by-(3x2x6) = 1-by-36 vector

    % nn_inputs (dim_inputs x num_inputs)
    % specify num_inputs = 1 for e_q, 3 for [e_q,e_px,e_py] or 4 for [e_q,e_px,e_py,e_pz]
    % specify dim_inputs = ndof

    %num_rbfs = size(weights,2);
    %num_outputs = size(weights,1);


    % 6dof,s sigma_mean: initial weights: 60,1,500 k = 2

    [num_inputs,dim_inputs,delta,weights] = RBFparams1dof(k,ndof,unc_sel);

    NN = NN_RBF(num_inputs,dim_inputs,delta,weights,k_params);
end

function [num_inputs,dim_inputs,delta,weights] = RBFparams1dof(k,ndof,unc_sel)

    num_inputs = 1; % 1 = e_q, 4 = [e_q,e_px,e_py,e_pz]
    dim_inputs = ndof;

    deltaWc = 1e-6;
    weightsWc = 1e-4*ones(1,k*dim_inputs);
    
    
    deltaZc = 1e-3;

    %%%%%%%%%%%%%%%%%
    % if unc_sel == 0.8
    %     weightsZc = 0.2*ones(1,k*dim_inputs); % incertidumbre 0.8 --> z_c = 1.244
    % elseif unc_sel == 0.9
    %     weightsZc = 0.16*ones(1,k*dim_inputs); % incertidumbre 0.9 --> z_c = 0.995
    % elseif unc_sel == 1
    %     weightsZc = 0.14*ones(1,k*dim_inputs); %  incertidumbre 1 --> z_c = 0.871
    % elseif unc_sel == 1.1
    %     weightsZc = 0.11*ones(1,k*dim_inputs); % incertidumbre 1.1 --> z_c = 0.684
    % elseif unc_sel == 1.2
    %     weightsZc = 0.07*ones(1,k*dim_inputs); % incertidumbre 1.2 --> z_c = 0.435
    % else
    %     weightsZc = 0.1*ones(1,k*dim_inputs);
    % end
    weightsZc = 0.08*ones(1,k*dim_inputs);

    
    deltaPc = 1e-3;
    weightsPc = 40*ones(1,k*dim_inputs);

    [delta,weights] = packdata(deltaWc,weightsWc,...
                               deltaZc,weightsZc,...
                               deltaPc,weightsPc,...
                               k,ndof);

    % 6dof: initial weights: 60,1,500 k = 2, num_inputs = 1
end

function [delta,weights] = packdata(deltaWc,weightsWc,...
                                           deltaZc,weightsZc,...
                                           deltaPc,weightsPc,...
                                           num_rbfs,ndof)

    delta.deltaWc = deltaWc;
    delta.deltaZc = deltaZc;
    delta.deltaPc = deltaPc;
    
    weights.weightWc = reshape(weightsWc(1:num_rbfs*ndof),1,num_rbfs,ndof);
    weights.weightZc = reshape(weightsZc(1:num_rbfs*ndof),1,num_rbfs,ndof);
    weights.weightPc = reshape(weightsPc(1:num_rbfs*ndof),1,num_rbfs,ndof);
end

function k = determine_best_k_clusters(kmeans_data)
    ksumd2 = zeros(size(kmeans_data,2)*3,1);
    
    for k = 1:(size(kmeans_data,2)*3)
        k_params = k_means_clustering(kmeans_data,k);
        for i = 1:k
            ksumd2(i) = ksumd2(i) + sum(k_params.D(k_params.idx==i,i).^2);
        end
    end
    
    dksumd2 = diff(ksumd2);
    ddksumd2 = diff(diff(ksumd2));
    
    figure(2)
    plot(1:k,ksumd2)
    hold on
    plot(1:(k-1),dksumd2)
    plot(1:(k-2),ddksumd2)

    a = find(sign(ddksumd2((size(kmeans_data,2)):(size(kmeans_data,2)*2-2)))==-1);
    k = size(kmeans_data,2) + min(a) - 1; % k = 3,4; optimo para r', k = 7,8 para q';
end

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

function plot_2dim_kmeans(k,kmeans_plot_data,k_params)

    figure(1);
    clf
    plot(kmeans_plot_data(:,1),kmeans_plot_data(:,2),"Color","#0072BD");

    idx = k_params.idx;
    C = k_params.C;
    %sumd = k_data.sumd;
    D = k_params.D;

    h = gobjects(k,1);

    pcolor = ["#D95319","#EDB120","#7E2F8E","#77AC30","#4DBEEE","#A2142F"];
    size_pcolor = size(pcolor,2) - 1;

    for i = 1:k
        hold on
        plot(C(i,1),C(i,2),"x","Color",pcolor(mod(i,size_pcolor)+1));
    
        plot(kmeans_plot_data(idx==i,1),kmeans_plot_data(idx==i,2),"Color",pcolor(mod(i,size_pcolor)+1));
    
        [xunit,yunit] = circle(C(i,1),C(i,2),sqrt(max(D(idx==i,i))));%sqrt(sumd(i)));
        h(i) = plot(xunit', yunit',"Color","#000000");
    end
    
    rx_max = max(kmeans_plot_data(:,1));
    rx_min = min(kmeans_plot_data(:,1));
    ry_max = max(kmeans_plot_data(:,2));
    ry_min = min(kmeans_plot_data(:,2));
    
    for i = 1:k
        if rx_max < max(h(i).XData)
            rx_max = max(h(i).XData);
        end
        if rx_min > min(h(i).XData)
            rx_min = min(h(i).XData);
        end
        if ry_max < max(h(i).YData)
            ry_max = max(h(i).YData);
        end
        if ry_min > min(h(i).YData)
            ry_min = min(h(i).YData);
        end
    end
    
    rx = rx_max - rx_min;
    ry = ry_max - ry_min;
    
    pbaspect([rx ry 1])
end

function [xunit,yunit] = circle(x,y,r)
    th = 0:pi/50:2*pi;
    xunit = r * cos(th) + x;
    yunit = r * sin(th) + y;
end