clc
clear
restoredefaultpath

addpath ..\Model\
addpath ..\MI_motors\
addpath ..\..\..\Utility_codes\

%% Parametros de la simulacion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tiempo de simulación
tsim = 15;
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

ii = 1;
for i = 1:size(MI_motors,2)
    %% Preparar datos para simulacion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    MI_motor = MI_motors(i);

    %MI_bus = MI_bus.add(MI_motor.struct,'MI_motor');
    if ii == 1
        MI_bus_info = Simulink.Bus.createObject(MI_motor.struct);
        MI_bus = evalin('base', MI_bus_info.busName);
    end
    
    simname = 'Modelo_MI_simulink1.slx';
    
    %% Simulacion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    out = sim(simname);
    
    %% Resultados de la simulacion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    data = SIMMI_GraficasHandler.get_data(out,simname);
    
    str_pref = "MI_model";
    str_dir_graficas = "graficas_modelo_MI";
    str_MI = MI_motor.shortNameString();
    
    str_dir = [str_pref,str_MI];
    
    %str_dir_graficas = "";
    
    tinit = 0;
    tfin = tsim;
    
    f_data1 = SIMMI_GraficasHandler.figData(simname,data.t,tinit,tfin,data,str_dir_graficas,str_dir);
    
    str_pref = "MI_model";
    str_dir_graficas = "graficas_modelo_MI_transitorio";
    str_MI = MI_motor.shortNameString();
    
    str_dir = [str_pref,str_MI];

    %str_dir_graficas = "";
    
    tinit = 0;
    tfin = 0.5;
    
    f_data2 = SIMMI_GraficasHandler.figData(simname,data.t,tinit,tfin,data,str_dir_graficas,str_dir);
    
    close("all")
    ii = ii + 1;
end