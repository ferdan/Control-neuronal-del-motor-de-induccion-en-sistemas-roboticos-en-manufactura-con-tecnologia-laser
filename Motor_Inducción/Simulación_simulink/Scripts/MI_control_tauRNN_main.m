clc
clear
restoredefaultpath

addpath ..\Model\
addpath ..\MI_motors\
addpath ..\..\..\Utility_codes\

%% Parametros de la simulacion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tiempo de simulación
tsim = 25;
tstep = 1e-4;

inversor_select = 0;

%% Parametros del motor %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

str_file04hp = 'MI_0.4hp_params(Liceaga).txt';
MI_motor04hp = fileHandler.getMI_params(str_file04hp);

str_file1hp = 'MI_1hp_params(Hoover).txt';
MI_motor1hp = fileHandler.getMI_params(str_file1hp);

str_file5hp = 'MI_5hp_params(Matlab).txt';
MI_motor5hp = fileHandler.getMI_params(str_file5hp);

str_file10hp = 'MI_10hp_params(Matlab).txt';
MI_motor10hp = fileHandler.getMI_params(str_file10hp);

str_file20hp = 'MI_20hp_params(Matlab).txt';
MI_motor20hp = fileHandler.getMI_params(str_file20hp);

MI_motors = [MI_motor04hp,MI_motor1hp,MI_motor5hp,MI_motor10hp,MI_motor20hp];

MI_motor = MI_motors(2);

%% Parametros de la senal de torque de carga %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Utilizar mismo nombre que bloque de simulink
tau_L = Perfil_trayectoria("Perfil torque de carga tau_L",tsim,tstep,4,MI_motor.tau_Rnom*0.5); 
tau_L.perfiles.polinomio7.tiempo.inicial = 1;
tau_L.perfiles.polinomio7.tiempo.final = 1.25;
tau_L.perfiles.senoidal.frecuencia = 2*pi;
%tau_L = Perfil_trayectoria("Perfil torque de carga tau_L",tsim,tstep,8,MI_motor.tau_Rnom*0.5); 

% tr_sel = 1;
% tau_L = Perfil_trayectoria("Perfil torque de carga tau_L",tsim,tstep,7,...
%                            "tau_Rref_tr"+string(tr_sel)+".mat"); 
% tau_L_ts = tau_L.set_perfil_ts(tsim,tstep,tr_sel);

%% Parametros de la senal de torque de referencia %%%%%%%%%%%%%%%%%%%%%%%%%
tau_Rref = tau_L;
%tau_Rref_ts = tau_L_ts;
tau_Rref.nombre = "Perfil torque de referencia tau_Rref";
% tau_Rref.perfiles.polinomio7.tiempo.inicial = 2;
% tau_Rref.perfiles.polinomio7.tiempo.final = 12;
% tau_Rref.perfiles.senoidal.frecuencia = 3/2*pi;
% tau_Rref.perfiles.senoidal.desfase = pi/2;

%% Parametros del controlador %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% contr = 'IFOC';
contr = 'PBC';


if strcmp(contr,'IFOC') == 1
    % Controlador IFOC (controlador IFOC + controlador lineal diseñado por ICAD)
    psi_Rmagref = MI_motor.psi_Rmagnom;
    MI_Contr = IFOC_Torque_Controller(psi_Rmagref,326.5,1000,[-400,-400],...
                                         [-50+200*1i,-50-200*1i]);

    simname = 'Torque_controller_IFOC';
    str_contr = "IFOC";

    handler_SimulinkBlockParams.setControladorIFOC(simname,"Controlador IFOC/Controlador Corrientes de Estator",MI_Contr)
elseif strcmp(contr,'PBC') == 1
    % Controlador PBC (controlador no lineal basado en pasividad)
    epsilon_KiS = 1; % Dejar en terminos de R_R
    psi_Rmagref = MI_motor.psi_Rmagnom;
    MI_Contr = PBC_Torque_Controller(psi_Rmagref,epsilon_KiS);
    %MI_PBC_tauR = MI_Controller_PBC_Torque_params(MI_motor,psi_Rmagref);

    % simname = 'Torque_controller_PBC';
    simname = 'Torque_controller_PBC_NNs';
    str_contr = "PBC";

    handler_SimulinkBlockParams.setControladorPBC(simname,"Controlador PBC",MI_Contr);
