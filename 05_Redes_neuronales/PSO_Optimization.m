% clc
% clear
format long

% PSO Optimization

% weights = [0.5, 0.2; 
%            0.3, 0.2; 
%            0.3, 0.1]; % num_outputs x num_rbfs

weights = [0.000444977504411,0.047583013851385;
           0.161174925796635,0.145971191332568;
           4.734616287869429,0.224736841636437]*100;

weights = [58.129019765225429,77.031889916512185;
           0.237841096651119,0.007983395328377;
           0.240305205292966,0.021602488923318];

weights = [0.116235513242376,0.108589915058422;
           0.001893733466454,0.062850688201634;
           3.191898082744509,1.828283788049950]*100;

weights = [2.871638368180681,0.169080851174493;
           0.002158535483539,0.000000134165078;
           0.002609060928890,0.000041953099594]*100;

weights = [3.029121791913112,0.016464931052871;
           0.002158301608378,0.000000000266863;
           0.002626441450137,0.000000571702338]*100;

weights_init = [3.044915812998948,0.000927422582042;
           0.002158301397612,0.000000000003354;
           0.002626267409924,0.000000001140129]*100;

%pso params
w = 0.8;
c1 = 0.1;
c2 = 0.1;

weights_dim1 = size(weights,1);
weights_dim2 = size(weights,2);

swarm_size = 25;
pso_perf_indicators = 2; % ITAE, ISCI
num_iter_pso = 50;


perf_arr = zeros(pso_perf_indicators,swarm_size);
pbest = zeros(swarm_size,1);
gbest = zeros(num_iter_pso,1);

% weights_init = 0.1 + rand(weights_dim1,weights_dim2).*0.1;
% weights_init = [0.081679299543943,0.137649373729613;
%                 0.003985687580491,0.026415927628499;
%                 0.685849182571248,1.219234492030772]*100;

weights_swarm = weights_init + (rand(weights_dim1,weights_dim2,swarm_size) - 0.5).*min(weights_init,[],2);
weights_swarm(:,:,1) = weights_init;





for i = 1:swarm_size
    weights = weights_swarm(:,:,i);

    sim('Basic_Control_Pendulum_RBF.slx');

    perf_arr(1,i) = ITAE;
    perf_arr(2,i) = ISCI;
    pbest(i) = cost_fcn(Error,ITAE,ISCI);
    disp("pbest(" + string(i) + "): " + string(pbest(i)));
end

[gbest(1),ind_min] = calc_gbest(pbest);

change_weights = 0;

%%

print_best_values(weights_swarm,pbest,gbest,ind_min,1);


%%

for j = 2:num_iter_pso
    disp("Iteracion " + string(j))
    V = 0.1 + rand(weights_dim1,weights_dim2,swarm_size)*0.15;
    for i = 1:swarm_size
        r = 0.4 + rand(weights_dim1,weights_dim2,2)*0.6;
        
        wV = w*V(:,:,i);
        crp = c1*r(:,:,1).*(pbest(i)/min(pbest)*ones(size(weights_swarm(:,:,i))) - weights_swarm(:,:,i));
        crg = c2*r(:,:,2).*(gbest(j-1)/min(pbest)*ones(size(weights_swarm(:,:,i))) - weights_swarm(:,:,i));

        V(:,:,i) = wV + crp + crg;
        
        weights = weights_swarm(:,:,i) + V(:,:,i);  

        sim('Basic_Control_Pendulum_RBF.slx');
    
        newpbest = cost_fcn(Error,ITAE,ISCI);

        if newpbest < pbest(i)

            weights_swarm(:,:,i) = weights;

            perf_arr(1,i) = ITAE;
            perf_arr(2,i) = ISCI;

            print_pbest_changes(pbest,newpbest,i);

            pbest(i) = newpbest;
        else
            disp("pbest(" + string(i) + ") not changed: " + string(newpbest) + " > " + string(pbest(i)));
        end
    end
    
    [gbest(j),ind_min] = calc_gbest(pbest);
    gbest_ant = gbest(j-1);

    if abs(gbest(j) - gbest_ant) < 1e-3
        change_weights = change_weights + 1;
    else     
        change_weights = 0;
    end
    if change_weights == 2
        disp("Recalculate weights_swarm")
        weights_swarm = recalculate_swarm(weights_swarm,ind_min,weights_dim1,weights_dim2,swarm_size);
        for i = 1:swarm_size
            weights = weights_swarm(:,:,i);
        
            sim('Basic_Control_Pendulum_RBF.slx');
        
            perf_arr(1,i) = ITAE;
            perf_arr(2,i) = ISCI;
            pbest(i) = cost_fcn(Error,ITAE,ISCI);
            disp("pbest(" + string(i) + "): " + string(pbest(i)));
        end
        [gbest(j),ind_min] = calc_gbest(pbest);
        gbest_ant = gbest(j-1);

        change_weights = 0;
    end


    print_best_values(weights_swarm,pbest,gbest,ind_min,j);
end

weights_init = weights_swarm(:,:,ind_min);



function [gbest,ind_min] = calc_gbest(pbest)
    [~,ind_min] = min(pbest);
    gbest = pbest(ind_min);
end

function weights_swarm = recalculate_swarm(weights_swarm,ind_min,weights_dim1,weights_dim2,swarm_size)
    weights_init = weights_swarm(:,:,ind_min);
    weights_swarm = weights_init + 0.1*(rand(weights_dim1,weights_dim2,swarm_size) - 0.5).*min(weights_init,[],2);
    weights_swarm(:,:,1) = weights_init;
end

function print_pbest_changes(pbest,newpbest,i)
    disp("pbest(" + string(i) + ") changed: ");
    disp(pbest(i));
    disp("to");
    disp(newpbest);
end

function print_best_values(weights_swarm,pbest,gbest,ind_min,ind_iter)
    disp("gbest: " + string(gbest(ind_iter)));
    disp("ind_min: " + string(ind_min));
    disp("pbest(" + string(ind_min) + "): " + string(pbest(ind_min)));
    disp(weights_swarm(:,:,ind_min));
end

function cost_fcn = cost_fcn(Error,ITAE,ISCI)
    cost_fcn = norm(Error)*1e4 + ITAE*1e4 + ISCI*0.11;
end





