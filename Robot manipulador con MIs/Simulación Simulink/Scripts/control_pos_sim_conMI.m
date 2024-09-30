clc
clear
restoredefaultpath

addpath ..\Model
addpath ..\MI_motors\

tstep = 5e-4;
t_tr_init = 10; % Al menos 8s
t_qeq_init = 1; % Al menos 0.5s

tsim = 4*pi+t_tr_init;
t = 0:tstep:tsim;

%% Modelo robot manipulador

%robot_params = robot_3dof_params();
robot_params = robot_6dof_params();
    
n = robot_params.ndof;

if n == 3
    DH = [0                  pi/2 robot_params.d(1) 0;
          robot_params.l(2)  0    0                 0;
          robot_params.l(3)  0    0                 0];
elseif n == 6
    DH = [0                  pi/2  robot_params.d(1) 0;
          robot_params.l(2)  0     0                 0;
          robot_params.l(3)  0     0                 0;
          0                  pi/2  robot_params.d(4) 0;
          0                  -pi/2 robot_params.d(5) 0;
          0                  0     robot_params.d(6) 0];
end

%% Controlador
if n == 3
    a0 = [400;150;100];
    a1 = [30;20;15];
elseif n == 6
    a0 = [2500;2000;2500;5000;2000;2000];
    a1 = [10;10;10;10;10;10];
end

%tr_sel = 1;

for tr_sel = 1:5
    
    robot_cinematica = robot_cin(robot_params,DH);
    [r0,dr0,ddr0,R] = trayectoria_muestra(0,0,tr_sel);
    
    if n == 3
        [q0,dq0,ddq0] = robot_cinematica.cin_inv_3dof(r0,dr0,ddr0);
    elseif n == 6
        [q0,dq0,ddq0] = robot_cinematica.cin_inv_6dof(r0,dr0,ddr0,R);
    end
    
    [r,dr,ddr] = trayectoria_muestra(t,t_tr_init,tr_sel);
    % pol_suavizado = pol7(t,0,1,t_tr_init,t_tr_init+pi/4);
    % 
    % tr_referencia = timeseries([r0 + (r-r0).*pol_suavizado;...
    %                             dr0 + (dr-dr0).*pol_suavizado;...
    %                             ddr0 + (ddr-ddr0).*pol_suavizado],t);
    
    tr_referencia = timeseries([r;dr;ddr],t);
    tr_ref.R = R;
    
    tr_struct = struct('r',r,'dr',dr,'ddr',ddr,'R',R);
    bus_tr_struct_info = Simulink.Bus.createObject(tr_struct);
    tr_struct_bus = evalin('base', bus_tr_struct_info.busName);
    
    robot_params_info = Simulink.Bus.createObject(robot_params.struct);
    robot_params_bus = evalin('base', robot_params_info.busName);
    
    robot_din = struct('D',zeros(robot_params.ndof,robot_params.ndof),...
                       'C',zeros(robot_params.ndof,robot_params.ndof),...
                       'G',zeros(robot_params.ndof,1),'g',9.81);
    bus_robot_din_info = Simulink.Bus.createObject(robot_din);
    robot_din_bus = evalin('base', bus_robot_din_info.busName);
    
    if n == 3
        simname = 'control_pos_3dof_conMI';
    elseif n == 6
        simname = 'control_pos_6dof_conMI';
    end
    
    if n == 3
        handler_SimulinkBlockParams.setModelRMA(simname,robot_params,'int_ddq',[0;0;0]);%dq0)
        handler_SimulinkBlockParams.setModelRMA(simname,robot_params,'int_dq',[0;-pi/2;0]) % inicializar en punto de equilibrio
    elseif n == 6
        handler_SimulinkBlockParams.setModelRMA(simname,robot_params,'int_ddq',[0;0;0;0;0;0]);%dq0)
        handler_SimulinkBlockParams.setModelRMA(simname,robot_params,'int_dq',[0;-pi/2;0;pi/2;0;0]) % inicializar en punto de equilibrio
    end
    
    
    if n == 3
        tau_L = [0;0;0];
    elseif n == 6
        tau_L = [0;0;0;0;0;0];
    end
    
    setup_motores_MI;
    
    out = sim(simname);
    
    %% Obtener datos de resultados
    
    data = SIMRMA_GraficasHandler.get_data(out,n,simname);
    
    %% Graficas animacion
    
    str_file = "00_mov_robot_control_" + string(n) + "dof_"+"tr_"+string(tr_sel);
    %str_file = "";
    str_dir_graficas = "RMA"+string(n)+"dof_Control";
    %str_dir_graficas = "";
    
    f_anim = SIMRMA_GraficasHandler.figAnims(robot_params,simname,tr_sel,data.t,t_tr_init,tsim,data,str_file,str_dir_graficas);
    
    %% Graficas p,q,tauR,P_mech
    
    
    %f_data = SIMRMA_GraficasHandler.figData(robot_params,simname,tr_sel,t,t_tr_init,tsim,data,str_dir_graficas);
    close('all')
    
    %save("tau_Rref_control_tr"+string(tr_sel)+"_"+string(robot_params.ndof)+"dof.mat","tau_Rref","-v7.3");
end