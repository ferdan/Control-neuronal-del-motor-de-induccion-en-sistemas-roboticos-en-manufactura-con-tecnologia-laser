classdef fileHandler
    methods (Static)
        function MI_motor = getMI_params(str_file)

            file = fopen(str_file,'r');
            %str = fscanf(file,'%s');
            str = textscan(file,"%s",'Whitespace',"");
            str_MI = string(str);
            fclose(file);
            [data,~] = str2num(str_MI);
            [Pnomval,v_Srmsnomval,w_Rnomval,n_p,R_Sval,R_Rval,...
                  L_Sval,L_Rval,Mval,Jval,bval] = fileHandler.AsignarDatosMI(data);
            
            [i_Srmsnomval,psi_Rmagnomval,tau_Rnomval]= ...
                fileHandler.CalcularDatosMI(Pnomval,v_Srmsnomval,w_Rnomval,Mval);
            
            MI_motor = MI_model(Pnomval,v_Srmsnomval,i_Srmsnomval,...
                                psi_Rmagnomval,w_Rnomval,tau_Rnomval,...
                                n_p,R_Sval,R_Rval,L_Sval,L_Rval,Mval,Jval,bval);
        end
        
        function [Pnomval,v_Srmsnomval,w_Rnomval,n_p,R_Sval,R_Rval,...
                  L_Sval,L_Rval,Mval,Jval,bval] = AsignarDatosMI(data)
        
            Pnomval = data(1);
            v_Srmsnomval = data(2);
            w_Rnomval = data(3);
        
            n_p = data(4);
            R_Sval = data(5);
            R_Rval = data(6);
            L_Sval = data(7);
            L_Rval = data(8);
            Mval = data(9);
            Jval = data(10);
            bval = data(11);
        end
        
        function [i_Srmsnomval,psi_Rmagnomval,tau_Rnomval]= CalcularDatosMI(Pnomval,v_Srmsnomval,w_Rnomval,Mval)
            i_Srmsnomval = Pnomval/v_Srmsnomval;
            psi_Rmagnomval = Mval*i_Srmsnomval/sqrt(2);
            tau_Rnomval = Pnomval/w_Rnomval;
        
        end

        function MI_control_tauR_resumen_simulacion(str_dir_graficas,str_file_res,MI_motor,controlador,tau_Rref,tau_L)
            if str_dir_graficas ~= ""
                file_resultados = fopen(str_file_res,'w');
                fileHandler.imprimir_resultados(file_resultados,MI_motor,controlador,tau_Rref,tau_L)
                fclose(file_resultados);
            end
            
            fileHandler.imprimir_resultados(1,MI_motor,controlador,tau_Rref,tau_L)
        end
        
        function imprimir_resultados(fileID,MI_motor,controlador,tau_Rref,tau_L)
            fprintf(fileID,"\n** Control de torque del motor de induccion ** \n\n");
            
            fprintf(fileID,MI_motor.toString);
            fprintf(fileID,controlador.toString);
        
            fprintf(fileID, "Magnitud del flujo deseado: " + string(controlador.psi_Rmagref)...
                  + " (" + string(controlador.psi_Rmagref/MI_motor.psi_Rmagnom*100) ...
                  + "%% de valor nominal) \n\n\n");
            
            fileHandler.printPerfil(fileID,tau_Rref,MI_motor.tau_Rnom,"[N m]")
            fileHandler.printPerfil(fileID,tau_L,MI_motor.tau_Rnom,"[N m]")
        
        end
        
        function printPerfil(fileID,perfil,valor_nominal,unidades)
            fprintf(fileID, perfil.toString);
        
            if perfil.sel_perfil ~= 1
                fprintf(fileID,"Valor deseado: " + string(perfil.valor_referencia) ...
                      + " " + unidades + " (" + string(perfil.valor_referencia/valor_nominal*100) ...
                      +"%% de valor nominal)\n\n\n");
            end
        end

        function MI_mediciones_VI(tstep,data,MI_motor_params,str_dir_graficas,str_file_res,frec_md_opt)

            if frec_md_opt == 1
                [v_scope,vf_peaks] = fileHandler.frec_measurements(tstep,data.u_S3abc);
                [i_scope,if_peaks] = fileHandler.frec_measurements(tstep,data.i_S3abc);
                close(v_scope)
                close(i_scope)
            else
                vf_peaks = -1;
                if_peaks = -1;
            end
            
            if str_dir_graficas ~= ""
                file_resultados = fopen(str_file_res,'a');
                fileHandler.imprimir_mediciones_VI(file_resultados,data,MI_motor_params,vf_peaks,if_peaks);
                fclose(file_resultados);
            end
            
            fileHandler.imprimir_mediciones_VI(1,data,MI_motor_params,vf_peaks,if_peaks);
            file_resultados = fopen(str_file_res,'a');
            fclose(file_resultados);
        end

        function RMA_ITAE_ISCI(ITAE,ISCI,str_dir_graficas,str_file_res)
            if str_dir_graficas ~= ""
                file_ID = fopen(str_file_res,'w');

                fprintf(file_ID,"ITAE\n");
                for i = 1:size(ITAE,1)
                    fprintf(file_ID,string(i) + ": " + string(ITAE(i)) + "\n");
                end
                
                fprintf(file_ID,"\n");

                fprintf(file_ID,"ISCI\n");
                for i = 1:size(ISCI,1)
                    fprintf(file_ID,string(i) + ": " + string(ISCI(i)) + "\n");
                end

                fclose(file_ID);
            end
        end

        function imprimir_mediciones_VI(fileID,data,MI_motor_params,vf_peaks,if_peaks)
            
            v_Srmsnom = MI_motor_params.v_Srmsnom;
            i_Srmsnom = MI_motor_params.i_Srmsnom;

            fprintf(fileID,"\n** Mediciones de voltaje y corriente **\n\n");
            
            u_S3abc = data.u_S3abc;
            i_S3abc = data.i_S3abc;

            u_Samax = max(abs(u_S3abc(:,1)));
            u_Snommax = v_Srmsnom*sqrt(2/3);
            u_Samaxpercent = u_Samax/u_Snommax*100;

            str_v = "Mediciones de voltaje: \n" ...
                  + "Voltaje pico: " + string(u_Samax) ...
                  + " (" + string(round(u_Samaxpercent,2)) + "%% de valor nominal)" + "\n";
        
            if size(vf_peaks,2) > 1
                str_v = str_v + "Frecuencia principal: " + string(vf_peaks(1,2)) + "\n";
            end

            fprintf(fileID,str_v);
            
            if u_Samax > v_Srmsnom/sqrt(2/3)*2
                fprintf(fileID,"NOTA: Voltaje pico excede valores nominales("+string(u_Snommax)+" V)\n");
            end
            fprintf(fileID,"\n");

            i_Samax = max(abs(i_S3abc(:,1)));
            i_Snommax = i_Srmsnom*sqrt(2/3);
            i_Samaxpercent = i_Samax/i_Snommax*100;

            str_i = "Mediciones de corriente: \n" ...
                  + "Corriente pico: " + string(i_Samax)...
                  + " (" + string(round(i_Samaxpercent,2)) + "%% de valor nominal)" + "\n";
            
            if size(if_peaks,2) > 1
                str_i = str_i + "Frecuencia principal: " + string(if_peaks(1,2)) + "\n";
            end
            
            fprintf(fileID,str_i);
            
            if i_Samax > i_Snommax
                fprintf(fileID,"NOTA: Corriente pico excede valores nominales("+string(i_Snommax)+" A)\n");
            end
            fprintf(fileID,"\n");
        end

        function [scope,f_peaks] = frec_measurements(tstep,VI_data)
            scope = spectrumAnalyzer('SampleRate',1/tstep,...'YLimits',[0,85], ...
                                       'SpectrumType','power','InputDomain','time', ...
                                       'FrequencySpan','start-and-stop-frequencies', ...
                                       'StartFrequency',0,'StopFrequency',75, ...
                                       'ViewType','spectrum',...
                                       PlotAsTwoSidedSpectrum=false);

            scope(VI_data)
            
            scope.PeakFinder.Enabled = true;
            scope.PeakFinder.LabelPeaks = true;
            
            data = [];
            if scope.isNewDataReady
                data = [data;getMeasurementsData(scope)];
            end
            
            f_peaks = [data.PeakFinder(end).Value,data.PeakFinder(end).Frequency];
        end
    end
end