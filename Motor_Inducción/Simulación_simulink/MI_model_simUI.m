classdef MI_model_simUI < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        figure_main                 matlab.ui.Figure

        %% Main layouts
        layout_main                 matlab.ui.container.GridLayout

        layout_param_main           matlab.ui.container.GridLayout
        panel_MI_params             matlab.ui.container.Panel
        
        layout_MI_params            matlab.ui.container.GridLayout
        layout_MI_data              matlab.ui.container.GridLayout
        
        %% Cargar archivo MI
        layout_MI_cargar_params     matlab.ui.container.GridLayout
        label_MI_archivo            matlab.ui.control.Label
        button_MI_archivo           matlab.ui.control.Button
        
        %% Valores nomniales
        panel_valnoms               matlab.ui.container.Panel
        layout_valnoms              matlab.ui.container.GridLayout

        label_nom01_Pnom            matlab.ui.control.Label
        editField_nom01_Pnom        matlab.ui.control.NumericEditField
        PnomLabel                   matlab.ui.control.Label

        label_nom02_VSrmsnom        matlab.ui.control.Label
        editField_nom02_VSrmsnom    matlab.ui.control.NumericEditField
        VSrmsnomLabel               matlab.ui.control.Label

        label_nom03_ISrmsnom        matlab.ui.control.Label
        editField_nom03_ISrmsnom    matlab.ui.control.NumericEditField
        ISrmsnomLabel               matlab.ui.control.Label

        label_nom04_psi_Rmagnom     matlab.ui.control.Label
        editField_nom04_psiRmagnom  matlab.ui.control.NumericEditField
        psiRnomLabel                matlab.ui.control.Label

        label_nom05_wRnom           matlab.ui.control.Label
        editField_nom05_wRnom       matlab.ui.control.NumericEditField
        wRnomLabel                  matlab.ui.control.Label

        label_nom06_tauRnom         matlab.ui.control.Label
        editField_nom06_tauRnom     matlab.ui.control.NumericEditField
        tauRnomLabel                matlab.ui.control.Label

        %% Parámetros eléctricos
        panel_elecparams            matlab.ui.container.Panel
        layout_elecparams           matlab.ui.container.GridLayout
        label_el01_np               matlab.ui.control.Label
        editField_el01_np           matlab.ui.control.NumericEditField
        npLabel                     matlab.ui.control.Label
        label_el02_RS               matlab.ui.control.Label
        editField_el02_RS           matlab.ui.control.NumericEditField
        RSLabel                     matlab.ui.control.Label
        label_el03_RR               matlab.ui.control.Label
        editField_el03_RR           matlab.ui.control.NumericEditField
        RRLabel                     matlab.ui.control.Label
        label_el04_LS               matlab.ui.control.Label
        editField_el04_LS           matlab.ui.control.NumericEditField
        LSLabel                     matlab.ui.control.Label
        label_el05_LR               matlab.ui.control.Label
        editField_el05_LR           matlab.ui.control.NumericEditField
        LRLabel                     matlab.ui.control.Label
        label_el06_M                matlab.ui.control.Label
        editField_el06_M            matlab.ui.control.NumericEditField
        MLabel                      matlab.ui.control.Label
        label_el07_sigma            matlab.ui.control.Label
        editField_el07_sigma        matlab.ui.control.NumericEditField
        SigmaLabel                  matlab.ui.control.Label
        editField_el08_gamma        matlab.ui.control.NumericEditField
        label_el08_gamma            matlab.ui.control.Label
        GammaLabel                  matlab.ui.control.Label

        %% Parámetros mecánicos
        panel_mechparams            matlab.ui.container.Panel
        layout_mechparams           matlab.ui.container.GridLayout
        label_me01_J                matlab.ui.control.Label
        editField_me01_J            matlab.ui.control.NumericEditField
        JLabel                      matlab.ui.control.Label
        label_me02_b                matlab.ui.control.Label
        editField_me02_b            matlab.ui.control.NumericEditField
        bLabel                      matlab.ui.control.Label

        %% Guardar/Limpiar parámetros MI
        layout_MI_guardar_params    matlab.ui.container.GridLayout

        button_LimpiarparamsMI        matlab.ui.control.Button
        button_GuardarparamsMI        matlab.ui.control.Button

        %% Parámetros de simulación
        layout_sim                  matlab.ui.container.GridLayout
        panel_sim_params            matlab.ui.container.Panel
        
        button_Simular              matlab.ui.control.Button
        layout_sim_params           matlab.ui.container.GridLayout

        label_sim01_tsim            matlab.ui.control.Label
        editField_sim01_tsim        matlab.ui.control.NumericEditField
        tsimLabel                   matlab.ui.control.Label

        label_sim02_tstep           matlab.ui.control.Label
        editField_sim02_tstep       matlab.ui.control.NumericEditField
        tstepLabel                  matlab.ui.control.Label

        label_sim03_metodo          matlab.ui.control.Label
        label_sim03_ODE5            matlab.ui.control.Label

        %% Resultados de simulación
        panel_sim_results           matlab.ui.container.Panel
        layout_sim_results          matlab.ui.container.GridLayout

        button_Guardargraficas      matlab.ui.control.Button
        label_sim_comments          matlab.ui.control.Label

        axes_torque                 matlab.ui.control.UIAxes
        axes_velocidad              matlab.ui.control.UIAxes
        axes_potencia               matlab.ui.control.UIAxes
        axes_voltaje1               matlab.ui.control.UIAxes
        axes_voltaje2               matlab.ui.control.UIAxes
        axes_voltaje3               matlab.ui.control.UIAxes
        axes_corriente1             matlab.ui.control.UIAxes
        axes_corriente2             matlab.ui.control.UIAxes
        axes_corriente3             matlab.ui.control.UIAxes
        
        layout_tvis                 matlab.ui.container.GridLayout
        layout_tviseditFields       matlab.ui.container.GridLayout
        slider_tvis                 matlab.ui.control.RangeSlider
        tvisLabel                   matlab.ui.control.Label
        editField_tvismin           matlab.ui.control.NumericEditField
        editField_tvismax           matlab.ui.control.NumericEditField

    end

    properties
        str_MIparams_Inputdata = ["Pnom","v_Srmsnom","w_Rnom","n_p","RS","RR",...
        "LS","LR","M","J","b"];
        str_SIMparams_Inputdata = ["tsim","tstep"];
        MI_motor
        SIM_motor

        datos_Graficas

        editFieldArr_MIparams_Inputdata
        editFieldArr_nomparams_Inputdata
        editFieldArr_elecparams_Inputdata
        editFieldArr_mechparams_Inputdata

        editFieldArr_MIparams_Calculateddata

        editFieldArr_SIMparams_Inputdata

        figaxesArr
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: button_MI_archivo
        function button_MI_archivoButtonPushed(app, event)

            if ~exist(pwd+"\MI_motors", 'dir')
               mkdir(pwd+"\MI_motors")
            end

            fdummy = figure('Position', [-100 -100 0 0],'CloseRequestFcn','');
            [filename,path] = uigetfile(".txt","Seleccionar archivo",pwd+"\MI_motors\");
            delete(fdummy);
            if filename == 0
                return
            end
            
            try
                file = fopen(strcat(path,filename),'r');
                str_MI = fscanf(file,'%s');
                fclose(file);
            catch
                app.label_MI_archivo.Text = "Error al cargar el archivo";
                return
            end

            [data,datacheck] = str2num(str_MI);

            if ~datacheck
                app.label_MI_archivo.Text = "El archivo no contiene el formato requerido";
                return
            end

            if size(data,2) ~= size(app.str_MIparams_Inputdata,2)
                app.label_MI_archivo.Text = "El archivo no contiene el número requerido de datos";
                return
            end

            [Pnomval,v_Srmsnomval,w_Rnomval,n_p,R_Sval,R_Rval,...
                  L_Sval,L_Rval,Mval,Jval,bval] = AsignarDatosMI(app,data);

            [i_Srmsnomval,psi_Rmagnomval,tau_Rnomval]= CalcularDatosMI(app,Pnomval,v_Srmsnomval,w_Rnomval,Mval);

            app.MI_motor = MI_model(Pnomval,v_Srmsnomval,i_Srmsnomval,...
                                psi_Rmagnomval,w_Rnomval,tau_Rnomval,...
                                n_p,R_Sval,R_Rval,L_Sval,L_Rval,Mval,Jval,bval);

            for i = 1:size(app.editFieldArr_MIparams_Inputdata,2)
                app.editFieldArr_MIparams_Inputdata(i).Value = data(i);
            end

            % app.editField_nom01_Pnom.Value = Pnomval;
            % app.editField_nom02_VSrmsnom.Value = v_Srmsnomval;
            % app.editField_nom05_wRnom.Value = w_Rnomval;
            % 
            % app.editField_el01_np.Value = n_p;
            % app.editField_el02_RS.Value = R_Sval;
            % app.editField_el03_RR.Value = R_Rval;
            % app.editField_el04_LS.Value = L_Sval;
            % app.editField_el05_LR.Value = L_Rval;
            % app.editField_el06_M.Value = Mval;
            %
            % app.editField_me01_J.Value = Jval;
            % app.editField_me02_b.Value = bval;

            app.editField_nom03_ISrmsnom.Value = i_Srmsnomval;
            app.editField_nom04_psiRmagnom.Value = psi_Rmagnomval;
            app.editField_nom06_tauRnom.Value = tau_Rnomval;

            app.editField_el07_sigma.Value = app.MI_motor.electric_params.sigma;
            app.editField_el08_gamma.Value = app.MI_motor.electric_params.gamma;

            app.button_GuardarparamsMI.Enable = "off";
            app.button_LimpiarparamsMI.Enable = "on";
            app.label_MI_archivo.Text = filename;
        end

        % Button pushed function: button_Guardarparams
        function button_GuardarparamsMIPushed(app, event)

            dataMI = LeerDatosIngresados(app,app.editFieldArr_MIparams_Inputdata);
            str_err = ValidarDatos(app,dataMI,app.str_MIparams_Inputdata);

            if size(str_err,2) == 0
                Pnomval = dataMI(1);
                
                str_data_MI = "";
                for i = 1:size(dataMI,2)
                    str_data_MI = str_data_MI + string(dataMI(i));
                    if i < size(dataMI,2)
                        str_data_MI = str_data_MI + ",";
                    end
                end

                if ~exist(pwd+"\MI_motors", 'dir')
                   mkdir(pwd+"\MI_motors")
                end
                
                filename = pwd+"\MI_motors\MI_" + string(round(Pnomval/745.7,2)) +"hp_params.txt";

                fdummy = figure('Position', [-100 -100 0 0],'CloseRequestFcn','');
                [filename,path] = uiputfile(filename);
                delete(fdummy);
                
                file = fopen(strcat(path,filename),'w');
                if file >= 3
                    fprintf(file,str_data_MI);
                    fclose(file);
                end
            end
        end

        function button_LimpiarparamsMIPushed(app,event)
            
            for i = 1:size(app.editFieldArr_MIparams_Inputdata,2)
                app.editFieldArr_MIparams_Inputdata(i).Value = 0;
            end
            for i = 1:size(app.editFieldArr_MIparams_Calculateddata,2)
                app.editFieldArr_MIparams_Calculateddata(i).Value = 0;
            end

            for i = 1:size(app.figaxesArr,2)
                cla(app.figaxesArr(i))
            end

            app.button_GuardarparamsMI.Enable = "off";
            app.button_LimpiarparamsMI.Enable = "off";
            app.slider_tvis.Enable = "off";
            app.editField_tvismin.Enable = "off";
            app.editField_tvismax.Enable = "off";
            app.button_Guardargraficas.Enable = "off";
        end

        % Button pushed function: button_Simular
        function button_SimularButtonPushed(app,event)

            dataMI = LeerDatosIngresados(app,app.editFieldArr_MIparams_Inputdata);
            str_err = ValidarDatos(app,dataMI,app.str_MIparams_Inputdata);

            dataSIM = LeerDatosIngresados(app,app.editFieldArr_SIMparams_Inputdata);
            str_err = [str_err,ValidarDatos(app,dataSIM,app.str_SIMparams_Inputdata)];

            if size(str_err,2) == 0

                [Pnomval,v_Srmsnomval,w_Rnomval,n_p,R_Sval,R_Rval,...
                  L_Sval,L_Rval,Mval,Jval,bval] = AsignarDatosMI(app,dataMI);
    
                [i_Srmsnomval,psi_Rmagnomval,tau_Rnomval]= CalcularDatosMI(app,Pnomval,v_Srmsnomval,w_Rnomval,Mval);

                app.editField_nom03_ISrmsnom.Value = i_Srmsnomval;
                app.editField_nom04_psiRmagnom.Value = psi_Rmagnomval;
                app.editField_nom06_tauRnom.Value = tau_Rnomval;
    
                app.MI_motor = MI_model(Pnomval,v_Srmsnomval,i_Srmsnomval,...
                                    psi_Rmagnomval,w_Rnomval,tau_Rnomval,...
                                    n_p,R_Sval,R_Rval,L_Sval,L_Rval,Mval,Jval,bval);
    
                app.editField_el07_sigma.Value = app.MI_motor.electric_params.sigma;
                app.editField_el08_gamma.Value = app.MI_motor.electric_params.gamma;
    
                [tsim,tstep] = AsignarDatosSIM(app,dataSIM);
                app.SIM_motor = SIM_model(tsim,tstep);
                
                evalin('base', 'clear all')

                MI_bus_info = Simulink.Bus.createObject(app.MI_motor.struct);
                app.SIM_motor.MI_bus = evalin('base', MI_bus_info.busName);

                assignin('base','tsim',app.SIM_motor.tsim)
                assignin('base','tstep',app.SIM_motor.tstep)
                assignin('base','MI_motor',app.MI_motor)
                assignin('base','MI_bus',app.SIM_motor.MI_bus)
                assignin('base','inversor_select',0)
                
                try
                    app.label_sim_comments.Text = "Simulacion en ejecución";
                    app.SIM_motor.out = sim('Modelo_MI_simulink1.slx');
                catch ME
                    app.label_sim_comments.Text = "Error en simulación";
                    disp(ME.message)
                    return
                end

                app.label_sim_comments.Text = "Simulación completada";
                
                GenerarGraficas(app,0,app.SIM_motor.tsim);

                assignin('base','out',app.SIM_motor.out)
                app.label_sim_comments.Text = "Simulacion ejecutada correctamente";

                app.slider_tvis.Enable = "on";
                app.editField_tvismin.Enable = "on";
                app.editField_tvismax.Enable = "on";
                app.button_Guardargraficas.Enable = "on";

                app.slider_tvis.Limits = [0 app.SIM_motor.tsim];
                app.slider_tvis.Value = [0 app.SIM_motor.tsim];
                app.editField_tvismin.Value = 0;
                app.editField_tvismax.Value = app.SIM_motor.tsim;
            end
        end

        % Value changed function: slider_tvis
        function slider_tvisValueChanged(app,event)
            val = app.slider_tvis.Value;
            if val(1) == val(2)
                if val(2) == 0
                    val(1) = 0;
                    val(2) = app.SIM_motor.tstep*10;
                elseif val(1) == app.SIM_motor.tsim
                    val(1) = app.SIM_motor.tsim - app.SIM_motor.tstep*10;
                    val(2) = app.SIM_motor.tsim;
                end
            end
            if val(2) - val(1) < app.SIM_motor.tstep*10
                if val(1) + app.SIM_motor.tstep*10 > app.SIM_motor.tsim
                    val(2) = app.SIM_motor.tsim;
                    val(1) = app.SIM_motor.tsim - app.SIM_motor.tstep*10;
                elseif val(2) - app.SIM_motor.tstep*10 < 0
                    val(1) = 0;
                    val(2) = app.SIM_motor.tstep*10;
                else
                    val(2) = val(1) + app.SIM_motor.tstep*10;
                end
            end
            
            app.slider_tvis.Value = val;
            app.editField_tvismin.Value = val(1);
            app.editField_tvismax.Value = val(2);
            GenerarGraficas(app,val(1),val(2));
        end

        % Value changed function: editField_tvismin
        function editField_tvisminValueChanged(app,event)
            min = app.editField_tvismin.Value;
            max = app.slider_tvis.Value(2);
            if min < 0
                min = 0;
            elseif min >= max 
                if max < app.SIM_motor.tstep*10
                    max = app.SIM_motor.tstep*10;
                    app.editField_tvismax.Value = max;
                end
                min = max - app.SIM_motor.tstep*10;
            end

            app.editField_tvismin.Value = min;
            app.slider_tvis.Value = [min max];
            GenerarGraficas(app,min,max);
        end

        % Value changed function: editField_tvismax
        function editField_tvismaxValueChanged(app,event)
            min = app.slider_tvis.Value(1);
            max = app.editField_tvismax.Value;
            if max > app.SIM_motor.tsim
                max = app.SIM_motor.tsim;
            elseif max <= min
                if min > app.SIM_motor.tsim - app.SIM_motor.tstep*10
                    min = app.SIM_motor.tsim - app.SIM_motor.tstep*10;
                    app.editField_tvismin.Value = min;
                end
                max = min + app.SIM_motor.tstep*10;
            end

            app.editField_tvismax.Value = max;
            app.slider_tvis.Value = [min max];
            GenerarGraficas(app,min,max);
        end

        % Value changed function: editField_nom01_Pnom
        function editField_nom01_PnomValueChanged(app, event)
            app.button_GuardarparamsMI.Enable = "on";
            app.button_LimpiarparamsMI.Enable = "on";
            app.label_MI_archivo.Text = 'Ningún archivo seleccionado';
        end

        % Value changed function: editField_nom02_VSrmsnom
        function editField_nom02_VSrmsnomValueChanged(app, event)
            app.button_GuardarparamsMI.Enable = "on";
            app.button_LimpiarparamsMI.Enable = "on";
            app.label_MI_archivo.Text = 'Ningún archivo seleccionado';
        end

        % Value changed function: editField_nom05_wRnom
        function editField_nom05_wRnomValueChanged(app, event)
            app.button_GuardarparamsMI.Enable = "on";
            app.button_LimpiarparamsMI.Enable = "on";
            app.label_MI_archivo.Text = 'Ningún archivo seleccionado';
        end

        % Value changed function: editField_el01_np
        function editField_el01_npValueChanged(app, event)
            app.button_GuardarparamsMI.Enable = "on";
            app.button_LimpiarparamsMI.Enable = "on";
            app.label_MI_archivo.Text = 'Ningún archivo seleccionado';
        end

        % Value changed function: editField_el02_RS
        function editField_el02_RSValueChanged(app, event)
            app.button_GuardarparamsMI.Enable = "on";
            app.button_LimpiarparamsMI.Enable = "on";
            app.label_MI_archivo.Text = 'Ningún archivo seleccionado';
        end

        % Value changed function: editField_el03_RR
        function editField_el03_RRValueChanged(app, event)
            app.button_GuardarparamsMI.Enable = "on";
            app.button_LimpiarparamsMI.Enable = "on";
            app.label_MI_archivo.Text = 'Ningún archivo seleccionado';
        end

        % Value changed function: editField_el04_LS
        function editField_el04_LSValueChanged(app, event)
            app.button_GuardarparamsMI.Enable = "on";
            app.button_LimpiarparamsMI.Enable = "on";
            app.label_MI_archivo.Text = 'Ningún archivo seleccionado';
        end

        % Value changed function: editField_el05_LR
        function editField_el05_LRValueChanged(app, event)
            app.button_GuardarparamsMI.Enable = "on";
            app.button_LimpiarparamsMI.Enable = "on";
            app.label_MI_archivo.Text = 'Ningún archivo seleccionado';
        end

        % Value changed function: editField_el06_M
        function editField_el06_MValueChanged(app, event)
            app.button_GuardarparamsMI.Enable = "on";
            app.button_LimpiarparamsMI.Enable = "on";
            app.label_MI_archivo.Text = 'Ningún archivo seleccionado';
        end

        % Value changed function: editField_me01_J
        function editField_me01_JValueChanged(app, event)
            app.button_GuardarparamsMI.Enable = "on";
            app.button_LimpiarparamsMI.Enable = "on";
            app.label_MI_archivo.Text = 'Ningún archivo seleccionado';
        end

        % Value changed function: editField_me02_b
        function editField_me02_bValueChanged(app, event)
            app.button_GuardarparamsMI.Enable = "on";
            app.button_LimpiarparamsMI.Enable = "on";
            app.label_MI_archivo.Text = 'Ningún archivo seleccionado';
        end

        function data = LeerDatosIngresados(app,editFieldMI_Arr)
            data = zeros(size(editFieldMI_Arr));
            for i = 1:size(data,2)
                data(i) = editFieldMI_Arr(i).Value;
            end
        end

        function [Pnomval,v_Srmsnomval,w_Rnomval,n_p,R_Sval,R_Rval,...
                  L_Sval,L_Rval,Mval,Jval,bval] = AsignarDatosMI(app,data)

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

        function [tsim,tstep] = AsignarDatosSIM(app,data)
            tsim = data(1);
            tstep = data(2);
        end

        function str_err = ValidarDatos(app,data,str)
            str_err = strings(0); 
            j = 1;
            %data
            for i = 1:size(str,2)
                if data(i) <= 0
                    str_err(j) = str(i);
                    j = j + 1;
                end
            end
            if size(str_err,2) > 0
                uialert(app.figure_main,["Se deben especificar valores mayores a cero:" str_err],"Warning","Icon","warning","Modal",true);
            end
        end

        function [i_Srmsnomval,psi_Rmagnomval,tau_Rnomval]= CalcularDatosMI(app,Pnomval,v_Srmsnomval,w_Rnomval,Mval)
            i_Srmsnomval = Pnomval/v_Srmsnomval;
            psi_Rmagnomval = Mval*i_Srmsnomval/sqrt(2);
            tau_Rnomval = Pnomval/w_Rnomval;

        end

        function GenerarGraficas(app,tinit,tfin)
            t = app.SIM_motor.out.tout;

            [~,tinit_ind] = min(abs(t-tinit));
            [~,tfin_ind] = min(abs(t-tfin));
            ind_data = tinit_ind:tfin_ind;
            t = t(ind_data);
            
            app.datos_Graficas = ValidarDatosGraficas(app);


            figureHandler.graficar_UIFig(app.axes_voltaje1,...
                    "Voltajes de estator trifasicas $u_S$",...
                    t,app.datos_Graficas.u_S3abc(ind_data,1), ...
                    14,"Tiempo [s]","Voltaje [V]", ...
                    "$u_{SA}$");

            figureHandler.graficar_UIFig(app.axes_voltaje2,...
                    "",t,app.datos_Graficas.u_S3abc(ind_data,2), ...
                    14,"Tiempo [s]","Voltaje [V]", ...
                    "$u_{SB}$");

            figureHandler.graficar_UIFig(app.axes_voltaje3,...
                    "",t,app.datos_Graficas.u_S3abc(ind_data,3), ...
                    14,"Tiempo [s]","Voltaje [V]", ...
                    "$u_{SC}$");

            figureHandler.graficar_UIFig(app.axes_corriente1,...
                    "Corrientes de estator trifasicas $i_S$",...
                    t,app.datos_Graficas.i_S3abc(ind_data,1), ...
                    14,"Tiempo [s]","Corriente [A]", ...
                    "$i_{SA}$");

            figureHandler.graficar_UIFig(app.axes_corriente2,...
                    "",t,app.datos_Graficas.i_S3abc(ind_data,2), ...
                    14,"Tiempo [s]","Corriente [A]", ...
                    "$i_{SB}$");

            figureHandler.graficar_UIFig(app.axes_corriente3,...
                    "",t,app.datos_Graficas.i_S3abc(ind_data,3), ...
                    14,"Tiempo [s]","Corriente [A]", ...
                    "$i_{SC}$");

            figureHandler.graficar_UIFig(app.axes_velocidad,...
                    "Velocidad $w_R$",t,app.datos_Graficas.w_R(ind_data), ...
                    14,"Tiempo [s]","Velocidad [rad/s]","$w_R$");

            figureHandler.graficar_UIFig(app.axes_torque,...
                    "Torque $\tau_R$",t,...
                    [app.datos_Graficas.tau_R(ind_data),app.datos_Graficas.tau_L(ind_data)], ...
                    14,"Tiempo [s]","Torque [N m]", ...
                    ["$\tau_R$","$\tau_L$"]);

            figureHandler.graficar_UIFig(app.axes_potencia, ...
                    "Potencia",t,...
                    [app.datos_Graficas.P_elect(ind_data),app.datos_Graficas.P_mech(ind_data)], ...
                    14,"Tiempo [s]","Potencia [W]", ...
                    ["Potencia electrica","Potencia mecanica"]);
        end

        function datos_Graficas = ValidarDatosGraficas(app)
            datos_Graficas.u_S3abc = figureHandler.checksize(app.SIM_motor.out.u_S3abc.data);
            datos_Graficas.i_S3abc = figureHandler.checksize(app.SIM_motor.out.i_S3abc.data);

            datos_Graficas.w_R = figureHandler.checksize(app.SIM_motor.out.w_R.data);
            datos_Graficas.tau_R = figureHandler.checksize(app.SIM_motor.out.tau_R.data);
            datos_Graficas.tau_L = figureHandler.checksize(app.SIM_motor.out.tau_L.data);

            datos_Graficas.P_elect = figureHandler.checksize(app.SIM_motor.out.P_elect.data);
            datos_Graficas.P_mech = figureHandler.checksize(app.SIM_motor.out.P_mech.data);
        end

        function button_GuardargraficasPushed(app,event)

            if ~exist(pwd+"\Simulación_modelo", 'dir')
               mkdir(pwd+"\Simulación_modelo\")
            end

            str_dir = "Motor" + string(round(app.MI_motor.Pnom/745.7,2)) + "hp\";

            fdummy = figure('Position', [-100 -100 0 0],'CloseRequestFcn','');
            str_dir_graficas = uigetdir(pwd+"\Simulación_modelo","Seleccionar folder");
            delete(fdummy);

            if str_dir_graficas == 0
                return
            end

            t = app.SIM_motor.out.tout;

            val = app.slider_tvis.Value;
            tinit = val(1);
            tfin = val(2);

            [~,tinit_ind] = min(abs(t-tinit));
            [~,tfin_ind] = min(abs(t-tfin));
            ind_data = tinit_ind:tfin_ind;
            t = t(ind_data);

            app.datos_Graficas = ValidarDatosGraficas(app);

            f(1) = figureHandler.graficar_Fig(1,1,[3,1],...
                            "Voltajes de estator trifasicas $u_S$", ...
                            t,app.datos_Graficas.u_S3abc(ind_data,:), ...
                            "Tiempo [s]","Voltaje [V]", ...
                            ["$u_{SA}$","$u_{SB}$","$u_{SC}$"]);

            f(2) = figureHandler.graficar_Fig(2,1,[3,1], ...
                            "Corrientes de estator trifasicas $i_S$", ...
                            t,app.datos_Graficas.i_S3abc(ind_data,:), ...
                            "Tiempo [s]","Corriente [A]", ...
                            ["$i_{SA}$","$i_{SB}$","$i_{SC}$"]);

            f(3) = figureHandler.graficar_Fig(3,0,[1,1], ...
                            "Torque $\tau_R$", ...
                            t,[app.datos_Graficas.tau_R(ind_data,:),app.datos_Graficas.tau_L(ind_data,:)], ...
                            "Tiempo [s]","Torque [N m]", ...
                            ["$\tau_R$","$\tau_L$"]);
        
            f(4) = figureHandler.graficar_Fig(4,0,[1,1], ...
                            "Velocidad $w_R$", ...
                            t,[app.datos_Graficas.w_R(ind_data,:)], ...
                            "Tiempo [s]","Velocidad [rad/s]", ...
                            "$w_R$");

            f(5) = figureHandler.graficar_Fig(5,0,[1,1], ...
                            "Potencia", ...
                            t,[app.datos_Graficas.P_elect(ind_data,:),app.datos_Graficas.P_mech(ind_data,:)], ...
                            "Tiempo [s]","Potencia [W]", ...
                            ["Potencia electrica","Potencia mecanica"]);

            figureHandler.guardarGrafica(f(1),str_dir_graficas,str_dir,"01","Voltaje");
            figureHandler.guardarGrafica(f(2),str_dir_graficas,str_dir,"02","Corriente");
            figureHandler.guardarGrafica(f(3),str_dir_graficas,str_dir,"03","Torque");
            figureHandler.guardarGrafica(f(4),str_dir_graficas,str_dir,"04","Velocidad");
            figureHandler.guardarGrafica(f(5),str_dir_graficas,str_dir,"05","Potencia");
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.figure_main = uifigure('Visible', 'off');
            app.figure_main.Position = [1 1 1367 768];
            app.figure_main.Name = ['Simulación del modelo ab de un' ...
                                 ' motor de inducción trifásico'];

            % Create layout_main
            app.layout_main = uigridlayout(app.figure_main);
            app.layout_main.ColumnWidth = {375, '1x'};
            app.layout_main.RowHeight = {'1x'};
            app.layout_main.ColumnSpacing = 0;
            app.layout_main.RowSpacing = 5;
            app.layout_main.Padding = [5 5 5 5];

            % Create layout_param_main
            app.layout_param_main = uigridlayout(app.layout_main);
            app.layout_param_main.ColumnWidth = {'1x'};
            app.layout_param_main.RowHeight = {'12x', '3x'};
            app.layout_param_main.ColumnSpacing = 5;
            app.layout_param_main.RowSpacing = 5;
            app.layout_param_main.Padding = [0 0 5 0];
            app.layout_param_main.Layout.Row = 1;
            app.layout_param_main.Layout.Column = 1;

            % Create panel_MI_params
            app.panel_MI_params = uipanel(app.layout_param_main);
            app.panel_MI_params.Title = 'Parámetros del motor de inducción';
            app.panel_MI_params.Layout.Row = 1;
            app.panel_MI_params.Layout.Column = 1;
            app.panel_MI_params.FontSize = 18;

            % Create layout_MI_params
            app.layout_MI_params = uigridlayout(app.panel_MI_params);
            app.layout_MI_params.ColumnWidth = {'1x'};
            app.layout_MI_params.RowHeight = {25, '1x', 25};
            app.layout_MI_params.ColumnSpacing = 0;
            app.layout_MI_params.RowSpacing = 5;
            app.layout_MI_params.Padding = [2 2 2 2];

            % Create layout_MI_cargar_params
            app.layout_MI_cargar_params = uigridlayout(app.layout_MI_params);
            app.layout_MI_cargar_params.ColumnWidth = {'5x', '12x'};
            app.layout_MI_cargar_params.RowHeight = {25};
            app.layout_MI_cargar_params.ColumnSpacing = 5;
            app.layout_MI_cargar_params.RowSpacing = 0;
            app.layout_MI_cargar_params.Padding = [0 0 0 0];
            app.layout_MI_cargar_params.Layout.Row = 1;
            app.layout_MI_cargar_params.Layout.Column = 1;

            % Create button_MI_archivo
            app.button_MI_archivo = uibutton(app.layout_MI_cargar_params, 'push');
            app.button_MI_archivo.ButtonPushedFcn = createCallbackFcn(app, @button_MI_archivoButtonPushed, true);
            app.button_MI_archivo.Layout.Row = 1;
            app.button_MI_archivo.Layout.Column = 1;
            app.button_MI_archivo.Text = 'Cargar Archivo';

            % Create label_MI_archivo
            app.label_MI_archivo = uilabel(app.layout_MI_cargar_params);
            app.label_MI_archivo.Layout.Row = 1;
            app.label_MI_archivo.Layout.Column = 2;
            app.label_MI_archivo.Text = 'Ningún archivo seleccionado';

            % Create layout_MI_data
            app.layout_MI_data = uigridlayout(app.layout_MI_params);
            app.layout_MI_data.ColumnWidth = {'1x'};
            app.layout_MI_data.RowHeight = {'17x','21x','9x'};
            app.layout_MI_data.ColumnSpacing = 0;
            app.layout_MI_data.RowSpacing = 5;
            app.layout_MI_data.Padding = [0 0 0 0];
            app.layout_MI_data.Layout.Row = 2;
            app.layout_MI_data.Layout.Column = 1;

            % Create panel_valnoms
            app.panel_valnoms = uipanel(app.layout_MI_data);
            app.panel_valnoms.Title = 'Valores nominales';
            app.panel_valnoms.Layout.Row = 1;
            app.panel_valnoms.Layout.Column = 1;
            app.panel_valnoms.FontSize = 18;

            % Create layout_valnoms
            app.layout_valnoms = uigridlayout(app.panel_valnoms);
            app.layout_valnoms.ColumnWidth = {'5x', '1x'};
            app.layout_valnoms.RowHeight = {20, 20, 20, 20, 20, 20};
            app.layout_valnoms.ColumnSpacing = 0;
            app.layout_valnoms.RowSpacing = 2;
            app.layout_valnoms.Padding = [2 2 2 2];

            % Create editField_nom01_Pnom
            app.editField_nom01_Pnom = uieditfield(app.layout_valnoms, 'numeric');
            app.editField_nom01_Pnom.ValueChangedFcn = createCallbackFcn(app, @editField_nom01_PnomValueChanged, true);
            app.editField_nom01_Pnom.Layout.Row = 1;
            app.editField_nom01_Pnom.Layout.Column = 2;
            app.editField_nom01_Pnom.RoundFractionalValues = "off";

            % Create PnomLabel
            app.PnomLabel = uilabel(app.layout_valnoms);
            app.PnomLabel.HorizontalAlignment = 'right';
            app.PnomLabel.Interpreter = 'latex';
            app.PnomLabel.Layout.Row = 1;
            app.PnomLabel.Layout.Column = 1;
            app.PnomLabel.Text = '$P_{nom}$: ';

            % Create label_nom01_Pnom
            app.label_nom01_Pnom = uilabel(app.layout_valnoms);
            app.label_nom01_Pnom.Interpreter = 'latex';
            app.label_nom01_Pnom.Layout.Row = 1;
            app.label_nom01_Pnom.Layout.Column = 1;
            app.label_nom01_Pnom.Text = 'Potencia nominal [W]';

            % Create VSrmsnomLabel
            app.VSrmsnomLabel = uilabel(app.layout_valnoms);
            app.VSrmsnomLabel.HorizontalAlignment = 'right';
            app.VSrmsnomLabel.Interpreter = 'latex';
            app.VSrmsnomLabel.Layout.Row = 2;
            app.VSrmsnomLabel.Layout.Column = 1;
            app.VSrmsnomLabel.Text = '$V_{S(rms)nom}$: ';

            % Create editField_nom02_VSrmsnom
            app.editField_nom02_VSrmsnom = uieditfield(app.layout_valnoms, 'numeric');
            app.editField_nom02_VSrmsnom.ValueChangedFcn = createCallbackFcn(app, @editField_nom02_VSrmsnomValueChanged, true);
            app.editField_nom02_VSrmsnom.Layout.Row = 2;
            app.editField_nom02_VSrmsnom.Layout.Column = 2;
            app.editField_nom02_VSrmsnom.RoundFractionalValues = "off";

            % Create label_nom02_VSrmsnom
            app.label_nom02_VSrmsnom = uilabel(app.layout_valnoms);
            app.label_nom02_VSrmsnom.Interpreter = 'latex';
            app.label_nom02_VSrmsnom.Layout.Row = 2;
            app.label_nom02_VSrmsnom.Layout.Column = 1;
            app.label_nom02_VSrmsnom.Text = 'Voltaje rms nominal [V]';

            % Create ISrmsnomLabel
            app.ISrmsnomLabel = uilabel(app.layout_valnoms);
            app.ISrmsnomLabel.HorizontalAlignment = 'right';
            app.ISrmsnomLabel.Interpreter = 'latex';
            app.ISrmsnomLabel.Layout.Row = 3;
            app.ISrmsnomLabel.Layout.Column = 1;
            app.ISrmsnomLabel.Text = '$i_{S(rms)nom}$: ';

            % Create editField_nom03_ISrmsnom
            app.editField_nom03_ISrmsnom = uieditfield(app.layout_valnoms, 'numeric');
            app.editField_nom03_ISrmsnom.Enable = 'off';
            app.editField_nom03_ISrmsnom.Layout.Row = 3;
            app.editField_nom03_ISrmsnom.Layout.Column = 2;
            app.editField_nom03_ISrmsnom.RoundFractionalValues = "off";

            % Create label_nom03_ISrmsnom
            app.label_nom03_ISrmsnom = uilabel(app.layout_valnoms);
            app.label_nom03_ISrmsnom.Interpreter = 'latex';
            app.label_nom03_ISrmsnom.Layout.Row = 3;
            app.label_nom03_ISrmsnom.Layout.Column = 1;
            app.label_nom03_ISrmsnom.Text = 'Corriente rms nominal [A]';

            % Create psiRnomLabel
            app.psiRnomLabel = uilabel(app.layout_valnoms);
            app.psiRnomLabel.HorizontalAlignment = 'right';
            app.psiRnomLabel.Interpreter = 'latex';
            app.psiRnomLabel.Layout.Row = 4;
            app.psiRnomLabel.Layout.Column = 1;
            app.psiRnomLabel.Text = '$||\psi_{Rnom}||$: ';

            % Create editField_nom04_psiRmagnom
            app.editField_nom04_psiRmagnom = uieditfield(app.layout_valnoms, 'numeric');
            app.editField_nom04_psiRmagnom.Enable = 'off';
            app.editField_nom04_psiRmagnom.Layout.Row = 4;
            app.editField_nom04_psiRmagnom.Layout.Column = 2;
            app.editField_nom04_psiRmagnom.RoundFractionalValues = "off";

            % Create label_nom04_psi_Rmagnom
            app.label_nom04_psi_Rmagnom = uilabel(app.layout_valnoms);
            app.label_nom04_psi_Rmagnom.Interpreter = 'latex';
            app.label_nom04_psi_Rmagnom.Layout.Row = 4;
            app.label_nom04_psi_Rmagnom.Layout.Column = 1;
            app.label_nom04_psi_Rmagnom.Text = 'Magnitud de flujo nominal [Wb vuelta]';

            % Create wRnomLabel
            app.wRnomLabel = uilabel(app.layout_valnoms);
            app.wRnomLabel.HorizontalAlignment = 'right';
            app.wRnomLabel.Interpreter = 'latex';
            app.wRnomLabel.Layout.Row = 5;
            app.wRnomLabel.Layout.Column = 1;
            app.wRnomLabel.Text = '$\omega_{Rnom}$: ';

            % Create editField_nom05_wRnom
            app.editField_nom05_wRnom = uieditfield(app.layout_valnoms, 'numeric');
            app.editField_nom05_wRnom.ValueChangedFcn = createCallbackFcn(app, @editField_nom05_wRnomValueChanged, true);
            app.editField_nom05_wRnom.Layout.Row = 5;
            app.editField_nom05_wRnom.Layout.Column = 2;
            app.editField_nom05_wRnom.RoundFractionalValues = "off";

            % Create label_nom05_wRnom
            app.label_nom05_wRnom = uilabel(app.layout_valnoms);
            app.label_nom05_wRnom.Interpreter = 'latex';
            app.label_nom05_wRnom.Layout.Row = 5;
            app.label_nom05_wRnom.Layout.Column = 1;
            app.label_nom05_wRnom.Text = 'Velocidad nominal [rad/s]';

            % Create tauRnomLabel
            app.tauRnomLabel = uilabel(app.layout_valnoms);
            app.tauRnomLabel.HorizontalAlignment = 'right';
            app.tauRnomLabel.Interpreter = 'latex';
            app.tauRnomLabel.Layout.Row = 6;
            app.tauRnomLabel.Layout.Column = 1;
            app.tauRnomLabel.Text = '$\tau_{Rnom}$: ';

            % Create editField_nom06_tauRnom
            app.editField_nom06_tauRnom = uieditfield(app.layout_valnoms, 'numeric');
            app.editField_nom06_tauRnom.Enable = 'off';
            app.editField_nom06_tauRnom.Layout.Row = 6;
            app.editField_nom06_tauRnom.Layout.Column = 2;
            app.editField_nom06_tauRnom.RoundFractionalValues = "off";

            % Create label_nom06_tauRnom
            app.label_nom06_tauRnom = uilabel(app.layout_valnoms);
            app.label_nom06_tauRnom.Interpreter = 'latex';
            app.label_nom06_tauRnom.Layout.Row = 6;
            app.label_nom06_tauRnom.Layout.Column = 1;
            app.label_nom06_tauRnom.Text = 'Torque nominal [N m]';

            % Create panel_elecparams
            app.panel_elecparams = uipanel(app.layout_MI_data);
            app.panel_elecparams.Title = 'Parámetros eléctricos';
            app.panel_elecparams.Layout.Row = 2;
            app.panel_elecparams.Layout.Column = 1;
            app.panel_elecparams.FontSize = 18;

            % Create layout_elecparams
            app.layout_elecparams = uigridlayout(app.panel_elecparams);
            app.layout_elecparams.ColumnWidth = {'5x', '1x'};
            app.layout_elecparams.RowHeight = {20, 20, 20, 20, 20, 20, 20, 20};
            app.layout_elecparams.ColumnSpacing = 0;
            app.layout_elecparams.RowSpacing = 2;
            app.layout_elecparams.Padding = [2 2 2 2];

            % Create npLabel
            app.npLabel = uilabel(app.layout_elecparams);
            app.npLabel.HorizontalAlignment = 'right';
            app.npLabel.Interpreter = 'latex';
            app.npLabel.Layout.Row = 1;
            app.npLabel.Layout.Column = 1;
            app.npLabel.Text = '$n_p$: ';

            % Create editField_el01_np
            app.editField_el01_np = uieditfield(app.layout_elecparams, 'numeric');
            app.editField_el01_np.ValueChangedFcn = createCallbackFcn(app, @editField_el01_npValueChanged, true);
            app.editField_el01_np.Layout.Row = 1;
            app.editField_el01_np.Layout.Column = 2;
            app.editField_el01_np.RoundFractionalValues = "off";

            % Create label_el01_np
            app.label_el01_np = uilabel(app.layout_elecparams);
            app.label_el01_np.Interpreter = 'latex';
            app.label_el01_np.Layout.Row = 1;
            app.label_el01_np.Layout.Column = 1;
            app.label_el01_np.Text = 'Número de pares de polos';

            % Create RSLabel
            app.RSLabel = uilabel(app.layout_elecparams);
            app.RSLabel.HorizontalAlignment = 'right';
            app.RSLabel.Interpreter = 'latex';
            app.RSLabel.Layout.Row = 2;
            app.RSLabel.Layout.Column = 1;
            app.RSLabel.Text = '$R_S$: ';

            % Create editField_el02_RS
            app.editField_el02_RS = uieditfield(app.layout_elecparams, 'numeric');
            app.editField_el02_RS.ValueChangedFcn = createCallbackFcn(app, @editField_el02_RSValueChanged, true);
            app.editField_el02_RS.Layout.Row = 2;
            app.editField_el02_RS.Layout.Column = 2;
            app.editField_el02_RS.RoundFractionalValues = "off";

            % Create label_el02_RS
            app.label_el02_RS = uilabel(app.layout_elecparams);
            app.label_el02_RS.Interpreter = 'latex';
            app.label_el02_RS.Layout.Row = 2;
            app.label_el02_RS.Layout.Column = 1;
            app.label_el02_RS.Text = 'Resistencia de devanados de estator $[\Omega]$';

            % Create RRLabel
            app.RRLabel = uilabel(app.layout_elecparams);
            app.RRLabel.HorizontalAlignment = 'right';
            app.RRLabel.Interpreter = 'latex';
            app.RRLabel.Layout.Row = 3;
            app.RRLabel.Layout.Column = 1;
            app.RRLabel.Text = '$R_R$: ';

            % Create editField_el03_RR
            app.editField_el03_RR = uieditfield(app.layout_elecparams, 'numeric');
            app.editField_el03_RR.ValueChangedFcn = createCallbackFcn(app, @editField_el03_RRValueChanged, true);
            app.editField_el03_RR.Layout.Row = 3;
            app.editField_el03_RR.Layout.Column = 2;
            app.editField_el03_RR.RoundFractionalValues = "off";

            % Create label_el03_RR
            app.label_el03_RR = uilabel(app.layout_elecparams);
            app.label_el03_RR.Interpreter = 'latex';
            app.label_el03_RR.Layout.Row = 3;
            app.label_el03_RR.Layout.Column = 1;
            app.label_el03_RR.Text = 'Resistencia de devanados de rotor $[\Omega]$';

            % Create LSLabel
            app.LSLabel = uilabel(app.layout_elecparams);
            app.LSLabel.HorizontalAlignment = 'right';
            app.LSLabel.Interpreter = 'latex';
            app.LSLabel.Layout.Row = 4;
            app.LSLabel.Layout.Column = 1;
            app.LSLabel.Text = '$L_S$: ';

            % Create editField_el04_LS
            app.editField_el04_LS = uieditfield(app.layout_elecparams, 'numeric');
            app.editField_el04_LS.ValueChangedFcn = createCallbackFcn(app, @editField_el04_LSValueChanged, true);
            app.editField_el04_LS.Layout.Row = 4;
            app.editField_el04_LS.Layout.Column = 2;
            app.editField_el04_LS.RoundFractionalValues = "off";

            % Create label_el04_LS
            app.label_el04_LS = uilabel(app.layout_elecparams);
            app.label_el04_LS.Interpreter = 'latex';
            app.label_el04_LS.Layout.Row = 4;
            app.label_el04_LS.Layout.Column = 1;
            app.label_el04_LS.Text = 'Inductancia de devanados de estator [H]';

            % Create LRLabel
            app.LRLabel = uilabel(app.layout_elecparams);
            app.LRLabel.HorizontalAlignment = 'right';
            app.LRLabel.Interpreter = 'latex';
            app.LRLabel.Layout.Row = 5;
            app.LRLabel.Layout.Column = 1;
            app.LRLabel.Text = '$L_R$: ';

            % Create editField_el05_LR
            app.editField_el05_LR = uieditfield(app.layout_elecparams, 'numeric');
            app.editField_el05_LR.ValueChangedFcn = createCallbackFcn(app, @editField_el05_LRValueChanged, true);
            app.editField_el05_LR.Layout.Row = 5;
            app.editField_el05_LR.Layout.Column = 2;
            app.editField_el05_LR.RoundFractionalValues = "off";

            % Create label_el05_LR
            app.label_el05_LR = uilabel(app.layout_elecparams);
            app.label_el05_LR.Interpreter = 'latex';
            app.label_el05_LR.Layout.Row = 5;
            app.label_el05_LR.Layout.Column = 1;
            app.label_el05_LR.Text = 'Inductancia de devanados de rotor [H]';

            % Create MLabel
            app.MLabel = uilabel(app.layout_elecparams);
            app.MLabel.HorizontalAlignment = 'right';
            app.MLabel.Interpreter = 'latex';
            app.MLabel.Layout.Row = 6;
            app.MLabel.Layout.Column = 1;
            app.MLabel.Text = '$M$: ';

            % Create editField_el06_M
            app.editField_el06_M = uieditfield(app.layout_elecparams, 'numeric');
            app.editField_el06_M.ValueChangedFcn = createCallbackFcn(app, @editField_el06_MValueChanged, true);
            app.editField_el06_M.Layout.Row = 6;
            app.editField_el06_M.Layout.Column = 2;
            app.editField_el06_M.RoundFractionalValues = "off";

            % Create label_el06_M
            app.label_el06_M = uilabel(app.layout_elecparams);
            app.label_el06_M.Interpreter = 'latex';
            app.label_el06_M.Layout.Row = 6;
            app.label_el06_M.Layout.Column = 1;
            app.label_el06_M.Text = 'Inductancia mutua [H]';

            % Create SigmaLabel
            app.SigmaLabel = uilabel(app.layout_elecparams);
            app.SigmaLabel.HorizontalAlignment = 'right';
            app.SigmaLabel.Interpreter = 'latex';
            app.SigmaLabel.Layout.Row = 7;
            app.SigmaLabel.Layout.Column = 1;
            app.SigmaLabel.Text = '$=L_S-M^2/L_R$ ';

            % Create editField_el07_sigma
            app.editField_el07_sigma = uieditfield(app.layout_elecparams, 'numeric');
            app.editField_el07_sigma.Enable = 'off';
            app.editField_el07_sigma.Layout.Row = 7;
            app.editField_el07_sigma.Layout.Column = 2;
            app.editField_el07_sigma.RoundFractionalValues = "off";

            % Create label_el07_sigma
            app.label_el07_sigma = uilabel(app.layout_elecparams);
            app.label_el07_sigma.Interpreter = 'latex';
            app.label_el07_sigma.Layout.Row = 7;
            app.label_el07_sigma.Layout.Column = 1;
            app.label_el07_sigma.Text = 'Factor de dispersión $\sigma$ [H]';

            % Create GammaLabel
            app.GammaLabel = uilabel(app.layout_elecparams);
            app.GammaLabel.HorizontalAlignment = 'right';
            app.GammaLabel.Interpreter = 'latex';
            app.GammaLabel.Layout.Row = 8;
            app.GammaLabel.Layout.Column = 1;
            app.GammaLabel.Text = '$=(R_SL_R^2+R_RM^2)/(\sigma L_R^2)$ ';

            % Create label_el08_gamma
            app.label_el08_gamma = uilabel(app.layout_elecparams);
            app.label_el08_gamma.Interpreter = 'latex';
            app.label_el08_gamma.Layout.Row = 8;
            app.label_el08_gamma.Layout.Column = 1;
            app.label_el08_gamma.Text = 'Factor $\gamma$ $[\Omega]$';

            % Create editField_el07_gamma
            app.editField_el08_gamma = uieditfield(app.layout_elecparams, 'numeric');
            app.editField_el08_gamma.Enable = 'off';
            app.editField_el08_gamma.Layout.Row = 8;
            app.editField_el08_gamma.Layout.Column = 2;
            app.editField_el08_gamma.RoundFractionalValues = "off";

            % Create panel_mechparams
            app.panel_mechparams = uipanel(app.layout_MI_data);
            app.panel_mechparams.Title = 'Parámetros mecánicos';
            app.panel_mechparams.Layout.Row = 3;
            app.panel_mechparams.Layout.Column = 1;
            app.panel_mechparams.FontSize = 18;

            % Create layout_mechparams
            app.layout_mechparams = uigridlayout(app.panel_mechparams);
            app.layout_mechparams.ColumnWidth = {'5x', '1x'};
            app.layout_mechparams.RowHeight = {20, 20};
            app.layout_mechparams.ColumnSpacing = 0;
            app.layout_mechparams.RowSpacing = 2;
            app.layout_mechparams.Padding = [2 2 2 2];

            % Create JLabel
            app.JLabel = uilabel(app.layout_mechparams);
            app.JLabel.HorizontalAlignment = 'right';
            app.JLabel.Interpreter = 'latex';
            app.JLabel.Layout.Row = 1;
            app.JLabel.Layout.Column = 1;
            app.JLabel.Text = '$J$: ';

            % Create editField_me01_J
            app.editField_me01_J = uieditfield(app.layout_mechparams, 'numeric');
            app.editField_me01_J.ValueChangedFcn = createCallbackFcn(app, @editField_me01_JValueChanged, true);
            app.editField_me01_J.Layout.Row = 1;
            app.editField_me01_J.Layout.Column = 2;
            app.editField_me01_J.RoundFractionalValues = "off";

            % Create label_me01_J
            app.label_me01_J = uilabel(app.layout_mechparams);
            app.label_me01_J.Interpreter = 'latex';
            app.label_me01_J.Layout.Row = 1;
            app.label_me01_J.Layout.Column = 1;
            app.label_me01_J.Text = 'Inercia del rotor [kg m^2]';
            
            % Create bLabel
            app.bLabel = uilabel(app.layout_mechparams);
            app.bLabel.HorizontalAlignment = 'right';
            app.bLabel.Interpreter = 'latex';
            app.bLabel.Layout.Row = 2;
            app.bLabel.Layout.Column = 1;
            app.bLabel.Text = '$b$: ';

            % Create editField_me02_b
            app.editField_me02_b = uieditfield(app.layout_mechparams, 'numeric');
            app.editField_me02_b.ValueChangedFcn = createCallbackFcn(app, @editField_me02_bValueChanged, true);
            app.editField_me02_b.Layout.Row = 2;
            app.editField_me02_b.Layout.Column = 2;
            app.editField_me02_b.RoundFractionalValues = "off";

            % Create label_me02_b
            app.label_me02_b = uilabel(app.layout_mechparams);
            app.label_me02_b.Interpreter = 'latex';
            app.label_me02_b.Layout.Row = 2;
            app.label_me02_b.Layout.Column = 1;
            app.label_me02_b.Text = 'Coeficiente de fricción';

            % Create layout_MI_guardar_params
            app.layout_MI_guardar_params = uigridlayout(app.layout_MI_params);
            app.layout_MI_guardar_params.ColumnWidth = {'1x', '2x'};
            app.layout_MI_guardar_params.RowHeight = {'1x'};
            app.layout_MI_guardar_params.ColumnSpacing = 2;
            app.layout_MI_guardar_params.RowSpacing = 0;
            app.layout_MI_guardar_params.Padding = [0 0 0 0];
            app.layout_MI_guardar_params.Layout.Row = 3;
            app.layout_MI_guardar_params.Layout.Column = 1;

            % Create button_Limpiarparams
            app.button_LimpiarparamsMI = uibutton(app.layout_MI_guardar_params, 'push');
            app.button_LimpiarparamsMI.ButtonPushedFcn = createCallbackFcn(app, @button_LimpiarparamsMIPushed, true);
            app.button_LimpiarparamsMI.Enable = 'off';
            app.button_LimpiarparamsMI.Layout.Row = 1;
            app.button_LimpiarparamsMI.Layout.Column = 1;
            app.button_LimpiarparamsMI.Text = 'Limpiar';

            % Create button_Guardarparams
            app.button_GuardarparamsMI = uibutton(app.layout_MI_guardar_params, 'push');
            app.button_GuardarparamsMI.ButtonPushedFcn = createCallbackFcn(app, @button_GuardarparamsMIPushed, true);
            app.button_GuardarparamsMI.Enable = 'off';
            app.button_GuardarparamsMI.Layout.Row = 1;
            app.button_GuardarparamsMI.Layout.Column = 2;
            app.button_GuardarparamsMI.Text = 'Guadar parámetros';
            
            % Create panel_sim_params
            app.panel_sim_params = uipanel(app.layout_param_main);
            app.panel_sim_params.Title = 'Parámetros de simulación';
            app.panel_sim_params.Layout.Row = 2;
            app.panel_sim_params.Layout.Column = 1;
            app.panel_sim_params.FontSize = 18;

            % Create layout_sim
            app.layout_sim = uigridlayout(app.panel_sim_params);
            app.layout_sim.ColumnWidth = {'1x'};
            app.layout_sim.RowHeight = {70, 40};
            app.layout_sim.ColumnSpacing = 2;
            app.layout_sim.RowSpacing = 2;
            app.layout_sim.Padding = [2 2 2 5];

            % Create layout_sim_params
            app.layout_sim_params = uigridlayout(app.layout_sim);
            app.layout_sim_params.ColumnWidth = {'3x', '1x'};
            app.layout_sim_params.RowHeight = {20, 20, 20};
            app.layout_sim_params.ColumnSpacing = 0;
            app.layout_sim_params.RowSpacing = 2;
            app.layout_sim_params.Padding = [2 2 2 2];
            app.layout_sim_params.Layout.Row = 1;
            app.layout_sim_params.Layout.Column = 1;

            % Create label_sim03_ODE5
            app.label_sim03_ODE5 = uilabel(app.layout_sim_params);
            app.label_sim03_ODE5.HorizontalAlignment = 'center';
            app.label_sim03_ODE5.Layout.Row = 3;
            app.label_sim03_ODE5.Layout.Column = 2;
            app.label_sim03_ODE5.Text = 'ODE5';
            app.label_sim03_ODE5.Interpreter = 'latex';

            % Create label_sim03_metodo
            app.label_sim03_metodo = uilabel(app.layout_sim_params);
            app.label_sim03_metodo.Layout.Row = 3;
            app.label_sim03_metodo.Layout.Column = 1;
            app.label_sim03_metodo.Text = 'Método Numérico';
            app.label_sim03_metodo.Interpreter = 'latex';

            % Create tsimLabel
            app.tsimLabel = uilabel(app.layout_sim_params);
            app.tsimLabel.HorizontalAlignment = 'right';
            app.tsimLabel.Layout.Row = 1;
            app.tsimLabel.Layout.Column = 1;
            app.tsimLabel.Text = '$t_{sim}$: ';
            app.tsimLabel.Interpreter = 'latex';

            % Create editField_sim01_tsim
            app.editField_sim01_tsim = uieditfield(app.layout_sim_params, 'numeric');
            app.editField_sim01_tsim.Layout.Row = 1;
            app.editField_sim01_tsim.Layout.Column = 2;
            app.editField_sim01_tsim.Value = 15;
            app.editField_sim01_tsim.RoundFractionalValues = "off";

            % Create label_sim01_tsim
            app.label_sim01_tsim = uilabel(app.layout_sim_params);
            app.label_sim01_tsim.Layout.Row = 1;
            app.label_sim01_tsim.Layout.Column = 1;
            app.label_sim01_tsim.Text = 'Tiempo de simulación [s]';
            app.label_sim01_tsim.Interpreter = 'latex';

            % Create tstepLabel
            app.tstepLabel = uilabel(app.layout_sim_params);
            app.tstepLabel.HorizontalAlignment = 'right';
            app.tstepLabel.Layout.Row = 2;
            app.tstepLabel.Layout.Column = 1;
            app.tstepLabel.Text = '$t_{step}$: ';
            app.tstepLabel.Interpreter = 'latex';

            % Create editField_sim02_tstep
            app.editField_sim02_tstep = uieditfield(app.layout_sim_params, 'numeric');
            app.editField_sim02_tstep.Layout.Row = 2;
            app.editField_sim02_tstep.Layout.Column = 2;
            app.editField_sim02_tstep.Value = 0.0001;
            app.editField_sim02_tstep.RoundFractionalValues = "off";

            % Create label_sim02_tstep
            app.label_sim02_tstep = uilabel(app.layout_sim_params);
            app.label_sim02_tstep.Layout.Row = 2;
            app.label_sim02_tstep.Layout.Column = 1;
            app.label_sim02_tstep.Text = 'Paso de integración (Fijo)';
            app.label_sim02_tstep.Interpreter = 'latex';

            % Create button_Simular
            app.button_Simular = uibutton(app.layout_sim, 'push');
            app.button_Simular.ButtonPushedFcn = createCallbackFcn(app, @button_SimularButtonPushed, true);
            app.button_Simular.FontSize = 18;
            app.button_Simular.Layout.Row = 2;
            app.button_Simular.Layout.Column = 1;
            app.button_Simular.Text = 'Simular';
            
            % Create panel_sim_results
            app.panel_sim_results = uipanel(app.layout_main);
            app.panel_sim_results.Title = 'Resultados de la simulación';
            app.panel_sim_results.Layout.Row = 1;
            app.panel_sim_results.Layout.Column = 2;
            app.panel_sim_results.FontSize = 18;


            % Create layout_sim_results
            app.layout_sim_results = uigridlayout(app.panel_sim_results);
            app.layout_sim_results.ColumnWidth = {'1x', '1x', '1x'};
            app.layout_sim_results.RowHeight = {'1x','1x','1x', 60};
            app.layout_sim_results.ColumnSpacing = 5;
            app.layout_sim_results.RowSpacing = 5;
            app.layout_sim_results.Padding = [5 5 5 5];

            % Create axes_voltaje1
            app.axes_voltaje1 = uiaxes(app.layout_sim_results);
            title(app.axes_voltaje1, 'Voltajes trifásicos')
            xlabel(app.axes_voltaje1, 'Tiempo')
            ylabel(app.axes_voltaje1, 'Voltaje')
            app.axes_voltaje1.Layout.Row = 1;
            app.axes_voltaje1.Layout.Column = 1;

            % Create axes_voltaje2
            app.axes_voltaje2 = uiaxes(app.layout_sim_results);
            xlabel(app.axes_voltaje2, 'Tiempo')
            ylabel(app.axes_voltaje2, 'Voltaje')
            app.axes_voltaje2.Layout.Row = 2;
            app.axes_voltaje2.Layout.Column = 1;

            % Create axes_voltaje3
            app.axes_voltaje3 = uiaxes(app.layout_sim_results);
            xlabel(app.axes_voltaje3, 'Tiempo')
            ylabel(app.axes_voltaje3, 'Voltaje')
            app.axes_voltaje3.Layout.Row = 3;
            app.axes_voltaje3.Layout.Column = 1;

            % Create axes_corriente1
            app.axes_corriente1 = uiaxes(app.layout_sim_results);
            title(app.axes_corriente1, 'Corrientes trifásicas')
            xlabel(app.axes_corriente1, 'Tiempo')
            ylabel(app.axes_corriente1, 'Corriente')
            app.axes_corriente1.Layout.Row = 1;
            app.axes_corriente1.Layout.Column = 2;

            % Create axes_corriente2
            app.axes_corriente2 = uiaxes(app.layout_sim_results);
            xlabel(app.axes_corriente2, 'Tiempo')
            ylabel(app.axes_corriente2, 'Corriente')
            app.axes_corriente2.Layout.Row = 2;
            app.axes_corriente2.Layout.Column = 2;

            % Create axes_corriente3
            app.axes_corriente3 = uiaxes(app.layout_sim_results);
            xlabel(app.axes_corriente3, 'Tiempo')
            ylabel(app.axes_corriente3, 'Corriente')
            app.axes_corriente3.Layout.Row = 3;
            app.axes_corriente3.Layout.Column = 2;

            % Create axes_torque
            app.axes_torque = uiaxes(app.layout_sim_results);
            title(app.axes_torque, 'Torque')
            xlabel(app.axes_torque, 'Tiempo')
            ylabel(app.axes_torque, 'Torque')
            app.axes_torque.Layout.Row = 1;
            app.axes_torque.Layout.Column = 3;

            % Create axes_velocidad
            app.axes_velocidad = uiaxes(app.layout_sim_results);
            title(app.axes_velocidad, 'Velocidad')
            xlabel(app.axes_velocidad, 'Tiempo')
            ylabel(app.axes_velocidad, 'Velocidad')
            app.axes_velocidad.Layout.Row = 2;
            app.axes_velocidad.Layout.Column = 3;

            % Create axes_potencia
            app.axes_potencia = uiaxes(app.layout_sim_results);
            title(app.axes_potencia, 'Potencia')
            xlabel(app.axes_potencia, 'Tiempo')
            ylabel(app.axes_potencia, 'Potencia')
            app.axes_potencia.Layout.Row = 3;
            app.axes_potencia.Layout.Column = 3;

            % Create label_sim_comments
            app.label_sim_comments = uilabel(app.layout_sim_results);
            app.label_sim_comments.Layout.Row = 4;
            app.label_sim_comments.Layout.Column = 1;
            app.label_sim_comments.Text = ' ';
            app.label_sim_comments.FontSize = 16;

            % Create button_Guardargraficas
            app.button_Guardargraficas = uibutton(app.layout_sim_results, 'push');
            app.button_Guardargraficas.ButtonPushedFcn = createCallbackFcn(app, @button_GuardargraficasPushed, true);
            app.button_Guardargraficas.FontSize = 18;
            app.button_Guardargraficas.Layout.Row = 4;
            app.button_Guardargraficas.Layout.Column = 3;
            app.button_Guardargraficas.Text = 'Guardar graficas';
            app.button_Guardargraficas.Enable = "off";

            % Create layout_tvis
            app.layout_tvis = uigridlayout(app.layout_sim_results);
            app.layout_tvis.ColumnWidth = {'3x','4x'};
            app.layout_tvis.RowHeight = {40,20};
            app.layout_tvis.ColumnSpacing = 0;
            app.layout_tvis.RowSpacing = 0;
            app.layout_tvis.Padding = [0 0 5 0];
            app.layout_tvis.Layout.Row = 4;
            app.layout_tvis.Layout.Column = 2;

            % Create layout_tviseditFields
            app.layout_tviseditFields = uigridlayout(app.layout_tvis);
            app.layout_tviseditFields.ColumnWidth = {'1x','1x'};
            app.layout_tviseditFields.RowHeight = {'1x'};
            app.layout_tviseditFields.ColumnSpacing = 2;
            app.layout_tviseditFields.RowSpacing = 0;
            app.layout_tviseditFields.Padding = [2 2 2 2];
            app.layout_tviseditFields.Layout.Row = 2;
            app.layout_tviseditFields.Layout.Column = 2;

            % Create tvisLabel
            app.tvisLabel = uilabel(app.layout_tvis);
            app.tvisLabel.Layout.Row = 1;
            app.tvisLabel.Layout.Column = 1;
            app.tvisLabel.Text = 'Intervalo personalizado. ';

            % Create slider_tvis
            app.slider_tvis = uislider(app.layout_tvis,"range");
            app.slider_tvis.ValueChangedFcn = createCallbackFcn(app, @slider_tvisValueChanged, true);
            app.slider_tvis.Layout.Row = 1;
            app.slider_tvis.Layout.Column = 2;
            app.slider_tvis.Limits = [0 15];
            app.slider_tvis.Enable = "off";

            % Create editField_tvismin
            app.editField_tvismin = uieditfield(app.layout_tviseditFields, 'numeric');
            app.editField_tvismin.ValueChangedFcn = createCallbackFcn(app, @editField_tvisminValueChanged, true);
            app.editField_tvismin.Layout.Row = 1;
            app.editField_tvismin.Layout.Column = 1;
            app.editField_tvismin.Value = 0;
            app.editField_tvismin.RoundFractionalValues = "off";
            app.editField_tvismin.Enable = "off";
            
            % Create editField_tvismax
            app.editField_tvismax = uieditfield(app.layout_tviseditFields, 'numeric');
            app.editField_tvismax.ValueChangedFcn = createCallbackFcn(app, @editField_tvismaxValueChanged, true);
            app.editField_tvismax.Layout.Row = 1;
            app.editField_tvismax.Layout.Column = 2;
            app.editField_tvismax.Value = 15;
            app.editField_tvismax.RoundFractionalValues = "off";
            app.editField_tvismax.Enable = "off";

            % Show the figure after all components are created
            app.figure_main.Visible = 'on';

            app.editFieldArr_nomparams_Inputdata = [app.editField_nom01_Pnom,...
                app.editField_nom02_VSrmsnom,app.editField_nom05_wRnom];

            app.editFieldArr_elecparams_Inputdata  = [app.editField_el01_np,...
                app.editField_el02_RS,app.editField_el03_RR,...
                app.editField_el04_LS,app.editField_el05_LR,...
                app.editField_el06_M];

            app.editFieldArr_mechparams_Inputdata = [app.editField_me01_J,...
                app.editField_me02_b];

            app.editFieldArr_MIparams_Inputdata = ...
                [app.editFieldArr_nomparams_Inputdata,...
                app.editFieldArr_elecparams_Inputdata,...
                app.editFieldArr_mechparams_Inputdata];

            app.editFieldArr_MIparams_Calculateddata = ...
                [app.editField_nom03_ISrmsnom,app.editField_nom04_psiRmagnom,...
                 app.editField_el07_sigma,app.editField_el08_gamma];

            app.editFieldArr_SIMparams_Inputdata = [app.editField_sim01_tsim,...
                                                    app.editField_sim02_tstep];

            app.figaxesArr = ...
                [app.axes_voltaje1,app.axes_voltaje2,app.axes_voltaje3,...
                app.axes_corriente1,app.axes_corriente2,app.axes_corriente3,...
                app.axes_torque,app.axes_velocidad,app.axes_potencia];
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = MI_model_simUI

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.figure_main)
            
            restoredefaultpath
            addpath Model
            addpath ..\..\Utility_codes\
            
            if nargout == 0
                clear app
            end

        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.figure_main)
        end
    end
end