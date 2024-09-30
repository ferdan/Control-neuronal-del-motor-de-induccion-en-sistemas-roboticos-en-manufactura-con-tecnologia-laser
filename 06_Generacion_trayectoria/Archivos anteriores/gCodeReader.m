function [toolpath,toolpath_time,step_dist] = gCodeReader(filepath, path_res_avg, vel_path,acel_path,snap_path, plot_path, interp, verbose, debug)
%gCodeReader  Function that takes a G-Code file and outputs the tool path 
% for plotting/analysis. Not a complete analysis of the whole file, but 
% more or less the basic motions. 
% Inputs: 
%        - path to G-Code file
%        - point spacing for linear motion (mm or inches, I guess)
%        - point spacing for arc motion (degrees)
%        - Plot the current path (1 or 0)
%        - Output raw G-Code to console
% Outputs:
%        - The interpolated tool path
% Notes:
%        - This is not at all complete, but should work well enough for
%        simple CNC G-Code. If you need anything more complex, I'd suggest
%        you implement it yourself, as this was more or less all I needed
%        at the time.
%        - I have also done zero optimization.
%        - This comes with no guarantees or warranties whatsoever, but I
%        hope it's useful for someone.
% 
% Example usage:
%       toolpath = gCodeReader('simplePart.NC',0.5,0.5,1,0);
% 
% Based on the code of Tom Williamson
% 18/06/2018
% Modified by Fernando Ramirez
% 14/04/2024

raw_gcode_file = fopen(filepath);

% Modes
Rapid_positioning = 0;
Linear_interpolation = 1;
CW_interpolation = 2;
CCW_interpolation = 3;
current_mode = NaN;

% Initialize variables
path = zeros(1000000,3);
path_time = zeros(1000000,1);
interp_pos = nan(3,1);

num_data_points = 1;

t = 0;

step_dist_i = 1;

while ~feof(raw_gcode_file)
    tline = fgetl(raw_gcode_file);
    if verbose == 1
        disp(tline)
    end
    % Check if its an instruction line
    if tline(1) == 'N' || tline(1) == 'G' ...
    || tline(1) == 'X' || tline(1) == 'Y' || tline(1) == 'Z'
        
        %arc_offsets = [0,0,0];
        if tline(1) == 'N'
            tline = tline(6:end);
        end
        splitLine = strsplit(tline,' ');

        if num_data_points > 1
            current_pos = path(num_data_points-1,:);
        else
            current_pos = path(1,:);
        end

        [new_pos,current_mode,arc_offsets] = parse_gLine(current_pos,current_mode,splitLine,verbose);



        % Check the current mode and calculate the next points along the
        % path: linear modes
        if current_mode == Linear_interpolation || current_mode == Rapid_positioning
            [interp_pos,t,step_dist(step_dist_i),tstep(step_dist_i)] = ...
                Line_interpolation(current_pos,vel_path,acel_path,snap_path,...
                                         new_pos,path_res_avg,interp,debug);
            step_dist_i = step_dist_i + 1;
        % Check the current mode and calculate the next points along the
        % path: arc modes, note that this assumes the arc is in the X-Y
        % axis only
        elseif current_mode == CW_interpolation
            counterclockwise = 0;
            [interp_pos,t,step_dist(step_dist_i),tstep(step_dist_i)] = ...
                Circle_interpolation(current_pos,vel_path,counterclockwise,...
                                     acel_path,snap_path,arc_offsets,...
                                     new_pos,path_res_avg,interp,debug);
            step_dist_i = step_dist_i + 1;
        elseif current_mode == CCW_interpolation
            counterclockwise = 1;
            [interp_pos,t,step_dist(step_dist_i),tstep(step_dist_i)] = ...
                Circle_interpolation(current_pos,vel_path,acel_path,snap_path,...
                                     counterclockwise,arc_offsets,...
                                     new_pos,path_res_avg,interp,debug);

            step_dist_i = step_dist_i + 1;
        end
        if ~max(isnan(interp_pos))
            num_data_points_ant = num_data_points;
            num_data_points = num_data_points + size(interp_pos,1);

            path(num_data_points_ant:num_data_points - 1,:) = interp_pos;

            if num_data_points_ant == 1
                tsum = path_time(num_data_points_ant);
            else
                tsum = path_time(num_data_points_ant - 1) + tstep(step_dist_i - 1);
            end
            path_time(num_data_points_ant:num_data_points - 1,:) = tsum + t;
            if debug
                disp("path_time : "+string(path_time(num_data_points - 1,:)));
            end
        end
    end
    % Plot if requested
    if plot_path
        figure(1)
        clf
        title("toolpath")
        ind_data = 1:num_data_points - 1;
        plot3(path(ind_data,1),path(ind_data,2),path(ind_data,3),'r-')
        %pause(0.1)
    end
