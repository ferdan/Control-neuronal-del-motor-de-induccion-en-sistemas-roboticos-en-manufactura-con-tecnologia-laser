classdef MI_Control_torque_simUI < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        figure_main                 matlab.ui.Figure

        %% Main layouts
        layout_main                 matlab.ui.container.GridLayout

        layout_param_main           matlab.ui.container.GridLayout
        panel_MI_params             matlab.ui.container.Panel
        
        layout_MI_params            matlab.ui.container.GridLayout
        layout_MI_data              matlab.ui.container.GridLayout

        layout_Contr_tauRef_main        matlab.ui.container.GridLayout
        
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

        button_LimpiarparamsMI      matlab.ui.control.Button
        button_GuardarparamsMI      matlab.ui.control.Button

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

        %% Parámetros del controlador
        panel_Controller_params         matlab.ui.container.Panel
        layout_Controller_params        matlab.ui.container.GridLayout

        layout_Contr_cargar_params      matlab.ui.container.GridLayout
        label_Contr_archivo             matlab.ui.control.Label
        button_Contr_archivo            matlab.ui.control.Button

        layout_Contr_guardar_params     matlab.ui.container.GridLayout
        button_LimpiarparamsContr       matlab.ui.control.Button
        button_GuardarparamsContr       matlab.ui.control.Button


        tabGroupController              matlab.ui.container.TabGroup

        % Controlador IFOC
        tab_IFOCICAD                    matlab.ui.container.Tab
        layout_IFOCdata                 matlab.ui.container.GridLayout

        layout_IFOC_psiRmagref          matlab.ui.container.GridLayout

        editField_IOFC_psiRmagref       matlab.ui.control.NumericEditField
        psi_RrefIFOCLabel               matlab.ui.control.Label
        label_IFOC_psiRmagref           matlab.ui.control.Label

        panel_IFOC_Integratordata       matlab.ui.container.Panel
        layout_Integratordata           matlab.ui.container.GridLayout

        label_IFOC_IntGanancia          matlab.ui.control.Label
        editField_IFOC_IntGanancia      matlab.ui.control.NumericEditField

        label_IFOC_IntCero              matlab.ui.control.Label
        editField_IFOC_IntCero          matlab.ui.control.NumericEditField

        panel_IFOC_Compensatordata      matlab.ui.container.Panel
        layout_IFOC_Compensatordata     matlab.ui.container.GridLayout

        label_IFOC_CompInstrucciones    matlab.ui.control.Label

        label_IFOC_CompPolos            matlab.ui.control.Label
        editField_IFOC_CompCeros        matlab.ui.control.EditField

        label_IFOC_CompCeros            matlab.ui.control.Label
        editFIeld_IFOC_CompPolos        matlab.ui.control.EditField

        % Controlador PBC
        tab_PBC                         matlab.ui.container.Tab
        layout_PBCdata                  matlab.ui.container.GridLayout

        label_PBC_psiRmagref            matlab.ui.control.Label
        editField_PBC_psiRmagref        matlab.ui.control.NumericEditField
        psi_RrefPBCLabel                matlab.ui.control.Label

        label_PBC_KiS                   matlab.ui.control.Label
        editField_PBC_KiS               matlab.ui.control.NumericEditField
        K_iSLabel                       matlab.ui.control.Label

        %% Señal de torque de referencia
        panel_tau_Rref_params           matlab.ui.container.Panel
        layout_tauRref_params           matlab.ui.container.GridLayout

        layout_tauRref_cargar_params    matlab.ui.container.GridLayout
        label_tauRref_cargar_params     matlab.ui.control.Label
        button_tauRref_cargar_params    matlab.ui.control.Button

        layout_tauRref_guardar_params   matlab.ui.container.GridLayout
        button_LimpiarparamstauRref     matlab.ui.control.Button
        button_GuardarparamstauRref     matlab.ui.control.Button

        tabGroup_tauRref_perfiles       matlab.ui.container.TabGroup

        % Referencia cero
        tab_tauRref_cero                matlab.ui.container.Tab
        layout_tauRref_cero             matlab.ui.container.GridLayout
        label_cero                      matlab.ui.control.Label

        % Referencia escalon
        tab_tauRref_escalon             matlab.ui.container.Tab
        layout_tauRref_escalon          matlab.ui.container.GridLayout

        label_tauRref_escalon_descripcion  matlab.ui.control.Label

        label_tauRref_escalon_valref    matlab.ui.control.Label
        editField_tauRref_escalon_valref  matlab.ui.control.NumericEditField

        label_tauRref_escalon_tinit     matlab.ui.control.Label
        editField_tauRref_escalon_tinit  matlab.ui.control.NumericEditField

        label_tauRref_escalon_tfin      matlab.ui.control.Label
        editField_tauRref_escalon_tfin  matlab.ui.control.NumericEditField

        % Referencia rampa
        tab_tauRref_rampa               matlab.ui.container.Tab
        layout_tauRref_rampa            matlab.ui.container.GridLayout

        label_tauRref_rampa_descripcion  matlab.ui.control.Label

        label_tauRref_rampa_valref      matlab.ui.control.Label
        editField_tauRref_rampa_valref  matlab.ui.control.NumericEditField

        label_tauRref_rampa_tinit       matlab.ui.control.Label
        editField_tauRref_rampa_tinit   matlab.ui.control.NumericEditField

        label_tauRref_rampa_tfin        matlab.ui.control.Label
        editField_tauRref_rampa_tfin    matlab.ui.control.NumericEditField

        % Referencia senoidal
        tab_tauRref_senoidal            matlab.ui.container.Tab
        layout_tauRref_senoidal         matlab.ui.container.GridLayout

        label_tauRref_senoidal_descripcion  matlab.ui.control.Label

        label_tauRref_senoidal_valref   matlab.ui.control.Label
        editField_tauRref_senoidal_valref  matlab.ui.control.NumericEditField

        label_tauRref_senoidal_frecuencia  matlab.ui.control.Label
        editField_tauRref_senoidal_frecuencia  matlab.ui.control.NumericEditField

        label_tauRref_senoidal_tinit    matlab.ui.control.Label
        editFIeld_tauRref_senoidal_tinit  matlab.ui.control.NumericEditField

        % Referencia polinomio7
        tab_tauRref_pol7                matlab.ui.container.Tab
        layout_tauRref_pol7             matlab.ui.container.GridLayout

        label_tauRref_pol7_descripcion  matlab.ui.control.Label

        label_tauRref_pol7_valref       matlab.ui.control.Label
        editField_tauRref_pol7_valref   matlab.ui.control.NumericEditField

        label_tauRref_pol7_tinit        matlab.ui.control.Label
        editField_tauRref_pol7_tinit    matlab.ui.control.NumericEditField

        label_tauRref_pol7_tfin         matlab.ui.control.Label
        editField_tauRref_pol7_tfin     matlab.ui.control.NumericEditField

        % Referencia tren de escalones
        tab_tauRref_escalones           matlab.ui.container.Tab
        layout_tauRref_escalones        matlab.ui.container.GridLayout

        label_tauRref_escalones_descripcion  matlab.ui.control.Label

        label_tauRref_escalones_valref  matlab.ui.control.Label
        editField_tauRref_escalones_valref  matlab.ui.control.NumericEditField
        
        label_tauRref_escalones_tescalon  matlab.ui.control.Label
        editField_tauRref_escalones_tescalon  matlab.ui.control.NumericEditField

        % Referencia timeseries
        tab_tauRref_timeseries          matlab.ui.container.Tab
        layout_tauRref_timeseries       matlab.ui.container.GridLayout

        label_tauRref_timeseries_descripcion  matlab.ui.control.Label

        label_tauRref_timeseries_senal  matlab.ui.control.Label
        spinner_tauRref_timeseries_senal matlab.ui.control.Spinner

        label_tauRref_timeseries_comentarios  matlab.ui.control.Label
        
        button_tau_Rref_timeseries_preview matlab.ui.control.Button

        %% Resultados de simulacion
        panel_Sim_Resultados            matlab.ui.container.Panel
        layout_Sim_Resultados           matlab.ui.container.GridLayout

        axes_velocidad                  matlab.ui.control.UIAxes
        axes_etorque                    matlab.ui.control.UIAxes
        axes_torque                     matlab.ui.control.UIAxes
        axes_potencia                   matlab.ui.control.UIAxes

        layout_axes_voltajecorriente    matlab.ui.container.GridLayout
        button_sim_voltaje              matlab.ui.control.Button
        button_sim_corriente            matlab.ui.control.Button

        button_Guardargraficas      matlab.ui.control.Button
        label_sim_comentarios           matlab.ui.control.Label

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

        str_IFOCparams_Inputdata = ["psi_Rref","intganancia","intcero",...
                                    "comppolos","compceros"];

        str_PBCparams_Inputdata = ["psi_Rref","KiS"];

        str_tauResca_Inputdata = ["valref","tinit","tfin"];
        str_tauRramp_Inputdata = ["valref","tinit","tfin"];
        str_tauRsen_Inputdata = ["valref","frec","tinit"];
        str_tauRpol7_Inputdata = ["valref","tinit","tfin"];
        str_tauRtresca_Inputdata = ["valref","tesca"];

        str_SIMparams_Inputdata = ["tsim","tstep"];
        MI_motor
        SIM_motor

        MI_Contr
        tau_Rref
        tau_L

        tau_preview

        datos_Graficas

        editFieldArr_MIparams_Inputdata
        editFieldArr_nomparams_Inputdata
        editFieldArr_elecparams_Inputdata
        editFieldArr_mechparams_Inputdata

        editFieldArr_MIparams_Calculateddata

        editFieldArr_SIMparams_Inputdata

        tabArr_Contr
        editFieldArr_IFOCparams_Inputdata
        editFieldArr_PBCparams_Inputdata

        editFieldArr_tauRrefparams_escalon_Inputdata
        editFieldArr_tauRrefparams_rampa_Inputdata
        editFieldArr_tauRrefparams_senoidal_Inputdata
        editFieldArr_tauRrefparams_pol7_Inputdata
        editFieldArr_tauRrefparams_trenescalones_Inputdata
        tabArr_tauRref

        figaxesArr
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: button_MI_archivo
        function button_MI_archivoButtonPushed(app, event)

            [filename_MI,str_MI] = verificar_CargaArchivo(app,"*.txt","\MI_motors");
            if size(str_MI,2) == 0
                return
            end
            
            [data,datacheck] = str2num(str_MI);
            valArchivo = verificar_FormatoArchivo(app,data,datacheck,...
                app.str_MIparams_Inputdata,app.label_MI_archivo);

            if valArchivo == false
                return
            end

            [Pnomval,v_Srmsnomval,w_Rnomval,n_p,R_Sval,R_Rval,...
                  L_Sval,L_Rval,Mval,Jval,bval] = AsignarDatosMI(app,data);

            [i_Srmsnomval,psi_Rmagnomval,tau_Rnomval]= ...
                CalcularDatosMI(app,Pnomval,v_Srmsnomval,w_Rnomval,Mval);

            app.MI_motor = MI_model(Pnomval,v_Srmsnomval,i_Srmsnomval,...
                                psi_Rmagnomval,w_Rnomval,tau_Rnomval,...
                                n_p,R_Sval,R_Rval,L_Sval,L_Rval,Mval,Jval,bval);

            for i = 1:size(app.editFieldArr_MIparams_Inputdata,2)
                app.editFieldArr_MIparams_Inputdata(i).Value = data(i);
            end

            app.editField_nom03_ISrmsnom.Value = i_Srmsnomval;
            app.editField_nom04_psiRmagnom.Value = psi_Rmagnomval;
            app.editField_nom06_tauRnom.Value = tau_Rnomval;

            app.editField_el07_sigma.Value = app.MI_motor.electric_params.sigma;
            app.editField_el08_gamma.Value = app.MI_motor.electric_params.gamma;

            app.button_GuardarparamsMI.Enable = "off";
            app.button_Guardargraficas.Enable = "off";
            app.button_LimpiarparamsMI.Enable = "on";
            app.label_MI_archivo.Text = filename_MI;
        end

        function button_Contr_archivoButtonPushed(app, event)
            [filename_Contr,str_Contr] = verificar_CargaArchivo(app,"*.txt","\Contr_params");
            if size(str_Contr,2) == 0
                return
            end
            dataContr = split(str_Contr,",");
            
            switch dataContr(1) 
                case "IFOC"
                    
                    %dataContr = 0;
                    data = 0;
                    datacheck = true;
                    % disp("size(dataContr(2:size(dataContr,1)),1): "+string(size(dataContr(2:size(dataContr,1)),1)))
                    % disp("size(app.str_IFOCparams_Inputdata,2): "+string(size(app.str_IFOCparams_Inputdata,2)))
                    % disp("size(dataContr(2:size(dataContr,2)),2) == size(app.str_IFOCparams_Inputdata,2): "+string(size(dataContr(2:size(dataContr,2)),2) == size(app.str_IFOCparams_Inputdata,2)))
                    if size(dataContr(2:size(dataContr,1)),1) == size(app.str_IFOCparams_Inputdata,2)
                        data = dataContr(2:size(dataContr,1));
                        [~,datacheck] = str2num(char(data(1:3)));
                        datacheckContr = true;
                        for i = 4:5
                            %disp("dataContr(i): "+data(i))
                            [~,datacheckContr] = str2num(data(i));
                        end
                        datacheck = datacheck && datacheckContr;
                    else
                        datacheck = false;
                    end

                    %disp("dataContr(2:size(dataContr,1)): "+string(dataContr(2:size(dataContr,1))))

                    valArchivo = verificar_FormatoArchivo(app,data',datacheck,...
                        app.str_IFOCparams_Inputdata,app.label_Contr_archivo);
        
                    if valArchivo == false
                        return
                    end

                    [psi_Rmagref,intGanancia,intCero,...
                          compPolos,compCeros] = AsignarDatosIFOC(app,data);
        
                    app.MI_Contr = IFOC_Torque_Controller(psi_Rmagref,...
                                       intGanancia,intCero,compPolos,compCeros);
    
                    for i = 1:size(app.editFieldArr_IFOCparams_Inputdata,2)
                        if i<4
                            app.editFieldArr_IFOCparams_Inputdata(i).Value = data(i).double;
                        else
                            datas = str2num(data(i));
                            str_datas = "";
                            for j = 1:size(datas,2)
                                str_datas = str_datas + string(datas(j));
                                if j < size(datas,2)
                                    str_datas = str_datas + ",";
                                end
                            end
                            app.editFieldArr_IFOCparams_Inputdata(i).Value = str_datas;
                        end
                    end
                    app.tabGroupController.SelectedTab = app.tab_IFOCICAD;
                    app.button_GuardarparamsContr.Enable = "off";
                    app.button_Guardargraficas.Enable = "off";
                    app.button_LimpiarparamsContr.Enable = "on";
                    app.label_Contr_archivo.Text = filename_Contr;
    
                case "PBC"
                    %dataContr
                    [data,datacheck] = str2num(char(dataContr(2:size(dataContr,1))));
                    valArchivo = verificar_FormatoArchivo(app,data',datacheck,...
                        app.str_PBCparams_Inputdata,app.label_Contr_archivo);
        
                    if valArchivo == false
                        return
                    end
    
                    [psi_Rmagref,K_iS] = AsignarDatosPBC(app,data);
        
                    app.MI_Contr = PBC_Torque_Controller(K_iS,psi_Rmagref);
        
                    for i = 1:size(app.editFieldArr_PBCparams_Inputdata,2)
                        app.editFieldArr_PBCparams_Inputdata(i).Value = data(i);
                    end
        
                    app.tabGroupController.SelectedTab = app.tab_PBC;
                    app.button_GuardarparamsContr.Enable = "off";
                    app.button_Guardargraficas.Enable = "off";
                    app.button_LimpiarparamsContr.Enable = "on";
                    app.label_Contr_archivo.Text = filename_Contr;
                    
                otherwise
                    disp("Error en archivo de carga de controlador")
            end
        end

        function button_tauRref_cargar_paramsButtonPushed(app, event)
            [filename_tauRref,str_tauRref] = verificar_CargaArchivo(app,{"*.txt";"*.mat"},"\TorqueRef_params");
            if size(str_tauRref,2) == 0
                return
            end

            str_file = split(filename_tauRref,".");
            if str_file(end) ~= "mat"
                datatauRref = split(str_tauRref,",");
            else
                datatauRref(1) = "ts";
                str_tauRref = "";
            end

            switch datatauRref(1)
                case "Cero"
                    %disp("Lectura de Constante cero")
                    return
                case "Esca"
                    %disp("Lectura de Escalon")
                    [data,datacheck] = str2num(char(datatauRref(2:size(datatauRref,1))));

                    valArchivo = verificar_FormatoArchivo(app,data',datacheck,...
                        app.str_tauResca_Inputdata,app.label_tauRref_cargar_params);
        
                    if valArchivo == false
                        return
                    end

                    for i = 1:size(app.editFieldArr_tauRrefparams_escalon_Inputdata,2)
                        app.editFieldArr_tauRrefparams_escalon_Inputdata(i).Value = data(i);
                    end
                    app.tabGroup_tauRref_perfiles.SelectedTab = app.tab_tauRref_escalon;
                    app.button_GuardarparamstauRref.Enable = "off";
                    app.button_Guardargraficas.Enable = "off";
                    app.button_LimpiarparamstauRref.Enable = "on";
                    app.label_tauRref_cargar_params.Text = filename_tauRref;

                case "Ramp"
                    %disp("Lectura de Rampa")
                    [data,datacheck] = str2num(char(datatauRref(2:size(datatauRref,1))));

                    valArchivo = verificar_FormatoArchivo(app,data',datacheck,...
                        app.str_tauRramp_Inputdata,app.label_tauRref_cargar_params);
        
                    if valArchivo == false
                        return
                    end

                    for i = 1:size(app.editFieldArr_tauRrefparams_rampa_Inputdata,2)
                        app.editFieldArr_tauRrefparams_rampa_Inputdata(i).Value = data(i);
                    end
                    app.tabGroup_tauRref_perfiles.SelectedTab = app.tab_tauRref_rampa;
                    app.button_GuardarparamstauRref.Enable = "off";
                    app.button_Guardargraficas.Enable = "off";
                    app.button_LimpiarparamstauRref.Enable = "on";
                    app.label_tauRref_cargar_params.Text = filename_tauRref;
                case "Sen"
                    %disp("Lectura de Senoidal")
                    [data,datacheck] = str2num(char(datatauRref(2:size(datatauRref,1))));

                    valArchivo = verificar_FormatoArchivo(app,data',datacheck,...
                        app.str_tauRsen_Inputdata,app.label_tauRref_cargar_params);
        
                    if valArchivo == false
                        return
                    end

                    for i = 1:size(app.editFieldArr_tauRrefparams_senoidal_Inputdata,2)
                        app.editFieldArr_tauRrefparams_senoidal_Inputdata(i).Value = data(i);
                    end
                    app.tabGroup_tauRref_perfiles.SelectedTab = app.tab_tauRref_senoidal;
                    app.button_GuardarparamstauRref.Enable = "off";
                    app.button_Guardargraficas.Enable = "off";
                    app.button_LimpiarparamstauRref.Enable = "on";
                    app.label_tauRref_cargar_params.Text = filename_tauRref;
                case "Pol7"
                    %disp("Lectura de Polinomio 7mo orden")
                    [data,datacheck] = str2num(char(datatauRref(2:size(datatauRref,1))));

                    valArchivo = verificar_FormatoArchivo(app,data',datacheck,...
                        app.str_tauRpol7_Inputdata,app.label_tauRref_cargar_params);
        
                    if valArchivo == false
                        return
                    end

                    for i = 1:size(app.editFieldArr_tauRrefparams_pol7_Inputdata,2)
                        app.editFieldArr_tauRrefparams_pol7_Inputdata(i).Value = data(i);
                    end
                    app.tabGroup_tauRref_perfiles.SelectedTab = app.tab_tauRref_pol7;
                    app.button_GuardarparamstauRref.Enable = "off";
                    app.button_Guardargraficas.Enable = "off";
                    app.button_LimpiarparamstauRref.Enable = "on";
                    app.label_tauRref_cargar_params.Text = filename_tauRref;
                case "Tren de escalones"
                    %disp("Lectura de Tren de escalones")
                    [data,datacheck] = str2num(char(datatauRref(2:size(datatauRref,1))));

                    valArchivo = verificar_FormatoArchivo(app,data',datacheck,...
                        app.str_tauRtresca_Inputdata,app.label_tauRref_cargar_params);
        
                    if valArchivo == false
                        return
                    end

                    for i = 1:size(app.editFieldArr_tauRrefparams_trenescalones_Inputdata,2)
                        app.editFieldArr_tauRrefparams_trenescalones_Inputdata(i).Value = data(i);
                    end
                    app.tabGroup_tauRref_perfiles.SelectedTab = app.tab_tauRref_escalones;
                    app.button_GuardarparamstauRref.Enable = "off";
                    app.button_Guardargraficas.Enable = "off";
                    app.button_LimpiarparamstauRref.Enable = "on";
                    app.label_tauRref_cargar_params.Text = filename_tauRref;
                case "ts"
                    %disp("Lectura de timeseries")

                    data_tauRref = load(filename_tauRref);
                    data_tauRref_cell = struct2cell(data_tauRref);
                    if ~isa(data_tauRref_cell{1},'double')
                        app.label_tauRref_cargar_params.Text = "El archivo no contiene datos válidos";
                        uialert(app.figure_main,"El archivo (.mat) no es correcto","Warning","Icon","warning","Modal",true);
                        return
                    end
                    app.tau_preview = Perfil_trayectoria("tau_preview",15,0.0001,7,filename_tauRref);
                    
                    app.spinner_tauRref_timeseries_senal.Enable = "on";
                    app.spinner_tauRref_timeseries_senal.Limits = [1 size(data_tauRref_cell{1},2)];
                    
                    app.tabGroup_tauRref_perfiles.SelectedTab = app.tab_tauRref_timeseries;
                    app.button_tau_Rref_timeseries_preview.Enable = "on";
                    app.button_GuardarparamstauRref.Enable = "off";
                    app.button_Guardargraficas.Enable = "off";
                    app.button_LimpiarparamstauRref.Enable = "on";
                    app.label_tauRref_cargar_params.Text = filename_tauRref;
                    return
                otherwise
                    disp("Error en archivo de carga de tauRref")
            end
            app.button_Guardargraficas.Enable = "off";
        end

        function [filename,str] = verificar_CargaArchivo(app,str_file_ext,str_dir)
            if ~exist(pwd+str_dir, 'dir')
               mkdir(pwd+str_dir)
            end
            fdummy = figure('Position', [-100 -100 0 0],'CloseRequestFcn','');
            [filename,path] = uigetfile(str_file_ext,"Seleccionar archivo",pwd+str_dir);
            delete(fdummy);

            if filename == 0
                str = strings(0);
                return
            end
            
            try
                file = fopen(strcat(path,filename),'r');
                %str = fscanf(file,'%s');
                str = textscan(file,"%s",'Whitespace',"");
                str = string(str);
                fclose(file);
            catch
                app.label_MI_archivo.Text = "Error al cargar el archivo";
                str = strings(0);
            end
        end

        function valfile = verificar_FormatoArchivo(app,data,datacheck,str_Inputpdata,label)
            if ~datacheck
                label.Text = "El archivo no contiene el formato requerido";
                valfile = false;
                return
            end

            if size(data,2) ~= size(str_Inputpdata,2)
                label.Text = "El archivo no contiene el número requerido de datos";
                valfile = false;
                return
            end
            valfile = true;
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
                delete(fdummy)
                
                file = fopen(strcat(path,filename),'w');
                if file >= 3
                    fprintf(file,str_data_MI);
                    fclose(file);
                end
            end
        end

        function button_GuardarparamsContrPushed(app,event)
            [dataContr,str_err] = LeerDatosContr(app,strings(0));
            
            str_Contr = "";
            str_Controlador = "";

            if size(str_err,2) == 0
                switch app.tabGroupController.SelectedTab
                    case app.tabArr_Contr(1)
                        str_Contr = str_Contr + "IFOC,";
                        str_Controlador = "IFOC";
                    case app.tabArr_Contr(2)
                        str_Contr = str_Contr + "PBC,";
                        str_Controlador = "PBC";
                    otherwise
                        disp("Error al guardar parámetros de controlador");
                end

                for i = 1:size(dataContr,2)
                    if app.tabGroupController.SelectedTab == app.tabArr_Contr(1) && i >= 4
                        str_ContrIFOC = split(string(dataContr(i)),",");
                        str_Contr = str_Contr + "[";
                        for j = 1:size(str_ContrIFOC,1)
                            str_Contr = str_Contr + string(str_ContrIFOC(j));
                            if j < size(str_ContrIFOC,1)
                                str_Contr = str_Contr + " ";
                            end
                        end
                        str_Contr = str_Contr + "]";
                    else
                        str_Contr = str_Contr + string(dataContr(i));
                    end
                    if i < size(dataContr,2)
                        str_Contr = str_Contr + ",";
                    end
                end

                if ~exist(pwd+"\Contr_params", 'dir')
                   mkdir(pwd+"\Contr_params")
                end
    
                
                filename = pwd+"\Contr_params\MI_" + string(...
                    round(app.MI_motor.Pnom/745.7,2)) +"hp_"+str_Controlador+"_params.txt";

                fdummy = figure('Position', [-100 -100 0 0],'CloseRequestFcn','');
                [filename,path] = uiputfile(filename);
                delete(fdummy)
                
                file = fopen(strcat(path,filename),'w');
                if file >= 3
                    fprintf(file,str_Contr);
                    fclose(file);
                end
            end
        end

        function button_GuardarparamstauRrefPushed(app,event)
            [datatauRref,str_err] = LeerDatostauRref(app,strings(0));
            str_tauR = "";
            if size(str_err,2) == 0
                switch app.tabGroup_tauRref_perfiles.SelectedTab
                    case app.tabArr_tauRref(1)
                        disp("Nada que guardar")
                        return
                    case app.tabArr_tauRref(2)
                        str_tauR = "Esca";
                    case app.tabArr_tauRref(3)
                        str_tauR = "Ramp";
                    case app.tabArr_tauRref(4)
                        str_tauR = "Sen";
                    case app.tabArr_tauRref(5)
                        str_tauR = "Pol7";
                    case app.tabArr_tauRref(6)
                        str_tauR = "TrEsca";
                    case app.tabArr_tauRref(7)
                        disp("Nada que guardar")
                        return
                    otherwise
                        disp("Error al guardar parámetros de tauRref")
                end
                str_tauRref = str_tauR + ",";
                for i = 1:size(datatauRref,2)
                    str_tauRref = str_tauRref + string(datatauRref(i));
                    if i < size(datatauRref,2)
                        str_tauRref = str_tauRref + ",";
                    end
                end

                if ~exist(pwd+"\TorqueRef_params", 'dir')
                   mkdir(pwd+"\TorqueRef_params")
                end
                
                filename = pwd+"\TorqueRef_params\MI_" + string(...
                    round(app.MI_motor.Pnom/745.7,2)) + "hp_" + str_tauR + "_"...
                  + string(round(app.tau_L.valor_referencia,2))+"_params.txt";

                fdummy = figure('Position', [-100 -100 0 0],'CloseRequestFcn','');
                [filename,path] = uiputfile(filename);
                delete(fdummy);
                
                file = fopen(strcat(path,filename),'w');
                if file >= 3
                    fprintf(file,str_tauRref);
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
            app.button_sim_voltaje.Enable = "off";
            app.button_sim_corriente.Enable = "off";

            app.label_MI_archivo.Text = 'Ningún archivo seleccionado';
        end

        function button_LimpiarparamsContrPushed(app,event)
            for i = 1:size(app.editFieldArr_IFOCparams_Inputdata,2)
                if i < 4
                    app.editFieldArr_IFOCparams_Inputdata(i).Value = 0;
                else
                    app.editFieldArr_IFOCparams_Inputdata(i).Value = "";
                end
            end

            for i = 1:size(app.editFieldArr_PBCparams_Inputdata,2)
                app.editFieldArr_PBCparams_Inputdata(i).Value = 0;
            end

            app.button_GuardarparamsContr.Enable = "off";
            app.button_LimpiarparamsContr.Enable = "off";
            app.label_Contr_archivo.Text = 'Ningún archivo seleccionado';
        end

        function button_LimpiarparamstauRrefPushed(app,event)
            for i = 1:size(app.editFieldArr_tauRrefparams_escalon_Inputdata,2)
                app.editFieldArr_tauRrefparams_escalon_Inputdata(i).Value = 0;
            end
            for i = 1:size(app.editFieldArr_tauRrefparams_rampa_Inputdata,2)
                app.editFieldArr_tauRrefparams_rampa_Inputdata(i).Value = 0;
            end
            for i = 1:size(app.editFieldArr_tauRrefparams_senoidal_Inputdata,2)
                app.editFieldArr_tauRrefparams_senoidal_Inputdata(i).Value = 0;
            end
            for i = 1:size(app.editFieldArr_tauRrefparams_pol7_Inputdata,2)
                app.editFieldArr_tauRrefparams_pol7_Inputdata(i).Value = 0;
            end
            for i = 1:size(app.editFieldArr_tauRrefparams_trenescalones_Inputdata,2)
                app.editFieldArr_tauRrefparams_trenescalones_Inputdata(i).Value = 0;
            end
            
            app.button_GuardarparamstauRref.Enable = "off";
            app.button_LimpiarparamstauRref.Enable = "off";
            app.label_tauRref_cargar_params.Text = 'Ningún archivo seleccionado';

        end

        % Button pushed function: button_Simular
        function button_SimularButtonPushed(app,event)

            dataMI = LeerDatosIngresados(app,app.editFieldArr_MIparams_Inputdata);
            str_err = ValidarDatos(app,dataMI,app.str_MIparams_Inputdata);

            dataSIM = LeerDatosIngresados(app,app.editFieldArr_SIMparams_Inputdata);
            str_err = [str_err,ValidarDatos(app,dataSIM,app.str_SIMparams_Inputdata)];

            [dataContr,str_err] = LeerDatosContr(app,str_err);
            [datatauRref,str_err] = LeerDatostauRref(app,str_err);

            if size(str_err,2) == 0

                createMIdata(app,dataMI)
                %[tsim,tstep] = AsignarDatosSIM(app,dataSIM);
                app.SIM_motor = SIM_model(dataSIM(1),dataSIM(2));
                createContrObj(app,dataContr);
                createtauRrefObj(app,datatauRref)

                if app.tau_L.sel_perfil == 7
                    tr_sel = app.spinner_tauRref_timeseries_senal.Value;
                    tau_L_ts = app.tau_L.set_perfil_ts(app.SIM_motor.tsim,...
                                                       app.SIM_motor.tstep,tr_sel);
                    tau_Rref_ts = tau_L_ts;
                end

                % app.tau_L = Perfil_trayectoria("Perfil torque de carga tau_L",tsim,tstep,5,app.MI_motor.tau_Rnom*0.85); 
                % app.tau_Rref = app.tau_L;
                % app.tau_Rref.nombre = "Perfil torque de referencia tau_Rref";


                evalin('base', 'clear all')

                MI_bus_info = Simulink.Bus.createObject(app.MI_motor.struct);
                app.SIM_motor.MI_bus = evalin('base', MI_bus_info.busName);

                Perfil_bus_info = Simulink.Bus.createObject(app.tau_L.perfiles);
                app.SIM_motor.Perfil_bus = evalin('base', Perfil_bus_info.busName);


                assignin('base','tsim',app.SIM_motor.tsim)
                assignin('base','tstep',app.SIM_motor.tstep)

                assignin('base','MI_bus',app.SIM_motor.MI_bus)
                assignin('base','Perfil_bus',app.SIM_motor.Perfil_bus)

                assignin('base','MI_motor',app.MI_motor)
                assignin('base','MI_Contr',app.MI_Contr)
                assignin('base','tau_Rref',app.tau_Rref)
                assignin('base','tau_L',app.tau_L)

                if app.tau_L.sel_perfil == 7
                    assignin('base','tau_L_ts',tau_L_ts)
                    assignin('base','tau_Rref_ts',tau_Rref_ts)
                end
                
                [simname,str_context] = setContrSimulink(app);
    
                handler_SimulinkBlockParams.setPerfilTrayectoria(simname,"",app.tau_L);
                handler_SimulinkBlockParams.setPerfilTrayectoria(simname,str_context,app.tau_Rref);
    
                try
                    app.label_sim_comentarios.Text = "Simulación en ejecución";
                    app.SIM_motor.out = sim(simname);
                catch ME
                    app.label_sim_comentarios.Text = "Error en simulación";
                    disp(ME.message)
                    return
                end

                app.label_sim_comentarios.Text = "Simulación completada";
                
                GenerarGraficas(app,0,app.SIM_motor.tsim);

                assignin('base','out',app.SIM_motor.out)
                app.label_sim_comentarios.Text = "Simulacion ejecutada correctamente";

                app.slider_tvis.Enable = "on";
                app.editField_tvismin.Enable = "on";
                app.editField_tvismax.Enable = "on";
                app.button_Guardargraficas.Enable = "on";
                app.button_GuardarparamsContr.Enable = "on";
                if app.tau_L.sel_perfil ~= 7
                    app.button_GuardarparamstauRref.Enable = "on";
                end

                app.button_sim_voltaje.Enable = "on";
                app.button_sim_corriente.Enable = "on";

                app.slider_tvis.Limits = [0 app.SIM_motor.tsim];
                app.slider_tvis.Value = [0 app.SIM_motor.tsim];
                app.editField_tvismin.Value = 0;
                app.editField_tvismax.Value = app.SIM_motor.tsim;

            end
        end

        function [simname,str_context] = setContrSimulink(app)
            switch app.tabGroupController.SelectedTab
                case app.tabArr_Contr(1)

                    simname = 'Torque_controller_IFOC';
                    str_context = "Controlador IFOC";
                    handler_SimulinkBlockParams.setControladorIFOC(simname,...
                        "Controlador IFOC/Controlador Corrientes de Estator",app.MI_Contr)

                case app.tabArr_Contr(2)

                    simname = 'Torque_controller_PBC';
                    str_context = "Controlador PBC";

                    handler_SimulinkBlockParams.setControladorPBC(simname,"Controlador PBC",app.MI_Contr);
        
                    PBC_bus_info = Simulink.Bus.createObject(app.MI_Contr.struct);
                    app.SIM_motor.Contr_bus = evalin('base', PBC_bus_info.busName);
                    assignin('base','PBC_bus',app.SIM_motor.Contr_bus)

                otherwise
                    disp("Error al cargar controlador a la simulacion")
            end
        end

        function [dataContr,str_err] = LeerDatosContr(app,str_err)
            switch app.tabGroupController.SelectedTab
                case app.tabArr_Contr(1)
                    dataContr = LeerDatosIngresados(app,app.editFieldArr_IFOCparams_Inputdata(1:3));
                    str_err = [str_err,ValidarDatos(app,dataContr(1:3),app.str_IFOCparams_Inputdata(1:3))];

                    dataContr = string(dataContr);
                    str_Comperr = strings(0);

                    for i = 4:5
                        dataContr(i) = app.editFieldArr_IFOCparams_Inputdata(i).Value;
                        [~,datacheck] = str2num(dataContr(i));
                        if ~datacheck
                            % disp("app.str_IFOCparams_Inputdata(i): "+string(app.str_IFOCparams_Inputdata(i)));
                            % disp("str_err: "+str_err)
                            % disp("srtcat: "+strcat(str_err,app.str_IFOCparams_Inputdata(i)))
                            str_Comperr = [str_Comperr,app.str_IFOCparams_Inputdata(i)];
                        end
                    end
                    if size(str_Comperr,2) > 0
                        uialert(app.figure_main,["Formato no valido para:" str_Comperr],"Warning","Icon","warning","Modal",true);
                    end
                    %disp("str_Comperr:"+str_Comperr)
                    str_err = [str_err,str_Comperr];

                case app.tabArr_Contr(2)
                    dataContr = LeerDatosIngresados(app,app.editFieldArr_PBCparams_Inputdata);
                    str_err = [str_err,ValidarDatos(app,dataContr,app.str_PBCparams_Inputdata)];
                otherwise
                    disp("Error al leer datos de controlador");
                    dataContr = 0;
            end
        end

        function [datatauRref,str_err] = LeerDatostauRref(app,str_err)
            datatauRref = 0;
            switch app.tabGroup_tauRref_perfiles.SelectedTab
                case app.tabArr_tauRref(1)
                    %disp("Leer datos. Referencia cero");
                    datatauRref = 0;
                case app.tabArr_tauRref(2)
                    %disp("Leer datos. Referencia escalon");
                    datatauRref = LeerDatosIngresados(app,app.editFieldArr_tauRrefparams_escalon_Inputdata);
                    str_err = [str_err,ValidarDatos(app,datatauRref,app.str_tauResca_Inputdata)];
                case app.tabArr_tauRref(3)
                    %disp("Leer datos. Referencia rampa");
                    datatauRref = LeerDatosIngresados(app,app.editFieldArr_tauRrefparams_rampa_Inputdata);
                    str_err = [str_err,ValidarDatos(app,datatauRref,app.str_tauRramp_Inputdata)];
                case app.tabArr_tauRref(4)
                    %disp("Leer datos. Referencia senoidal");
                    datatauRref = LeerDatosIngresados(app,app.editFieldArr_tauRrefparams_senoidal_Inputdata);
                    str_err = [str_err,ValidarDatos(app,datatauRref,app.str_tauRsen_Inputdata)];
                case app.tabArr_tauRref(5)
                    %disp("Leer datos. Referencia polinomio7");
                    datatauRref = LeerDatosIngresados(app,app.editFieldArr_tauRrefparams_pol7_Inputdata);
                    str_err = [str_err,ValidarDatos(app,datatauRref,app.str_tauRpol7_Inputdata)];
                case app.tabArr_tauRref(6)
                    %disp("Leer datos. Referencia tren escalones");
                    datatauRref = LeerDatosIngresados(app,app.editFieldArr_tauRrefparams_trenescalones_Inputdata);
                    str_err = [str_err,ValidarDatos(app,datatauRref,app.str_tauRtresca_Inputdata)];
                case app.tabArr_tauRref(7)
                    %disp("Matlab timeseries.")
                    if ~isa(app.tau_preview,'Perfil_trayectoria')
                        str_err = [str_err,"Torque de referencia (.mat)"];
                        uialert(app.figure_main,["El archivo (.mat) no es correcto:" str_err],"Warning","Icon","warning","Modal",true);
                    end
                otherwise
                    disp("Error al leer datos de torque de referencia")
            end
        end

        function createContrObj(app,dataContr)
            switch app.tabGroupController.SelectedTab
                case app.tabArr_Contr(1)
                    psi_Rmagref = dataContr(1).double;
                    if psi_Rmagref > app.MI_motor.psi_Rmagnom
                        psi_Rmagref = app.MI_motor.psi_Rmagnom;
                        app.editField_IOFC_psiRmagref.Value = psi_Rmagref;
                    end
                    intGain = dataContr(2).double;
                    intZero = dataContr(3).double;
                    compPoles = str2num(dataContr(4));
                    compZeros = str2num(dataContr(5));
                    app.MI_Contr = IFOC_Torque_Controller(psi_Rmagref,...
                        intGain,intZero,compPoles,compZeros);
                case app.tabArr_Contr(2)
                    psi_Rmagref = dataContr(1);
                    if psi_Rmagref > app.MI_motor.psi_Rmagnom
                        psi_Rmagref = app.MI_motor.psi_Rmagnom;
                        app.editField_PBC_psiRmagref.Value = psi_Rmagref;
                    end
                    epsilon_KiS = dataContr(2);
                    if epsilon_KiS > 1
                        epsilon_KiS = 1;
                        app.editField_PBC_KiS.Value = epsilon_KiS;
                    end
                    app.MI_Contr = PBC_Torque_Controller(psi_Rmagref,epsilon_KiS);
                otherwise
                    app.MI_Contr = 0;
                    disp("Error creando objeto controlador")
            end
        end

        function createtauRrefObj(app,datatauRref)
            str_tau_L = "Perfil torque de carga tau_L";
            tsim = app.SIM_motor.tsim;
            tstep = app.SIM_motor.tstep;

            % disp("datatauRref(1): "+string(datatauRref(1)));
            % disp("app.MI_motor.tau_Rnom: "+string(app.MI_motor.tau_Rnom));
            % disp("datatauRref(1) > app.MI_motor.tau_Rnom: "+string(datatauRref(1) > app.MI_motor.tau_Rnom));

            if datatauRref(1) > app.MI_motor.tau_Rnom
                datatauRref(1) = app.MI_motor.tau_Rnom;
                app.editField_tauRref_escalon_valref.Value = app.MI_motor.tau_Rnom;
                app.editField_tauRref_rampa_valref.Value =app.MI_motor.tau_Rnom;
                app.editField_tauRref_senoidal_valref.Value = app.MI_motor.tau_Rnom;
                app.editField_tauRref_pol7_valref.Value = app.MI_motor.tau_Rnom;
                app.editField_tauRref_escalones_valref.Value = app.MI_motor.tau_Rnom;
            end

            switch app.tabGroup_tauRref_perfiles.SelectedTab
                case app.tabArr_tauRref(1)
                    app.tau_L = Perfil_trayectoria(str_tau_L,tsim,tstep,1,0); 
                case app.tabArr_tauRref(2)
                    app.tau_L = Perfil_trayectoria(str_tau_L,tsim,tstep,2,datatauRref(1)); 

                    app.tau_L.perfiles.escalon1.tiempo_inicio = datatauRref(2);
                    if app.tau_L.perfiles.escalon1.tiempo_inicio > app.SIM_motor.tsim
                        app.tau_L.perfiles.escalon1.tiempo_inicio = app.SIM_motor.tsim - 0.001;
                        app.editField_tauRref_escalon_tinit.Value = app.tau_L.perfiles.escalon1.tiempo_inicio;
                    end

                    app.tau_L.perfiles.escalon2.tiempo_inicio = datatauRref(3);
                    if app.tau_L.perfiles.escalon2.tiempo_inicio < app.tau_L.perfiles.escalon1.tiempo_inicio
                        app.tau_L.perfiles.escalon2.tiempo_inicio = app.tau_L.perfiles.escalon1.tiempo_inicio + 0.001;
                        app.editField_tauRref_escalon_tfin.Value = app.tau_L.perfiles.escalon2.tiempo_inicio;
                    end

                case app.tabArr_tauRref(3)
                    app.tau_L = Perfil_trayectoria(str_tau_L,tsim,tstep,3,datatauRref(1)); 

                    app.tau_L.perfiles.rampa.tiempo_inicio = datatauRref(2);
                    if app.tau_L.perfiles.escalon1.tiempo_inicio > app.SIM_motor.tsim
                         app.tau_L.perfiles.rampa.tiempo_inicio = app.SIM_motor.tsim - 0.001;
                         app.editField_tauRref_rampa_tinit.Value = app.tau_L.perfiles.rampa.tiempo_inicio;
                    end

                    app.tau_L.perfiles.rampa.tiempo_fin = datatauRref(3);
                    if app.tau_L.perfiles.rampa.tiempo_fin < app.tau_L.perfiles.rampa.tiempo_inicio
                        app.tau_L.perfiles.rampa.tiempo_fin = app.tau_L.perfiles.rampa.tiempo_inicio + 0.001;
                        app.editField_tauRref_rampa_tfin.Value = app.tau_L.perfiles.rampa.tiempo_fin;
                    end
                case app.tabArr_tauRref(4)
                    app.tau_L = Perfil_trayectoria(str_tau_L,tsim,tstep,4,datatauRref(1)); 
                    app.tau_L.perfiles.senoidal.frecuencia = datatauRref(2);

                    app.tau_L.perfiles.senoidal.tiempo_inicio = datatauRref(3);
                    if app.tau_L.perfiles.senoidal.tiempo_inicio > app.SIM_motor.tsim
                        app.tau_L.perfiles.senoidal.tiempo_inicio = app.SIM_motor.tsim - 0.001;
                        app.editFIeld_tauRref_senoidal_tinit.Value = app.tau_L.perfiles.senoidal.tiempo_inicio;
                    end
                case app.tabArr_tauRref(5)
                    app.tau_L = Perfil_trayectoria(str_tau_L,tsim,tstep,5,datatauRref(1)); 

                    app.tau_L.perfiles.polinomio7.tiempo.inicial  = datatauRref(2);
                    if app.tau_L.perfiles.polinomio7.tiempo.inicial > app.SIM_motor.tsim
                        app.tau_L.perfiles.polinomio7.tiempo.inicial = app.SIM_motor - 0.001;
                        app.editField_tauRref_pol7_tinit.Value = app.tau_L.perfiles.polinomio7.tiempo.inicial;
                    end

                    app.tau_L.perfiles.polinomio7.tiempo.final = datatauRref(3);
                    if app.tau_L.perfiles.polinomio7.tiempo.final < app.tau_L.perfiles.polinomio7.tiempo.inicial
                        app.tau_L.perfiles.polinomio7.tiempo.final = app.tau_L.perfiles.polinomio7.tiempo.inicial + 0.001;
                        app.editField_tauRref_pol7_tfin.Value = app.tau_L.perfiles.polinomio7.tiempo.final;
                    end
                case app.tabArr_tauRref(6)
                    app.tau_L = Perfil_trayectoria(str_tau_L,tsim,tstep,6,datatauRref(1)); 
                    
                    app.tau_L.perfiles.escalones.tiempo_entre_escalones = datatauRref(2);
                    if app.tau_L.perfiles.escalones.tiempo_entre_escalones*6 < app.SIM_motor.tsim
                        app.tau_L.perfiles.escalones.tiempo_entre_escalones = app.SIM_motor.tsim/6;
                        app.editField_tauRref_escalones_tescalon.Value = app.tau_L.perfiles.escalones.tiempo_entre_escalones;
                    end

                case app.tabArr_tauRref(7)
                    app.tau_L = app.tau_preview;
                    app.tau_L.nombre = str_tau_L;
                otherwise
                    disp("Error al cargar tauRref a la simulacion")
            end
            app.tau_Rref = app.tau_L;
            app.tau_Rref.nombre = "Perfil torque de referencia tau_Rref";
        end

        function createMIdata(app,dataMI)
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

        function editField_IOFC_psiRmagrefValueChanged(app,event)
            app.button_LimpiarparamsContr.Enable = "on";
            app.label_Contr_archivo.Text = 'Ningún archivo seleccionado';
        end

        function editField_IFOC_IntGananciaValueChanged(app,event)
            app.button_LimpiarparamsContr.Enable = "on";
            app.label_Contr_archivo.Text = 'Ningún archivo seleccionado';
        end

        function editField_IFOC_IntCeroValueChanged(app,event)
            app.button_LimpiarparamsContr.Enable = "on";
            app.label_Contr_archivo.Text = 'Ningún archivo seleccionado';
        end

        function editField_IFOC_CompPolosValueChanged(app,event)
            app.button_LimpiarparamsContr.Enable = "on";
            app.label_Contr_archivo.Text = 'Ningún archivo seleccionado';
        end

        function editField_IFOC_CompCerosValueChanged(app,event)
            app.button_LimpiarparamsContr.Enable = "on";
            app.label_Contr_archivo.Text = 'Ningún archivo seleccionado';
        end

        function editField_PBC_psiRmagrefValueChanged(app,event)
            app.button_LimpiarparamsContr.Enable = "on";
            app.label_Contr_archivo.Text = 'Ningún archivo seleccionado';
        end

        function editField_PBC_KiSValueChanged(app,event)
            app.button_LimpiarparamsContr.Enable = "on";
            app.label_Contr_archivo.Text = 'Ningún archivo seleccionado';
        end

        function editField_tauRref_escalon_valrefValueChanged(app,event)
            app.button_LimpiarparamstauRref.Enable = "on";
            app.label_tauRref_cargar_params.Text = 'Ningún archivo seleccionado';
        end

        function editField_tauRref_escalon_tinitValueChanged(app,event)
            app.button_LimpiarparamstauRref.Enable = "on";
            app.label_tauRref_cargar_params.Text = 'Ningún archivo seleccionado';
        end

        function editField_tauRref_escalon_tfinValueChanged(app,event)
            app.button_LimpiarparamstauRref.Enable = "on";
            app.label_tauRref_cargar_params.Text = 'Ningún archivo seleccionado';
        end

        function editField_tauRref_rampa_valrefValueChanged(app,event)
            app.button_LimpiarparamstauRref.Enable = "on";
            app.label_tauRref_cargar_params.Text = 'Ningún archivo seleccionado';
        end

        function editField_tauRref_rampa_tinitValueChanged(app,event)
            app.button_LimpiarparamstauRref.Enable = "on";
            app.label_tauRref_cargar_params.Text = 'Ningún archivo seleccionado';
        end

        function editField_tauRref_rampa_tfinValueChanged(app,event)
            app.button_LimpiarparamstauRref.Enable = "on";
            app.label_tauRref_cargar_params.Text = 'Ningún archivo seleccionado';
        end

        function editField_tauRref_senoidal_valrefValueChanged(app,event)
            app.button_LimpiarparamstauRref.Enable = "on";
            app.label_tauRref_cargar_params.Text = 'Ningún archivo seleccionado';
        end

        function editField_tauRref_senoidal_frecuenciaValueChanged(app,event)
            app.button_LimpiarparamstauRref.Enable = "on";
            app.label_tauRref_cargar_params.Text = 'Ningún archivo seleccionado';
        end

        function editFIeld_tauRref_senoidal_tinitValueChanged(app,event)
            app.button_LimpiarparamstauRref.Enable = "on";
            app.label_tauRref_cargar_params.Text = 'Ningún archivo seleccionado';
        end

        function editField_tauRref_pol7_valrefValueChanged(app,event)
            app.button_LimpiarparamstauRref.Enable = "on";
            app.label_tauRref_cargar_params.Text = 'Ningún archivo seleccionado';
        end

        function editField_tauRref_pol7_tinitValueChanged(app,event)
            app.button_LimpiarparamstauRref.Enable = "on";
            app.label_tauRref_cargar_params.Text = 'Ningún archivo seleccionado';
        end

        function editField_tauRref_pol7_tfinValueChanged(app,event)
            app.button_LimpiarparamstauRref.Enable = "on";
            app.label_tauRref_cargar_params.Text = 'Ningún archivo seleccionado';
        end

        function editField_tauRref_escalones_valrefValueChanged(app,event)
            app.button_LimpiarparamstauRref.Enable = "on";
            app.label_tauRref_cargar_params.Text = 'Ningún archivo seleccionado';
        end

        function editField_tauRref_escalones_tescalonValueChanged(app,event)
            app.button_LimpiarparamstauRref.Enable = "on";
            app.label_tauRref_cargar_params.Text = 'Ningún archivo seleccionado';
        end

        function tabGroupControllerSelectionChanged(app, event)
            app.label_Contr_archivo.Text = "Ningún archivo seleccionado";
            app.button_Guardargraficas.Enable = "off";
            app.button_sim_voltaje.Enable = "off";
            app.button_sim_corriente.Enable = "off";
        end

        function tabGroup_tauRref_perfilesSelectionChanged(app,event)
            app.label_Contr_archivo.Text = "Ningún archivo seleccionado";
            app.button_Guardargraficas.Enable = "off";
            app.button_sim_voltaje.Enable = "off";
            app.button_sim_corriente.Enable = "off";

            if app.tabGroup_tauRref_perfiles.SelectedTab == app.tab_tauRref_cero || ...
               app.tabGroup_tauRref_perfiles.SelectedTab == app.tab_tauRref_timeseries
                app.button_GuardarparamstauRref.Enable = "off";
                app.button_LimpiarparamstauRref.Enable = "off";
            end
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

        function [psi_Rmagref,intGanancia,intCero,...
                  compPolos,compCeros] = AsignarDatosIFOC(app,data)
            psi_Rmagref = data(1).double;
            intGanancia = data(2).double;
            intCero = data(3).double;
            compPolos = data(4);
            compCeros = data(5);
        end

        function [psi_Rmagref,K_iS] = AsignarDatosPBC(app,data)
            psi_Rmagref = data(1);
            K_iS = data(2);
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

            figureHandler.graficar_UIFig(app.axes_torque,...
                    "Torque $\tau_R$",t,...
                    [app.datos_Graficas.tau_R(ind_data),app.datos_Graficas.tau_L(ind_data)], ...
                    14,"Tiempo [s]","Torque [N m]", ...
                    ["$\tau_R$","$\tau_L$"]);

            figureHandler.graficar_UIFig(app.axes_etorque,...
                    "Error de seguimiento de torque",t,...
                    app.datos_Graficas.tau_R(ind_data)-app.datos_Graficas.tau_L(ind_data), ...
                    14,"Tiempo [s]","Torque [N m]", ...
                    "$e_{\tau_R}$");

            figureHandler.graficar_UIFig(app.axes_velocidad,...
                    "Velocidad $w_R$",t,app.datos_Graficas.w_R(ind_data), ...
                    14,"Tiempo [s]","Velocidad [rad/s]","$w_R$");

            figureHandler.graficar_UIFig(app.axes_potencia, ...
                    "Potencia",t,...
                    [app.datos_Graficas.P_elect(ind_data),app.datos_Graficas.P_mech(ind_data)], ...
                    14,"Tiempo [s]","Potencia [W]", ...
                    ["Potencia electrica","Potencia mecanica"]);
        end

        function datos_Graficas = ValidarDatosGraficas(app)
            datos_Graficas.u_S3abc = figureHandler.checksize(app.SIM_motor.out.u_S3abc.data);
            datos_Graficas.i_S3abc = figureHandler.checksize(app.SIM_motor.out.i_S3abc.data);

            datos_Graficas.i_Sab = figureHandler.checksize(app.SIM_motor.out.i_Sab.data);
            datos_Graficas.i_Sabref = figureHandler.checksize(app.SIM_motor.out.i_Sabref.data);

            datos_Graficas.w_R = figureHandler.checksize(app.SIM_motor.out.w_R.data);
            datos_Graficas.tau_R = figureHandler.checksize(app.SIM_motor.out.tau_R.data);
            datos_Graficas.tau_L = figureHandler.checksize(app.SIM_motor.out.tau_L.data);

            datos_Graficas.P_elect = figureHandler.checksize(app.SIM_motor.out.P_elect.data);
            datos_Graficas.P_mech = figureHandler.checksize(app.SIM_motor.out.P_mech.data);
        end

        function button_tau_Rref_timeseries_previewPushed(app,event)
            %disp("previsualizar señal de torque")
            tr_sel = app.spinner_tauRref_timeseries_senal.Value;
            tsim = app.editField_sim01_tsim.Value; 
            tstep = app.editField_sim02_tstep.Value;

            tau_preview_ts = app.tau_preview.set_perfil_ts(tsim,tstep,tr_sel);
            tau_preview_ts.Name = "tau_R";
            assignin("base","tau",tau_preview_ts)
            plot(tau_preview_ts)
        end

        function button_GuardargraficasPushed(app,event)

            if ~exist(pwd+"\Simulación_seguimiento_torque", 'dir')
               mkdir(pwd+"\Simulación_seguimiento_torque\")
            end

            str_dir = "Motor" + string(round(app.MI_motor.Pnom/745.7,2)) + "hp";
            switch app.tabGroupController.SelectedTab
                case app.tabArr_Contr(1)
                    str_dir = str_dir + "_IFOC";
                case app.tabArr_Contr(2)
                    str_dir = str_dir + "_PBC";
                otherwise
                    disp("Error al nombrar carpeta de graficas de resultados de simulación (controlador)")
            end

            switch app.tabGroup_tauRref_perfiles.SelectedTab
                case app.tabArr_tauRref(1)
                    str_dir = str_dir + "_Cero";
                case app.tabArr_tauRref(2)
                    str_dir = str_dir + "_Esca_" + string(round(app.tau_L.valor_referencia,2));
                case app.tabArr_tauRref(3)
                    str_dir = str_dir + "_Ramp_" + string(round(app.tau_L.valor_referencia,2));
                case app.tabArr_tauRref(4)
                    str_dir = str_dir + "_Sen_" + string(round(app.tau_L.valor_referencia,2));
                case app.tabArr_tauRref(5)
                    str_dir = str_dir + "_Pol7_" + string(round(app.tau_L.valor_referencia,2));
                case app.tabArr_tauRref(6)
                    str_dir = str_dir + "_TrEsca_" + string(round(app.tau_L.valor_referencia,2));
                case app.tabArr_tauRref(7)
                    str_dir = str_dir + "_Timeseries";
                otherwise
                    disp("Error al nombrar carpeta de graficas de resultados de simulación (perfil de referencia)")
            end

            fdummy = figure('Position', [-100 -100 0 0],'CloseRequestFcn','');
            str_dir_graficas = uigetdir(pwd+"\Simulación_seguimiento_torque","Seleccionar folder");
            delete(fdummy)

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

            f(3) = figureHandler.graficar_Fig(3,1,[2,1], ...
                            "Error seguimiento de corriente (marco ab)", ...
                            t,app.datos_Graficas.i_Sab(ind_data,:)-app.datos_Graficas.i_Sabref(ind_data,:), ...
                            "Tiempo [s]","Corriente [A]", ...
                            ["$e_{i_{Sa}}$","$e_{i_{Sb}}$"]);

            f(4) = figureHandler.graficar_Fig(4,0,[1,1], ...
                            "Torque $\tau_R$", ...
                            t,[app.datos_Graficas.tau_R(ind_data),app.datos_Graficas.tau_L(ind_data)], ...
                            "Tiempo [s]","Torque [N m]", ...
                            ["$\tau_R$","$\tau_L$"]);

            f(5) = figureHandler.graficar_Fig(5,0,[1,1], ...
                            "Error seguimiento de torque", ...
                            t,app.datos_Graficas.tau_R(ind_data)-app.datos_Graficas.tau_L(ind_data), ...
                            "Tiempo [s]","Torque [N m]", ...
                            "$e_{\tau_R}$");
        
            f(6) = figureHandler.graficar_Fig(6,0,[1,1], ...
                            "Velocidad $w_R$", ...
                            t,[app.datos_Graficas.w_R(ind_data)], ...
                            "Tiempo [s]","Velocidad [rad/s]", ...
                            "$w_R$");

            f(7) = figureHandler.graficar_Fig(7,0,[1,1], ...
                            "Potencia", ...
                            t,[app.datos_Graficas.P_elect(ind_data),app.datos_Graficas.P_mech(ind_data)], ...
                            "Tiempo [s]","Potencia [W]", ...
                            ["Potencia electrica","Potencia mecanica"]);

            figureHandler.guardarGrafica(f(1),str_dir_graficas,str_dir,"01","Voltaje");
            figureHandler.guardarGrafica(f(2),str_dir_graficas,str_dir,"02","Corriente");
            figureHandler.guardarGrafica(f(3),str_dir_graficas,str_dir,"03","ErrorCorriente");
            figureHandler.guardarGrafica(f(4),str_dir_graficas,str_dir,"04","Torque");
            figureHandler.guardarGrafica(f(5),str_dir_graficas,str_dir,"05","ErrorTorque");
            figureHandler.guardarGrafica(f(6),str_dir_graficas,str_dir,"06","Velocidad");
            figureHandler.guardarGrafica(f(7),str_dir_graficas,str_dir,"07","Potencia");

            str_file_res = str_dir_graficas+"\"+str_dir+"\00_"+str_dir+".txt";
            
            MI_control_tauR_resumen_simulacion(str_dir_graficas+"\"+str_dir,...
                str_file_res,...
                app.MI_motor,app.MI_Contr,app.tau_Rref,app.tau_L)
            
            file_resultados = fopen(str_file_res,'a');
            app.imprimir_mediciones(file_resultados)
            fclose(file_resultados);
        end

        function imprimir_mediciones(app,fileID)

            fprintf(fileID,"\n** Mediciones de voltaje y corriente **\n\n");
            
            t = app.SIM_motor.out.tout;

            tinit = 0;
            if 2 > app.SIM_motor.tsim
                tinit = 2;
            end
            
            tfin = app.SIM_motor.tsim;

            [~,tinit_ind] = min(abs(t-tinit));
            [~,tfin_ind] = min(abs(t-tfin));
            ind_data = tinit_ind:tfin_ind;

            fprintf(fileID,"Mediciones de voltaje: \n" ...
                  + "Voltaje pico: " + string(max(app.SIM_motor.out.u_S3abc.data(ind_data,1))) ...
                  + " (" + string(round(max(app.SIM_motor.out.u_S3abc.data(ind_data,1))...
                          /(app.MI_motor.v_Srmsnom*sqrt(2/3))*100,2)) + "%% de valor nominal)" + "\n");
            
            if max(app.SIM_motor.out.u_S3abc.data(:,1))>app.MI_motor.v_Srmsnom/sqrt(2/3)*2
                fprintf(fileID,"NOTA: Voltaje pico excede valores nominales("+string(app.MI_motor.v_Srmsnom/sqrt(2/3)*2)+" V)\n");
            end
            fprintf(fileID,"\n");
            
            fprintf(fileID,"Mediciones de corriente: \n" ...
                  + "Corriente pico: " + string(max(app.SIM_motor.out.i_S3abc.data(ind_data,1)))...
                  + " (" + string(round(max(app.SIM_motor.out.i_S3abc.data(ind_data,1))/...
                  (app.MI_motor.i_Srmsnom*sqrt(2/3))*100)) + "%% de valor nominal)" + "\n");
            
            if max(app.SIM_motor.out.i_S3abc.data(:,1))>app.MI_motor.i_Srmsnom/sqrt(2/3)*2
                fprintf(fileID,"NOTA: Corriente pico excede valores nominales("+string(app.MI_motor.i_Srmsnom/sqrt(2)*2)+" A)\n");
            end
            fprintf(fileID,"\n");
        end

        function button_sim_voltajeContrPushed(app,event)
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

        end

        function button_sim_corrienteContrPushed(app,event)
            t = app.SIM_motor.out.tout;

            val = app.slider_tvis.Value;
            tinit = val(1);
            tfin = val(2);

            [~,tinit_ind] = min(abs(t-tinit));
            [~,tfin_ind] = min(abs(t-tfin));
            ind_data = tinit_ind:tfin_ind;
            t = t(ind_data);
            
            app.datos_Graficas = ValidarDatosGraficas(app);

            f(2) = figureHandler.graficar_Fig(2,1,[3,1], ...
                            "Corrientes de estator trifasicas $i_S$", ...
                            t,app.datos_Graficas.i_S3abc(ind_data,:), ...
                            "Tiempo [s]","Corriente [A]", ...
                            ["$i_{SA}$","$i_{SB}$","$i_{SC}$"]);

            f(3) = figureHandler.graficar_Fig(3,1,[2,1], ...
                            "Error seguimiento de corriente (marco ab)", ...
                            t,app.datos_Graficas.i_Sab(ind_data,:)-app.datos_Graficas.i_Sabref(ind_data,:), ...
                            "Tiempo [s]","Corriente [A]", ...
                            ["$e_{i_{Sa}}$","$e_{i_{Sb}}$"]);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.figure_main = uifigure('Visible', 'off');
            app.figure_main.Position = [1 1 1367 768];
            app.figure_main.Name = ['Simulación del control de torque ' ...
                                    'del motor de inducción'];

            % Create layout_main
            app.layout_main = uigridlayout(app.figure_main);
            app.layout_main.ColumnWidth = {375, 325, '1x'};
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

            % Create button_LimpiarparamsMI
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
            
            % Create layout_Contr_tauRef_main
            app.layout_Contr_tauRef_main = uigridlayout(app.layout_main);
            app.layout_Contr_tauRef_main.ColumnWidth = {'1x'};
            app.layout_Contr_tauRef_main.RowHeight = {340,280, '5x'};
            app.layout_Contr_tauRef_main.ColumnSpacing = 0;
            app.layout_Contr_tauRef_main.RowSpacing = 5;
            app.layout_Contr_tauRef_main.Padding = [0 0 5 0];
            app.layout_Contr_tauRef_main.Layout.Row = 1;
            app.layout_Contr_tauRef_main.Layout.Column = 2;


            % Create panel_Controller_params
            app.panel_Controller_params = uipanel(app.layout_Contr_tauRef_main);
            app.panel_Controller_params.Title = 'Parámetros del controlador';
            app.panel_Controller_params.Layout.Row = 1;
            app.panel_Controller_params.Layout.Column = 1;
            app.panel_Controller_params.FontSize = 18;

            % Create layout_Controller_params
            app.layout_Controller_params = uigridlayout(app.panel_Controller_params);
            app.layout_Controller_params.ColumnWidth = {'1x'};
            app.layout_Controller_params.RowHeight = {25, 240, 25};
            app.layout_Controller_params.ColumnSpacing = 0;
            app.layout_Controller_params.RowSpacing = 5;
            app.layout_Controller_params.Padding = [0 2 0 2];

            % Create tabGroupController
            app.tabGroupController = uitabgroup(app.layout_Controller_params);
            app.tabGroupController.SelectionChangedFcn = createCallbackFcn(app, @tabGroupControllerSelectionChanged, true);
            app.tabGroupController.Layout.Row = 2;
            app.tabGroupController.Layout.Column = 1;

            % Create tab_IFOCICAD
            app.tab_IFOCICAD = uitab(app.tabGroupController);
            app.tab_IFOCICAD.Title = 'IFOC+ICAD(Lineal)';

            % Create layout_IFOCdata
            app.layout_IFOCdata = uigridlayout(app.tab_IFOCICAD);
            app.layout_IFOCdata.ColumnWidth = {'1x'};
            app.layout_IFOCdata.RowHeight = {20, 80, 100};
            app.layout_IFOCdata.ColumnSpacing = 0;
            app.layout_IFOCdata.RowSpacing = 5;
            app.layout_IFOCdata.Padding = [0 5 0 5];

            % Create layout_IFOC_psiRmagref
            app.layout_IFOC_psiRmagref = uigridlayout(app.layout_IFOCdata);
            app.layout_IFOC_psiRmagref.ColumnWidth = {'5x', '1x'};
            app.layout_IFOC_psiRmagref.RowHeight = {'1x'};
            app.layout_IFOC_psiRmagref.ColumnSpacing = 5;
            app.layout_IFOC_psiRmagref.RowSpacing = 0;
            app.layout_IFOC_psiRmagref.Padding = [0 0 0 0];
            app.layout_IFOC_psiRmagref.Layout.Row = 1;
            app.layout_IFOC_psiRmagref.Layout.Column = 1;

            % Create label_IFOC_psiRmagref
            app.label_IFOC_psiRmagref = uilabel(app.layout_IFOC_psiRmagref);
            app.label_IFOC_psiRmagref.Layout.Row = 1;
            app.label_IFOC_psiRmagref.Layout.Column = 1;
            app.label_IFOC_psiRmagref.Interpreter = 'latex';
            app.label_IFOC_psiRmagref.Text = 'Mágnitud de flujo de referencia';

            % Create editField_psiRmagref
            app.editField_IOFC_psiRmagref = uieditfield(app.layout_IFOC_psiRmagref, 'numeric');
            app.editField_IOFC_psiRmagref.ValueChangedFcn = createCallbackFcn(app, @editField_IOFC_psiRmagrefValueChanged, true);
            app.editField_IOFC_psiRmagref.Layout.Row = 1;
            app.editField_IOFC_psiRmagref.Layout.Column = 2;

            % Create psi_RrefLabel
            app.psi_RrefIFOCLabel = uilabel(app.layout_IFOC_psiRmagref);
            app.psi_RrefIFOCLabel.HorizontalAlignment = 'right';
            app.psi_RrefIFOCLabel.Layout.Row = 1;
            app.psi_RrefIFOCLabel.Layout.Column = 1;
            app.psi_RrefIFOCLabel.Text = '$||\psi_{Rref}||: $';
            app.psi_RrefIFOCLabel.Interpreter = 'latex';

            % Create panel_IFOC_Integratordata
            app.panel_IFOC_Integratordata = uipanel(app.layout_IFOCdata);
            app.panel_IFOC_Integratordata.Title = 'Integrador';
            app.panel_IFOC_Integratordata.Layout.Row = 2;
            app.panel_IFOC_Integratordata.Layout.Column = 1;
            app.panel_IFOC_Integratordata.FontSize = 14;

            % Create layout_Integratordata
            app.layout_Integratordata = uigridlayout(app.panel_IFOC_Integratordata);
            app.layout_Integratordata.ColumnWidth = {'5x', '1x'};
            app.layout_Integratordata.RowHeight = {20, 20};
            app.layout_Integratordata.ColumnSpacing = 0;
            app.layout_Integratordata.RowSpacing = 2;
            app.layout_Integratordata.Padding = [0 2 2 2];

            % Create label_IFOC_IntGanancia
            app.label_IFOC_IntGanancia = uilabel(app.layout_Integratordata);
            app.label_IFOC_IntGanancia.Layout.Row = 1;
            app.label_IFOC_IntGanancia.Layout.Column = 1;
            app.label_IFOC_IntGanancia.Interpreter = 'latex';
            app.label_IFOC_IntGanancia.Text = 'Ganancia';

            % Create editField_IFOC_IntGanancia
            app.editField_IFOC_IntGanancia = uieditfield(app.layout_Integratordata, 'numeric');
            app.editField_IFOC_IntGanancia.ValueChangedFcn = createCallbackFcn(app, @editField_IFOC_IntGananciaValueChanged, true);
            app.editField_IFOC_IntGanancia.Layout.Row = 1;
            app.editField_IFOC_IntGanancia.Layout.Column = 2;

            % Create label_IFOC_IntCero
            app.label_IFOC_IntCero = uilabel(app.layout_Integratordata);
            app.label_IFOC_IntCero.Layout.Row = 2;
            app.label_IFOC_IntCero.Layout.Column = 1;
            app.label_IFOC_IntCero.Interpreter = 'latex';
            app.label_IFOC_IntCero.Text = 'Cero';

            % Create editField_IFOC_IntCero
            app.editField_IFOC_IntCero = uieditfield(app.layout_Integratordata, 'numeric');
            app.editField_IFOC_IntCero.ValueChangedFcn = createCallbackFcn(app, @editField_IFOC_IntCeroValueChanged, true);
            app.editField_IFOC_IntCero.Layout.Row = 2;
            app.editField_IFOC_IntCero.Layout.Column = 2;


            % Create panel_IFOC_Compensatordata
            app.panel_IFOC_Compensatordata = uipanel(app.layout_IFOCdata);
            app.panel_IFOC_Compensatordata.Title = 'Compensador';
            app.panel_IFOC_Compensatordata.Layout.Row = 3;
            app.panel_IFOC_Compensatordata.Layout.Column = 1;
            app.panel_IFOC_Compensatordata.FontSize = 14;

            % Create layout_IFOC_Compensatordata
            app.layout_IFOC_Compensatordata = uigridlayout(app.panel_IFOC_Compensatordata);
            app.layout_IFOC_Compensatordata.ColumnWidth = {'2x', '1x'};
            app.layout_IFOC_Compensatordata.RowHeight = {20, 20, 20};
            app.layout_IFOC_Compensatordata.ColumnSpacing = 0;
            app.layout_IFOC_Compensatordata.RowSpacing = 2;
            app.layout_IFOC_Compensatordata.Padding = [0 2 2 2];

            % Create label_IFOC_CompInstrucciones
            app.label_IFOC_CompInstrucciones = uilabel(app.layout_IFOC_Compensatordata);
            app.label_IFOC_CompInstrucciones.FontSize = 10;
            app.label_IFOC_CompInstrucciones.Layout.Row = 1;
            app.label_IFOC_CompInstrucciones.Layout.Column = [1 2];
            app.label_IFOC_CompInstrucciones.Interpreter = 'latex';
            app.label_IFOC_CompInstrucciones.Text = 'Ingresa números separados por comas (ej. -400,4.5+45.6i,0.967)';

            % Create label_IFOC_CompCeros
            app.label_IFOC_CompCeros = uilabel(app.layout_IFOC_Compensatordata);
            app.label_IFOC_CompCeros.Layout.Row = 3;
            app.label_IFOC_CompCeros.Layout.Column = 1;
            app.label_IFOC_CompCeros.Interpreter = 'latex';
            app.label_IFOC_CompCeros.Text = 'Ceros';

            % Create editFIeld_IFOC_CompPolos
            app.editFIeld_IFOC_CompPolos = uieditfield(app.layout_IFOC_Compensatordata, 'text');
            app.editFIeld_IFOC_CompPolos.ValueChangedFcn = createCallbackFcn(app, @editField_IFOC_CompPolosValueChanged, true);
            app.editFIeld_IFOC_CompPolos.Layout.Row = 2;
            app.editFIeld_IFOC_CompPolos.Layout.Column = 2;

            % Create label_IFOC_CompPolos
            app.label_IFOC_CompPolos = uilabel(app.layout_IFOC_Compensatordata);
            app.label_IFOC_CompPolos.Layout.Row = 2;
            app.label_IFOC_CompPolos.Layout.Column = 1;
            app.label_IFOC_CompPolos.Interpreter = 'latex';
            app.label_IFOC_CompPolos.Text = 'Polos';

            % Create editField_IFOC_CompCeros
            app.editField_IFOC_CompCeros = uieditfield(app.layout_IFOC_Compensatordata, 'text');
            app.editField_IFOC_CompCeros.ValueChangedFcn = createCallbackFcn(app, @editField_IFOC_CompCerosValueChanged, true);
            app.editField_IFOC_CompCeros.Layout.Row = 3;
            app.editField_IFOC_CompCeros.Layout.Column = 2;



            % Create PBCTab
            app.tab_PBC = uitab(app.tabGroupController);
            app.tab_PBC.Title = 'PBC';

            % Create layout_PBCdata
            app.layout_PBCdata = uigridlayout(app.tab_PBC);
            app.layout_PBCdata.ColumnWidth = {'5x', '1x'};
            app.layout_PBCdata.RowHeight = {20, 20, 20};
            app.layout_PBCdata.ColumnSpacing = 2;
            app.layout_PBCdata.RowSpacing = 2;
            app.layout_PBCdata.Padding = [0 2 2 2];


            % Create label_PBC_psiRmagref
            app.label_PBC_psiRmagref = uilabel(app.layout_PBCdata);
            app.label_PBC_psiRmagref.Layout.Row = 1;
            app.label_PBC_psiRmagref.Layout.Column = 1;
            app.label_PBC_psiRmagref.Interpreter = 'latex';
            app.label_PBC_psiRmagref.Text = 'Magnitud de flujo de referencia';

            % Create editField_PBC_psiRmagref
            app.editField_PBC_psiRmagref = uieditfield(app.layout_PBCdata, 'numeric');
            app.editField_PBC_psiRmagref.ValueChangedFcn = createCallbackFcn(app, @editField_PBC_psiRmagrefValueChanged, true);
            app.editField_PBC_psiRmagref.Layout.Row = 1;
            app.editField_PBC_psiRmagref.Layout.Column = 2;

            % Create psi_RmagrefLabel
            app.psi_RrefPBCLabel = uilabel(app.layout_PBCdata);
            app.psi_RrefPBCLabel.HorizontalAlignment = 'right';
            app.psi_RrefPBCLabel.Layout.Row = 1;
            app.psi_RrefPBCLabel.Layout.Column = 1;
            app.psi_RrefPBCLabel.Text = '$||\psi_{Rref}||: $';
            app.psi_RrefPBCLabel.Interpreter = 'latex';

            % Create label_PBC_KiS
            app.label_PBC_KiS = uilabel(app.layout_PBCdata);
            app.label_PBC_KiS.Layout.Row = 2;
            app.label_PBC_KiS.Layout.Column = 1;
            app.label_PBC_KiS.Interpreter = 'latex';
            app.label_PBC_KiS.Text = 'Inyección de amortiguamiento';

            % Create editField_PBC_KiS
            app.editField_PBC_KiS = uieditfield(app.layout_PBCdata, 'numeric');
            app.editField_PBC_KiS.ValueChangedFcn = createCallbackFcn(app, @editField_PBC_KiSValueChanged, true);
            app.editField_PBC_KiS.Layout.Row = 2;
            app.editField_PBC_KiS.Layout.Column = 2;

            % Create K_iSLabel
            app.K_iSLabel = uilabel(app.layout_PBCdata);
            app.K_iSLabel.HorizontalAlignment = 'right';
            app.K_iSLabel.Layout.Row = 2;
            app.K_iSLabel.Layout.Column = 1;
            app.K_iSLabel.Text = '$\epsilon_{K_{i_S}}$: ';
            app.K_iSLabel.Interpreter = 'latex';

            % Create layout_Contr_guardar_params
            app.layout_Contr_guardar_params = uigridlayout(app.layout_Controller_params);
            app.layout_Contr_guardar_params.RowHeight = {'1x'};
            app.layout_Contr_guardar_params.ColumnSpacing = 2;
            app.layout_Contr_guardar_params.RowSpacing = 0;
            app.layout_Contr_guardar_params.Padding = [2 0 2 0];
            app.layout_Contr_guardar_params.Layout.Row = 3;
            app.layout_Contr_guardar_params.Layout.Column = 1;

            % Create button_GuardarparamsContr
            app.button_GuardarparamsContr = uibutton(app.layout_Contr_guardar_params, 'push');
            app.button_GuardarparamsContr.ButtonPushedFcn = createCallbackFcn(app, @button_GuardarparamsContrPushed, true);
            app.button_GuardarparamsContr.Layout.Row = 1;
            app.button_GuardarparamsContr.Layout.Column = 2;
            app.button_GuardarparamsContr.Text = 'Guardar parámetros';
            app.button_GuardarparamsContr.Enable = "off";

            % Create button_LimpiarparamsContr
            app.button_LimpiarparamsContr = uibutton(app.layout_Contr_guardar_params, 'push');
            app.button_LimpiarparamsContr.ButtonPushedFcn = createCallbackFcn(app, @button_LimpiarparamsContrPushed, true);
            app.button_LimpiarparamsContr.Layout.Row = 1;
            app.button_LimpiarparamsContr.Layout.Column = 1;
            app.button_LimpiarparamsContr.Text = 'Limpiar';
            app.button_LimpiarparamsContr.Enable = "off";

            % Create layout_Contr_cargar_params
            app.layout_Contr_cargar_params = uigridlayout(app.layout_Controller_params);
            app.layout_Contr_cargar_params.ColumnWidth = {'5x', '12x'};
            app.layout_Contr_cargar_params.RowHeight = {'1x'};
            app.layout_Contr_cargar_params.ColumnSpacing = 5;
            app.layout_Contr_cargar_params.RowSpacing = 0;
            app.layout_Contr_cargar_params.Padding = [2 0 2 0];
            app.layout_Contr_cargar_params.Layout.Row = 1;
            app.layout_Contr_cargar_params.Layout.Column = 1;

            % Create button_Contr_archivo
            app.button_Contr_archivo = uibutton(app.layout_Contr_cargar_params, 'push');
            app.button_Contr_archivo.ButtonPushedFcn = createCallbackFcn(app, @button_Contr_archivoButtonPushed, true);
            app.button_Contr_archivo.Layout.Row = 1;
            app.button_Contr_archivo.Layout.Column = 1;
            app.button_Contr_archivo.Text = 'Cargar archivo';

            % Create label_Contr_archivo
            app.label_Contr_archivo = uilabel(app.layout_Contr_cargar_params);
            app.label_Contr_archivo.Layout.Row = 1;
            app.label_Contr_archivo.Layout.Column = 2;
            app.label_Contr_archivo.Text = 'Níngún archivo seleccionado';



            % Create panel_tau_Rref_params
            app.panel_tau_Rref_params = uipanel(app.layout_Contr_tauRef_main);
            app.panel_tau_Rref_params.Title = 'Torque de Referencia';
            app.panel_tau_Rref_params.Layout.Row = 2;
            app.panel_tau_Rref_params.Layout.Column = 1;
            app.panel_tau_Rref_params.FontSize = 18;

            % Create layout_tauRref_params
            app.layout_tauRref_params = uigridlayout(app.panel_tau_Rref_params);
            app.layout_tauRref_params.ColumnWidth = {'1x'};
            app.layout_tauRref_params.RowHeight = {25, 180, 25};
            app.layout_tauRref_params.ColumnSpacing = 0;
            app.layout_tauRref_params.RowSpacing = 5;
            app.layout_tauRref_params.Padding = [0 2 0 2];

            % Create tabGroup_tauRref_perfiles
            app.tabGroup_tauRref_perfiles = uitabgroup(app.layout_tauRref_params);
            app.tabGroup_tauRref_perfiles.SelectionChangedFcn = createCallbackFcn(app, @tabGroup_tauRref_perfilesSelectionChanged, true);
            app.tabGroup_tauRref_perfiles.TabLocation = 'left';
            app.tabGroup_tauRref_perfiles.Layout.Row = 2;
            app.tabGroup_tauRref_perfiles.Layout.Column = 1;

            % Create tab_tauRref_cero
            app.tab_tauRref_cero = uitab(app.tabGroup_tauRref_perfiles);
            app.tab_tauRref_cero.Title = 'Cero';

            % Create layout_tauRref_cero
            app.layout_tauRref_cero = uigridlayout(app.tab_tauRref_cero);
            app.layout_tauRref_cero.ColumnWidth = {'1x'};
            app.layout_tauRref_cero.RowHeight = {20};
            app.layout_tauRref_cero.ColumnSpacing = 2;
            app.layout_tauRref_cero.RowSpacing = 2;
            app.layout_tauRref_cero.Padding = [2 2 2 2];

            % Create label_cero
            app.label_cero = uilabel(app.layout_tauRref_cero);
            app.label_cero.Layout.Row = 1;
            app.label_cero.Layout.Column = 1;
            app.label_cero.Interpreter = 'latex';
            app.label_cero.Text = 'Referencia cero';

            % Create tab_tauRref_escalon
            app.tab_tauRref_escalon = uitab(app.tabGroup_tauRref_perfiles);
            app.tab_tauRref_escalon.Title = 'Escalón';

            % Create layout_tauRref_escalon
            app.layout_tauRref_escalon = uigridlayout(app.tab_tauRref_escalon);
            app.layout_tauRref_escalon.ColumnWidth = {'3x', '1x'};
            app.layout_tauRref_escalon.RowHeight = {20, 20, 20, 20};
            app.layout_tauRref_escalon.ColumnSpacing = 0;
            app.layout_tauRref_escalon.RowSpacing = 2;
            app.layout_tauRref_escalon.Padding = [2 2 2 2];

            % Create label_tauRref_escalon_descripcion
            app.label_tauRref_escalon_descripcion = uilabel(app.layout_tauRref_escalon);
            app.label_tauRref_escalon_descripcion.Layout.Row = 1;
            app.label_tauRref_escalon_descripcion.Layout.Column = [1 2];
            app.label_tauRref_escalon_descripcion.Interpreter = 'latex';
            app.label_tauRref_escalon_descripcion.Text = 'Escalón de duración finita';

            % Create label_tauRref_escalon_valref
            app.label_tauRref_escalon_valref = uilabel(app.layout_tauRref_escalon);
            app.label_tauRref_escalon_valref.Layout.Row = 2;
            app.label_tauRref_escalon_valref.Layout.Column = 1;
            app.label_tauRref_escalon_valref.Interpreter = 'latex';
            app.label_tauRref_escalon_valref.Text = 'Valor de referencia [N m]';

            % Create editField_tauRref_escalon_valref
            app.editField_tauRref_escalon_valref = uieditfield(app.layout_tauRref_escalon, 'numeric');
            app.editField_tauRref_escalon_valref.ValueChangedFcn = createCallbackFcn(app, @editField_tauRref_escalon_valrefValueChanged, true);
            app.editField_tauRref_escalon_valref.Layout.Row = 2;
            app.editField_tauRref_escalon_valref.Layout.Column = 2;
            app.editField_tauRref_escalon_valref.Value = 0;

            % Create label_tauRref_escalon_tinit
            app.label_tauRref_escalon_tinit = uilabel(app.layout_tauRref_escalon);
            app.label_tauRref_escalon_tinit.Layout.Row = 3;
            app.label_tauRref_escalon_tinit.Layout.Column = 1;
            app.label_tauRref_escalon_tinit.Interpreter = 'latex';
            app.label_tauRref_escalon_tinit.Text = 'Tiempo de inicio [s]';

            % Create editField_tauRref_escalon_tinit
            app.editField_tauRref_escalon_tinit = uieditfield(app.layout_tauRref_escalon, 'numeric');
            app.editField_tauRref_escalon_tinit.ValueChangedFcn = createCallbackFcn(app, @editField_tauRref_escalon_tinitValueChanged, true);
            app.editField_tauRref_escalon_tinit.Layout.Row = 3;
            app.editField_tauRref_escalon_tinit.Layout.Column = 2;
            app.editField_tauRref_escalon_tinit.Value = 2.5;

            % Create editField_tauRref_escalon_tfin
            app.editField_tauRref_escalon_tfin = uieditfield(app.layout_tauRref_escalon, 'numeric');
            app.editField_tauRref_escalon_tfin.ValueChangedFcn = createCallbackFcn(app, @editField_tauRref_escalon_tfinValueChanged, true);
            app.editField_tauRref_escalon_tfin.Layout.Row = 4;
            app.editField_tauRref_escalon_tfin.Layout.Column = 2;
            app.editField_tauRref_escalon_tfin.Value = 7.5;

            % Create label_tauRref_escalon_tfin
            app.label_tauRref_escalon_tfin = uilabel(app.layout_tauRref_escalon);
            app.label_tauRref_escalon_tfin.Layout.Row = 4;
            app.label_tauRref_escalon_tfin.Layout.Column = 1;
            app.label_tauRref_escalon_tfin.Interpreter = 'latex';
            app.label_tauRref_escalon_tfin.Text = 'Tiempo de fin [s]';

            % Create tab_tauRref_rampa
            app.tab_tauRref_rampa = uitab(app.tabGroup_tauRref_perfiles);
            app.tab_tauRref_rampa.Title = 'Rampa';

            % Create layout_tauRref_rampa
            app.layout_tauRref_rampa = uigridlayout(app.tab_tauRref_rampa);
            app.layout_tauRref_rampa.ColumnWidth = {'3x', '1x'};
            app.layout_tauRref_rampa.RowHeight = {20, 20, 20, 20};
            app.layout_tauRref_rampa.ColumnSpacing = 2;
            app.layout_tauRref_rampa.RowSpacing = 2;
            app.layout_tauRref_rampa.Padding = [2 2 2 2];

            % Create label_tauRref_rampa_descripcion
            app.label_tauRref_rampa_descripcion = uilabel(app.layout_tauRref_rampa);
            app.label_tauRref_rampa_descripcion.Layout.Row = 1;
            app.label_tauRref_rampa_descripcion.Layout.Column = [1 2];
            app.label_tauRref_rampa_descripcion.Interpreter = 'latex';
            app.label_tauRref_rampa_descripcion.Text = 'Rampa';

            % Create label_tauRref_rampa_valref
            app.label_tauRref_rampa_valref = uilabel(app.layout_tauRref_rampa);
            app.label_tauRref_rampa_valref.Layout.Row = 2;
            app.label_tauRref_rampa_valref.Layout.Column = 1;
            app.label_tauRref_rampa_valref.Interpreter = 'latex';
            app.label_tauRref_rampa_valref.Text = 'Valor de referencia [N m]';

            % Create editField_tauRref_rampa_valref
            app.editField_tauRref_rampa_valref = uieditfield(app.layout_tauRref_rampa, 'numeric');
            app.editField_tauRref_rampa_valref.ValueChangedFcn = createCallbackFcn(app, @editField_tauRref_rampa_valrefValueChanged, true);
            app.editField_tauRref_rampa_valref.Layout.Row = 2;
            app.editField_tauRref_rampa_valref.Layout.Column = 2;
            app.editField_tauRref_rampa_valref.Value = 0;

            % Create label_tauRref_rampa_tinit
            app.label_tauRref_rampa_tinit = uilabel(app.layout_tauRref_rampa);
            app.label_tauRref_rampa_tinit.Layout.Row = 3;
            app.label_tauRref_rampa_tinit.Layout.Column = 1;
            app.label_tauRref_rampa_tinit.Interpreter = 'latex';
            app.label_tauRref_rampa_tinit.Text = 'Tiempo de inicio [s]';

            % Create editField_tauRref_rampa_tinit
            app.editField_tauRref_rampa_tinit = uieditfield(app.layout_tauRref_rampa, 'numeric');
            app.editField_tauRref_rampa_tinit.ValueChangedFcn = createCallbackFcn(app, @editField_tauRref_rampa_tinitValueChanged, true);
            app.editField_tauRref_rampa_tinit.Layout.Row = 3;
            app.editField_tauRref_rampa_tinit.Layout.Column = 2;
            app.editField_tauRref_rampa_tinit.Value = 2.5;

            % Create label_tauRref_rampa_tfin
            app.label_tauRref_rampa_tfin = uilabel(app.layout_tauRref_rampa);
            app.label_tauRref_rampa_tfin.Layout.Row = 4;
            app.label_tauRref_rampa_tfin.Layout.Column = 1;
            app.label_tauRref_rampa_tfin.Interpreter = 'latex';
            app.label_tauRref_rampa_tfin.Text = 'Tiempo de fin [s]';

            % Create editField_tauRref_rampa_tfin
            app.editField_tauRref_rampa_tfin = uieditfield(app.layout_tauRref_rampa, 'numeric');
            app.editField_tauRref_rampa_tfin.ValueChangedFcn = createCallbackFcn(app, @editField_tauRref_rampa_tfinValueChanged, true);
            app.editField_tauRref_rampa_tfin.Layout.Row = 4;
            app.editField_tauRref_rampa_tfin.Layout.Column = 2;
            app.editField_tauRref_rampa_tfin.Value = 7.5;

            % Create tab_tauRref_senoidal
            app.tab_tauRref_senoidal = uitab(app.tabGroup_tauRref_perfiles);
            app.tab_tauRref_senoidal.Title = 'Senoidal';
            
            % Create layout_tauRref_senoidal
            app.layout_tauRref_senoidal = uigridlayout(app.tab_tauRref_senoidal);
            app.layout_tauRref_senoidal.ColumnWidth = {'3x', '1x'};
            app.layout_tauRref_senoidal.RowHeight = {20, 20, 20, 20};
            app.layout_tauRref_senoidal.ColumnSpacing = 2;
            app.layout_tauRref_senoidal.RowSpacing = 2;
            app.layout_tauRref_senoidal.Padding = [2 2 2 2];

            % Create label_tauRref_senoidal_descripcion
            app.label_tauRref_senoidal_descripcion = uilabel(app.layout_tauRref_senoidal);
            app.label_tauRref_senoidal_descripcion.Layout.Row = 1;
            app.label_tauRref_senoidal_descripcion.Layout.Column = [1 2];
            app.label_tauRref_senoidal_descripcion.Interpreter = 'latex';
            app.label_tauRref_senoidal_descripcion.Text = 'Senoidal';

            % Create label_tauRref_senoidal_valref
            app.label_tauRref_senoidal_valref = uilabel(app.layout_tauRref_senoidal);
            app.label_tauRref_senoidal_valref.Layout.Row = 2;
            app.label_tauRref_senoidal_valref.Layout.Column = 1;
            app.label_tauRref_senoidal_valref.Interpreter = 'latex';
            app.label_tauRref_senoidal_valref.Text = 'Amplitud pico [N m]';

            % Create editField_tauRref_senoidal_valref
            app.editField_tauRref_senoidal_valref = uieditfield(app.layout_tauRref_senoidal, 'numeric');
            app.editField_tauRref_senoidal_valref.ValueChangedFcn = createCallbackFcn(app, @editField_tauRref_senoidal_valrefValueChanged, true);
            app.editField_tauRref_senoidal_valref.Layout.Row = 2;
            app.editField_tauRref_senoidal_valref.Layout.Column = 2;
            app.editField_tauRref_senoidal_valref.Value = 0;

            % Create label_tauRref_senoidal_frecuencia
            app.label_tauRref_senoidal_frecuencia = uilabel(app.layout_tauRref_senoidal);
            app.label_tauRref_senoidal_frecuencia.Layout.Row = 3;
            app.label_tauRref_senoidal_frecuencia.Layout.Column = 1;
            app.label_tauRref_senoidal_frecuencia.Interpreter = 'latex';
            app.label_tauRref_senoidal_frecuencia.Text = 'Frecuencia [rad/s]';

            % Create editField_tauRref_senoidal_frecuencia
            app.editField_tauRref_senoidal_frecuencia = uieditfield(app.layout_tauRref_senoidal, 'numeric');
            app.editField_tauRref_senoidal_frecuencia.ValueChangedFcn = createCallbackFcn(app, @editField_tauRref_senoidal_frecuenciaValueChanged, true);
            app.editField_tauRref_senoidal_frecuencia.Layout.Row = 3;
            app.editField_tauRref_senoidal_frecuencia.Layout.Column = 2;
            app.editField_tauRref_senoidal_frecuencia.Value = 10;

            % Create label_tauRref_senoidal_tinit
            app.label_tauRref_senoidal_tinit = uilabel(app.layout_tauRref_senoidal);
            app.label_tauRref_senoidal_tinit.Layout.Row = 4;
            app.label_tauRref_senoidal_tinit.Layout.Column = 1;
            app.label_tauRref_senoidal_tinit.Interpreter = 'latex';
            app.label_tauRref_senoidal_tinit.Text = 'Tiempo de inicio [s]';

            % Create editFIeld_tauRref_senoidal_tinit
            app.editFIeld_tauRref_senoidal_tinit = uieditfield(app.layout_tauRref_senoidal, 'numeric');
            app.editFIeld_tauRref_senoidal_tinit.ValueChangedFcn = createCallbackFcn(app, @editFIeld_tauRref_senoidal_tinitValueChanged, true);
            app.editFIeld_tauRref_senoidal_tinit.Layout.Row = 4;
            app.editFIeld_tauRref_senoidal_tinit.Layout.Column = 2;
            app.editFIeld_tauRref_senoidal_tinit.Value = 2.5;

            % Create tab_tauRref_pol7
            app.tab_tauRref_pol7 = uitab(app.tabGroup_tauRref_perfiles);
            app.tab_tauRref_pol7.Title = 'Polinomio 7mo orden';

            % Create layout_tauRref_pol7
            app.layout_tauRref_pol7 = uigridlayout(app.tab_tauRref_pol7);
            app.layout_tauRref_pol7.ColumnWidth = {'3x', '1x'};
            app.layout_tauRref_pol7.RowHeight = {20, 20, 20, 20};
            app.layout_tauRref_pol7.ColumnSpacing = 2;
            app.layout_tauRref_pol7.RowSpacing = 2;
            app.layout_tauRref_pol7.Padding = [2 2 2 2];

            % Create label_tauRref_pol7_descripcion
            app.label_tauRref_pol7_descripcion = uilabel(app.layout_tauRref_pol7);
            app.label_tauRref_pol7_descripcion.Layout.Row = 1;
            app.label_tauRref_pol7_descripcion.Layout.Column = [1 2];
            app.label_tauRref_pol7_descripcion.Interpreter = 'latex';
            app.label_tauRref_pol7_descripcion.Text = 'Polinomio de 7mo grado';


            % Create label_tauRref_pol7_valref
            app.label_tauRref_pol7_valref = uilabel(app.layout_tauRref_pol7);
            app.label_tauRref_pol7_valref.Layout.Row = 2;
            app.label_tauRref_pol7_valref.Layout.Column = 1;
            app.label_tauRref_pol7_valref.Interpreter = 'latex';
            app.label_tauRref_pol7_valref.Text = 'Valor de referencia [N m]';

            % Create editField_tauRref_pol7_valref
            app.editField_tauRref_pol7_valref = uieditfield(app.layout_tauRref_pol7, 'numeric');
            app.editField_tauRref_pol7_valref.ValueChangedFcn = createCallbackFcn(app, @editField_tauRref_pol7_valrefValueChanged, true);
            app.editField_tauRref_pol7_valref.Layout.Row = 2;
            app.editField_tauRref_pol7_valref.Layout.Column = 2;
            app.editField_tauRref_pol7_valref.Value = 0;

            % Create label_tauRref_pol7_tinit
            app.label_tauRref_pol7_tinit = uilabel(app.layout_tauRref_pol7);
            app.label_tauRref_pol7_tinit.Layout.Row = 3;
            app.label_tauRref_pol7_tinit.Layout.Column = 1;
            app.label_tauRref_pol7_tinit.Interpreter = 'latex';
            app.label_tauRref_pol7_tinit.Text = 'Tiempo de inicio [s]';

            % Create editField_tauRref_pol7_tinit
            app.editField_tauRref_pol7_tinit = uieditfield(app.layout_tauRref_pol7, 'numeric');
            app.editField_tauRref_pol7_tinit.ValueChangedFcn = createCallbackFcn(app, @editField_tauRref_pol7_tinitValueChanged, true);
            app.editField_tauRref_pol7_tinit.Layout.Row = 3;
            app.editField_tauRref_pol7_tinit.Layout.Column = 2;
            app.editField_tauRref_pol7_tinit.Value = 2.5;

            % Create label_tauRref_pol7_tfin
            app.label_tauRref_pol7_tfin = uilabel(app.layout_tauRref_pol7);
            app.label_tauRref_pol7_tfin.Layout.Row = 4;
            app.label_tauRref_pol7_tfin.Layout.Column = 1;
            app.label_tauRref_pol7_tfin.Interpreter = 'latex';
            app.label_tauRref_pol7_tfin.Text = 'Tiempo de fin [s]';

            % Create editField_tauRref_pol7_tfin
            app.editField_tauRref_pol7_tfin = uieditfield(app.layout_tauRref_pol7, 'numeric');
            app.editField_tauRref_pol7_tfin.ValueChangedFcn = createCallbackFcn(app, @editField_tauRref_pol7_tfinValueChanged, true);
            app.editField_tauRref_pol7_tfin.Layout.Row = 4;
            app.editField_tauRref_pol7_tfin.Layout.Column = 2;
            app.editField_tauRref_pol7_tfin.Value = 7.5;

            % Create tab_tauRref_escalones
            app.tab_tauRref_escalones = uitab(app.tabGroup_tauRref_perfiles);
            app.tab_tauRref_escalones.Title = 'Tren de escalones';

            % Create layout_tauRref_escalones
            app.layout_tauRref_escalones = uigridlayout(app.tab_tauRref_escalones);
            app.layout_tauRref_escalones.ColumnWidth = {'3x', '1x'};
            app.layout_tauRref_escalones.RowHeight = {20, 20, 20};
            app.layout_tauRref_escalones.ColumnSpacing = 2;
            app.layout_tauRref_escalones.RowSpacing = 2;
            app.layout_tauRref_escalones.Padding = [2 2 2 2];

            % Create label_tauRref_escalones_descripcion
            app.label_tauRref_escalones_descripcion = uilabel(app.layout_tauRref_escalones);
            app.label_tauRref_escalones_descripcion.Layout.Row = 1;
            app.label_tauRref_escalones_descripcion.Layout.Column = [1 2];
            app.label_tauRref_escalones_descripcion.Interpreter = 'latex';
            app.label_tauRref_escalones_descripcion.Text = 'Tren de escalones hasta referencia';

            % Create label_tauRref_escalones_valref
            app.label_tauRref_escalones_valref = uilabel(app.layout_tauRref_escalones);
            app.label_tauRref_escalones_valref.Layout.Row = 2;
            app.label_tauRref_escalones_valref.Layout.Column = 1;
            app.label_tauRref_escalones_valref.Interpreter = 'latex';
            app.label_tauRref_escalones_valref.Text = 'Valor de referencia [N m]';

            % Create editField_tauRref_escalones_valref
            app.editField_tauRref_escalones_valref = uieditfield(app.layout_tauRref_escalones, 'numeric');
            app.editField_tauRref_escalones_valref.ValueChangedFcn = createCallbackFcn(app, @editField_tauRref_escalones_valrefValueChanged, true);
            app.editField_tauRref_escalones_valref.Layout.Row = 2;
            app.editField_tauRref_escalones_valref.Layout.Column = 2;
            app.editField_tauRref_escalones_valref.Value = 0;

            % Create label_tauRref_escalones_tescalon
            app.label_tauRref_escalones_tescalon = uilabel(app.layout_tauRref_escalones);
            app.label_tauRref_escalones_tescalon.Layout.Row = 3;
            app.label_tauRref_escalones_tescalon.Layout.Column = 1;
            app.label_tauRref_escalones_tescalon.Interpreter = 'latex';
            app.label_tauRref_escalones_tescalon.Text = 'Tiempo entre escalones [s]';

            % Create editField_tauRref_escalones_tescalon
            app.editField_tauRref_escalones_tescalon = uieditfield(app.layout_tauRref_escalones, 'numeric');
            app.editField_tauRref_escalones_tescalon.ValueChangedFcn = createCallbackFcn(app, @editField_tauRref_escalones_tescalonValueChanged, true);
            app.editField_tauRref_escalones_tescalon.Layout.Row = 3;
            app.editField_tauRref_escalones_tescalon.Layout.Column = 2;
            app.editField_tauRref_escalones_tescalon.Value = 2.5;

            % Create tab_tauRref_timeseries
            app.tab_tauRref_timeseries = uitab(app.tabGroup_tauRref_perfiles);
            app.tab_tauRref_timeseries.Title = 'Timeseries';

            % Create layout_tauRref_timeseries
            app.layout_tauRref_timeseries = uigridlayout(app.tab_tauRref_timeseries);
            app.layout_tauRref_timeseries.ColumnWidth = {'3x','1x'};
            app.layout_tauRref_timeseries.RowHeight = {20, 20, 20, 25};
            app.layout_tauRref_timeseries.ColumnSpacing = 2;
            app.layout_tauRref_timeseries.RowSpacing = 2;
            app.layout_tauRref_timeseries.Padding = [2 2 2 2];

            % Create label_tauRref_timeseries_senal
            app.label_tauRref_timeseries_senal = uilabel(app.layout_tauRref_timeseries);
            app.label_tauRref_timeseries_senal.Layout.Row = 2;
            app.label_tauRref_timeseries_senal.Layout.Column = 1;
            app.label_tauRref_timeseries_senal.Interpreter = 'latex';
            app.label_tauRref_timeseries_senal.Text = 'Seleccionar señal';

            % Create spinner_tauRref_timeseries_senal
            app.spinner_tauRref_timeseries_senal = uispinner(app.layout_tauRref_timeseries);
            app.spinner_tauRref_timeseries_senal.Layout.Row = 2;
            app.spinner_tauRref_timeseries_senal.Limits = [1 Inf];
            app.spinner_tauRref_timeseries_senal.Layout.Column = 2;
            app.spinner_tauRref_timeseries_senal.Value = 1;
            app.spinner_tauRref_timeseries_senal.Enable = "off";

            % Create label_tauRref_timeseries_comentarios
            app.label_tauRref_timeseries_comentarios = uilabel(app.layout_tauRref_timeseries);
            app.label_tauRref_timeseries_comentarios.Layout.Row = 3;
            app.label_tauRref_timeseries_comentarios.Layout.Column = [1 2];
            app.label_tauRref_timeseries_comentarios.Interpreter = 'latex';
            app.label_tauRref_timeseries_comentarios.Text = 'La señal se va a muestrear a tstep';

            % Create button_tau_Rref_timeseries_preview
            app.button_tau_Rref_timeseries_preview = uibutton(app.layout_tauRref_timeseries, 'push');
            app.button_tau_Rref_timeseries_preview.ButtonPushedFcn = createCallbackFcn(app, @button_tau_Rref_timeseries_previewPushed, true);
            app.button_tau_Rref_timeseries_preview.Layout.Row = 4;
            app.button_tau_Rref_timeseries_preview.Layout.Column = [1 2];
            app.button_tau_Rref_timeseries_preview.Text = 'Previsualizar señal';
            app.button_tau_Rref_timeseries_preview.Enable = "off";

            % Create label_tauRref_timeseries_descripcion
            app.label_tauRref_timeseries_descripcion = uilabel(app.layout_tauRref_timeseries);
            app.label_tauRref_timeseries_descripcion.Layout.Row = 1;
            app.label_tauRref_timeseries_descripcion.Layout.Column = [1 2];
            app.label_tauRref_timeseries_descripcion.Interpreter = 'latex';
            app.label_tauRref_timeseries_descripcion.Text = 'Datos (double) de archivo (.mat)';

            % Create layout_tauRref_guardar_params
            app.layout_tauRref_guardar_params = uigridlayout(app.layout_tauRref_params);
            app.layout_tauRref_guardar_params.RowHeight = {'1x'};
            app.layout_tauRref_guardar_params.ColumnSpacing = 2;
            app.layout_tauRref_guardar_params.RowSpacing = 0;
            app.layout_tauRref_guardar_params.Padding = [2 0 2 0];
            app.layout_tauRref_guardar_params.Layout.Row = 3;
            app.layout_tauRref_guardar_params.Layout.Column = 1;

            % Create button_GuardarparamstauRref
            app.button_GuardarparamstauRref = uibutton(app.layout_tauRref_guardar_params, 'push');
            app.button_GuardarparamstauRref.ButtonPushedFcn = createCallbackFcn(app, @button_GuardarparamstauRrefPushed, true);
            app.button_GuardarparamstauRref.Layout.Row = 1;
            app.button_GuardarparamstauRref.Layout.Column = 2;
            app.button_GuardarparamstauRref.Text = 'Guardar parámetros';
            app.button_GuardarparamstauRref.Enable = "off";

            % Create button_LimpiarparamstauRref
            app.button_LimpiarparamstauRref = uibutton(app.layout_tauRref_guardar_params, 'push');
            app.button_LimpiarparamstauRref.ButtonPushedFcn = createCallbackFcn(app, @button_LimpiarparamstauRrefPushed, true);
            app.button_LimpiarparamstauRref.Layout.Row = 1;
            app.button_LimpiarparamstauRref.Layout.Column = 1;
            app.button_LimpiarparamstauRref.Text = 'Limpiar';
            app.button_LimpiarparamstauRref.Enable = "off";

            % Create layout_tauRref_cargar_params
            app.layout_tauRref_cargar_params = uigridlayout(app.layout_tauRref_params);
            app.layout_tauRref_cargar_params.ColumnWidth = {'5x', '12x'};
            app.layout_tauRref_cargar_params.RowHeight = {'1x'};
            app.layout_tauRref_cargar_params.ColumnSpacing = 5;
            app.layout_tauRref_cargar_params.RowSpacing = 0;
            app.layout_tauRref_cargar_params.Padding = [2 0 2 0];
            app.layout_tauRref_cargar_params.Layout.Row = 1;
            app.layout_tauRref_cargar_params.Layout.Column = 1;

            % Create button_tauRref_cargar_params
            app.button_tauRref_cargar_params = uibutton(app.layout_tauRref_cargar_params, 'push');
            app.button_tauRref_cargar_params.ButtonPushedFcn = createCallbackFcn(app, @button_tauRref_cargar_paramsButtonPushed, true);
            app.button_tauRref_cargar_params.Layout.Row = 1;
            app.button_tauRref_cargar_params.Layout.Column = 1;
            app.button_tauRref_cargar_params.Text = 'Cargar archivo';

            % Create label_tauRref_cargar_params
            app.label_tauRref_cargar_params = uilabel(app.layout_tauRref_cargar_params);
            app.label_tauRref_cargar_params.Layout.Row = 1;
            app.label_tauRref_cargar_params.Layout.Column = 2;
            app.label_tauRref_cargar_params.Text = 'Ningún archivo seleccionado';

            % Create panel_Sim_Resultados
            app.panel_Sim_Resultados = uipanel(app.layout_main);
            app.panel_Sim_Resultados.Title = 'Resultados de simulación';
            app.panel_Sim_Resultados.Layout.Row = 1;
            app.panel_Sim_Resultados.Layout.Column = 3;
            app.panel_Sim_Resultados.FontSize = 18;

            % Create layout_Sim_Resultados
            app.layout_Sim_Resultados = uigridlayout(app.panel_Sim_Resultados);
            app.layout_Sim_Resultados.RowHeight = {'1x', '1x', 40, 60};
            app.layout_Sim_Resultados.ColumnSpacing = 2;
            app.layout_Sim_Resultados.RowSpacing = 2;
            app.layout_Sim_Resultados.Padding = [2 2 2 2];

            % Create axes_torque
            app.axes_torque = uiaxes(app.layout_Sim_Resultados);
            title(app.axes_torque, 'Torque')
            xlabel(app.axes_torque, 'Tiempo')
            ylabel(app.axes_torque, 'Torque')
            app.axes_torque.Layout.Row = 1;
            app.axes_torque.Layout.Column = 1;

            % Create axes_etorque
            app.axes_etorque = uiaxes(app.layout_Sim_Resultados);
            title(app.axes_etorque, 'Error seguimiento de torque')
            xlabel(app.axes_etorque, 'Tiempo')
            ylabel(app.axes_etorque, 'Torque')
            app.axes_etorque.Layout.Row = 2;
            app.axes_etorque.Layout.Column = 1;

            % Create axes_velocidad
            app.axes_velocidad = uiaxes(app.layout_Sim_Resultados);
            title(app.axes_velocidad, 'Velocidad')
            xlabel(app.axes_velocidad, 'Tiempo')
            ylabel(app.axes_velocidad, 'Velocidad')
            app.axes_velocidad.Layout.Row = 1;
            app.axes_velocidad.Layout.Column = 2;

            % Create axes_potencia
            app.axes_potencia = uiaxes(app.layout_Sim_Resultados);
            title(app.axes_potencia, 'Potencia')
            xlabel(app.axes_potencia, 'Tiempo')
            ylabel(app.axes_potencia, 'Potencia')
            app.axes_potencia.Layout.Row = 2;
            app.axes_potencia.Layout.Column = 2;

            % Create layout_axes_voltajecorriente
            app.layout_axes_voltajecorriente = uigridlayout(app.layout_Sim_Resultados);
            app.layout_axes_voltajecorriente.RowHeight = {'1x'};
            app.layout_axes_voltajecorriente.ColumnSpacing = 2;
            app.layout_axes_voltajecorriente.RowSpacing = 2;
            app.layout_axes_voltajecorriente.Padding = [2 2 2 2];
            app.layout_axes_voltajecorriente.Layout.Row = 3;
            app.layout_axes_voltajecorriente.Layout.Column = 2;

            % Create button_sim_corriente
            app.button_sim_corriente = uibutton(app.layout_axes_voltajecorriente, 'push');
            app.button_sim_corriente.ButtonPushedFcn = createCallbackFcn(app, @button_sim_corrienteContrPushed, true);
            app.button_sim_corriente.Layout.Row = 1;
            app.button_sim_corriente.Layout.Column = 2;
            app.button_sim_corriente.Text = 'Corriente';
            app.button_sim_corriente.Enable = "off";

            % Create button_sim_voltaje
            app.button_sim_voltaje = uibutton(app.layout_axes_voltajecorriente, 'push');
            app.button_sim_voltaje.ButtonPushedFcn = createCallbackFcn(app, @button_sim_voltajeContrPushed, true);
            app.button_sim_voltaje.Layout.Row = 1;
            app.button_sim_voltaje.Layout.Column = 1;
            app.button_sim_voltaje.Text = 'Voltaje';
            app.button_sim_voltaje.Enable = "off";

            % Create label_sim_comentarios
            app.label_sim_comentarios = uilabel(app.layout_Sim_Resultados);
            app.label_sim_comentarios.Layout.Row = 3;
            app.label_sim_comentarios.Layout.Column = 1;
            app.label_sim_comentarios.FontSize = 16;
            app.label_sim_comentarios.Text = "";

            % Create button_Guardargraficas
            app.button_Guardargraficas = uibutton(app.layout_Sim_Resultados, 'push');
            app.button_Guardargraficas.ButtonPushedFcn = createCallbackFcn(app, @button_GuardargraficasPushed, true);
            app.button_Guardargraficas.FontSize = 18;
            app.button_Guardargraficas.Layout.Row = 4;
            app.button_Guardargraficas.Layout.Column = 2;
            app.button_Guardargraficas.Text = 'Guardar graficas';
            app.button_Guardargraficas.Enable = "off";

            % Create layout_tvis
            app.layout_tvis = uigridlayout(app.layout_Sim_Resultados);
            app.layout_tvis.ColumnWidth = {'3x','4x'};
            app.layout_tvis.RowHeight = {40,20};
            app.layout_tvis.ColumnSpacing = 0;
            app.layout_tvis.RowSpacing = 0;
            app.layout_tvis.Padding = [0 0 5 0];
            app.layout_tvis.Layout.Row = 4;
            app.layout_tvis.Layout.Column = 1;

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

            app.editFieldArr_IFOCparams_Inputdata = [app.editField_IOFC_psiRmagref,...
                 app.editField_IFOC_IntGanancia,app.editField_IFOC_IntCero,...
                 app.editFIeld_IFOC_CompPolos,app.editField_IFOC_CompCeros];

            app.editFieldArr_PBCparams_Inputdata = [app.editField_PBC_psiRmagref,...
                app.editField_PBC_KiS];

            app.tabArr_Contr = [app.tab_IFOCICAD,app.tab_PBC];

            app.editFieldArr_tauRrefparams_escalon_Inputdata = ...
                [app.editField_tauRref_escalon_valref,...
                 app.editField_tauRref_escalon_tinit,...
                 app.editField_tauRref_escalon_tfin];

            app.editFieldArr_tauRrefparams_rampa_Inputdata = ...
                [app.editField_tauRref_rampa_valref,...
                 app.editField_tauRref_rampa_tinit,...
                 app.editField_tauRref_rampa_tfin];

            app.editFieldArr_tauRrefparams_senoidal_Inputdata = ...
                [app.editField_tauRref_senoidal_valref,...
                app.editField_tauRref_senoidal_frecuencia,...
                app.editFIeld_tauRref_senoidal_tinit];

            app.editFieldArr_tauRrefparams_pol7_Inputdata = ...
                [app.editField_tauRref_pol7_valref,...
                 app.editField_tauRref_pol7_tinit,...
                 app.editField_tauRref_pol7_tfin];

            app.editFieldArr_tauRrefparams_trenescalones_Inputdata = ...
                [app.editField_tauRref_escalones_valref,...
                 app.editField_tauRref_escalones_tescalon];

            app.tabArr_tauRref = [app.tab_tauRref_cero,app.tab_tauRref_escalon...
                 app.tab_tauRref_rampa,app.tab_tauRref_senoidal,...
                 app.tab_tauRref_pol7,app.tab_tauRref_escalones,...
                 app.tab_tauRref_timeseries];

            app.figaxesArr = ...
                [app.axes_torque,app.axes_etorque,app.axes_velocidad,...
                 app.axes_potencia];
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = MI_Control_torque_simUI

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.figure_main)
            
            restoredefaultpath
            addpath Model\
            addpath TorqueRef_params\
            addpath Scripts\

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