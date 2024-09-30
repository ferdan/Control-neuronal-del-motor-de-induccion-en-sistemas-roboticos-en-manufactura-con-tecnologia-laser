str_dir_graficas = "graficas_PBC_control_wR_caso_02"; % comentar para guardar graficas

opt = zeros(data_size(1),9);
str_opt = strings(data_size(1),1);

close('all')

for i = 1:size(w_Rrefs,2)
    for j = 1:size(tau_Rrefs,2)

        ind_i_arr = (i-1)*size(tau_Rrefs,2) + j;

        p_elect_i = p_elect_avg_arr(ind_i_arr,:);
        ind_v = find(v_peaks_arr(ind_i_arr,:)>MI_motor.v_Srmsnom*sqrt(2));
        ind_i = find(i_peaks_arr(ind_i_arr,:)>MI_motor.i_Srmsnom*sqrt(2));
    
        ind_vi = unique(horzcat(ind_v,ind_i),'first');
    
        if size(ind_vi,2) < size(tau_Rrefs,2)
            p_elect_i(ind_vi) = max(p_elect_i);
        end
    
        ind_min_p = find(p_elect_i==min(p_elect_i));
        
        psi_Rmagopt = psi_Rmagrefs(ind_min_p);
        err_wR_min = err_wR(ind_i_arr,ind_min_p);
        v_peak_min = v_peaks_arr(ind_i_arr,ind_min_p);
        i_peak_min = i_peaks_arr(ind_i_arr,ind_min_p);
        v_f_min = v_f_arr(ind_i_arr,ind_min_p);
        p_elect_min = p_elect_avg_arr(ind_i_arr,ind_min_p);
        p_mech_min = p_mech_avg_arr(ind_i_arr,ind_min_p);
        
        opt(ind_i_arr,:) = [tau_Rrefs(j),...
                            w_Rrefs(i),...
                            psi_Rmagopt,v_peak_min,i_peak_min,...
                            v_f_min,err_wR_min,...
                            p_elect_min,p_mech_min];
    
    
        str_opt(ind_i_arr) = "";
        for k = 1:size(opt,2)
            str_opt(ind_i_arr) = str_opt(ind_i_arr) + string(opt(ind_i_arr,k)) + ",";
        end
    end
end

if str_dir_graficas ~= ""
    if ~exist(str_dir_graficas+"\", 'dir')
       mkdir(str_dir_graficas)
    end
    file_resultados = fopen(strcat(pwd,"\" + str_dir_graficas + "\control_MI_wR_flujo_optimo.txt"),'a');
    for i = 1:size(opt,1)
        fprintf(file_resultados,str_opt(i) + "\n");
        fprintf(1,str_opt(i) + "\n");
    end
    fprintf(file_resultados,"\n");
    fprintf(1,"\n");
    fclose(file_resultados);
end

for i = 1:size(opt,1)
    fprintf(1,str_opt(i) + "\n");
end
fprintf(1,"\n");



str_medicion = ["Magnitud de flujo magnetico","Voltaje pico","Corriente pico",...
                "Frecuencia de la componente principal",...
                "Error de velocidad (t = "+string(tsim-1)+" - "+string(tsim)+"s)",... 
                "Potencia electrica","Potencia mecanica","Eficiencia"];
str_unidades = ["Wb","V","A","Hz","rad/s","W","W","\\%%"];


mediciones = zeros(size(w_Rrefs,2),size(tau_Rrefs,2),size(opt,2)-1);

for i = 1:(size(opt,2)-2)
    mediciones(:,:,i) = reshape(opt(:,i+2),size(w_Rrefs,2),size(tau_Rrefs,2))';
end

mediciones(:,:,8) = mediciones(:,:,7)./mediciones(:,:,6).*100;

for i = 1:size(mediciones,3)
    
    caso02_figs = figure(i);
    clf


    caso02_figs.Units = 'normalized';
    caso02_figs.OuterPosition = [0 0 1 1];

    sgtitle(str_medicion(i),'interpreter','latex','FontSize',24)
    set(groot, 'defaultAxesTickLabelInterpreter','latex');

    [x,y] = meshgrid(tau_Rrefs,w_Rrefs);

    s = mesh(x,y,mediciones(:,:,i), ...
             'FaceAlpha',0.8,...
             'LineStyle','-','EdgeColor','black');

    s.FaceColor = 'interp';
    colorbar
    
    if i == size(mediciones,3)
        ztickformat('$%g \\%%$')
        str_zlabel = sprintf(str_medicion(i));
    else
        str_zlabel = sprintf(str_medicion(i) +  " $[" + str_unidades(i) + "]$");
    end

    xlabel("$\tau_{R} [N m]$",'interpreter','latex','FontSize',24)
    ylabel("$\omega_{R} [rad/s]$",'interpreter','latex','FontSize',24)
    zlabel(str_zlabel,'interpreter','latex','FontSize',24)


    if str_dir_graficas ~= ""
        strfig = "\" + str_dir_graficas + "\0" + string(i) + '_' + str_medicion(i) + '.fig';
        strpng = "\" + str_dir_graficas + "\0" + string(i) + '_' + str_medicion(i) + '.png';
        saveas(gcf,strcat(pwd,strfig))
        saveas(gcf,strcat(pwd,strpng))
    end
end