end

fclose(raw_gcode_file);

toolpath = path(1:num_data_points - 1,:);
toolpath_time = path_time(1:num_data_points - 1);

clear path
clear path_time

end

function [new_pos,current_mode,arc_offsets] = parse_gLine(current_pos,old_mode,splitLine,verbose)
    new_pos = current_pos;
    arc_offsets = [0,0,0];
    current_mode = old_mode;
    for i = 1:length(splitLine)
        if verbose == 1
            disp(splitLine{i});
        end
        % Check what the command is (only the main ones are
        % implemented i.e. G0 - G3)
        if strcmp(splitLine{i}, 'G0')
            if verbose == 1
                disp('Rapid positioning')
            end
            current_mode = 0; % Rapid_positioning
        elseif strcmp(splitLine{i}, 'G1')
            if verbose == 1
                disp('Linear interpolation')
            end
            current_mode = 1; % Linear_interpolation
        elseif strcmp(splitLine{i}, 'G2')
            if verbose == 1
                disp('Circular interpolation, clockwise')
            end
            current_mode = 2; % CW_interpolation
        elseif strcmp(splitLine{i}, 'G3')
            if verbose == 1
                disp('Circular interpolation, counterclockwise')
            end
            current_mode = 3; % CCW_interpolation
        else
            if ~isempty(splitLine{i})
                if splitLine{i}(1) == 'X'
                    new_pos(1) = str2double(splitLine{i}(2:end));
                elseif splitLine{i}(1) == 'Y'
                    new_pos(2) = str2double(splitLine{i}(2:end));
                elseif splitLine{i}(1) == 'Z'
                    new_pos(3) = str2double(splitLine{i}(2:end));
                elseif splitLine{i}(1) == 'I'
                    arc_offsets(1) = str2double(splitLine{i}(2:end));
                elseif splitLine{i}(1) == 'J'
                    arc_offsets(2) = str2double(splitLine{i}(2:end));
                end
            end
        end
    end
end

function [interp_pos,t,step_dist,tstep] = Line_interpolation(current_pos,vel_path,acel_path,snap_path,new_pos,dist_res,interp,debug)

    dist = norm((new_pos - current_pos));
    if dist > dist_res

        %vel_path = 5;

        num_steps = round(dist/dist_res);
        step_dist = dist/num_steps;

        tend = dist/vel_path;
        tstep = tend/num_steps;

        t = (0:tstep:(tend-tstep))';

        switch interp
            case 0 % linear interpolation
                q = 0:step_dist:dist;
                q = q(1:end-1)';
            case 1 % 7th order polinomial
                q = interpol_pol7(dist,t,tend-tstep,debug);
            case 2 % 15 segments trajectory
                [q,T] = pol15segs.bounded_tr(dist,num_steps,vel_path,acel_path,snap_path,debug);
                q = q(1:end-1)';

                tstep = T/num_steps;
                t = (0:tstep:(T-tstep))';
        end

        dire = (new_pos - current_pos)/dist;
        interp_pos = current_pos + dire.*q;
    else
        interp_pos = NaN;
        step_dist = NaN;
        tstep = NaN;
        t = NaN;
    end
end

