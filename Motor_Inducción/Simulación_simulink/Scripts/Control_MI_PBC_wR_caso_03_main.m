% Control de velocidad w_R
% Caso de estudio 1:

% Ver la variacion de la amplitud maxima de voltaje y corriente con
% respecto a las senales de referencia velocidad w_Rref y torque tau_Rref.

% Se observa la variacion de la componente principal de frecuencia y
% potencia requerida con respecto a las senales de referencia de velocidad
% w_Rref y tau_Rref. 

% En todas las simulaciones se considera norma de flujo nominal. 

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

% Objeto controlador
MI_Contr = PBC_Speed_Controller(MI_motor.psi_Rmagnom,epsilon_KiS,K_wR,Kp_eWR,Ki_eWR);

% Parametros de la simulacion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tiempo de simulación
tsimref = 15;
tstep = 1e-4;

num_data_points = 10;

f_init = 0.1; % hz
f_fin = 4.5;

w_R_frefs = (f_init:0.1:f_fin);%logspace(log10(f_init),log10(f_fin),25);

% Parametros de la senal de torque de carga %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tau_L = Perfil_trayectoria("Perfil torque de carga tau_L",tsimref,tstep,1,0);

data_size = size(w_R_frefs);

e_iSa_arr = zeros(data_size);
e_iSb_arr = zeros(data_size);
e_wR_arr = zeros(data_size);
p_elect_avg_arr = zeros(data_size);
p_mech_avg_arr = zeros(data_size);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


str_dir_graficas = "graficas_PBC_control_wR_caso_03";
str_dir_graficas = "";

for i = 1:size(w_R_frefs,2)
    clc
    w_R_frefs(i)
    % Parametros de la senal de velocidad de referencia %%%%%%%%%%%%%%%%%%%%%%%
    w_Rref = Perfil_trayectoria("Perfil velocidad de referencia w_Rref",tsimref,tstep,4,MI_motor.w_Rnom/4);
    w_Rref.perfiles.senoidal.frecuencia = w_R_frefs(i)*2*pi;
    w_Rref.perfiles.senoidal.tiempo_inicio = 1.5;

    tsim = 1.5 + (1/w_R_frefs(i))*5;
    if tsim < tsimref
        tsim = 10;
    end
    %w_Rref.perfiles.senoidal.desfase = pi/2;

    w_Rref.perfiles.ts.time = 0:tstep:tsimref;
    w_Rref.perfiles.ts.data = zeros(size(w_Rref.perfiles.ts.time));
    % Preparar datos para simulacion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %MI_bus = MI_bus.add(MI_motor.struct,'MI_motor');

    if i == 1
        MI_bus_info = Simulink.Bus.createObject(MI_motor.struct);
        MI_bus = evalin('base', MI_bus_info.busName);
        
        PBC_bus_info = Simulink.Bus.createObject(MI_Contr.struct);
        PBC_bus = evalin('base', PBC_bus_info.busName);

        Perfil_bus_info = Simulink.Bus.createObject(tau_L.perfiles);
        Perfil_bus = evalin('base', Perfil_bus_info.busName);
    end

    simname = 'Speed_controller_PBC';
    

    handler_SimulinkBlockParams.setControladorPBC(simname,"Controlador PBC",MI_Contr)
    handler_SimulinkBlockParams.setPerfilTrayectoria(simname,"",tau_L);
    handler_SimulinkBlockParams.setPerfilTrayectoria(simname,"Controlador PBC",w_Rref);

    % Simulacion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    out = sim(simname);

    % Resultados de la simulacion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    str_pref = "ControlPBC_wR_caso03frec";
    str_MI = "MI_" + string(round(MI_motor.Pnom/745.7,2)) + "hp";
    str_sim_refs = "wR_" + w_Rref.sel_perfil_short_str+"_"...
                 + string(round(w_Rref.valor_referencia,2))...
                 + "_tauL_" + tau_L.sel_perfil_short_str+"_"...
                 + string(round(tau_L.valor_referencia,2));
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

    %graficas_control_wR = MI_control_wR_generar_graficas(out,str_dir_graficas,str_dir);

    %MI_control_wR_resumen_simulacion(str_dir_graficas,str_file_res,MI_motor,MI_Contr,w_Rref,tau_L);

    %MI_mediciones_VI;
    fclose('all');
    
    
    w_Rrefdata = figureHandler.checksize(out.w_Rref.data);
    w_R = figureHandler.checksize(out.w_R.data);
    i_Sab = figureHandler.checksize(out.i_Sab.data);
    i_Sabref = figureHandler.checksize(out.i_Sabref.data);

    [~,tinit_ind] = min(abs(out.tout-(1.5+(1/w_R_frefs(i)))));
    [~,tfin_ind] = min(abs(out.tout-tsim));
    ind_data = tinit_ind:tfin_ind;
    %t = out.tout(ind_data);
    e_wR_arr(i) = max(abs(w_R(ind_data) - w_Rrefdata(ind_data)));
    e_iSa_arr(i) = max(abs(i_Sab(ind_data,1) - i_Sabref(ind_data,1)));
    e_iSb_arr(i) = max(abs(i_Sab(ind_data,2) - i_Sabref(ind_data,2)));

    p_elect_avg_arr(i) = mean(out.P_elect.Data(ind_data));
    p_mech_avg_arr(i) = mean(out.P_mech.Data(ind_data));
    
    figure(1)
    plot(w_R_frefs,e_wR_arr)
    
    figure(2)
    subplot(2,1,1)
    plot(w_R_frefs,e_iSa_arr)
    subplot(2,1,2)
    plot(w_R_frefs,e_iSb_arr)
end

%%

figure(1)
loglog(w_R_frefs,e_wR_arr./(MI_motor.w_Rnom/4)*100)

figure(2)
subplot(2,1,1)
plot(w_R_frefs,e_iSa_arr)
subplot(2,1,2)
plot(w_R_frefs,e_iSb_arr)
