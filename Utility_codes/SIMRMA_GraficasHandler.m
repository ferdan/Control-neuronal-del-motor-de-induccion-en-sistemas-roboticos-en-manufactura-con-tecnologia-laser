classdef SIMRMA_GraficasHandler
    methods (Static)

        function f_anim = figAnims(robot_params,simname,tr_sel,t,tinit,tsim,data,str_file,str_dir_graficas)
            
            str_sim = SIMRMA_GraficasHandler.get_simtype(simname);

            [~,tinit1_ind] = min(abs(t-1-tinit/2));
            [~,tinit2_ind] = min(abs(t-tinit));
            
            % [~,tfin_ind] = min(abs(t-tsim));
            
            % ind_data1 = tinit1_ind:tfin_ind;
            % ind_data2 = tinit2_ind:tfin_ind;

            str_file_figs = strings(3,1);

            if ~strcmp(str_file,"")
                str_file_figs(1) = str_file + "_robot(completo)";
                str_file_figs(2) = str_file + "_robot";
                str_file_figs(3) = str_file + "_pxyz";
            end

            if strcmp(str_sim,"dindir") || strcmp(str_sim,"dininv")
                p = data.p;
                p_ref = double.empty(0);
            else
                p = data.p;
                p_ref = data.p_ref;
            end

            if tinit ~= 0
                f_anim(1) = SIMRMA_GraficasHandler.plotxyz_animacion(11,robot_params,...
                       t,1,p,p_ref,0,0,...
                       "Movimiento del brazo manipulador en el espacio cartesiano (completo)",...
                       str_file_figs(1));
            end

            f_anim(2) = SIMRMA_GraficasHandler.plotxyz_animacion(12,robot_params,...
                   t,tinit1_ind,p,p_ref,0,0,...
                   "Movimiento del brazo manipulador en el espacio cartesiano",...
                   str_file_figs(2));

            f_anim(3) = SIMRMA_GraficasHandler.plotxyz_animacion(13,robot_params,...
                   t,tinit2_ind,p,p_ref,1,1,...
                   "Trayectoria del efector final en el espacio",...
                   str_file_figs(3));

            if ~strcmp(str_dir_graficas,"")
                if tr_sel ~= 0
                    str_tr_sel = "tr"+string(tr_sel);
                else
                    str_tr_sel = "";
                end
                if tinit ~= 0
                    figureHandler.guardarGrafica(f_anim(1),str_dir_graficas,str_tr_sel,"00",str_file_figs(1));
                end
                figureHandler.guardarGrafica(f_anim(2),str_dir_graficas,str_tr_sel,"00",str_file_figs(2));
                figureHandler.guardarGrafica(f_anim(3),str_dir_graficas,str_tr_sel,"00",str_file_figs(3));
            end
        end

        function f_data = figData(robot_params,simname,tr_sel,t,tinit,tfin,data,str_dir_graficas)

            ndof = robot_params.ndof;

            if ndof == 6
                nrep = 3;
            else
                nrep = ndof;
            end

            str_sim = SIMRMA_GraficasHandler.get_simtype(simname);

            [~,tinit_ind] = min(abs(t-tinit));
            [~,tfin_ind] = min(abs(t-tfin));
            ind_data = tinit_ind:tfin_ind;


            lgd_p = ["$p_{x}$","$p_{y}$"];
            lgd_dp = ["$\dot{p}_{x}$","$\dot{p}_{y}$"];
            lgd_ddp = ["$\ddot{p}_{x}$","$\ddot{p}_{y}$"];

            lgd_ep = ["$e_{p_x}$","$e_{p_y}$"];
            lgd_dep = ["$\dot{e}_{p_x}$","$\dot{e}_{p_y}$"];
            lgd_ddep = ["$\ddot{e}_{p_x}$","$\ddot{e}_{p_y}$"];

            if ndof > 2
                lgd_p = cat(2,lgd_p,"$p_{z}$");
                lgd_dp = cat(2,lgd_dp,"$\dot{p}_{z}$");
                lgd_ddp = cat(2,lgd_ddp,"$\ddot{p}_{z}$");

                lgd_ep = cat(2,lgd_ep,"$e_{p_z}$");
                lgd_dep = cat(2,lgd_dep,"$\dot{e}_{p_z}$");
                lgd_ddep = cat(2,lgd_ddep,"$\ddot{e}_{p_z}$");
            end

            lgd_q = strings(1,ndof);
            lgd_dq = strings(1,ndof);
            lgd_ddq = strings(1,ndof);

            lgd_eq = strings(1,ndof);
            lgd_deq = strings(1,ndof);
            lgd_ddeq = strings(1,ndof);

            lgd_tauR = strings(1,ndof);
            lgd_tauL = strings(1,ndof);
            lgd_tauRref = strings(1,ndof);
            lgd_tauRMI = strings(1,ndof);
            lgd_Pmech = strings(1,ndof);

            for i = 1:ndof
                lgd_q(i) = "$\theta_"+ string(i) +"$";
                lgd_dq(i) = "$\dot{\theta}_"+ string(i) +"$";
                lgd_ddq(i) = "$\ddot{\theta}_"+ string(i) +"$";

                lgd_eq(i) = "$e_{\theta_" + string(i) + "}$";
                lgd_deq(i) = "$\dot{e}_{\theta_" + string(i) + "}$";
                lgd_ddeq(i) = "$\ddot{e}_{\theta_" + string(i) + "}$";

                lgd_tauR(i) = "$\tau_{R" + string(i) + "}$";
                lgd_tauL(i) = "$\tau_{L" + string(i) + "}$";
                lgd_tauRref(i) = "$\tau_{Rref" + string(i) + "}$";
                lgd_tauRMI(i) = "$\tau_{R(MI" + string(i) + ")}$";
                lgd_Pmech(i) = "$P_{" + string(i) + "}$";
            end

            f_data(1) = figureHandler.graficar_Fig(1,0,[3,nrep],...
                   "Efector final", ...
                   t(ind_data),...
                   [data.p(ind_data,1:nrep,ndof),...
                    data.dp(ind_data,1:nrep),...
                    data.ddp(ind_data,1:nrep)], ...
                   "Tiempo [s]",repelem(["$[m]$","$[m/s]$","$[m/s^2$]"],nrep), ...
                   horzcat(lgd_p,lgd_dp,lgd_ddp),...
                   "northeast");
            
            f_data(2) = figureHandler.graficar_Fig(2,0,[3,nrep],...
                   "Articulaciones 1-" + string(nrep) + " del brazo manipulador", ...
                   t(ind_data),...
                   [data.q(ind_data,1:nrep),...
                    data.dq(ind_data,1:nrep),...
                    data.ddq(ind_data,1:nrep)], ...
                   "Tiempo [s]",repelem(["$[rad]$","$[rad/s]$","$[rad/s^2$]"],nrep), ...
                   horzcat(lgd_q(1:nrep),lgd_dq(1:nrep),lgd_ddq(1:nrep)),...
                   "northeast");
            
            if ndof == 6
                f_data(3) = figureHandler.graficar_Fig(3,0,[3,nrep],...
                       "Articulaciones " + string(nrep+1) + "-" + string(ndof) + " del brazo manipulador", ...
                       t(ind_data),...
                       [data.q(ind_data,(nrep+1):ndof),...
                        data.dq(ind_data,(nrep+1):ndof),...
                        data.ddq(ind_data,(nrep+1):ndof)], ...
                       "Tiempo [s]",repelem(["$[rad]$","$[rad/s]$","$[rad/s^2$]"],nrep), ...
                       horzcat(lgd_q((nrep+1):ndof),lgd_dq((nrep+1):ndof),lgd_ddq((nrep+1):ndof)),...
                        "northeast");
            end
            
            
            if strcmp(str_sim,"control_conMI") || strcmp(str_sim,"control_sinMI")
                f_data(4) = figureHandler.graficar_Fig(4,0,[3,nrep],...
                       "Error de seguimiento del efector final", ...
                       t(ind_data),[data.p(ind_data,:,ndof)-data.p_ref(ind_data,1:nrep),...
                       data.dp(ind_data,1:nrep)-data.dp_ref(ind_data,1:nrep),...
                       data.ddp(ind_data,1:nrep)-data.ddp_ref(ind_data,1:nrep)], ...
                       "Tiempo [s]",repelem(["$[m]$","$[m/s]$","$[m/s^2$]"],nrep), ...
                       horzcat(lgd_ep,lgd_dep,lgd_ddep),...
                       "northeast");
                
                f_data(5) = figureHandler.graficar_Fig(5,0,[3,nrep],...
                       "Error de seguimiento de las articulaciones 1-" + string(nrep) +" del brazo manipulador", ...
                       t(ind_data),[data.q(ind_data,1:nrep)-data.q_ref(ind_data,1:nrep),...
                       data.dq(ind_data,1:nrep)-data.dq_ref(ind_data,1:nrep),...
                       data.ddq(ind_data,1:nrep)-data.ddq_ref(ind_data,1:nrep)], ...
                       "Tiempo [s]",repelem(["$[rad]$","$[rad/s]$","$[rad/s^2$]"],nrep), ...
                       horzcat(lgd_eq(1:nrep),lgd_deq(1:nrep),lgd_ddeq(1:nrep)),...
                       "northeast");
            
                if ndof == 6
                    f_data(6) = figureHandler.graficar_Fig(6,0,[3,3],...
                           "Error de seguimiento de las articulaciones 4-6 del brazo manipulador", ...
                           t(ind_data),[data.q(ind_data,(nrep+1):ndof)-data.q_ref(ind_data,(nrep+1):ndof),...
                           data.dq(ind_data,(nrep+1):ndof)-data.dq_ref(ind_data,(nrep+1):ndof), ...
                           data.ddq(ind_data,(nrep+1):ndof)-data.ddq_ref(ind_data,(nrep+1):ndof)], ...
                           "Tiempo [s]",repelem(["$[rad]$","$[rad/s]$","$[rad/s^2$]"],nrep), ...
                           horzcat(lgd_eq((nrep+1):ndof),lgd_deq((nrep+1):ndof),lgd_ddeq((nrep+1):ndof)),...
                           "northeast");
                end
            end
            

            if strcmp(str_sim,"dininv")
                f_data(7) = figureHandler.graficar_Fig(7,floor((6-ndof)/3),[nrep,ceil(ndof/3)],...
                       "Perfil de torque (modelo)",...
                       t(ind_data),data.tau_Rref(ind_data,:),...
                       "Tiempo [s]","Torque [N m]",...
                       lgd_tauR,...
                       "northeast");
            elseif strcmp(str_sim,"control_sinMI")
                f_data(7) = figureHandler.graficar_Fig(7,floor((6-ndof)/3),[nrep,ceil(ndof/3)],...
                       "Perfil de torque (controlador)",...
                       t(ind_data),data.tau_Rref(ind_data,:),...
                       "Tiempo [s]","Torque [N m]",...
                       lgd_tauR,...
                       "northeast");
            elseif strcmp(str_sim,"control_conMI")
                tau_Rcomp = zeros(size(data.tau_R(:,1),1),2,ndof);
                lgd_tauRcomp = strings(2,ndof);
                for i = 1:ndof
                    tau_Rcomp(:,1,i) = data.tau_R(:,i);
                    tau_Rcomp(:,2,i) = data.tau_Rref(:,i);
                    lgd_tauRcomp(1,i) = lgd_tauRref(i);
                    lgd_tauRcomp(2,i) = lgd_tauR(i);
                end
                f_data(7) = figureHandler.graficar_Fig_multiplot(7,floor((6-ndof)/3),[nrep,ceil(ndof/3)],...
                       "Seguimiento de torque (controlador - actuadores)",...
                       t(ind_data),tau_Rcomp(ind_data,:,1:ndof),...
                       "Tiempo [s]","Torque [N m]",...
                       lgd_tauRcomp,'bestoutside');
            end

            if ~strcmp(str_sim,"dindir")
                f_data(8) = figureHandler.graficar_Fig(8,floor((6-ndof)/3),[nrep,ceil(ndof/3)],...
                       "Torque de carga",...
                       t(ind_data),data.tau_L(ind_data,:),...
                       "Tiempo [s]","Torque [N m]",...
                       lgd_tauL,...
                       "northeast");
            end


            % Falta error de seguimiento de actuadores
            if strcmp(str_sim,"control_conMI")
                f_data(9) = figureHandler.graficar_Fig(9,floor((6-ndof)/3),[nrep,ceil(ndof/3)],...
                       "Torque producido por los actuadores",...
                       t(ind_data),data.tau_RMI(ind_data,:),...
                       "Tiempo [s]","Torque [N m]",...
                       lgd_tauRMI,...
                       "northeast");
            end
            
            f_data(10) = figureHandler.graficar_Fig(10,floor((6-ndof)/3),[nrep,ceil(ndof/3)],...
                   "Potencia mecanica de cada articulacion",...
                   t(ind_data),data.P_mech(ind_data,:),...
                   "Tiempo [s]","Potencia [W]",...
                   lgd_Pmech,...
                   "northeast");

            if strcmp(str_sim,"control_conMI") || strcmp(str_sim,"control_sinMI")
                f_data(31) = figureHandler.graficar_Fig(31,0,[1,1],...
                       "Error de seguimiento del efector final",...
                       t(ind_data),data.norm_e_p(ind_data,1),...
                       "Tiempo [s]","Posicion [m]",...
                       "$||e_p||$",...
                       "northeast");
            end
        
            
            if ~strcmp(str_dir_graficas,"")
                figureHandler.guardarGrafica(f_data(1),str_dir_graficas,"tr"+string(tr_sel),"01","Posicion_xyz");
                figureHandler.guardarGrafica(f_data(2),str_dir_graficas,"tr"+string(tr_sel),"02","Posicion_q123");
                
                if ndof == 6
                    figureHandler.guardarGrafica(f_data(3),str_dir_graficas,"tr"+string(tr_sel),"03","Posicion_q456");
                end
                
                if strcmp(str_sim,"control_conMI") || strcmp(str_sim,"control_sinMI")
                    figureHandler.guardarGrafica(f_data(4),str_dir_graficas,"tr"+string(tr_sel),"04","Error_Posicion_xyz");
                    figureHandler.guardarGrafica(f_data(5),str_dir_graficas,"tr"+string(tr_sel),"05","Error_Posicion_q123");
                    
                    if ndof == 6
                        figureHandler.guardarGrafica(f_data(6),str_dir_graficas,"tr"+string(tr_sel),"06","Error_Posicion_q456");
                    end
                end
                
                if ~strcmp(str_sim,"dindir")
                    figureHandler.guardarGrafica(f_data(7),str_dir_graficas,"tr"+string(tr_sel),"07","Torque");
                    figureHandler.guardarGrafica(f_data(8),str_dir_graficas,"tr"+string(tr_sel),"08","Torque_carga");
                end
                
                if strcmp(str_sim,"control_conMI")
                    figureHandler.guardarGrafica(f_data(9),str_dir_graficas,"tr"+string(tr_sel),"09","Torque(actuadores)");
                end
                figureHandler.guardarGrafica(f_data(10),str_dir_graficas,"tr"+string(tr_sel),"10","Potencia");
                if strcmp(str_sim,"control_conMI") || strcmp(str_sim,"control_sinMI")
                    figureHandler.guardarGrafica(f_data(31),str_dir_graficas,"tr"+string(tr_sel),"00","Norma_error_posicion");
                end
            end

        end

        function data = get_data(out,ndof,simname)

            str_sim = SIMRMA_GraficasHandler.get_simtype(simname);
            
            data.t = out.tout;
            
            if ndof ~= 2
                data.p = zeros(size(out.p.data,3),3,ndof);
            else
                data.p = zeros(size(out.p.data,3),2,ndof);
            end
            for i = 1:ndof
                data.p(:,:,i) = figureHandler.checksize(out.p.data(:,i,:));
            end
            data.dp = figureHandler.checksize(out.dp.data);
            data.ddp = figureHandler.checksize(out.ddp.data);
            
            data.norm_e_p = out.norm_e_p.data;

            data.q = figureHandler.checksize(out.q.data);
            data.dq = figureHandler.checksize(out.dq.data);
            data.ddq = figureHandler.checksize(out.ddq.data);

            data.P_mech = figureHandler.checksize(out.P_mech.data);
            data.tau_Rref = figureHandler.checksize(out.tau_Rref.data);
            data.tau_L = figureHandler.checksize(out.tau_L.data);
            
            if strcmp(str_sim,"control_sinMI") || strcmp(str_sim,"control_conMI")
                data.p_ref = figureHandler.checksize(out.p_ref.data);
                data.dp_ref = figureHandler.checksize(out.dp_ref.data);
                data.ddp_ref = figureHandler.checksize(out.ddp_ref.data);

                data.q_ref = figureHandler.checksize(out.q_ref.data);
                data.dq_ref = figureHandler.checksize(out.dq_ref.data);
                data.ddq_ref = figureHandler.checksize(out.ddq_ref.data);


                if strcmp(str_sim,"control_conMI")
                    data.tau_R = figureHandler.checksize(out.tau_R.data);
                    data.tau_RMI = figureHandler.checksize(out.tau_RMI.data);
                end
            end
        end

        function str_sim = get_simtype(simname)
            str_simname = string(split(simname,"_"));
            if strcmp(str_simname(1),"control") || strcmp(str_simname(1),"controlGPI")
                str_sim = "control" + "_" + str_simname(end);
            else
                str_sim = str_simname(end);
            end
        end

        function f = plotxyz_animacion(numfig,robot_params,t,tinit_ind,p,p_ref,opt_subplots,opt_plot_tr,strtitle,str_file_fig)
        
            ndof = robot_params.ndof;
            
            p_data = p(tinit_ind:end,:,:);
            if size(p_ref,1) ~= 0
                pref_data = p_ref(tinit_ind:end,:);
            else
                pref_data = p_ref;
            end

            [L,Llim,timetextpos,ndofplot] = ...
                SIMRMA_GraficasHandler.calcular_lims(p_data,pref_data,ndof,opt_plot_tr);
        
            
            if ~strcmp(str_file_fig,"")
                if isfile(str_file_fig+".gif")
                    delete(str_file_fig+".gif")
                end
            end
        
            if opt_subplots == 1
                nfigplots = 2;
            else
                nfigplots = 1;
            end
        
            f = figure(numfig);
            
            clf
        
            f.Units = 'normalized';
            f.OuterPosition = [0 0 1 1];
        
            
            % sgtitle(strtitle,'FontSize',30,'interpreter','latex');
        
            for i = 1:nfigplots^2
                subplot(nfigplots,nfigplots,i)
        
                hold on
        
                pbaspect(L(2,:)-L(1,:))
                axis(Llim)
        
                xlabel("Eje x [m]",'interpreter','latex','FontSize',30);
                ylabel("Eje y [m]",'interpreter','latex','FontSize',30);
                zlabel("eje z [m]",'interpreter','latex','FontSize',30);
                switch i
                    case 1
                        %view(20,45)
                        view(45,45) % isometrica
                    case 2
                        title('Vista superior','interpreter','latex','FontSize',16)
                        view(2) % eje xy
                    case 3 
                        title('Perfil izquierdo','interpreter','latex','FontSize',16)
                        view(0,0) % eje xz
                    case 4
                        title('Vista frontal','interpreter','latex','FontSize',16)
                        view(90,0) % eje yz
                    otherwise
                        disp('Error al ajustar vistas de plotxyz animacion')
                end
                grid on
                hAx=gca; 
                set(hAx,'xminorgrid','on','yminorgrid','on',...
                        'TickLabelInterpreter','latex',...
                        'FontSize',30)
            end
        
            i = tinit_ind;
            ixtime = t(i);
            %currenttime = t(i);
            plottime = 0.01;
            num_img = floor(ixtime/(1/12.5))-1;
            %indt2 = tinit_ind+1;
        
            pplot = gobjects(ndof,int32(nfigplots^2));
            splot = gobjects(ndof,int32(nfigplots^2));
            posplot = gobjects(int32(nfigplots^2),1);
            %if size(p_ref,1) ~= 0
            posrefplot = gobjects(int32(nfigplots^2),1);
            %end
        
            pcolor = ["#0072BD","#77AC30","#A2142F","#7E2F8E","#77AC30","#D95319"];
            
            while i < size(p,1)-1
                currenttime = t(i);
                if currenttime - ixtime >= plottime
            
                    indt1 = find(t==ixtime);
                    indt2 = find(t==currenttime);
            
                    ixtime = t(i);
            
                    if indt1 == indt2
                        indt2 = indt1 + 1;
                    end
                    
                    for j = 1:nfigplots^2
                        subplot(nfigplots,nfigplots,j)
                        posplot(j) = ...
                            SIMRMA_GraficasHandler.plot_trayectoria(p,ndofplot(end),"-","#000000",tinit_ind,indt2);
                        if size(p_ref,1) ~= 0
                            posrefplot(j) = ...
                                SIMRMA_GraficasHandler.plot_trayectoria(p_ref,0,"--","#199E57",tinit_ind,indt2);
                        end
                        [pplot(:,j),splot(:,j)] = ...
                            SIMRMA_GraficasHandler.plot_brazoManipulador(p,pcolor,ndof,ndofplot,i);
                    end
        
                    subplot(nfigplots,nfigplots,1)
                    timetext = text(timetextpos(1),timetextpos(2),timetextpos(3),...
                                    't = '+string(t(i,1)),'interpreter','latex','FontSize',30);
            
                    if floor(currenttime/(1/12.5)) > num_img 
                        if ~strcmp(str_file_fig,"")
                            if size(p_ref,1) ~= 0
                                if nfigplots == 1
                                    lgd = legend([posplot(1),posrefplot(1)],'Posicion',"Posicion de referencia",...
                                                'FontSize',30,'interpreter','latex','Location','northeastoutside');
                                end
                            end
                            exportgraphics(gcf,str_file_fig+'.gif','Append',true);
                            if size(p_ref,1) ~= 0 && nfigplots == 1
                                delete(lgd)
                            end
                        end
                        num_img = num_img + 1;
                    end
        
                    pause(0.001)
        
                    delete(pplot)
                    delete(splot)

                    delete(posplot)
                    delete(posrefplot)
                    delete(timetext)
                end
                i = i+1;
            end
            
            sizeP = size(p,1);
        
            for j = 1:nfigplots^2
                subplot(nfigplots,nfigplots,j)
                [pplot(:,j),splot(:,j)] = ...
                    SIMRMA_GraficasHandler.plot_brazoManipulador(p,pcolor,ndof,ndofplot,sizeP);
                posplot(j) = ...
                    SIMRMA_GraficasHandler.plot_trayectoria(p,ndofplot(end),"-","#000000",tinit_ind,sizeP);
                if size(p_ref,1) ~= 0
                    posrefplot(j) = ...
                        SIMRMA_GraficasHandler.plot_trayectoria(p_ref,ndofplot(end),"--","#199E57",tinit_ind,sizeP);
                end
            end
            
            if ~strcmp(str_file_fig,"")
                if size(p_ref,1) ~= 0
                    if nfigplots == 1
                        lgd = legend([posplot(1),posrefplot(1)],'Posicion',"Posicion de referencia",...
                                    'FontSize',30,'interpreter','latex','Location','northeastoutside');
                    end
                end
                for i = 1:15
                    exportgraphics(gcf,str_file_fig+'.gif','Append',true);
                end
                if size(p_ref,1) ~= 0 && nfigplots == 1
                    delete(lgd)
                end
            end
        end
        
        
        function [pplot,splot] = plot_brazoManipulador(p,pcolor,ndof,ndofplot,i)
            pplot = gobjects(ndof,1);
            splot = gobjects(ndof,1);
            
            for j = ndofplot(1):ndofplot(end)
                pplot(j) = SIMRMA_GraficasHandler.plot_line(p,i,j,pcolor(j));
                if j < ndofplot(end)
                    splot(j) = SIMRMA_GraficasHandler.plot_joint(p,i,j);
                end
            end
        end
        
        function posplot = plot_trayectoria(p,ndofplot,linestyle,pcolor,indt1,indt2)
            if size(size(p),2) == 3
                posplot = plot3([p(indt1:indt2,1,ndofplot)]',...
                                [p(indt1:indt2,2,ndofplot)]', ...
                                [p(indt1:indt2,3,ndofplot)]',...
                                'Color',pcolor,'LineStyle',linestyle,'linewidth',1.5);
            else
                posplot = plot3([p(indt1:indt2,1)]',...
                                [p(indt1:indt2,2)]', ...
                                [p(indt1:indt2,3)]',...
                                'Color',pcolor,'LineStyle',linestyle,'linewidth',1.5);
            end
        end
        
        function pplot = plot_line(p,indpdata,ind_artfin,pcolor)
            if ind_artfin == 1
                pfin = zeros(3,1);
            else
                pfin = p(indpdata,:,ind_artfin-1);
            end
        
            pplot = plot3([p(indpdata,1,ind_artfin),pfin(1)]',...
                          [p(indpdata,2,ind_artfin),pfin(2)]', ...
                          [p(indpdata,3,ind_artfin),pfin(3)]',...
                             'Color',pcolor,'linewidth',2);
        end
        
        function splot = plot_joint(p,indpdata,ind_art)
            splot = plot3(p(indpdata,1,ind_art)',p(indpdata,2,ind_art)',...
                          p(indpdata,3,ind_art)','o','Color','black',...
                          'MarkerSize',4,'MarkerFaceColor',"#000000",...
                          'linewidth',2);
        end
        
        function [L,Llim,timetextpos,ndofplot] = calcular_lims(p,p_ref,ndof,opt_plot_tr)
            if opt_plot_tr == 1
                if ndof == 6
                    ndofplot = (4:6)';
                    if size(p,1) ~= 1
                        L = [min(min(p(:,:,4:6)),[],3);max(max(p(:,:,4:6)),[],3)];
                    else
                        L = [min(p(:,:,4:6),[],3);max(p(:,:,4:6),[],3)];
                    end
                elseif ndof == 3
                    ndofplot = 3;
                    L = [min(p(:,:,3));max(p(:,:,3))];
                end
            else
                if size(p,1) ~= 1
                    L = [min(min(p),[],3);max(max(p),[],3)];
                else
                    L = [min(p,[],3);max(p,[],3)];
                end
                ndofplot = (1:ndof)';
            end
        
            if size(p_ref,1) ~= 0
                if size(p_ref,1) ~= 1
                    Lpref = [min(min(p_ref),[],3);max(max(p_ref),[],3)];
                else
                    Lpref = [min(p_ref,[],3);max(p_ref,[],3)];
                end
                L(1,:) = min(L(1,:),Lpref(1,:));
                L(2,:) = max(L(2,:),Lpref(2,:));
            end
        
        
            for i = 1:3
                if L(1,i) > 0
                    L(1,i) = L(1,i)*0.95;
                else
                    L(1,i) = L(1,i)*1.05;
                end
        
                if L(2,i) > 0
                    L(2,i) = L(2,i)*1.05;
                else
                    L(2,i) = L(2,i)*0.95;
                end
        
                if abs(L(2,i)-L(1,i)) < 0.05
                    L(1,i) = L(1,i) - 0.05;
                    L(2,i) = L(2,i) + 0.05;
                end
            end
        
            Llim = reshape(L,1,6);
        
            xpos = Llim(1) + (Llim(2)-Llim(1))*0.05;
            ypos = Llim(3) + (Llim(4)-Llim(3))*0.05;
            zpos = Llim(6) - (Llim(6)-Llim(5))*0.05;
        
            timetextpos = [xpos,ypos,zpos];
        end
    end
end

