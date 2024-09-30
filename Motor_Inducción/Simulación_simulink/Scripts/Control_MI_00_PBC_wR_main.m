clc
clear
addpath ..\Model\
addpath ..\MI_motors\

% Parametros  del motor %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MI_motor = MI_1HP_params;

% Parametros del controlador %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MI_PBC_wR = MI_Controller_Speed_params(MI_motor);

% Amortiguamiento del subsistema electrico
epsilon_KiS = 5e-2;%0.1;
%epsilon_KiS = 8*MI_motor.electric_params.R_R; % Dejar en terminos de R_R

% Amortiguamiento del subsistema mecanico
K_wR = 4.915;
%K_wR = 2.5;

% Filtro de primer orden para el error de velocidad
Kp_eWR = 0;
Ki_eWR = 0;

% Objeto controlador
MI_Contr = PBC_Speed_Controller(MI_motor.psi_Rmagnom,epsilon_KiS,K_wR,Kp_eWR,Ki_eWR);

% Parametros de la simulacion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tiempo de simulación
tsim = 15;
tstep = 1e-4;

% Parametros de la senal de velocidad de referencia %%%%%%%%%%%%%%%%%%%%%%%
w_Rref = Perfil_trayectoria("Perfil velocidad de referencia w_Rref",tsim,tstep,5,MI_motor.w_Rnom*0.4); 
% w_Rref.perfiles.polinomio7.tiempo.inicial = 1;
% w_Rref.perfiles.polinomio7.tiempo.final = 3;
% w_Rref.perfiles.rampa.tiempo_inicio= 1;
% w_Rref.perfiles.rampa.tiempo_fin = 6;
w_Rref.perfiles.senoidal.frecuencia = 1*2*pi; % rad/s
%w_Rref.perfiles.senoidal.desfase = pi/2;

% Parametros de la senal de torque de carga %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tau_L = Perfil_trayectoria("Perfil torque de carga tau_L",tsim,tstep,5,MI_motor.tau_Rnom*0.25); 
tau_L.perfiles.polinomio7.tiempo.inicial = 1;
tau_L.perfiles.polinomio7.tiempo.final = 1.5;

% Preparar datos para simulacion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MI_bus = MI_bus.add(MI_motor.struct,'MI_motor');
MI_bus_info = Simulink.Bus.createObject(MI_motor.struct);
MI_bus = evalin('base', MI_bus_info.busName);

Perfil_bus_info = Simulink.Bus.createObject(tau_L.perfiles);
Perfil_bus = evalin('base', Perfil_bus_info.busName);

PBC_bus_info = Simulink.Bus.createObject(MI_Contr.struct);
PBC_bus = evalin('base', PBC_bus_info.busName);

simname = 'Speed_controller_PBC';

handler_SimulinkBlockParams.setControladorPBC(simname,"Controlador PBC",MI_Contr)
handler_SimulinkBlockParams.setPerfilTrayectoria(simname,"",tau_L);
handler_SimulinkBlockParams.setPerfilTrayectoria(simname,"Controlador PBC",w_Rref);


% Simulacion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
out = sim(simname);

% Resultados de la simulacion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

str_pref = "ControlPBC_wR";
str_dir_graficas = "graficas_PBC_control_wR";
str_MI = "MI_" + string(round(MI_motor.Pnom/745.7,2)) + "hp";
str_sim_refs = "wR_" + w_Rref.sel_perfil_short_str+"_"...
             + string(round(w_Rref.valor_referencia,2))...
             + "_tauL_" + tau_L.sel_perfil_short_str+"_"...
             + string(round(tau_L.valor_referencia,2));
str_dir = [str_pref,str_MI,str_sim_refs];

%"senoidal_"+string(round(w_Rref.senoidal.frecuencia,2))+"Hz_

str_dir_sim = "";
for  i = size(str_dir,2)
    if i ~= size(str_dir,2)
        str_dir_sim = str_dir_sim + str_dir(i) + "_";
    else
        str_dir_sim = str_dir_sim + str_dir(i);
    end
end

str_dir_graficas = "";

str_file_res = pwd + "\" + str_dir_graficas + "\" + str_dir_sim + "\"...
             + "00_" + str_sim_refs +'.txt';



graficas_control_wR = MI_control_wR_generar_graficas(out,str_dir_graficas,str_dir);

MI_control_wR_resumen_simulacion(str_dir_graficas,str_file_res,MI_motor,MI_Contr,w_Rref,tau_L);

MI_mediciones_VI;
fclose('all');