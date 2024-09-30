function MI_control_tauR_resumen_simulacion(str_dir_graficas,str_file_res,MI_motor,controlador,tau_Rref,tau_L)
    if str_dir_graficas ~= ""
        file_resultados = fopen(str_file_res,'w');
        imprimir_resultados(file_resultados,MI_motor,controlador,tau_Rref,tau_L)
        fclose(file_resultados);
    end
    
    imprimir_resultados(1,MI_motor,controlador,tau_Rref,tau_L)
end

function imprimir_resultados(fileID,MI_motor,controlador,tau_Rref,tau_L)
    fprintf(fileID,"\n** Control de torque del motor de induccion ** \n\n");
    
    fprintf(fileID,MI_motor.toString);
    fprintf(fileID,controlador.toString);

    fprintf(fileID, "Magnitud del flujo deseado: " + string(controlador.psi_Rmagref)...
          + " (" + string(controlador.psi_Rmagref/MI_motor.psi_Rmagnom*100) ...
          + "%% de valor nominal) \n\n\n");
    
    printPerfil(fileID,tau_Rref,MI_motor.tau_Rnom,"[N m]")
    printPerfil(fileID,tau_L,MI_motor.tau_Rnom,"[N m]")

end

function printPerfil(fileID,perfil,valor_nominal,unidades)
    fprintf(fileID, perfil.toString);

    if perfil.sel_perfil ~= 1
        fprintf(fileID,"Valor deseado: " + string(perfil.valor_referencia) ...
              + " " + unidades + " (" + string(perfil.valor_referencia/valor_nominal*100) ...
              +"%% de valor nominal)\n\n\n");
    end
end