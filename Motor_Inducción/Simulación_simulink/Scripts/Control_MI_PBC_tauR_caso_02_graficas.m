str_medicion = ["Voltaje pico","Corriente pico",...
                "Frecuencia de la componente principal",...
                "Potencia electrica","Potencia mecanica"];
str_unidades = ["V","A","Hz","W","W"];

mediciones = zeros(size(w_Rrefs,2),size(tau_Rrefs,2),5);
mediciones(:,:,1) = v_peaks_arr;
mediciones(:,:,2) = i_peaks_arr;
mediciones(:,:,3) = v_f_arr;
mediciones(:,:,4) = p_elect_avg_arr;
mediciones(:,:,5) = p_mech_avg_arr;

for i = 1:size(mediciones,3)
    if i == 5
        f = figure(i);
        clf
    end


    f.Units = 'normalized';
    f.OuterPosition = [0 0 1 1];

    sgtitle(str_medicion(i),'interpreter','latex','FontSize',24)

    [x,y] = meshgrid(MI_motor.tau_Rnom*tau_Rrefs,psi_Rmagrefs);

    s = mesh(x,y,mediciones(:,:,i), ...
             'FaceAlpha',0.8,...
             'LineStyle','-','EdgeColor','black');

    s.FaceColor = 'interp';
    colorbar

    xlabel("$\tau_{R} [N m]$",'interpreter','latex','FontSize',24)
    ylabel("$|\psi_{R}| [rad/s]$",'interpreter','latex','FontSize',24)
    zlabel(str_medicion(i) +  " $["...
          + str_unidades(i) + "]$",'interpreter','latex','FontSize',24)


    if str_dir_graficas ~= ""
        strfig = "\" + str_dir_graficas + "\0" + string(i) + '_' + str_medicion(i) + '.fig';
        strpng = "\" + str_dir_graficas + "\0" + string(i) + '_' + str_medicion(i) + '.png';
        saveas(gcf,strcat(pwd,strfig))
        saveas(gcf,strcat(pwd,strpng))
    end
end