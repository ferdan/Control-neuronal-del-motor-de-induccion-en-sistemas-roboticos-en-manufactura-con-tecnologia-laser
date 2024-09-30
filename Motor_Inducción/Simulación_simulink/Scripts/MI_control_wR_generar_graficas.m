% Graficas %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function f = MI_control_wR_generar_graficas(out,str_dir_graficas,str_dir)

    w_Rref = checksize(out.w_Rref.data);
    tau_L = checksize(out.tau_L.data);
    u_S3abc = checksize(out.u_S3abc.data);
    i_S3abc = checksize(out.i_S3abc.data);
    P_elect = checksize(out.P_elect.data);
    P_mech = checksize(out.P_mech.data);
    
    f(1) = graficar(1,0,[1,1],"Velocidad $w_R$", ...
                    out.tout,[out.w_R.data,w_Rref], ...
                    "Tiempo [s]","Velocidad [rad/s]", ...
                    ["$w_R$","$w_{Rref}$"]);

    f(2) = graficar(2,0,[1,1],"Error seguimiento de velocidad $w_R$", ...
                    out.tout,out.w_R.data-w_Rref, ...
                    "Tiempo [s]","Velocidad [rad/s]", ...
                    "$e_{w_R}$");

    f(3) = graficar(3,0,[1,1],"Torque $\tau_R$", ...
                    out.tout,[out.tau_R.data,tau_L], ...
                    "Tiempo [s]","Torque [N m]", ...
                    ["$\tau_R$","$\tau_L$"]);

    f(4) = graficar(4,1,[3,1],"Voltajes de estator trifasicas $u_S$", ...
                    out.tout,u_S3abc, ...
                    "Tiempo [s]","Voltaje [V]", ...
                    ["$u_{SA}$","$u_{SB}$","$u_{SC}$"]);

    f(5) = graficar(5,1,[3,1],"Corrientes de estator trifasicas $i_S$", ...
                    out.tout,i_S3abc, ...
                    "Tiempo [s]","Corriente [A]", ...
                    ["$i_{SA}$","$i_{SB}$","$i_{SC}$"]);

    f(6) = graficar(6,0,[1,1],"Potencia", ...
                    out.tout,[P_elect,P_mech], ...
                    "Tiempo [s]","Potencia [W]", ...
                    ["Potencia electrica","Potencia mecanica"]);

    if str_dir_graficas ~= ""
        guardarGrafica(f(1),str_dir_graficas,str_dir,"01","Velocidad");
        guardarGrafica(f(2),str_dir_graficas,str_dir,"02","ErrorVelocidad");
        guardarGrafica(f(3),str_dir_graficas,str_dir,"03","Torque");
        guardarGrafica(f(4),str_dir_graficas,str_dir,"04","Voltaje");
        guardarGrafica(f(5),str_dir_graficas,str_dir,"05","Corriente");
        guardarGrafica(f(6),str_dir_graficas,str_dir,"06","Potencia");
    end

end

function resized_data = checksize(data)
    s_data = size(size(data));
    if s_data(2) > 2
        resized_data = reshape(data,[],size(data,3),1)';
    else
        resized_data = data;
    end
end

function f = graficar(numfig,posfig,numsubplots,strtitle,datax,datay,strxlabel,strylabel,strlegend)

    f = figure(numfig);
    clf
    f.Units = 'normalized';
    if posfig == 1
        f.OuterPosition = [0 0 0.5 1];
    else
        f.OuterPosition = [0 0 1 1];
    end

    sgtitle(strtitle,'interpreter','latex','FontSize',24)

    for i = 1:size(datay,2)
        if numsubplots(1) ~= 1 || numsubplots(2) ~= 1
            subplot(numsubplots(1),numsubplots(2),i)
        end

        if min(min(datay)) ~= max(max(datay*1.1))
            ylim([min(min(datay))*1.1,max(max(datay*1.1))*1.1]);
        end

        grid on
        hAx=gca; 
        set(hAx,'xminorgrid','on','yminorgrid','on')

        hold on
        plot(datax,datay(:,i),'LineWidth',2)

        

        set(gca,'FontSize',24)
        xlabel(strxlabel,'interpreter','latex','FontSize',24)
        ylabel(strylabel,'interpreter','latex','FontSize',24)
        if numsubplots(1) ~= 1 || numsubplots(2) ~= 1
            legend(strlegend(i),'interpreter','latex','FontSize',16)
        end
    end
    
    if numsubplots(1) == 1 && numsubplots(2) == 1
        legend(strlegend,'interpreter','latex','FontSize',16)
    end
end

function guardarGrafica(fig,str_dir_graficas,str_dir,numfig,str_fig_nombre)
    figure(fig);
    str_dir_sim = "";
    for  i = size(str_dir,2)
        if i ~= size(str_dir,2)
            str_dir_sim = str_dir_sim + str_dir(i) + "_";
        else
            str_dir_sim = str_dir_sim + str_dir(i);
        end
    end

    str_dir_fig = str_dir_graficas + "/" + str_dir_sim + "/";
    
    if ~exist(str_dir_graficas+"/", 'dir')
       mkdir(str_dir_graficas)
    end
    if ~exist(str_dir_fig, 'dir')
       mkdir(str_dir_fig)
    end

    strfig = "\" + str_dir_fig + numfig + '_' + str_fig_nombre + '.fig';
    strpng = "\" + str_dir_fig + numfig + '_' + str_fig_nombre + '.png';
    saveas(gcf,strcat(pwd,strfig))
    saveas(gcf,strcat(pwd,strpng))
end