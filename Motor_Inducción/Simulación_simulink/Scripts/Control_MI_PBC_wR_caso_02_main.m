% Control de velocidad w_R
% Caso de estudio 2:

% Observar potencia, eficiencia del controlador variando la norma del
% flujo y torque tau_R, manteniendo fija la velocidad

% Determinar el flujo optimo para cada par w_R y tau_R

clc
clear
addpath ..\Model\
addpath ..\MI_motors\

% Parametros  del motor %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MI_motor = MI_1HP_params;

% Parametros del controlador %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MI_PBC_wR = MI_Controller_Speed_params(MI_motor);

% Amortiguamiento del subsistema electrico
epsilon_KiS = 1;

% Amortiguamiento del subsistema mecanico
K_wR = 4.915;

% Filtro de primer orden para el error de velocidad
Kp_eWR = 0;
Ki_eWR = 0;

% Parametros de la simulacion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tiempo de simulación
tsim = 15;
tstep = 1e-4;

num_data_points = 10;

psi_Rmagrefs = 0.1:MI_motor.psi_Rmagnom/(num_data_points-1):MI_motor.psi_Rmagnom;
w_Rrefs = 0:MI_motor.w_Rnom/(num_data_points-1):MI_motor.w_Rnom;
tau_Rrefs = 0:MI_motor.tau_Rnom/(num_data_points-1):MI_motor.tau_Rnom;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data_size = [size(tau_Rrefs,2)*size(w_Rrefs,2),size(psi_Rmagrefs,2)];

v_peaks_arr = zeros(data_size);
i_peaks_arr = zeros(data_size);
v_f_arr = zeros(data_size);
p_elect_avg_arr = zeros(data_size);
p_mech_avg_arr = zeros(data_size);
err_wR = zeros(data_size);

out = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% str_dir_graficas = "graficas_PBC_control_wR";
str_dir_graficas = "";

for i = 1:size(w_Rrefs,2)
    for j = 1:size(tau_Rrefs,2)
        for k = 1:size(psi_Rmagrefs,2)
            clc
            % Parametros de la senal de velocidad de referencia %%%%%%%%%%%%%%%%%%%
            w_Rref = Perfil_trayectoria("Perfil velocidad de referencia w_Rref",tsim,tstep,5,w_Rrefs(i)); 
            %w_Rref.senoidal.frecuencia = 3/2*pi;
            %w_Rref.senoidal.desfase = pi/2;
        
            % Parametros de la senal de torque de carga %%%%%%%%%%%%%%%%%%%%%%%%%%%
            tau_L = Perfil_trayectoria("Perfil torque de carga tau_L",tsim,tstep,5,tau_Rrefs(j)); 

            psi_Rmagref = psi_Rmagrefs(k);
            % Objeto controlador
            MI_Contr = PBC_Speed_Controller(psi_Rmagref,epsilon_KiS,K_wR,Kp_eWR,Ki_eWR);


            % Preparar datos para simulacion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %MI_bus = MI_bus.add(MI_motor.struct,'MI_motor');
    
            if i == 1 && j == 1
                MI_bus_info = Simulink.Bus.createObject(MI_motor.struct);
                MI_bus = evalin('base', MI_bus_info.busName);
                
                Perfil_bus_info = Simulink.Bus.createObject(tau_L.perfiles);
                Perfil_bus = evalin('base', Perfil_bus_info.busName);
                
                PBC_bus_info = Simulink.Bus.createObject(MI_Contr.struct);
                PBC_bus = evalin('base', PBC_bus_info.busName);
            end
    
            simname = 'Speed_controller_PBC';
            
            handler_SimulinkBlockParams.setControladorPBC(simname,"Controlador PBC",MI_Contr)
            handler_SimulinkBlockParams.setPerfilTrayectoria(simname,"",tau_L);
            handler_SimulinkBlockParams.setPerfilTrayectoria(simname,"Controlador PBC",w_Rref);

            % Simulacion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            out = sim(simname);
        
            % Resultados de la simulacion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
            str_pref = "ControlPBC_wR";
            str_MI = "MI_" + string(round(MI_motor.Pnom/745.7,2)) + "hp";
            str_sim_refs = "wR_"...
                         + string(round(w_Rref.valor_referencia,2))...
                         + "_tauL_" + string(round(tau_L.valor_referencia,2));
            str_dir = [str_pref,str_MI,str_sim_refs];
        
            %"senoidal_"+string(round(w_Rref.senoidal.frecuencia,2))+"Hz_
        
            str_dir_sim = "";
            for  i_str = size(str_dir,2)
                if i_str ~= size(str_dir,2)
                    str_dir_sim = str_dir_sim + str_dir(i_str) + "_";
                else
                    str_dir_sim = str_dir_sim + str_dir(i_str);
                end
            end
        
        
            str_file_res = pwd + "\" + str_dir_graficas + "\" + str_dir_sim + "\"...
                         + "00_" + str_sim_refs +'.txt';
        
            graficas_control_wR = MI_control_wR_generar_graficas(out,str_dir_graficas,str_dir);
    
            MI_control_wR_resumen_simulacion(str_dir_graficas,str_file_res,MI_motor,MI_Contr,w_Rref,tau_L);
        
        
            MI_mediciones_VI;
            fclose('all');

            ind_i_arr = (i-1)*size(tau_Rrefs,2) + j;
        
            v_peaks_arr(ind_i_arr,k) = max(out.u_S3abc.data(:,1));
            i_peaks_arr(ind_i_arr,k) = max(out.i_S3abc.data(:,1));
        
            v_f_arr(ind_i_arr,k) = v_peaks(1,2);
        
            ind1 = find(out.tout==tsim-1);
            ind2 = find(out.tout==tsim);
            p_elect_avg_arr(ind_i_arr,k) = mean(out.P_elect.Data(ind1:ind2));
            p_mech_avg_arr(ind_i_arr,k) = mean(out.P_mech.Data(ind1:ind2));
    
            w_Rref_arr = reshape(out.w_Rref.Data,[],size(out.w_Rref.Data,3),1)';
            err_wR(ind_i_arr,k) = max(abs(w_Rref_arr(ind1:ind2)-out.w_R.data(ind1:ind2)));
        end
    end
end

Control_MI_PBC_wR_caso_02_graficas;

