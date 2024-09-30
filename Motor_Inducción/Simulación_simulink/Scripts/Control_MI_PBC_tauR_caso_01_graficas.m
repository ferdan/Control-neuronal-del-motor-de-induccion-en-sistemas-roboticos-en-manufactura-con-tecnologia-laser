str_medicion = ["Voltaje pico","Corriente pico",...
                "Frecuencia de la componente principal",...
                "Potencia electrica","Potencia mecanica"];
str_unidades = ["V","A","Hz","W","W"];


tau_R_arr = MI_motor.tau_Rnom*tau_Rrefs;

f(6) = graficar(6,0,[1,1],"Velocidad $w_R$ ($t = "+ string(tsim-1) + "-" + string(tsim) + "s$)",...
                tau_R_arr,w_R_arr,"Torque [N m]","Velocidad [rad/s]",...
                "$w_R$ (t = "+ string(tsim-1) + "-" + string(tsim) + "s)");
f(7) = graficar(7,0,[1,1],"Voltaje pico",tau_R_arr,v_peaks_arr,...
                "Torque [N m]","Voltaje [V]","$u_{Sa}$ (pico)");
f(8) = graficar(8,0,[1,1],"Corriente pico",tau_R_arr,i_peaks_arr,...
                "Torque [N m]","Corriente [A]","$i_{Sa}$ (pico)");
f(9) = graficar(9,0,[1,1],"Frecuencia de la componente principal de voltaje",tau_R_arr,v_f_arr,...
                "Torque [N m]","Frecuencia [Hz]","$f_{u_{Sa}}$");
f(10) = graficar(10,0,[1,1],"Potencia",tau_R_arr,...
                [p_elect_avg_arr,p_mech_avg_arr],...
                "Torque [N m]","Potencia [W]",...
                ["Potencia electrica","Potencia mecanica"]);

if str_dir_graficas ~= ""
    guardarGrafica(f(6),str_dir_graficas,str_dir,"06","Velocidad");
    guardarGrafica(f(7),str_dir_graficas,str_dir,"07","Voltaje pico");
    guardarGrafica(f(8),str_dir_graficas,str_dir,"08","Corriente pico");
    guardarGrafica(f(9),str_dir_graficas,str_dir,"09","Frecuencia");
    guardarGrafica(f(10),str_dir_graficas,str_dir,"10","Potencia");
end

function resized_data = checksize(data)
    s_data = size(size(data));
    if s_data(2) > 2
        resized_data = reshape(data,[],size(data,3),1)';
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