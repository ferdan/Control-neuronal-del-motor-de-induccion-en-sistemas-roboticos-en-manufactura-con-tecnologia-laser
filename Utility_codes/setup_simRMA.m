
tr_struct = struct('r',r,'dr',dr,'ddr',ddr,'R',R);

Perfil_bus_info = Simulink.Bus.createObject(tau_L.perfiles);
Perfil_bus = evalin('base', Perfil_bus_info.busName);

bus_tr_struct_info = Simulink.Bus.createObject(tr_struct);
tr_struct_bus = evalin('base', bus_tr_struct_info.busName);

robot_params_info = Simulink.Bus.createObject(robot_params.struct);
robot_params_bus = evalin('base', robot_params_info.busName);

NN_Bspline_params_info = Simulink.Bus.createObject(NN_Bspline_params.struct);
NN_Bspline_params_bus = evalin('base', NN_Bspline_params_info.busName);

NN_RBF_params_info = Simulink.Bus.createObject(NN_RBF_params.struct);
NN_RBF_params_bus = evalin('base', NN_RBF_params_info.busName);

robot_din = struct('D',zeros(ndof,ndof),'C',zeros(ndof,ndof),'G',zeros(ndof,1),'g',9.81);
bus_robot_din_info = Simulink.Bus.createObject(robot_din);
robot_din_bus = evalin('base', bus_robot_din_info.busName);
