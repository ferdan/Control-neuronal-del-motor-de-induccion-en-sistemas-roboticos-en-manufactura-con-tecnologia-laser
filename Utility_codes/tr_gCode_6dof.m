%'simplePart.NC'
path_res_avg = tstep; % asegurar que sea lo suficientemente pequeño para evitar que el controlador oscile
vel_path = 80;
acel_path = 180; % only for 15 segs trajectory
snap_path = 60000; % only for 15 segs trajectory
plot_opt = 0;
verbose_opt = 0;
interp_opt = 2; % 0 = linear, 1 = 7th order pol, 2 = 15 segs trajectory
debug_opt = 0;
%'simplePart.NC'
%'PI3_Simple_Hexagon3.gcode'
%'MiniTest1_Square.txt'

str_path = "../../../06_Generacion_trayectoria/";
str_file = "PI3_Simple_Hexagon3.gcode";%"MiniTest1_Square.txt";%"simplePart.NC";%

[toolpath,toolpath_time,step_dist] = gCodeReader(str_path+str_file,...
           path_res_avg,vel_path,acel_path,snap_path,...
           plot_opt,interp_opt,verbose_opt,debug_opt);
phi = 180*pi/180;
theta = 0*pi/180;   
gamma = 0*pi/180;

R = XYZ(phi,theta,gamma);


if strcmp(str_file,'simplePart.NC') == 1 || strcmp(str_file,'MiniTest1_Square.txt') == 1
    r = [toolpath(:,2)'.*0.01+0.8;toolpath(:,1)'.*0.01;toolpath(:,3)'.*0.01+0.2];
elseif strcmp(str_file,'PI3_Simple_Hexagon2_var.gcode') == 1
    r = [toolpath(:,1)'.*0.01+0.4;toolpath(:,2)'.*0.01-0.2;toolpath(:,3)'.*0.01];
end


function R = XYZ(phi,theta,gamma)
    R_xphi     = [1, 0       , 0        ;
                  0, cos(phi), -sin(phi);
                  0, sin(phi),  cos(phi)];

    R_yptheta  = [ cos(theta), 0, sin(theta);
                   0         , 1, 0         ;
                  -sin(theta), 0, cos(theta)];

    R_zppgamma = [cos(gamma), -sin(gamma), 0;
                  sin(gamma),  cos(gamma), 0;
                  0         , 0          , 1];
    R = R_xphi*R_yptheta*R_zppgamma;
end