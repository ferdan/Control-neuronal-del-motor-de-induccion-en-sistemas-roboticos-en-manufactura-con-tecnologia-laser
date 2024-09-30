addpath ..\Utility_codes\

path_res_avg = 0.01;
vel_path = 5;
acel_path = 2.5; % only for 15 segs trajectory
snap_path = 100; % only for 15 segs trajectory
plot_opt = 1;
verbose_opt = 1;
interp_opt = 2; % 0 = linear, 1 = 7th order pol, 2 = 15 segs trajectory
debug_opt = 1;
%'simplePart.NC'
%'PI3_Simple_Hexagon2.gcode'
%'MiniTest1_Square.txt'
[toolpath,toolpath_time,step_dist] = gCodeReader('PI3_Simple_Hexagon2.gcode',...
           path_res_avg,vel_path,acel_path,snap_path,...
           plot_opt,interp_opt,verbose_opt,debug_opt);

path_distance = sqrt(sum(toolpath.^2,2));

total_distance = zeros(size(path_distance));
% 
% for i = 1:size(path_distance,1)
%     total_distance(i) = sum(path_distance(1:i));
% end

f = figure(1);
title("Toolpath")

lims = minmax(toolpath');

if min(sum(abs(lims),2)) == 0
    offset = max(max(min(toolpath),max(toolpath)*0.1));

    lims(:,2) = lims(:,2)+offset;
end

pbaspect(sum(abs(lims),2)')

%plot3(toolpath(:,2).*0.01+0.8,toolpath(:,1).*0.01,toolpath(:,3).*0.01+0.2)

figure(2)
clf
sgtitle("Toolpath in xyz")
subplot(3,1,1)
plot(toolpath_time,toolpath(:,1))
ylabel("x")
subplot(3,1,2)
plot(toolpath_time,toolpath(:,2))
ylabel("y")
subplot(3,1,3)
plot(toolpath_time,toolpath(:,3))
ylabel("z")

figure(3)
clf
sgtitle("First Derivative of Toolpath in xyz")
subplot(3,1,1)
plot(toolpath_time(1:(end-1)),diff(toolpath(:,1)))
ylabel("x")
subplot(3,1,2)
plot(toolpath_time(1:(end-1)),diff(toolpath(:,2)))
ylabel("y")
subplot(3,1,3)
plot(toolpath_time(1:(end-1)),diff(toolpath(:,3)))
ylabel("z")

figure(4)
clf
sgtitle("Second Derivative of Toolpath in xyz")
subplot(3,1,1)
plot(toolpath_time(1:(end-2)),diff(diff(toolpath(:,1))))
ylabel("x")
subplot(3,1,2)
plot(toolpath_time(1:(end-2)),diff(diff(toolpath(:,2))))
ylabel("y")
subplot(3,1,3)
plot(toolpath_time(1:(end-2)),diff(diff(toolpath(:,3))))
ylabel("z")

figure(5)
clf
plot(path_distance);
title("Path distance sqrt(x^2+y^2+z^2)")

% figure(6)
% clf
% plot(total_distance);
% title("Total distance")

figure(7)
clf
histogram(step_dist,20)
