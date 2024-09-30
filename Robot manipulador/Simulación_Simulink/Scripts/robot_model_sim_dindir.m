clc
clear
restoredefaultpath

addpath ..\Model
addpath ..\tau_Rrefs\

tsim = 10;%4.2;
tstep = 0.01;

t = 0:tstep:tsim;

%robot_params = robot_3dof_params();
robot_params = robot_6dof_params();
n = robot_params.ndof;

if n == 3
    DH = [0                  pi/2 robot_params.d(1) 0;
          robot_params.l(2)  0    0               0;
          robot_params.l(3)  0    0               0];
elseif n == 6
    DH = [0                  pi/2  robot_params.d(1) 0;
          robot_params.l(2)  0     0                 0;
          robot_params.l(3)  0     0                 0;
          0                  pi/2  robot_params.d(4) 0;
          0                  -pi/2 robot_params.d(5) 0;
          0                  0     robot_params.d(6) 0];
end

robot_cinematica = robot_cin(robot_params,DH);
% [q0,dq0,ddq0] = robot_cinematica.cin_inv_6dof(r0,dr0,ddr0,R);


robot_params_info = Simulink.Bus.createObject(robot_params.struct);
robot_params_bus = evalin('base', robot_params_info.busName);

% tau_Rref = load("tau_Rref_tr"+string(tr_sel)+".mat","tau_Rref");
% tau_Rref = timeseries(tau_Rref.tau_Rref,t);
% 
% tau_L = tau_Rref;

tau_Rref = zeros(robot_params.ndof,1);

if n == 3
    tau_L = [0.01;0;0];%zeros(robot_params.ndof,1);
elseif n == 6
    tau_L = [0;0;0;0;0;0];
end

if n == 3
    simname = 'modelo_robot_3dof_dindir';
elseif n == 6
    simname = 'modelo_robot_6dof_dindir';
end

if n == 3
    handler_SimulinkBlockParams.setModelRMA(simname,robot_params,'int_ddq',zeros(n,1))
    handler_SimulinkBlockParams.setModelRMA(simname,robot_params,'int_dq',[0;-pi/2-pi/32;0]);%zeros(n,1))
elseif n == 6
    handler_SimulinkBlockParams.setModelRMA(simname,robot_params,'int_ddq',zeros(n,1))
    handler_SimulinkBlockParams.setModelRMA(simname,robot_params,'int_dq',[0;-pi/2+pi/16;0;pi/2+pi/32;0;0]);%zeros(n,1))
end

out = sim(simname);
%% Obtener datos de resultados

data = SIMRMA_GraficasHandler.get_data(out,n,simname);

%% Graficas animacion

str_file = "00_mov_robot_dindir_" + string(n) + "dof_";
str_file = "";
str_dir_graficas = "RMA"+string(n)+"dof_dindir";
str_dir_graficas = "";

f_anim = SIMRMA_GraficasHandler.figAnims(robot_params,simname,0,data.t,0,tsim,data,str_file,str_dir_graficas);

%% Graficas p,q,tauR,P_mech


f_data = SIMRMA_GraficasHandler.figData(robot_params,simname,0,t,0,tsim,data,str_dir_graficas);
%close('all')

%save("tau_Rref_control_tr"+string(tr_sel)+"_"+string(robot_params.ndof)+"dof.mat","tau_Rref","-v7.3");


% %% Graficas
% 
% p = zeros(size(out.p.data,3),3,robot_params.ndof);
% for i = 1:n
%     p(:,:,i) = figureHandler.checksize(out.p.data(:,i,:));
% end
% 
% % f(1) = plotxyz_animacion(1,robot_params,out.tout,p,double.empty(0),0,0,...
% %        "Movimiento del brazo manipulador en el espacio cartesiano","");
% % f(2) = plotxyz_animacion(2,robot_params,out.tout,p,double.empty(0),1,1,...
% %        "Trayectoria del efector final en el espacio","");
% 
% f(1) = plotxyz_animacion(1,robot_params,out.tout,p,double.empty(0),0,0,...
%        "Movimiento del brazo manipulador en el espacio cartesiano",...
%        "00_mov_robot_dindir_" + string(n) + "dof_equilibrio1_robot");
% f(2) = plotxyz_animacion(2,robot_params,out.tout,p,double.empty(0),1,1,...
%        "Trayectoria del efector final en el espacio",...
%        "00_mov_robot_dindir_" + string(n) + "dof_equilibrio1_trxyz");
% 
% 
% function set_integrador(simname,robot_params,str_bloque,q)
%     load_system(simname)
%     str_path = simname;
%     perfilPaths = find_system(str_path);
%     filtered_perfilPath = perfilPaths(contains(perfilPaths,str_bloque));
%     blockHandlerInt = getSimulinkBlockHandle(filtered_perfilPath,true);
% 
%     str_i = "[";
%     for i = 1:robot_params.ndof
%         str_i = str_i + string(q(i));
%         if i == robot_params.ndof
%             str_i = str_i + "]";
%         else
%             str_i = str_i + ";";
%         end
%     end
%     set_param(blockHandlerInt,"InitialCondition",str_i);
% end



