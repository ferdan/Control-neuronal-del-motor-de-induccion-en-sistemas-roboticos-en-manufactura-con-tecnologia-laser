clc
clear
restoredefaultpath

addpath ..\Model\
addpath ..\MI_motors\
addpath ..\..\..\Utility_codes\

%% Parametros de la simulacion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tiempo de simulación
tsim = 10;
tstep = 1e-3;

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

MI_motor = MI_motors(1);

%% Incertidumbre parametrica %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

MI_contr.MImodel = MI_motor;

params_unc = 1.2;%1.1,1.2,0.8,0.9;

MI_contr.MImodel.struct.elecparams.R_R = MI_motor.struct.elecparams.R_R*params_unc;
MI_contr.MImodel.struct.elecparams.L_R = MI_motor.struct.elecparams.L_R*params_unc;
MI_contr.MImodel.struct.elecparams.sigma = MI_electric_parameters.calculate_sigma(MI_contr.MImodel.struct.elecparams);
MI_contr.MImodel.struct.elecparams.gamma = MI_electric_parameters.calculate_gamma(MI_contr.MImodel.struct.elecparams);

%% Parametros de la senal de torque de carga %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Utilizar mismo nombre que bloque de simulink
tau_L = Perfil_trayectoria("Perfil torque de carga tau_L",tsim,tstep,5,MI_motor.tau_Rnom*0.5); 
tau_L.perfiles.polinomio7.tiempo.inicial = 1;
tau_L.perfiles.polinomio7.tiempo.final = 1.25;
tau_L.perfiles.senoidal.frecuencia = 2*pi;
%tau_L = Perfil_trayectoria("Perfil torque de carga tau_L",tsim,tstep,8,MI_motor.tau_Rnom*0.5); 

% tr_sel = 1;
% tau_L = Perfil_trayectoria("Perfil torque de carga tau_L",tsim,tstep,7,...
%                            "tau_Rref_tr"+string(tr_sel)+".mat"); 
% tau_L_ts = tau_L.set_perfil_ts(tsim,tstep,tr_sel);

%% Parametros de la senal de torque de referencia %%%%%%%%%%%%%%%%%%%%%%%%%
theta_Rref = Perfil_trayectoria("Perfil posicion de referencia theta_Rref",tsim,tstep,5,1);

theta_Rref.perfiles.polinomio7.tiempo.inicial = 1;
theta_Rref.perfiles.polinomio7.tiempo.final = 1.5;
% theta_Rref.perfiles.senoidal.frecuencia = 3/2*pi;
% theta_Rref.perfiles.senoidal.desfase = pi/2;

t = 0:tstep:tsim;
q0 = theta_Rref.perfiles.polinomio7.pos.inicial;
q1 = theta_Rref.perfiles.polinomio7.pos.final;
t0 = theta_Rref.perfiles.polinomio7.tiempo.inicial;
t1 = theta_Rref.perfiles.polinomio7.tiempo.final;

theta_Rref_tr = pol7(t,q0,q1,t0,t1);

%% Parametros del controlador GPI y PBC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% contr = 'IFOC';
contr = 'PBC';

% Controlador PBC (controlador no lineal basado en pasividad)
epsilon_KiS = 1; % Dejar en terminos de R_R
psi_Rmagref = MI_motor.psi_Rmagnom;
MI_Contr = PBC_Torque_Controller(psi_Rmagref,epsilon_KiS);
%MI_PBC_tauR = MI_Controller_PBC_Torque_params(MI_motor,psi_Rmagref);

simname = 'Position_controller_GPI_PBC';
str_contr = "GPI+PBC";

handler_SimulinkBlockParams.setControladorPBC(simname,"Controlador PBC",MI_Contr);

nn_select = 0; % sintonizacion por redes neuronales bspline == 1, rbf == 2

NN_Bspline_params = setup_BSpline_nets(1);

unc_sel = params_unc;
NN_RBF_params = setup_RBF_nets(1,theta_Rref_tr',unc_sel);

Wc = 300;
Zc = 0.6;
Pc = 300;

%% Preparar simulacion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Contr_bus_info = Simulink.Bus.createObject(MI_Contr.struct);
Contr_bus = evalin('base', Contr_bus_info.busName);

handler_SimulinkBlockParams.setPerfilTrayectoria(simname,"",theta_Rref);
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

