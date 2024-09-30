

[v_scope,v_peaks] = peaks_measurements(tstep,out);
[i_scope,i_peaks] = peaks_measurements(tstep,out);

close(v_scope)
clear(i_scope)

if str_dir_graficas ~= ""
    file_resultados = fopen(str_file_res,'a');
    imprimir_mediciones(file_resultados,out,MI_motor.v_Srmsnom,MI_motor.i_Srmsnom,v_peaks,i_peaks);
    fclose(file_resultados);
end

imprimir_mediciones(1,out,MI_motor.v_Srmsnom,MI_motor.i_Srmsnom,v_peaks,i_peaks);

function imprimir_mediciones(fileID,out,v_Srmsnom,i_Srmsnom,v_peaks,i_peaks)

    fprintf(fileID,"\n** Mediciones de voltaje y corriente **\n\n");
    
    u_S3abc = checksize(out.u_S3abc.data);
    i_S3abc = checksize(out.i_S3abc.data);

    fprintf(fileID,"Mediciones de voltaje: \n" ...
          + "Voltaje pico: " + string(max(u_S3abc(:,1))) ...
          + " (" + string(round(max(u_S3abc(:,1))/(v_Srmsnom*sqrt(2/3))*100,2)) + "%% de valor nominal)" + "\n" ...
          + "Frecuencia principal: " + string(v_peaks(1,2)) + "\n");
    
    if max(out.u_S3abc.data(:,1))>v_Srmsnom/sqrt(2/3)*2
        fprintf(fileID,"NOTA: Voltaje pico excede valores nominales("+string(v_Srmsnom/sqrt(2/3)*2)+" V)\n");
    end
    fprintf(fileID,"\n");
    
    fprintf(fileID,"Mediciones de corriente: \n" ...
          + "Corriente pico: " + string(max(i_S3abc(:,1)))...
          + " (" + string(round(max(i_S3abc(:,1))/(i_Srmsnom*sqrt(2/3))*100)) + "%% de valor nominal)" + "\n" ...
          + "Frecuencia principal: " + string(i_peaks(1,2)) + "\n");
    
    if max(out.i_S3abc.data(:,1))>i_Srmsnom/sqrt(2/3)*2
        fprintf(fileID,"NOTA: Corriente pico excede valores nominales("+string(i_Srmsnom/sqrt(2)*2)+" A)\n");
    end
    fprintf(fileID,"\n");
end


function [scope,peaks] = peaks_measurements(tstep,out)
    scope = spectrumAnalyzer('SampleRate',1/tstep,...'YLimits',[0,85], ...
                               'SpectrumType','power','InputDomain','time', ...
                               'FrequencySpan','start-and-stop-frequencies', ...
                               'StartFrequency',0,'StopFrequency',75, ...
                               'ViewType','spectrum',...
                               PlotAsTwoSidedSpectrum=false);
    
    u_S3abc = checksize(out.u_S3abc.data);

    scope(u_S3abc)
    
    scope.PeakFinder.Enabled = true;
    scope.PeakFinder.LabelPeaks = true;
    
    data = [];
    if scope.isNewDataReady
        data = [data;getMeasurementsData(scope)];
    end
    
    peaks = [data.PeakFinder(end).Value,data.PeakFinder(end).Frequency];
end

function resized_data = checksize(data)
    s_data = size(size(data));
    if s_data(2) > 2
        resized_data = reshape(data,[],size(data,3),1)';
    else
        resized_data = data;
    end
end