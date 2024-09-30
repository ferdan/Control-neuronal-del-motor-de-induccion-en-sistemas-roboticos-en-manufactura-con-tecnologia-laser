clc
clear
restoredefaultpath

addpath ..\Model
addpath ..\tau_Rrefs\

tsim = 2*pi+pi/2;
tstep = 1e-2;
tinit = pi/2;
t = 0:tstep:tsim;

%tr_sel = 4;

%robot_params = robot_3dof_params();
robot_params = robot_6dof_params();

n = robot_params.ndof;


for tr_sel = 5
    [r0,dr0,ddr0,~] = trayectoria_muestra(0,0,tr_sel);
    [r,dr,ddr,R] = trayectoria_muestra(t,tinit,tr_sel);
    
    % pol_suavizado = pol7(t,0,1,tinit,tinit+pi/4);
    % tr_referencia = timeseries([r0 + (r-r0).*pol_suavizado;...
    %                             dr0 + (dr-dr0).*pol_suavizado;...
    %                             ddr0 + (ddr-ddr0).*pol_suavizado],t);
    
    tr_referencia = timeseries([r;dr;ddr],t);
    tr_ref.R = R;
    %save("tr_referencia.mat","tr_referencia","-v7.3");
    
    tr_struct = struct('r',r,'dr',dr,'ddr',ddr,'R',R);
    bus_tr_struct_info = Simulink.Bus.createObject(tr_struct);
    tr_struct_bus = evalin('base', bus_tr_struct_info.busName);
    
    robot_params_info = Simulink.Bus.createObject(robot_params.struct);
    robot_params_bus = evalin('base', robot_params_info.busName);
    
    if n == 3
        simname = 'modelo_robot_3dof_dininv';
    elseif n == 6
        simname = 'modelo_robot_6dof_dininv';
    end
    
    out = sim(simname);

    %% Obtener datos de resultados
    
    data = SIMRMA_GraficasHandler.get_data(out,n,simname);
    
    %% Graficas animacion
    
    str_file = "00_mov_robot_dininv_" + string(n) + "dof_"+"tr_"+string(tr_sel);
    str_file = "";
    str_dir_graficas = "RMA"+string(n)+"dof_dininv";
    str_dir_graficas = "";
    
    f_anim = SIMRMA_GraficasHandler.figAnims(robot_params,simname,tr_sel,data.t,0,tsim,data,str_file,str_dir_graficas);
    
    %% Graficas p,q,tauR,P_mech
    
    
    f_data = SIMRMA_GraficasHandler.figData(robot_params,simname,tr_sel,t,0,tsim,data,str_dir_graficas);
    close('all')
    
    %save("tau_Rref_control_tr"+string(tr_sel)+"_"+string(robot_params.ndof)+"dof.mat","tau_Rref","-v7.3");

end

% % tau_Rref_table = array2table([out.tout,tau_Rref],'VariableNames',...
% %                              ["Time","tau_R1","tau_R2","tau_R3"]);
% % writetable(tau_Rref_table,'tau_Rref_tr'+string(tr_sel)+'.csv');
% save("tau_Rref_tr"+string(tr_sel)+"_"+string(n)+"dof.mat","tau_Rref","-v7.3");

% Ver contenido frecuencial de la señal
% [tauRref_scope,tauRref_peaks] = peaks_measurements(tstep,tau_Rref);
% 
% 
% function [scope,peaks] = peaks_measurements(tstep,outdata)
%     scope = spectrumAnalyzer('SampleRate',1/tstep,...'YLimits',[-20,45], ...
%                                'SpectrumType','power','InputDomain','time', ...
%                                'FrequencySpan','start-and-stop-frequencies', ...
%                                'StartFrequency',0,'StopFrequency',10, ...
%                                'ViewType','spectrum',...
%                                PlotAsTwoSidedSpectrum=false);
% 
%     scope(outdata)
% 
%     scope.PeakFinder.Enabled = true;
%     scope.PeakFinder.LabelPeaks = true;
% 
%     data = [];
%     if scope.isNewDataReady
%         data = [data;getMeasurementsData(scope)];
%     end
% 
%     peaks = [data.PeakFinder(end).Value,data.PeakFinder(end).Frequency];
% end