else
    disp("Error en seleccion del controlador")
    str_contr = "";
    return
end

%% Setup Redes neuronales

nn_select = 2; % sintonizacion por redes neuronales bspline == 1, rbf == 2
unc_sel = 1;

NN_Bspline_params = setup_BSpline_nets(1);
NN_RBF_params = setup_RBF_nets(1,linspace(0,MI_motor.tau_Rnom,16)',unc_sel);

% entrenamiento de redes neuronales
NN_training = 0;
e_p_tol = 1e-6;

epsilon_KiS = 1;

%% Incertidumbre parametrica %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

MI_contr.MImodel = MI_motor;

params_unc = 1;%1.1,1.2,0.8,0.9;

MI_contr.MImodel.struct.elecparams.R_R = MI_motor.struct.elecparams.R_R*params_unc;
MI_contr.MImodel.struct.elecparams.L_R = MI_motor.struct.elecparams.L_R*params_unc;
MI_contr.MImodel.struct.elecparams.sigma = MI_electric_parameters.calculate_sigma(MI_contr.MImodel.struct.elecparams);
MI_contr.MImodel.struct.elecparams.gamma = MI_electric_parameters.calculate_gamma(MI_contr.MImodel.struct.elecparams);

%% Preparar simulacion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Contr_bus_info = Simulink.Bus.createObject(MI_Contr.struct);
Contr_bus = evalin('base', Contr_bus_info.busName);

handler_SimulinkBlockParams.setPerfilTrayectoria(simname,"Controlador "+str_contr,tau_Rref);
handler_SimulinkBlockParams.setPerfilTrayectoria(simname,"",tau_L);

MI_bus_info = Simulink.Bus.createObject(MI_motor.struct);
MI_bus = evalin('base', MI_bus_info.busName);

Perfil_bus_info = Simulink.Bus.createObject(tau_L.perfiles);
Perfil_bus = evalin('base', Perfil_bus_info.busName);

NN_Bspline_params_info = Simulink.Bus.createObject(NN_Bspline_params.struct);
NN_Bspline_params_bus = evalin('base', NN_Bspline_params_info.busName);

NN_RBF_params_info = Simulink.Bus.createObject(NN_RBF_params.struct);
NN_RBF_params_bus = evalin('base', NN_RBF_params_info.busName);

%% Simulacion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
out = sim(simname);

%% Resultados de la simulacion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data = SIMMI_GraficasHandler.get_data(out,simname);

str_pref = "Control" + str_contr + "_tauR";

str_dir_graficas = "graficas_" + str_contr + "_control_tauR";
str_dir_graficas = ""; % Comentar para guardar graficas

str_MI = MI_motor.shortNameString();
str_sim_refs = "tauRref_" + tau_Rref.sel_perfil_short_str + "_"...
             + string(round(tau_Rref.valor_referencia,2))...
             + "_tauL_" + tau_L.sel_perfil_short_str + "_"...
             + string(round(tau_L.valor_referencia,2));

str_dir = [str_pref,str_MI,str_sim_refs];

% "senoidal_"+string(round(w_Rref.senoidal.frecuencia,2))+"Hz_
% str_dir_graficas = "";

str_dir_sim = "";
for  i = size(str_dir,2)
    if i ~= size(str_dir,2)
        str_dir_sim = str_dir_sim + str_dir(i) + "_";
    else
        str_dir_sim = str_dir_sim + str_dir(i);
    end
end

str_file_res = pwd + "\" + str_dir_graficas + "\" + str_dir_sim + "\"...
             + "00_" + str_sim_refs +'.txt';

tinit = 0;
tfin = tsim;

f_data = SIMMI_GraficasHandler.figData(simname,data.t,tinit,tfin,data,str_dir_graficas,str_dir);

%graficas_control_tauR = MI_control_tauR_generar_graficas(out,str_dir_graficas,str_dir);

%% Archivo Resumen de simulacion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fileHandler.MI_control_tauR_resumen_simulacion(str_dir_graficas,str_file_res,...
                                   MI_motor,MI_Contr,tau_Rref,tau_L);

fileHandler.MI_mediciones_VI(tstep,data,MI_motor,str_dir_graficas,str_file_res,1);

fclose('all');
close('all');

