%'simplePart.NC'
path_res_avg = tstep; % asegurar que sea lo suficientemente pequeño para evitar que el controlador oscile
vel_path = 10;
acel_path = 5; % only for 15 segs trajectory
snap_path = 100; % only for 15 segs trajectory
plot_opt = 0;
verbose_opt = 0;
interp_opt = 2; % 0 = linear, 1 = 7th order pol, 2 = 15 segs trajectory
debug_opt = 0;
%'simplePart.NC'
%'PI3_Simple_Hexagon2.gcode'
%'MiniTest1_Square.txt'
[toolpath,toolpath_time,step_dist] = gCodeReader('../../../06_Generacion_trayectoria/PI3_Simple_Hexagon2.gcode',...
           path_res_avg,vel_path,acel_path,snap_path,...
           plot_opt,interp_opt,verbose_opt,debug_opt);
phi = 180*pi/180;
theta = 0*pi/180;
gamma = 0*pi/180;

R = XYZ(phi,theta,gamma);


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