addpath ..\MI_motors\

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

if ndof == 2
    MI_motor1 = MI_motor1hp;
    MI_motor2 = MI_motor1hp;
elseif ndof == 3
    MI_motor1 = MI_motor1hp;
    MI_motor2 = MI_motor1hp;
    MI_motor3 = MI_motor1hp;
elseif ndof == 6
    MI_motor1 = MI_motor1hp;
    MI_motor2 = MI_motor5hp;
    MI_motor3 = MI_motor5hp;
    MI_motor4 = MI_motor1hp;
    MI_motor5 = MI_motor1hp;
    MI_motor6 = MI_motor04hp;
end

MI_motors(1) = MI_motor1;
MI_motors(2) = MI_motor2;
if ndof >= 3
    MI_motors(3) = MI_motor3;
end
if ndof == 6
    MI_motors(4) = MI_motor4;
    MI_motors(5) = MI_motor5;
    MI_motors(6) = MI_motor6;
end

% Motorreductores
if ndof == 2
    ns = [25.01;3.7];
elseif ndof == 3
    ns = [1;3.7;1];
elseif ndof == 6
    %ns = [1;1;1;1;1;1];
    ns = [25.01;25.01;13.73;13.73;6.75;6.75];
end

epsilon_KiS = 1;
MI_motor_uncertainty = 1.2;

MI_Contr1 = PBC_Torque_Controller(MI_motor1.psi_Rmagnom,epsilon_KiS);
MI_Contr1.MImodel = Contr_MIModel_uncertainty(MI_motor1,MI_motor_uncertainty);
MI_Contr2 = PBC_Torque_Controller(MI_motor2.psi_Rmagnom,epsilon_KiS);
MI_Contr2.MImodel = Contr_MIModel_uncertainty(MI_motor2,MI_motor_uncertainty);

if ndof >= 3
    MI_Contr3 = PBC_Torque_Controller(MI_motor3.psi_Rmagnom,epsilon_KiS);
    MI_Contr3.MImodel = Contr_MIModel_uncertainty(MI_motor3,MI_motor_uncertainty);
end

if ndof == 6
    MI_Contr4 = PBC_Torque_Controller(MI_motor4.psi_Rmagnom,epsilon_KiS);
    MI_Contr4.MImodel = Contr_MIModel_uncertainty(MI_motor4,MI_motor_uncertainty);
    MI_Contr5 = PBC_Torque_Controller(MI_motor5.psi_Rmagnom,epsilon_KiS);
    MI_Contr5.MImodel = Contr_MIModel_uncertainty(MI_motor5,MI_motor_uncertainty);
    MI_Contr6 = PBC_Torque_Controller(MI_motor6.psi_Rmagnom,epsilon_KiS);
    MI_Contr6.MImodel = Contr_MIModel_uncertainty(MI_motor6,MI_motor_uncertainty);
end

MI_Contrs(1) = MI_Contr1;
MI_Contrs(2) = MI_Contr2;

if ndof >= 3
    MI_Contrs(3) = MI_Contr3;
end

if ndof == 6
    MI_Contrs(4) = MI_Contr4;
    MI_Contrs(5) = MI_Contr5;
    MI_Contrs(6) = MI_Contr6;
end

MI_bus_info = Simulink.Bus.createObject(MI_motor20hp.struct);
MI_bus = evalin('base', MI_bus_info.busName);

Contr_bus_info = Simulink.Bus.createObject(MI_Contr1.struct);
Contr_bus = evalin('base', Contr_bus_info.busName);

handler_SimulinkBlockParams.setControladorPBC(simname,"Actuadores (Motores de inducción)/MI1 + PBC Torque Controller/Controlador PBC",MI_Contr1);
handler_SimulinkBlockParams.setControladorPBC(simname,"Actuadores (Motores de inducción)/MI2 + PBC Torque Controller/Controlador PBC",MI_Contr2);

if ndof >= 3
    handler_SimulinkBlockParams.setControladorPBC(simname,"Actuadores (Motores de inducción)/MI3 + PBC Torque Controller/Controlador PBC",MI_Contr3);
end

if ndof == 6
    handler_SimulinkBlockParams.setControladorPBC(simname,"Actuadores (Motores de inducción)/MI4 + PBC Torque Controller/Controlador PBC",MI_Contr4);
    handler_SimulinkBlockParams.setControladorPBC(simname,"Actuadores (Motores de inducción)/MI5 + PBC Torque Controller/Controlador PBC",MI_Contr5);
    handler_SimulinkBlockParams.setControladorPBC(simname,"Actuadores (Motores de inducción)/MI6 + PBC Torque Controller/Controlador PBC",MI_Contr6);
end

function MImodel = Contr_MIModel_uncertainty(MI_motor,MI_motor_uncertainty)
    MImodel = MI_motor;
    
    MImodel.struct.elecparams.R_R = MI_motor.struct.elecparams.R_R*MI_motor_uncertainty;
    MImodel.struct.elecparams.L_R = MI_motor.struct.elecparams.L_R*MI_motor_uncertainty;
    MImodel.struct.elecparams.sigma = MI_electric_parameters.calculate_sigma(MImodel.struct.elecparams);
    MImodel.struct.elecparams.gamma = MI_electric_parameters.calculate_gamma(MImodel.struct.elecparams);

end
