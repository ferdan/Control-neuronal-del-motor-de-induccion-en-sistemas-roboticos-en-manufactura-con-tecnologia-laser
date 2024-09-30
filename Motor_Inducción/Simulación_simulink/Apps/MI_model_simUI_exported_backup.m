classdef MI_model_simUI_exported_backup < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                    matlab.ui.Figure
        layout_main                 matlab.ui.container.GridLayout
        panel_sim_results           matlab.ui.container.Panel
        layout_sim_results          matlab.ui.container.GridLayout
        GuardargraficasButton       matlab.ui.control.Button
        label_sim_comments          matlab.ui.control.Label
        layout_sim_grafs2           matlab.ui.container.GridLayout
        axes_torque                 matlab.ui.control.UIAxes
        axes_velocidad              matlab.ui.control.UIAxes
        axes_potencia               matlab.ui.control.UIAxes
        axes_voltaje                matlab.ui.control.UIAxes
        axes_corriente              matlab.ui.control.UIAxes
        layout_param_main           matlab.ui.container.GridLayout
        panel_MI_params             matlab.ui.container.Panel
        layout_MI_params            matlab.ui.container.GridLayout
        layout_MI_data              matlab.ui.container.GridLayout
        panel_mechparams            matlab.ui.container.Panel
        layout_mechparams           matlab.ui.container.GridLayout
        label_me01_J                matlab.ui.control.Label
        editField_me01_J            matlab.ui.control.NumericEditField
        JLabel                      matlab.ui.control.Label
        label_me02_b                matlab.ui.control.Label
        editField_me02_b            matlab.ui.control.NumericEditField
        bLabel                      matlab.ui.control.Label
        panel_elecparams            matlab.ui.container.Panel
        layout_elecparams           matlab.ui.container.GridLayout
        label_el01_np               matlab.ui.control.Label
        editField_el01_np           matlab.ui.control.NumericEditField
        label_el02_RS               matlab.ui.control.Label
        editField_el02_RS           matlab.ui.control.NumericEditField
        label_el03_RR               matlab.ui.control.Label
        editField_el03_RR           matlab.ui.control.NumericEditField
        label_el04_LS               matlab.ui.control.Label
        editField_el04_LS           matlab.ui.control.NumericEditField
        label_el05_LR               matlab.ui.control.Label
        editField_el05_LR           matlab.ui.control.NumericEditField
        label_el06_M                matlab.ui.control.Label
        editField_el06_M            matlab.ui.control.NumericEditField
        label_el07_sigma            matlab.ui.control.Label
        editField_el07_gamma        matlab.ui.control.NumericEditField
        label_el08_gamma            matlab.ui.control.Label
        Label_2                     matlab.ui.control.Label
        editField_el08_sigma        matlab.ui.control.NumericEditField
        Label                       matlab.ui.control.Label
        MLabel                      matlab.ui.control.Label
        LRLabel                     matlab.ui.control.Label
        LSLabel                     matlab.ui.control.Label
        RRLabel                     matlab.ui.control.Label
        RSLabel                     matlab.ui.control.Label
        npLabel                     matlab.ui.control.Label
        panel_valnoms               matlab.ui.container.Panel
        layout_valnoms              matlab.ui.container.GridLayout
        label_nom01_Pnom            matlab.ui.control.Label
        PnomLabel                   matlab.ui.control.Label
        editField_nom01_Pnom        matlab.ui.control.NumericEditField
        label_nom02_VSrmsnom        matlab.ui.control.Label
        editField_nom02_VSrmsnom    matlab.ui.control.NumericEditField
        label_nom03_ISrmsnom        matlab.ui.control.Label
        editField_nom03_ISrmsnom    matlab.ui.control.NumericEditField
        label_nom04_psi_Rmagnom     matlab.ui.control.Label
        editField_nom04_psiRmagnom  matlab.ui.control.NumericEditField
        label_nom05_wRnom           matlab.ui.control.Label
        editField_nom05_wRnom       matlab.ui.control.NumericEditField
        label_nom06_tauRnom         matlab.ui.control.Label
        editField_nom06_tauRnom     matlab.ui.control.NumericEditField
        tauRnomLabel                matlab.ui.control.Label
        wRnomLabel                  matlab.ui.control.Label
        psiRnomLabel                matlab.ui.control.Label
        ISrmsnomLabel               matlab.ui.control.Label
        VSrmsnomLabel               matlab.ui.control.Label
        layout_MI_cargar_params     matlab.ui.container.GridLayout
        label_MI_archivo            matlab.ui.control.Label
        button_MI_archivo           matlab.ui.control.Button
        layout_MI_guardar_params    matlab.ui.container.GridLayout
        button_Guardarparams        matlab.ui.control.Button
        checkBox_Modificarparams    matlab.ui.control.CheckBox
        panel_sim_params            matlab.ui.container.Panel
        layout_sim                  matlab.ui.container.GridLayout
        button_Simular              matlab.ui.control.Button
        layout_sim_params           matlab.ui.container.GridLayout
        label_sim01_tsim            matlab.ui.control.Label
        editField_sim01_tsim        matlab.ui.control.NumericEditField
        label_sim02_tstep           matlab.ui.control.Label
        editField_sim02_tstep       matlab.ui.control.NumericEditField
        tstepLabel                  matlab.ui.control.Label
        tsimLabel                   matlab.ui.control.Label
        label_sim03_metodo          matlab.ui.control.Label
        label_sim03_ODE5            matlab.ui.control.Label
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: button_Simular
        function button_SimularButtonPushed(app, event)
            
            Pnomval = app.editField_nom01_Pnom.Value;
            v_Srmsnomval = app.editField_nom02_VSrmsnom.Value;

            n_p = app.editField_el01_np.Value;
            R_Sval = app.editField_el02_RS.Value;
            R_Rval = app.editField_el03_RR.Value;
            L_Sval = app.editField_el04_LS.Value;
            L_Rval = app.editField_el05_LR.Value;
            Mval = app.editField_el06_M.Value;

            w_Rnomval = app.editField_nom05_wRnom.Value;

            i_Srmsnomval = 0;
            tau_Rnomval = 0;
            psi_Rmagnomval = 0;

            if v_Srmsnomval > 0
                i_Srmsnomval = Pnomval/v_Srmsnomval;
                app.editField_nom03_ISrmsnom.Value = i_Srmsnomval;
                psi_Rmagnomval = Mval*i_Srmsnom/sqrt(2);
                app.editField_nom04_psiRmagnom.Value = psi_Rmagnomval;
            else
                %throw('v_Srmsnom is cero');
                app.label_sim_comments.Text = app.label_sim_comments.Text + "v_Srmsnom is not valid\n";
            end

            if w_Rnomval > 0
                tau_Rnomval = Pnomval/w_Rnomval;
                app.editField_nom06_tauRnom.Value = tau_Rnomval;
            else
                %throw('w_Rnomval is cero');
                app.label_sim_comments.Text = app.label_sim_comments.Text + "w_Rnom is not valid\n";
            end
            
            if L_Rval <= 0
                app.label_sim_comments.Text = app.label_sim_comments.Text + "L_R is not valid\n";
            end

            Jval = app.editField_me01_J.Value;
            bval = app.editField_me02_b.Value;

            MI_motor = MI_model(Pnomval,v_Srmsnomval,i_Srmsnomval,...
                                psi_Rmagnomval,w_Rnomval,tau_Rnomval,...
                                n_p,R_Sval,R_Rval,L_Sval,L_Rval,Mval,Jval,bval);

            app.editField_el08_sigma.Value = MI_motor.electric_params.sigma;
            app.editField_el09_gamma.Value = MI_motor.electric_params.gamma;

            tsim = app.editField_sim01_tsim.Value;
            tstep = app.editField_sim02_tstep.Value;

            out = sim('Modelo_MI_simulink1.slx');
            app.label_sim_comments.Text = "Simulacion ejecutada correctamente";

        end

        % Value changed function: editField_nom01_Pnom
        function editField_nom01_PnomValueChanged(app, event)
            app.button_Guardarparams.Enable = "on";
        end

        % Value changed function: editField_nom02_VSrmsnom
        function editField_nom02_VSrmsnomValueChanged(app, event)
            app.button_Guardarparams.Enable = "on";
        end

        % Value changed function: editField_nom05_wRnom
        function editField_nom05_wRnomValueChanged(app, event)
            app.button_Guardarparams.Enable = "on";
        end

        % Value changed function: editField_el01_np
        function editField_el01_npValueChanged(app, event)
            app.button_Guardarparams.Enable = "on";
        end

        % Value changed function: editField_el02_RS
        function editField_el02_RSValueChanged(app, event)
            app.button_Guardarparams.Enable = "on";
        end

        % Value changed function: editField_el03_RR
        function editField_el03_RRValueChanged(app, event)
            app.button_Guardarparams.Enable = "on";
        end

        % Value changed function: editField_el04_LS
        function editField_el04_LSValueChanged(app, event)
            app.button_Guardarparams.Enable = "on";
        end

        % Value changed function: editField_el05_LR
        function editField_el05_LRValueChanged(app, event)
            app.button_Guardarparams.Enable = "on";
        end

        % Value changed function: editField_el06_M
        function editField_el06_MValueChanged(app, event)
            app.button_Guardarparams.Enable = "on";
        end

        % Value changed function: editField_me02_b
        function editField_me02_bValueChanged(app, event)
            app.button_Guardarparams.Enable = "on";
        end

        % Value changed function: editField_me01_J
        function editField_me01_JValueChanged(app, event)
            app.button_Guardarparams.Enable = "on";
        end

        % Button pushed function: button_MI_archivo
        function button_MI_archivoButtonPushed(app, event)
            
        end

        % Value changed function: checkBox_Modificarparams
        function checkBox_ModificarparamsValueChanged(app, event)
            value = app.checkBox_Modificarparams.Value;
            
        end

        % Button pushed function: GuardargraficasButton
        function GuardargraficasButtonPushed(app, event)
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [1 1 1367 768];
            app.UIFigure.Name = 'MATLAB App';

            % Create layout_main
            app.layout_main = uigridlayout(app.UIFigure);
            app.layout_main.ColumnWidth = {375, '1x'};
            app.layout_main.RowHeight = {'1x'};

            % Create layout_param_main
            app.layout_param_main = uigridlayout(app.layout_main);
            app.layout_param_main.ColumnWidth = {'1x'};
            app.layout_param_main.RowHeight = {'3x', '1x'};
            app.layout_param_main.ColumnSpacing = 0;
            app.layout_param_main.RowSpacing = 5;
            app.layout_param_main.Padding = [0 2 0 2];
            app.layout_param_main.Layout.Row = 1;
            app.layout_param_main.Layout.Column = 1;

            % Create panel_sim_params
            app.panel_sim_params = uipanel(app.layout_param_main);
            app.panel_sim_params.Title = 'Parametros de simulacion';
            app.panel_sim_params.Layout.Row = 2;
            app.panel_sim_params.Layout.Column = 1;

            % Create layout_sim
            app.layout_sim = uigridlayout(app.panel_sim_params);
            app.layout_sim.ColumnWidth = {'1x'};
            app.layout_sim.RowHeight = {'1x', 40};

            % Create layout_sim_params
            app.layout_sim_params = uigridlayout(app.layout_sim);
            app.layout_sim_params.ColumnWidth = {'3x', '1x'};
            app.layout_sim_params.RowHeight = {20, 20, 20};
            app.layout_sim_params.ColumnSpacing = 0;
            app.layout_sim_params.RowSpacing = 2;
            app.layout_sim_params.Padding = [0 2 0 2];
            app.layout_sim_params.Layout.Row = 1;
            app.layout_sim_params.Layout.Column = 1;

            % Create label_sim03_ODE5
            app.label_sim03_ODE5 = uilabel(app.layout_sim_params);
            app.label_sim03_ODE5.HorizontalAlignment = 'center';
            app.label_sim03_ODE5.Layout.Row = 3;
            app.label_sim03_ODE5.Layout.Column = 2;
            app.label_sim03_ODE5.Text = 'ODE5';

            % Create label_sim03_metodo
            app.label_sim03_metodo = uilabel(app.layout_sim_params);
            app.label_sim03_metodo.Layout.Row = 3;
            app.label_sim03_metodo.Layout.Column = 1;
            app.label_sim03_metodo.Text = 'Método Numérico';

            % Create tsimLabel
            app.tsimLabel = uilabel(app.layout_sim_params);
            app.tsimLabel.HorizontalAlignment = 'right';
            app.tsimLabel.Layout.Row = 1;
            app.tsimLabel.Layout.Column = 1;
            app.tsimLabel.Text = 'tsim: ';

            % Create tstepLabel
            app.tstepLabel = uilabel(app.layout_sim_params);
            app.tstepLabel.HorizontalAlignment = 'right';
            app.tstepLabel.Layout.Row = 2;
            app.tstepLabel.Layout.Column = 1;
            app.tstepLabel.Text = 'tstep: ';

            % Create editField_sim02_tstep
            app.editField_sim02_tstep = uieditfield(app.layout_sim_params, 'numeric');
            app.editField_sim02_tstep.Layout.Row = 2;
            app.editField_sim02_tstep.Layout.Column = 2;
            app.editField_sim02_tstep.Value = 0.0001;

            % Create label_sim02_tstep
            app.label_sim02_tstep = uilabel(app.layout_sim_params);
            app.label_sim02_tstep.Layout.Row = 2;
            app.label_sim02_tstep.Layout.Column = 1;
            app.label_sim02_tstep.Text = 'Paso de integración (Fijo)';

            % Create editField_sim01_tsim
            app.editField_sim01_tsim = uieditfield(app.layout_sim_params, 'numeric');
            app.editField_sim01_tsim.Layout.Row = 1;
            app.editField_sim01_tsim.Layout.Column = 2;
            app.editField_sim01_tsim.Value = 15;

            % Create label_sim01_tsim
            app.label_sim01_tsim = uilabel(app.layout_sim_params);
            app.label_sim01_tsim.Layout.Row = 1;
            app.label_sim01_tsim.Layout.Column = 1;
            app.label_sim01_tsim.Text = 'Tiempo de simulación';

            % Create button_Simular
            app.button_Simular = uibutton(app.layout_sim, 'push');
            app.button_Simular.ButtonPushedFcn = createCallbackFcn(app, @button_SimularButtonPushed, true);
            app.button_Simular.FontSize = 18;
            app.button_Simular.Layout.Row = 2;
            app.button_Simular.Layout.Column = 1;
            app.button_Simular.Text = 'Simular';

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

            % Create layout_MI_guardar_params
            app.layout_MI_guardar_params = uigridlayout(app.layout_MI_params);
            app.layout_MI_guardar_params.ColumnWidth = {'12x', '5x'};
            app.layout_MI_guardar_params.RowHeight = {'1x'};
            app.layout_MI_guardar_params.ColumnSpacing = 0;
            app.layout_MI_guardar_params.RowSpacing = 0;
            app.layout_MI_guardar_params.Padding = [0 0 0 0];
            app.layout_MI_guardar_params.Layout.Row = 3;
            app.layout_MI_guardar_params.Layout.Column = 1;

            % Create checkBox_Modificarparams
            app.checkBox_Modificarparams = uicheckbox(app.layout_MI_guardar_params);
            app.checkBox_Modificarparams.ValueChangedFcn = createCallbackFcn(app, @checkBox_ModificarparamsValueChanged, true);
            app.checkBox_Modificarparams.Text = 'Modificar manualmente';
            app.checkBox_Modificarparams.Layout.Row = 1;
            app.checkBox_Modificarparams.Layout.Column = 1;

            % Create button_Guardarparams
            app.button_Guardarparams = uibutton(app.layout_MI_guardar_params, 'push');
            app.button_Guardarparams.Enable = 'off';
            app.button_Guardarparams.Layout.Row = 1;
            app.button_Guardarparams.Layout.Column = 2;
            app.button_Guardarparams.Text = 'Guadar';

            % Create layout_MI_cargar_params
            app.layout_MI_cargar_params = uigridlayout(app.layout_MI_params);
            app.layout_MI_cargar_params.ColumnWidth = {'5x', '12x'};
            app.layout_MI_cargar_params.RowHeight = {'1x'};
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
            app.layout_MI_data.RowHeight = {'7x', '9x', '3x'};
            app.layout_MI_data.ColumnSpacing = 0;
            app.layout_MI_data.RowSpacing = 5;
            app.layout_MI_data.Padding = [0 5 0 5];
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
            app.layout_valnoms.Padding = [0 2 2 2];

            % Create VSrmsnomLabel
            app.VSrmsnomLabel = uilabel(app.layout_valnoms);
            app.VSrmsnomLabel.HorizontalAlignment = 'right';
            app.VSrmsnomLabel.Layout.Row = 2;
            app.VSrmsnomLabel.Layout.Column = 1;
            app.VSrmsnomLabel.Text = 'VSrmsnom: ';

            % Create ISrmsnomLabel
            app.ISrmsnomLabel = uilabel(app.layout_valnoms);
            app.ISrmsnomLabel.HorizontalAlignment = 'right';
            app.ISrmsnomLabel.Layout.Row = 3;
            app.ISrmsnomLabel.Layout.Column = 1;
            app.ISrmsnomLabel.Text = 'ISrmsnom: ';

            % Create psiRnomLabel
            app.psiRnomLabel = uilabel(app.layout_valnoms);
            app.psiRnomLabel.HorizontalAlignment = 'right';
            app.psiRnomLabel.Layout.Row = 4;
            app.psiRnomLabel.Layout.Column = 1;
            app.psiRnomLabel.Text = '||psiRnom||: ';

            % Create wRnomLabel
            app.wRnomLabel = uilabel(app.layout_valnoms);
            app.wRnomLabel.HorizontalAlignment = 'right';
            app.wRnomLabel.Layout.Row = 5;
            app.wRnomLabel.Layout.Column = 1;
            app.wRnomLabel.Text = 'wRnom: ';

            % Create tauRnomLabel
            app.tauRnomLabel = uilabel(app.layout_valnoms);
            app.tauRnomLabel.HorizontalAlignment = 'right';
            app.tauRnomLabel.Layout.Row = 6;
            app.tauRnomLabel.Layout.Column = 1;
            app.tauRnomLabel.Text = 'tauRnom: ';

            % Create editField_nom06_tauRnom
            app.editField_nom06_tauRnom = uieditfield(app.layout_valnoms, 'numeric');
            app.editField_nom06_tauRnom.Enable = 'off';
            app.editField_nom06_tauRnom.Layout.Row = 6;
            app.editField_nom06_tauRnom.Layout.Column = 2;

            % Create label_nom06_tauRnom
            app.label_nom06_tauRnom = uilabel(app.layout_valnoms);
            app.label_nom06_tauRnom.Interpreter = 'latex';
            app.label_nom06_tauRnom.Layout.Row = 6;
            app.label_nom06_tauRnom.Layout.Column = 1;
            app.label_nom06_tauRnom.Text = 'Torque nominal [N m]';

            % Create editField_nom05_wRnom
            app.editField_nom05_wRnom = uieditfield(app.layout_valnoms, 'numeric');
            app.editField_nom05_wRnom.ValueChangedFcn = createCallbackFcn(app, @editField_nom05_wRnomValueChanged, true);
            app.editField_nom05_wRnom.Layout.Row = 5;
            app.editField_nom05_wRnom.Layout.Column = 2;

            % Create label_nom05_wRnom
            app.label_nom05_wRnom = uilabel(app.layout_valnoms);
            app.label_nom05_wRnom.Interpreter = 'latex';
            app.label_nom05_wRnom.Layout.Row = 5;
            app.label_nom05_wRnom.Layout.Column = 1;
            app.label_nom05_wRnom.Text = 'Velocidad nominal [rad/s]';

            % Create editField_nom04_psiRmagnom
            app.editField_nom04_psiRmagnom = uieditfield(app.layout_valnoms, 'numeric');
            app.editField_nom04_psiRmagnom.Enable = 'off';
            app.editField_nom04_psiRmagnom.Layout.Row = 4;
            app.editField_nom04_psiRmagnom.Layout.Column = 2;

            % Create label_nom04_psi_Rmagnom
            app.label_nom04_psi_Rmagnom = uilabel(app.layout_valnoms);
            app.label_nom04_psi_Rmagnom.Interpreter = 'latex';
            app.label_nom04_psi_Rmagnom.Layout.Row = 4;
            app.label_nom04_psi_Rmagnom.Layout.Column = 1;
            app.label_nom04_psi_Rmagnom.Text = 'Magnitud de flujo nominal [Wb vuelta]';

            % Create editField_nom03_ISrmsnom
            app.editField_nom03_ISrmsnom = uieditfield(app.layout_valnoms, 'numeric');
            app.editField_nom03_ISrmsnom.Enable = 'off';
            app.editField_nom03_ISrmsnom.Layout.Row = 3;
            app.editField_nom03_ISrmsnom.Layout.Column = 2;

            % Create label_nom03_ISrmsnom
            app.label_nom03_ISrmsnom = uilabel(app.layout_valnoms);
            app.label_nom03_ISrmsnom.Interpreter = 'latex';
            app.label_nom03_ISrmsnom.Layout.Row = 3;
            app.label_nom03_ISrmsnom.Layout.Column = 1;
            app.label_nom03_ISrmsnom.Text = 'Corriente rms nominal [A]';

            % Create editField_nom02_VSrmsnom
            app.editField_nom02_VSrmsnom = uieditfield(app.layout_valnoms, 'numeric');
            app.editField_nom02_VSrmsnom.ValueChangedFcn = createCallbackFcn(app, @editField_nom02_VSrmsnomValueChanged, true);
            app.editField_nom02_VSrmsnom.Layout.Row = 2;
            app.editField_nom02_VSrmsnom.Layout.Column = 2;

            % Create label_nom02_VSrmsnom
            app.label_nom02_VSrmsnom = uilabel(app.layout_valnoms);
            app.label_nom02_VSrmsnom.Interpreter = 'latex';
            app.label_nom02_VSrmsnom.Layout.Row = 2;
            app.label_nom02_VSrmsnom.Layout.Column = 1;
            app.label_nom02_VSrmsnom.Text = 'Voltaje rms nominal [V]';

            % Create editField_nom01_Pnom
            app.editField_nom01_Pnom = uieditfield(app.layout_valnoms, 'numeric');
            app.editField_nom01_Pnom.ValueChangedFcn = createCallbackFcn(app, @editField_nom01_PnomValueChanged, true);
            app.editField_nom01_Pnom.Layout.Row = 1;
            app.editField_nom01_Pnom.Layout.Column = 2;

            % Create PnomLabel
            app.PnomLabel = uilabel(app.layout_valnoms);
            app.PnomLabel.HorizontalAlignment = 'right';
            app.PnomLabel.Layout.Row = 1;
            app.PnomLabel.Layout.Column = 1;
            app.PnomLabel.Text = 'Pnom: ';

            % Create label_nom01_Pnom
            app.label_nom01_Pnom = uilabel(app.layout_valnoms);
            app.label_nom01_Pnom.Interpreter = 'latex';
            app.label_nom01_Pnom.Layout.Row = 1;
            app.label_nom01_Pnom.Layout.Column = 1;
            app.label_nom01_Pnom.Text = 'Potencia nominal [W]';

            % Create panel_elecparams
            app.panel_elecparams = uipanel(app.layout_MI_data);
            app.panel_elecparams.Title = 'Parametros eléctricos';
            app.panel_elecparams.Layout.Row = 2;
            app.panel_elecparams.Layout.Column = 1;
            app.panel_elecparams.FontSize = 18;

            % Create layout_elecparams
            app.layout_elecparams = uigridlayout(app.panel_elecparams);
            app.layout_elecparams.ColumnWidth = {'5x', '1x'};
            app.layout_elecparams.RowHeight = {20, 20, 20, 20, 20, 20, 20, 20};
            app.layout_elecparams.ColumnSpacing = 0;
            app.layout_elecparams.RowSpacing = 2;
            app.layout_elecparams.Padding = [0 2 2 2];

            % Create npLabel
            app.npLabel = uilabel(app.layout_elecparams);
            app.npLabel.HorizontalAlignment = 'right';
            app.npLabel.Layout.Row = 1;
            app.npLabel.Layout.Column = 1;
            app.npLabel.Text = 'np: ';

            % Create RSLabel
            app.RSLabel = uilabel(app.layout_elecparams);
            app.RSLabel.HorizontalAlignment = 'right';
            app.RSLabel.Layout.Row = 2;
            app.RSLabel.Layout.Column = 1;
            app.RSLabel.Text = 'RS: ';

            % Create RRLabel
            app.RRLabel = uilabel(app.layout_elecparams);
            app.RRLabel.HorizontalAlignment = 'right';
            app.RRLabel.Layout.Row = 3;
            app.RRLabel.Layout.Column = 1;
            app.RRLabel.Text = 'RR: ';

            % Create LSLabel
            app.LSLabel = uilabel(app.layout_elecparams);
            app.LSLabel.HorizontalAlignment = 'right';
            app.LSLabel.Layout.Row = 4;
            app.LSLabel.Layout.Column = 1;
            app.LSLabel.Text = 'LS: ';

            % Create LRLabel
            app.LRLabel = uilabel(app.layout_elecparams);
            app.LRLabel.HorizontalAlignment = 'right';
            app.LRLabel.Layout.Row = 5;
            app.LRLabel.Layout.Column = 1;
            app.LRLabel.Text = 'LR: ';

            % Create MLabel
            app.MLabel = uilabel(app.layout_elecparams);
            app.MLabel.HorizontalAlignment = 'right';
            app.MLabel.Layout.Row = 6;
            app.MLabel.Layout.Column = 1;
            app.MLabel.Text = 'M: ';

            % Create Label
            app.Label = uilabel(app.layout_elecparams);
            app.Label.HorizontalAlignment = 'right';
            app.Label.Layout.Row = 7;
            app.Label.Layout.Column = 1;
            app.Label.Text = '=LS-M/LR ';

            % Create editField_el08_sigma
            app.editField_el08_sigma = uieditfield(app.layout_elecparams, 'numeric');
            app.editField_el08_sigma.Enable = 'off';
            app.editField_el08_sigma.Layout.Row = 7;
            app.editField_el08_sigma.Layout.Column = 2;

            % Create Label_2
            app.Label_2 = uilabel(app.layout_elecparams);
            app.Label_2.HorizontalAlignment = 'right';
            app.Label_2.Layout.Row = 8;
            app.Label_2.Layout.Column = 1;
            app.Label_2.Text = '=(RS*LR^2+RR*M^2)/(sigma*LR^2) ';

            % Create label_el08_gamma
            app.label_el08_gamma = uilabel(app.layout_elecparams);
            app.label_el08_gamma.Interpreter = 'latex';
            app.label_el08_gamma.Layout.Row = 8;
            app.label_el08_gamma.Layout.Column = 1;
            app.label_el08_gamma.Text = 'Factor $\gamma$ $[\Omega]$';

            % Create editField_el07_gamma
            app.editField_el07_gamma = uieditfield(app.layout_elecparams, 'numeric');
            app.editField_el07_gamma.Enable = 'off';
            app.editField_el07_gamma.Layout.Row = 8;
            app.editField_el07_gamma.Layout.Column = 2;

            % Create label_el07_sigma
            app.label_el07_sigma = uilabel(app.layout_elecparams);
            app.label_el07_sigma.Interpreter = 'latex';
            app.label_el07_sigma.Layout.Row = 7;
            app.label_el07_sigma.Layout.Column = 1;
            app.label_el07_sigma.Text = 'Factor de dispersión $\sigma$ []';

            % Create editField_el06_M
            app.editField_el06_M = uieditfield(app.layout_elecparams, 'numeric');
            app.editField_el06_M.ValueChangedFcn = createCallbackFcn(app, @editField_el06_MValueChanged, true);
            app.editField_el06_M.Layout.Row = 6;
            app.editField_el06_M.Layout.Column = 2;

            % Create label_el06_M
            app.label_el06_M = uilabel(app.layout_elecparams);
            app.label_el06_M.Interpreter = 'latex';
            app.label_el06_M.Layout.Row = 6;
            app.label_el06_M.Layout.Column = 1;
            app.label_el06_M.Text = 'Inductancia mutua [H]';

            % Create editField_el05_LR
            app.editField_el05_LR = uieditfield(app.layout_elecparams, 'numeric');
            app.editField_el05_LR.ValueChangedFcn = createCallbackFcn(app, @editField_el05_LRValueChanged, true);
            app.editField_el05_LR.Layout.Row = 5;
            app.editField_el05_LR.Layout.Column = 2;

            % Create label_el05_LR
            app.label_el05_LR = uilabel(app.layout_elecparams);
            app.label_el05_LR.Interpreter = 'latex';
            app.label_el05_LR.Layout.Row = 5;
            app.label_el05_LR.Layout.Column = 1;
            app.label_el05_LR.Text = 'Inductancia de devanados de rotor [H]';

            % Create editField_el04_LS
            app.editField_el04_LS = uieditfield(app.layout_elecparams, 'numeric');
            app.editField_el04_LS.ValueChangedFcn = createCallbackFcn(app, @editField_el04_LSValueChanged, true);
            app.editField_el04_LS.Layout.Row = 4;
            app.editField_el04_LS.Layout.Column = 2;

            % Create label_el04_LS
            app.label_el04_LS = uilabel(app.layout_elecparams);
            app.label_el04_LS.Interpreter = 'latex';
            app.label_el04_LS.Layout.Row = 4;
            app.label_el04_LS.Layout.Column = 1;
            app.label_el04_LS.Text = 'Inductancia de devanados de estator [H]';

            % Create editField_el03_RR
            app.editField_el03_RR = uieditfield(app.layout_elecparams, 'numeric');
            app.editField_el03_RR.ValueChangedFcn = createCallbackFcn(app, @editField_el03_RRValueChanged, true);
            app.editField_el03_RR.Layout.Row = 3;
            app.editField_el03_RR.Layout.Column = 2;

            % Create label_el03_RR
            app.label_el03_RR = uilabel(app.layout_elecparams);
            app.label_el03_RR.Interpreter = 'latex';
            app.label_el03_RR.Layout.Row = 3;
            app.label_el03_RR.Layout.Column = 1;
            app.label_el03_RR.Text = 'Resistencia de devanados de rotor $[\Omega]$';

            % Create editField_el02_RS
            app.editField_el02_RS = uieditfield(app.layout_elecparams, 'numeric');
            app.editField_el02_RS.ValueChangedFcn = createCallbackFcn(app, @editField_el02_RSValueChanged, true);
            app.editField_el02_RS.Layout.Row = 2;
            app.editField_el02_RS.Layout.Column = 2;

            % Create label_el02_RS
            app.label_el02_RS = uilabel(app.layout_elecparams);
            app.label_el02_RS.Interpreter = 'latex';
            app.label_el02_RS.Layout.Row = 2;
            app.label_el02_RS.Layout.Column = 1;
            app.label_el02_RS.Text = 'Resistencia de devanados de estator $[\Omega]$';

            % Create editField_el01_np
            app.editField_el01_np = uieditfield(app.layout_elecparams, 'numeric');
            app.editField_el01_np.ValueChangedFcn = createCallbackFcn(app, @editField_el01_npValueChanged, true);
            app.editField_el01_np.Layout.Row = 1;
            app.editField_el01_np.Layout.Column = 2;

            % Create label_el01_np
            app.label_el01_np = uilabel(app.layout_elecparams);
            app.label_el01_np.Interpreter = 'latex';
            app.label_el01_np.Layout.Row = 1;
            app.label_el01_np.Layout.Column = 1;
            app.label_el01_np.Text = 'Número de pares de polos';

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
            app.layout_mechparams.Padding = [0 2 2 2];

            % Create bLabel
            app.bLabel = uilabel(app.layout_mechparams);
            app.bLabel.HorizontalAlignment = 'right';
            app.bLabel.Layout.Row = 2;
            app.bLabel.Layout.Column = 1;
            app.bLabel.Text = 'b: ';

            % Create editField_me02_b
            app.editField_me02_b = uieditfield(app.layout_mechparams, 'numeric');
            app.editField_me02_b.ValueChangedFcn = createCallbackFcn(app, @editField_me02_bValueChanged, true);
            app.editField_me02_b.Layout.Row = 2;
            app.editField_me02_b.Layout.Column = 2;

            % Create label_me02_b
            app.label_me02_b = uilabel(app.layout_mechparams);
            app.label_me02_b.Interpreter = 'latex';
            app.label_me02_b.Layout.Row = 2;
            app.label_me02_b.Layout.Column = 1;
            app.label_me02_b.Text = 'Coeficiente de fricción';

            % Create JLabel
            app.JLabel = uilabel(app.layout_mechparams);
            app.JLabel.HorizontalAlignment = 'right';
            app.JLabel.Layout.Row = 1;
            app.JLabel.Layout.Column = 1;
            app.JLabel.Text = 'J: ';

            % Create editField_me01_J
            app.editField_me01_J = uieditfield(app.layout_mechparams, 'numeric');
            app.editField_me01_J.ValueChangedFcn = createCallbackFcn(app, @editField_me01_JValueChanged, true);
            app.editField_me01_J.Layout.Row = 1;
            app.editField_me01_J.Layout.Column = 2;

            % Create label_me01_J
            app.label_me01_J = uilabel(app.layout_mechparams);
            app.label_me01_J.Interpreter = 'latex';
            app.label_me01_J.Layout.Row = 1;
            app.label_me01_J.Layout.Column = 1;
            app.label_me01_J.Text = 'Inercia del rotor [kg m^2]';

            % Create panel_sim_results
            app.panel_sim_results = uipanel(app.layout_main);
            app.panel_sim_results.Title = 'Resultados de la simulación';
            app.panel_sim_results.Layout.Row = 1;
            app.panel_sim_results.Layout.Column = 2;
            app.panel_sim_results.FontSize = 18;

            % Create layout_sim_results
            app.layout_sim_results = uigridlayout(app.panel_sim_results);
            app.layout_sim_results.ColumnWidth = {'1x', '1x', '1x'};
            app.layout_sim_results.RowHeight = {'1x', 40};

            % Create axes_corriente
            app.axes_corriente = uiaxes(app.layout_sim_results);
            title(app.axes_corriente, 'Title')
            xlabel(app.axes_corriente, 'X')
            ylabel(app.axes_corriente, 'Y')
            zlabel(app.axes_corriente, 'Z')
            app.axes_corriente.Layout.Row = 1;
            app.axes_corriente.Layout.Column = 2;

            % Create axes_voltaje
            app.axes_voltaje = uiaxes(app.layout_sim_results);
            title(app.axes_voltaje, 'Title')
            xlabel(app.axes_voltaje, 'X')
            ylabel(app.axes_voltaje, 'Y')
            zlabel(app.axes_voltaje, 'Z')
            app.axes_voltaje.Layout.Row = 1;
            app.axes_voltaje.Layout.Column = 1;

            % Create layout_sim_grafs2
            app.layout_sim_grafs2 = uigridlayout(app.layout_sim_results);
            app.layout_sim_grafs2.ColumnWidth = {'1x'};
            app.layout_sim_grafs2.RowHeight = {'1x', '1x', '1x'};
            app.layout_sim_grafs2.Layout.Row = 1;
            app.layout_sim_grafs2.Layout.Column = 3;

            % Create axes_potencia
            app.axes_potencia = uiaxes(app.layout_sim_grafs2);
            title(app.axes_potencia, 'Title')
            xlabel(app.axes_potencia, 'X')
            ylabel(app.axes_potencia, 'Y')
            zlabel(app.axes_potencia, 'Z')
            app.axes_potencia.Layout.Row = 3;
            app.axes_potencia.Layout.Column = 1;

            % Create axes_velocidad
            app.axes_velocidad = uiaxes(app.layout_sim_grafs2);
            title(app.axes_velocidad, 'Title')
            xlabel(app.axes_velocidad, 'X')
            ylabel(app.axes_velocidad, 'Y')
            zlabel(app.axes_velocidad, 'Z')
            app.axes_velocidad.Layout.Row = 2;
            app.axes_velocidad.Layout.Column = 1;

            % Create axes_torque
            app.axes_torque = uiaxes(app.layout_sim_grafs2);
            title(app.axes_torque, 'Title')
            xlabel(app.axes_torque, 'X')
            ylabel(app.axes_torque, 'Y')
            zlabel(app.axes_torque, 'Z')
            app.axes_torque.Layout.Row = 1;
            app.axes_torque.Layout.Column = 1;

            % Create label_sim_comments
            app.label_sim_comments = uilabel(app.layout_sim_results);
            app.label_sim_comments.Layout.Row = 2;
            app.label_sim_comments.Layout.Column = 1;
            app.label_sim_comments.Text = ' ';

            % Create GuardargraficasButton
            app.GuardargraficasButton = uibutton(app.layout_sim_results, 'push');
            app.GuardargraficasButton.ButtonPushedFcn = createCallbackFcn(app, @GuardargraficasButtonPushed, true);
            app.GuardargraficasButton.FontSize = 18;
            app.GuardargraficasButton.Layout.Row = 2;
            app.GuardargraficasButton.Layout.Column = 3;
            app.GuardargraficasButton.Text = 'Guardar graficas';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = MI_model_simUI_exported_backup

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end