function [interp_pos,t,step_dist,tstep] = Circle_interpolation(current_pos,vel_path,acel_path,snap_path,counterclockwise,arc_offsets,new_pos,dist_res,interp,debug)
    center_pos = current_pos + arc_offsets;

    v1 = (current_pos(1:2)-center_pos(1:2));
    v2 = (new_pos(1:2)-center_pos(1:2));
    if debug
        disp("norm(v1) - norm(v2):" + string(norm(v1)) + " - " + string(norm(v2)) + " = " + string(abs(norm(v1) - norm(v2))));
    end

    r = norm(new_pos(1:2)-center_pos(1:2));
    tol = 1e-12;

    if abs(norm(v1) - norm(v2)) > tol
        r = max(norm(v1),norm(v2));
        pc = Circle_coords(current_pos(1:2),new_pos(1:2),r,abs(norm(v1) - norm(v2)));

        if size(pc,1) > 0
            [~,id_min] = min(sqrt(sum((pc-center_pos(1:2)).^2,2)));
            center_new_pos = pc(id_min,:);
    
            v1new = (current_pos(1:2)-center_new_pos(1:2));
            v2new = (new_pos(1:2)-center_new_pos(1:2));
    
            if abs(norm(v1new) - norm(v2new)) < abs(norm(v1) - norm(v2))
                center_pos(1:2) = center_new_pos;
                v1 = v1new;
                v2 = v2new;
                if debug
                    disp("Recalculate center: norm(v1) - norm(v2):" + string(norm(v1)) + " - " + string(norm(v2)) + " = " + string(abs(norm(v1) - norm(v2))));
                end
            else
                if debug
                    disp("Cant improve more");
                end
            end
        else
            if debug
                disp("Cant improve more");
            end
        end
    end
    
    angle_1 = atan2(v1(2),v1(1));
    angle_2 = atan2(v2(2),v2(1));

    if counterclockwise == 1
        if norm(v1) <0.1
            angle_1 = 0;
        end
    
        if norm(v2) <0.1
            angle_2 = 0;
        end
        
        if angle_2 < angle_1
            angle_2 = angle_2 + 2*pi;
        end
    end

    distz = norm(new_pos(3) - current_pos(3));

    delta_angle = abs(angle_2-angle_1);
    dist = delta_angle*r;

    num_steps = round(dist/dist_res);
    step_dist = dist/round(dist/dist_res);

    tend = dist/vel_path;
    tstep = tend/num_steps;

    t = (0:tstep:(tend-tstep))';

    switch interp
        case 0 % linear interpolation
            q = (0:step_dist:dist)';
            q = q(1:end-1)';

            if distz > step_dist
                qz = (0:distz/size(q,2):distz)';
                qz = qz(1:end-1)';
            else
                qz = zeros(q)';
            end
        case 1 % 7th order polinomial
            q = interpol_pol7(dist,t,tend-tstep,debug);

            if distz > step_dist
                qz = interpol_pol7(distz,t,tend-tstep,debug);
            else
                qz = zeros(size(q))';
            end
        case 2 % 15 segments trajectory
            [q,Tr] = pol15segs.bounded_tr(dist,num_steps,vel_path,acel_path,snap_path,debug);
            q = q(1:end-1)';

            if distz > step_dist
                [qz,Tz] = pol15segs.bounded_tr(distz,num_steps,vel_path,acel_path,snap_path,debug);
                qz = qz(1:end-1);
            else
                qz = zeros(size(q))';
                Tz = Tr;
            end

            T = max(Tr,Tz);
            tstep = T/num_steps;
            t = (0:tstep:(T-tstep))';
    end

    interp_pos = angle_1 + (q./r);

    % polar transformation
    pos_x = center_pos(1) + cos(interp_pos)'*r;
    pos_y = center_pos(2) + sin(interp_pos)'*r;

    if distz ~= 0
        dire = (new_pos(3) - current_pos(3))/distz;
    else
        dire = 0;
    end
    pos_z = current_pos(3) + dire.*qz;
    interp_pos = [pos_x;pos_y;pos_z]';
    interp_pos;
end


function q = interpol_pol7(dist,t,tend,debug)
    [q,d1q,d2q,d3q] = pol7(t,0,dist,0,tend);
    if debug == 1
        figure(2)
        subplot(4,1,1)
        plot(q)
        subplot(4,1,2)
        plot(d1q)
        subplot(4,1,3)
        plot(d2q)
        subplot(4,1,4)
        plot(d3q)
    end
end


