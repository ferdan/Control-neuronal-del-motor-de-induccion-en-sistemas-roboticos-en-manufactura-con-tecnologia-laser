% Control de torque tau_R
% Caso de estudio 1:

% Observar la velocidad, potencia, corriente pico al variar la referencia
% de torque de carga. 

clc
clear
addpath ..\Model\
addpath ..\MI_motors\

% Referencias %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tau_Rrefs = 0:0.1:1; % porcentaje de valor nominal
tau_Rref_perfil = 5; %pol7

% Parametros  del motor %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MI_motor = MI_1HP_params;

% Parametros del controlador %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MI_PBC_tauR = MI_Controller_Torque_params(MI_motor);

psi_Rmagrefs = MI_motor.psi_Rmagnom*(0.1:0.1:1);



% Parametros de la simulacion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tiempo de simulación
tsim = 15;
tstep = 1e-4;

data_size = [size(tau_Rrefs,2),size(psi_Rmagrefs,2)];

v_peaks_arr = zeros(data_size);
i_peaks_arr = zeros(data_size);
v_f_arr = zeros(data_size);
p_elect_avg_arr = zeros(data_size);
p_mech_avg_arr = zeros(data_size);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
str_dir_graficas = "graficas_PBC_control_tauR";
%str_dir_graficas = "";

for i = 1:size(tau_Rrefs,2)
    for j = 1:size(psi_Rmagrefs,2)
        clc
        % Parametros de la senal de velocidad de referencia %%%%%%%%%%%%%%%%%%%
        tau_Rref = Perfil_trayectoria(tsim,tstep,tau_Rref_perfil,MI_motor.tau_Rnom*tau_Rrefs(i));
        %w_Rref.senoidal.frecuencia = 3/2*pi;
        %w_Rref.senoidal.desfase = pi/2;
    
        % Parametros de la senal de torque de carga %%%%%%%%%%%%%%%%%%%%%%%%%%%
        tau_Lrefs = tau_Rref;%Perfil_trayectoria(tsim,tstep,tau_Rref_perfil,MI_motor.tau_Rnom*tau_Rrefs(i));
    
        psi_Rmagref = psi_Rmagrefs(j);
    
        % Simulacion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        out = sim('Torque_controller3.slx');
    
        % Resultados de la simulacion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
        str_pref = "ControlPBC_tauR";
        str_MI = "MI_" + string(round(MI_motor.Pnom/745.7,2)) + "hp";
        str_sim_refs = "tauR_"...
                     + string(round(tau_Rref.valor_referencia,2))...
                     + "_tauL_" + string(round(tau_Lref.valor_referencia,2));
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
    
        str_dir_graficas = ""; % comentar para guardar graficas
    
        str_file_res = pwd + "\" + str_dir_graficas + "\" + str_dir_sim + "\"...
                     + "00_" + str_sim_refs +'.txt';
    
        graficas_control_wR = MI_control_tauR_generar_graficas(out,str_dir_graficas,str_dir);
    
        MI_control_tauR_resumen_simulacion;
    
        MI_mediciones_VI;
        fclose('all');

        ind_i_arr = (i-1)*size(tau_Lrefs,2) + j;
    
        v_peaks_arr(ind_i_arr) = max(out.u_S3abc.data(:,1));
        i_peaks_arr(ind_i_arr) = max(out.i_S3abc.data(:,1));
    
        v_f_arr(ind_i_arr) = v_peaks(1,2);
    
        ind1 = find(out.tout==tsim-1);
        ind2 = find(out.tout==tsim);
        p_elect_avg_arr(ind_i_arr) = mean(out.P_elect.Data(ind1:ind2));
        p_mech_avg_arr(ind_i_arr) = mean(out.P_mech.Data(ind1:ind2));
    end
end

Control_MI_PBC_tauR_caso_02_graficas;


