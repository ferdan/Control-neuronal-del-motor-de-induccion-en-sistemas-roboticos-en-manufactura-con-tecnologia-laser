clc
clear
restoredefaultpath

addpath ..\Model
addpath ..\MI_motors\
addpath ..\..\..\Utility_codes\

tstep = 5e-4;
t_tr_init = 10; % Al menos 8s
t_qeq_init = 1; % Al menos 0.5s
t_trtr = pi/4;

tsim = 4*pi+t_tr_init;
t = 0:tstep:tsim;

%% Modelo robot manipulador

%robot_params = robot_2dof_params();
%robot_params = robot_3dof_params();
robot_params = robot_6dof_params();
    
ndof = robot_params.ndof;

if ndof == 2
    q_eq = [-pi/2;0];
elseif ndof == 3
    q_eq = [0;-pi/2;0];
elseif ndof == 6
    q_eq = [0;-pi/2;0;pi/2;0;0];
end
q_cero = zeros(size(q_eq));

robot_params_uncertainty = 0.8:0.1:1.2;

for unc_sel = robot_params_uncertainty
    for tr_sel = 2%1:5
        %% Setup trayectoria de referencia
        robot_cinematica = robot_cin(robot_params);
        
        tr_muestra = 0;
    
        if tr_muestra == 1 || ndof ~= 6
    
            [r,dr,ddr,R] = trayectoria_muestra(t,ndof,t_tr_init,tr_sel);
    
            if ndof == 2
                tsim = t_tr_init + 12;
                t = 0:tstep:tsim;
                [q,dq,ddq] = robot_cin.cin_inv_2dof(robot_params,r,dr,ddr);
            elseif ndof == 3
                [q,dq,ddq] = robot_cin.cin_inv_3dof(robot_params,r,dr,ddr);
            elseif ndof == 6
                [q,dq,ddq] = robot_cin.cin_inv_6dof(robot_params,r,dr,ddr,R);
            end
    
            r0 = r(:,1);
            dr0 = dr(:,1);
            ddr0 = ddr(:,1);
    
            q0 = q(:,1);
            dq0 = dq(:,1);
            ddq0 = ddq(:,1);
    
            tr_referencia = timeseries([r;dr;ddr],t);
            tr_ref.R = R;
    
        elseif tr_muestra == 0 && ndof == 6
            tr_gCode_6dof();
    
            tsim = toolpath_time(end) + t_tr_init + pi/4;
            t_init = 0:tstep:(t_tr_init + pi/4);

            r = [toolpath(:,2)'.*0.01+0.8;toolpath(:,1)'.*0.01;toolpath(:,3)'.*0.01+0.2];

            dr = zeros(size(r));
            ddr = zeros(size(r));
    
            tr = cat(2,ones(1,size(t_init,2)-1).*[r(:,1);ddr(:,1);ddr(:,1)],[r;ddr;ddr]);
            tr_t = cat(2,t_init(1:end-1),t_tr_init + pi/4 + toolpath_time');
    
            tr_referencia = timeseries(tr,tr_t);
            tr_ref.R = R;
    
            t = 0:tstep:tsim;
    
            q = robot_cin.cin_invq_6dof(robot_params,tr,R);
            dq = zeros(size(q));
            ddq = zeros(size(q));
    
            q0 = q(:,1);
        end
    
        %% Parametros de la senal de torque de carga %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Utilizar mismo nombre que bloque de simulink
        tau_L = Perfil_trayectoria("Perfil torque de carga tau_L",tsim,tstep,4,1); 
        %tau_L.perfiles.polinomio7.tiempo.inicial = 12;
        %tau_L.perfiles.polinomio7.tiempo.final = 1.25;
        tau_L.perfiles.senoidal.frecuencia = 2*pi;
        tau_L.perfiles.senoidal.tiempo_inicio = 10+2*pi;
        %tau_L.perfiles.senoidal.offset = 0.5;
        
        tau_L_mags = robot_params.m*0.5;
    
        %% Setup Redes neuronales
        nn_select = 0; % sintonizacion por redes neuronales bspline == 1, rbf == 2
        
        NN_Bspline_params = setup_BSpline_nets(ndof);
        NN_RBF_params = setup_RBF_nets(ndof,q',unc_sel);
    
        % entrenamiento de redes neuronales
        NN_training = 0;
        e_p_tol = 1e-6;
    
        %% Setup Simulink Valores iniciales
        
        setup_simRMA;
    
        if ndof == 2
            simname = 'controlGPI_pos_2dof_conMI';
        elseif ndof == 3
            simname = 'controlGPI_pos_3dof_conMI';
        elseif ndof == 6
            simname = 'controlGPI_pos_6dof_conMI';
        end
    
        setup_GPI;
        setup_motores_MI;
    
        %% Ejecucion de la simulacion
        
        out = sim(simname);
    %     return
    % end
        %% Obtener datos de resultados
    
        data = SIMRMA_GraficasHandler.get_data(out,ndof,simname);

        data_NN = SIMNN_GraficasHandler.get_data(out,nn_select,ndof,simname);
    
        % [~,tinit_ind] = min(abs(out.tout-0));
        [~,tinit_ind] = min(abs(out.tout-t_tr_init));
        [~,tfin_ind] = min(abs(out.tout-tsim));

        data.t2 = out.tout(tinit_ind:tfin_ind);

        simnameMI = "control_Torque";
        data_MI(1) = SIMMI_GraficasHandler.get_data_simRMA(out.MI_motor1,simnameMI,tinit_ind,tfin_ind);
        data_MI(2) = SIMMI_GraficasHandler.get_data_simRMA(out.MI_motor2,simnameMI,tinit_ind,tfin_ind);
    
        if ndof >= 3
            data_MI(3) = SIMMI_GraficasHandler.get_data_simRMA(out.MI_motor3,simnameMI,tinit_ind,tfin_ind);
        end
        if ndof == 6
            data_MI(4) = SIMMI_GraficasHandler.get_data_simRMA(out.MI_motor4,simnameMI,tinit_ind,tfin_ind);
            data_MI(5) = SIMMI_GraficasHandler.get_data_simRMA(out.MI_motor5,simnameMI,tinit_ind,tfin_ind);
            data_MI(6) = SIMMI_GraficasHandler.get_data_simRMA(out.MI_motor6,simnameMI,tinit_ind,tfin_ind);
        end
    
        str_file = "00_mov_robot_controlGPI_" + string(ndof) + "dof_"+"tr_"+string(tr_sel);
        % str_file = "";

        str_dir_graficas = "RMA"+string(ndof)+"dof_ControlGPI_";
        if nn_select == 2
            str_dir_graficas = str_dir_graficas + "conRBFNN_";
        elseif nn_select == 1
            str_dir_graficas = str_dir_graficas + "conBSplineNN_";
        else
            str_dir_graficas = str_dir_graficas + "sinNN_";
        end
        str_dir_graficas = str_dir_graficas + "incertidumbre_" + string(unc_sel);

        %str_dir_graficas = "";
    
        %% Entrenamiento NN, no recomendado
        [~,tinit_ind] = min(abs(out.tout-t_tr_init));
        [~,tfin_ind] = min(abs(out.tout-tsim));
        ind_data = tinit_ind:tfin_ind;
    
        num_epochs = 1;
    
        if NN_training == 1
            while mean(out.norm_e_p.data(ind_data)) > e_p_tol
                disp("num_epochs: "+string(num_epochs));
                disp("out.norm_e_p.data:"+string(mean(out.norm_e_p.data(ind_data))));
                if nn_select == 1
                    NN_Bspline_params.weights.weightWc = data_NN.BSplineNN_weights.weightsWc(end,:,:);
                    NN_Bspline_params.weights.weightZc = data_NN.BSplineNN_weights.weightsZc(end,:,:);
                    NN_Bspline_params.weights.weightPc = data_NN.BSplineNN_weights.weightsPc(end,:,:);
                elseif nn_select == 2
                    NN_RBF_params.weights.weightWc = data_NN.RBFNN_weights.weightsWc(end,:,:);
                    %NN_RBF_params.weights.weightZc = data_NN.RBFNN_weights.weightsZc(end,:,:);
                    NN_RBF_params.weights.weightPc = data_NN.RBFNN_weights.weightsPc(end,:,:);
                else
                    disp("Ningun peso que actualizar");
                end
                out = sim(simname);
                num_epochs = num_epochs + 1;
                data = SIMRMA_GraficasHandler.get_data(out,ndof,simname);
                data_NN = SIMNN_GraficasHandler.get_data(out,nn_select,ndof,simname);
            end
        end
    
        %% Graficas animacion
    
        if ndof ~= 2 && unc_sel == 1
            % f_anim = SIMRMA_GraficasHandler.figAnims(robot_params,simname,tr_sel,data.t,t_tr_init,tsim,data,str_file,str_dir_graficas);
        end
    
    
        %% Graficas RMA: 
    
        f_data = SIMRMA_GraficasHandler.figData(robot_params,simname,tr_sel,data.t,t_tr_init,tsim,data,str_dir_graficas);
        
        str_file_res = pwd + "\" + str_dir_graficas + "\" + "tr" + string(tr_sel) + "\" + "ITAE_ISCI.txt";
        fileHandler.RMA_ITAE_ISCI(out.ITAE,out.ISCI,str_dir_graficas,str_file_res);

        %% Graficas MI: 
    
        for i = 1:ndof
            str_MI = "MI" + string(i);
            num_fig_init = (2 + i)*10;

            str_file_res = pwd + "\" + str_dir_graficas + "\" + "tr" + string(tr_sel) + "\" + str_MI + "\" ...
                           + str_MI + "_torque.txt";

            f_data = SIMMI_GraficasHandler.figData_simRMA(num_fig_init,tr_sel,data.t2,t_tr_init,tsim,data_MI(i),str_dir_graficas,str_MI);

            % Archivo Resumen de simulacion para MIs 

            fileHandler.MI_control_tauR_resumen_simulacion(str_dir_graficas,str_file_res,...
                                                MI_motors(i),MI_Contrs(i),tau_L,tau_L);

            tau_L.valor_referencia = tau_L_mags(i);
            tau_L.perfiles.senoidal.amplitud = tau_L_mags(i);
            fileHandler.MI_mediciones_VI(tstep,data_MI(i),MI_motors(i),str_dir_graficas,str_file_res,0);

        end
    
    
        %% Graficas NN
        if nn_select ~= 0
            f_data = SIMNN_GraficasHandler.figData(robot_params,simname,tr_sel,data.t,t_tr_init,tsim,data_NN,nn_select,str_dir_graficas);
        end
    
        close('all')
    
        %save("tau_Rref_control_tr"+string(tr_sel)+"_"+string(robot_params.ndof)+"dof.mat","tau_Rref","-v7.3");
    
    end
end