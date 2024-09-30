classdef app2_Controlador_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure

        layout_main                     matlab.ui.container.GridLayout

        layout_Contr_tauRef_main        matlab.ui.container.GridLayout

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

        editField_psiRmagref            matlab.ui.control.NumericEditField
        psi_RrefLabel                   matlab.ui.control.Label
        label_IFOC_psiRmagref           matlab.ui.control.Label

        panel_IFOC_Integratordata       matlab.ui.container.Panel
        layout_Integratordata           matlab.ui.container.GridLayout

        label_IFOC_IntGanancia          matlab.ui.control.Label
        editField_IFOC_IntGanancia      matlab.ui.control.NumericEditField
        EditFieldLabel                  matlab.ui.control.Label

        label_IFOC_IntCero              matlab.ui.control.Label
        editField_IFOC_IntCero          matlab.ui.control.NumericEditField
        EditField2Label                 matlab.ui.control.Label

        panel_IFOC_Compensatordata      matlab.ui.container.Panel
        layout_IFOC_Compensatordata     matlab.ui.container.GridLayout

        label_IFOC_CompInstrucciones    matlab.ui.control.Label

        label_IFOC_CompPolos            matlab.ui.control.Label
        editField_IFOC_CompCeros        matlab.ui.control.EditField
        EditField4Label                 matlab.ui.control.Label

        label_IFOC_CompCeros            matlab.ui.control.Label
        editFIeld_IFOC_CompPolos        matlab.ui.control.EditField
        EditField3Label                 matlab.ui.control.Label

        % Controlador PBC
        tab_PBC                         matlab.ui.container.Tab
        layout_PBCdata                  matlab.ui.container.GridLayout

        label_PBC_psiRmagref            matlab.ui.control.Label
        editField_PBC_psiRmagref        matlab.ui.control.NumericEditField
        psi_RmagrefLabel                matlab.ui.control.Label

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
        EditField5Label                 matlab.ui.control.Label

        label_tauRref_escalon_tinit     matlab.ui.control.Label
        editField_tauRref_escalon_tinit  matlab.ui.control.NumericEditField
        EditField6Label                 matlab.ui.control.Label

        label_tauRref_escalon_tfin      matlab.ui.control.Label
        editField_tauRref_escalon_tfin  matlab.ui.control.NumericEditField
        EditField7Label                 matlab.ui.control.Label

        % Referencia rampa
        tab_tauRref_rampa               matlab.ui.container.Tab
        layout_tauRref_rampa            matlab.ui.container.GridLayout

        label_tauRref_rampa_descripcion  matlab.ui.control.Label

        label_tauRref_rampa_valref      matlab.ui.control.Label
        editField_tauRref_rampa_valref  matlab.ui.control.NumericEditField
        EditField8Label                 matlab.ui.control.Label

        label_tauRref_rampa_tinit       matlab.ui.control.Label
        editField_tauRref_rampa_tinit   matlab.ui.control.NumericEditField
        EditField9Label                 matlab.ui.control.Label

        label_tauRref_rampa_tfin        matlab.ui.control.Label
        editField_tauRref_rampa_tfin    matlab.ui.control.NumericEditField
        EditField10Label                matlab.ui.control.Label

        % Referencia senoidal
        tab_tauRref_senoidal            matlab.ui.container.Tab
        layout_tauRref_senoidal         matlab.ui.container.GridLayout

        label_tauRref_senoidal_descripcion  matlab.ui.control.Label

        label_tauRref_senoidal_valref   matlab.ui.control.Label
        editField_tauRref_senoidal_valref  matlab.ui.control.NumericEditField
        EditField11Label                matlab.ui.control.Label

        label_tauRref_senoidal_frecuencia  matlab.ui.control.Label
        editField_tauRref_senoidal_frecuencia  matlab.ui.control.NumericEditField
        EditField12Label                matlab.ui.control.Label

        label_tauRref_senoidal_tinit    matlab.ui.control.Label
        editFIeld_tauRref_senoidal_tinit  matlab.ui.control.NumericEditField
        EditField13Label                matlab.ui.control.Label

        % Referencia polinomio7
        tab_tauRref_pol7                matlab.ui.container.Tab
        layout_tauRref_pol7             matlab.ui.container.GridLayout

        label_tauRref_pol7_descripcion  matlab.ui.control.Label

        label_tauRref_pol7_valref       matlab.ui.control.Label
        editField_tauRref_pol7_valref   matlab.ui.control.NumericEditField
        EditField14Label                matlab.ui.control.Label

        label_tauRref_pol7_tinit        matlab.ui.control.Label
        editField_tauRref_pol7_tinit    matlab.ui.control.NumericEditField
        EditField15Label                matlab.ui.control.Label

        label_tauRref_pol7_tfin         matlab.ui.control.Label
        editField_tauRref_pol7_tfin     matlab.ui.control.NumericEditField
        EditField16Label                matlab.ui.control.Label

        % Referencia tren de escalones
        tab_tauRref_escalones           matlab.ui.container.Tab
        layout_tauRref_escalones        matlab.ui.container.GridLayout

        label_tauRref_escalones_descripcion  matlab.ui.control.Label

        label_tauRref_escalones_valref  matlab.ui.control.Label
        editField_tauRref_escalones_valref  matlab.ui.control.NumericEditField
        EditField17Label                matlab.ui.control.Label
        
        label_tauRref_escalones_tescalon  matlab.ui.control.Label
        editField_tauRref_escalones_tescalon  matlab.ui.control.NumericEditField
        EditField18Label                matlab.ui.control.Label

        % Referencia timeseries
        tab_tauRref_timeseries          matlab.ui.container.Tab
        layout_tauRref_timeseries       matlab.ui.container.GridLayout
        label_tauRref_timeseries_descripcion  matlab.ui.control.Label
        label_tauRref_timeseries_archivo  matlab.ui.control.Label

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

        label_sim_comentarios           matlab.ui.control.Label

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
            app.layout_main.ColumnWidth = {375, 375, '1x'};
            app.layout_main.RowHeight = {'1x'};

            % Create layout_Contr_tauRef_main
            app.layout_Contr_tauRef_main = uigridlayout(app.layout_main);
            app.layout_Contr_tauRef_main.ColumnWidth = {'1x'};
            app.layout_Contr_tauRef_main.RowHeight = {'18x', '15x', '5x'};
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
            app.editField_psiRmagref = uieditfield(app.layout_IFOC_psiRmagref, 'numeric');
            app.editField_psiRmagref.Layout.Row = 1;
            app.editField_psiRmagref.Layout.Column = 2;

            % Create psi_RrefLabel
            app.psi_RrefLabel = uilabel(app.layout_IFOC_psiRmagref);
            app.psi_RrefLabel.HorizontalAlignment = 'right';
            app.psi_RrefLabel.Layout.Row = 1;
            app.psi_RrefLabel.Layout.Column = 1;
            app.psi_RrefLabel.Text = '$||\psi_{Rref}||$';

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
            app.editField_IFOC_IntGanancia.Layout.Row = 1;
            app.editField_IFOC_IntGanancia.Layout.Column = 2;

            % Create EditFieldLabel
            app.EditFieldLabel = uilabel(app.layout_Integratordata);
            app.EditFieldLabel.HorizontalAlignment = 'right';
            app.EditFieldLabel.Layout.Row = 1;
            app.EditFieldLabel.Layout.Column = 1;
            app.EditFieldLabel.Text = 'Edit Field';

            % Create label_IFOC_IntCero
            app.label_IFOC_IntCero = uilabel(app.layout_Integratordata);
            app.label_IFOC_IntCero.Layout.Row = 2;
            app.label_IFOC_IntCero.Layout.Column = 1;
            app.label_IFOC_IntCero.Interpreter = 'latex';
            app.label_IFOC_IntCero.Text = 'Cero';

            % Create editField_IFOC_IntCero
            app.editField_IFOC_IntCero = uieditfield(app.layout_Integratordata, 'numeric');
            app.editField_IFOC_IntCero.Layout.Row = 2;
            app.editField_IFOC_IntCero.Layout.Column = 2;

            % Create EditField2Label
            app.EditField2Label = uilabel(app.layout_Integratordata);
            app.EditField2Label.HorizontalAlignment = 'right';
            app.EditField2Label.Layout.Row = 2;
            app.EditField2Label.Layout.Column = 1;
            app.EditField2Label.Text = 'Edit Field2';


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
            app.label_IFOC_CompInstrucciones.FontSize = 11;
            app.label_IFOC_CompInstrucciones.Layout.Row = 1;
            app.label_IFOC_CompInstrucciones.Layout.Column = [1 2];
            app.label_IFOC_CompInstrucciones.Interpreter = 'latex';
            app.label_IFOC_CompInstrucciones.Text = 'Ingresa números separados por comas (ej. [-400,4.5+45.6i,0.967])';

            % Create label_IFOC_CompCeros
            app.label_IFOC_CompCeros = uilabel(app.layout_IFOC_Compensatordata);
            app.label_IFOC_CompCeros.Layout.Row = 3;
            app.label_IFOC_CompCeros.Layout.Column = 1;
            app.label_IFOC_CompCeros.Interpreter = 'latex';
            app.label_IFOC_CompCeros.Text = 'Ceros';

            % Create editFIeld_IFOC_CompPolos
            app.editFIeld_IFOC_CompPolos = uieditfield(app.layout_IFOC_Compensatordata, 'text');
            app.editFIeld_IFOC_CompPolos.Layout.Row = 2;
            app.editFIeld_IFOC_CompPolos.Layout.Column = 2;

            % Create EditField3Label
            app.EditField3Label = uilabel(app.layout_IFOC_Compensatordata);
            app.EditField3Label.HorizontalAlignment = 'right';
            app.EditField3Label.Layout.Row = 2;
            app.EditField3Label.Layout.Column = 1;
            app.EditField3Label.Text = 'Edit Field3';

            % Create label_IFOC_CompPolos
            app.label_IFOC_CompPolos = uilabel(app.layout_IFOC_Compensatordata);
            app.label_IFOC_CompPolos.Layout.Row = 2;
            app.label_IFOC_CompPolos.Layout.Column = 1;
            app.label_IFOC_CompPolos.Interpreter = 'latex';
            app.label_IFOC_CompPolos.Text = 'Polos';

            % Create editField_IFOC_CompCeros
            app.editField_IFOC_CompCeros = uieditfield(app.layout_IFOC_Compensatordata, 'text');
            app.editField_IFOC_CompCeros.Layout.Row = 3;
            app.editField_IFOC_CompCeros.Layout.Column = 2;

            % Create EditField4Label
            app.EditField4Label = uilabel(app.layout_IFOC_Compensatordata);
            app.EditField4Label.HorizontalAlignment = 'right';
            app.EditField4Label.Layout.Row = 3;
            app.EditField4Label.Layout.Column = 1;
            app.EditField4Label.Text = 'Edit Field4';



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
            app.editField_PBC_psiRmagref.Layout.Row = 1;
            app.editField_PBC_psiRmagref.Layout.Column = 2;

            % Create psi_RmagrefLabel
            app.psi_RmagrefLabel = uilabel(app.layout_PBCdata);
            app.psi_RmagrefLabel.HorizontalAlignment = 'right';
            app.psi_RmagrefLabel.Layout.Row = 1;
            app.psi_RmagrefLabel.Layout.Column = 1;
            app.psi_RmagrefLabel.Text = '$||\psi_{Rref}||$';

            % Create label_PBC_KiS
            app.label_PBC_KiS = uilabel(app.layout_PBCdata);
            app.label_PBC_KiS.Layout.Row = 2;
            app.label_PBC_KiS.Layout.Column = 1;
            app.label_PBC_KiS.Interpreter = 'latex';
            app.label_PBC_KiS.Text = 'Inyección de amortiguamiento';

            % Create editField_PBC_KiS
            app.editField_PBC_KiS = uieditfield(app.layout_PBCdata, 'numeric');
            app.editField_PBC_KiS.Layout.Row = 2;
            app.editField_PBC_KiS.Layout.Column = 2;

            % Create K_iSLabel
            app.K_iSLabel = uilabel(app.layout_PBCdata);
            app.K_iSLabel.HorizontalAlignment = 'right';
            app.K_iSLabel.Layout.Row = 2;
            app.K_iSLabel.Layout.Column = 1;
            app.K_iSLabel.Text = '$K_{iS}$';

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
            app.button_GuardarparamsContr.Layout.Row = 1;
            app.button_GuardarparamsContr.Layout.Column = 2;
            app.button_GuardarparamsContr.Text = 'Guardar';

            % Create button_LimpiarparamsContr
            app.button_LimpiarparamsContr = uibutton(app.layout_Contr_guardar_params, 'push');
            app.button_LimpiarparamsContr.Layout.Row = 1;
            app.button_LimpiarparamsContr.Layout.Column = 1;
            app.button_LimpiarparamsContr.Text = 'Limpiar';

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
            app.layout_tauRref_escalon.ColumnWidth = {'5x', '1x'};
            app.layout_tauRref_escalon.RowHeight = {20, 20, 20, 20};
            app.layout_tauRref_escalon.ColumnSpacing = 0;
            app.layout_tauRref_escalon.RowSpacing = 2;
            app.layout_tauRref_escalon.Padding = [0 2 2 2];

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
            app.label_tauRref_escalon_valref.Text = 'Valor de referencia';

            % Create editField_tauRref_escalon_valref
            app.editField_tauRref_escalon_valref = uieditfield(app.layout_tauRref_escalon, 'numeric');
            app.editField_tauRref_escalon_valref.Layout.Row = 2;
            app.editField_tauRref_escalon_valref.Layout.Column = 2;

            % Create EditField5Label
            app.EditField5Label = uilabel(app.layout_tauRref_escalon);
            app.EditField5Label.HorizontalAlignment = 'right';
            app.EditField5Label.Layout.Row = 2;
            app.EditField5Label.Layout.Column = 1;
            app.EditField5Label.Text = 'Edit Field5';

            % Create label_tauRref_escalon_tinit
            app.label_tauRref_escalon_tinit = uilabel(app.layout_tauRref_escalon);
            app.label_tauRref_escalon_tinit.Layout.Row = 3;
            app.label_tauRref_escalon_tinit.Layout.Column = 1;
            app.label_tauRref_escalon_tinit.Interpreter = 'latex';
            app.label_tauRref_escalon_tinit.Text = 'Tiempo de inicio';

            % Create editField_tauRref_escalon_tinit
            app.editField_tauRref_escalon_tinit = uieditfield(app.layout_tauRref_escalon, 'numeric');
            app.editField_tauRref_escalon_tinit.Layout.Row = 3;
            app.editField_tauRref_escalon_tinit.Layout.Column = 2;

            % Create EditField6Label
            app.EditField6Label = uilabel(app.layout_tauRref_escalon);
            app.EditField6Label.HorizontalAlignment = 'right';
            app.EditField6Label.Layout.Row = 3;
            app.EditField6Label.Layout.Column = 1;
            app.EditField6Label.Text = 'Edit Field6';

            % Create editField_tauRref_escalon_tfin
            app.editField_tauRref_escalon_tfin = uieditfield(app.layout_tauRref_escalon, 'numeric');
            app.editField_tauRref_escalon_tfin.Layout.Row = 4;
            app.editField_tauRref_escalon_tfin.Layout.Column = 2;

            % Create EditField7Label
            app.EditField7Label = uilabel(app.layout_tauRref_escalon);
            app.EditField7Label.HorizontalAlignment = 'right';
            app.EditField7Label.Layout.Row = 4;
            app.EditField7Label.Layout.Column = 1;
            app.EditField7Label.Text = 'Edit Field7';

            % Create label_tauRref_escalon_tfin
            app.label_tauRref_escalon_tfin = uilabel(app.layout_tauRref_escalon);
            app.label_tauRref_escalon_tfin.Layout.Row = 4;
            app.label_tauRref_escalon_tfin.Layout.Column = 1;
            app.label_tauRref_escalon_tfin.Interpreter = 'latex';
            app.label_tauRref_escalon_tfin.Text = 'Tiempo de fin';

            % Create tab_tauRref_rampa
            app.tab_tauRref_rampa = uitab(app.tabGroup_tauRref_perfiles);
            app.tab_tauRref_rampa.Title = 'Rampa';

            % Create layout_tauRref_rampa
            app.layout_tauRref_rampa = uigridlayout(app.tab_tauRref_rampa);
            app.layout_tauRref_rampa.ColumnWidth = {'5x', '1x'};
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
            app.label_tauRref_rampa_valref.Text = 'Valor de referencia';

            % Create editField_tauRref_rampa_valref
            app.editField_tauRref_rampa_valref = uieditfield(app.layout_tauRref_rampa, 'numeric');
            app.editField_tauRref_rampa_valref.Layout.Row = 2;
            app.editField_tauRref_rampa_valref.Layout.Column = 2;

            % Create EditField8Label
            app.EditField8Label = uilabel(app.layout_tauRref_rampa);
            app.EditField8Label.HorizontalAlignment = 'right';
            app.EditField8Label.Layout.Row = 2;
            app.EditField8Label.Layout.Column = 1;
            app.EditField8Label.Text = 'Edit Field8';

            % Create label_tauRref_rampa_tinit
            app.label_tauRref_rampa_tinit = uilabel(app.layout_tauRref_rampa);
            app.label_tauRref_rampa_tinit.Layout.Row = 3;
            app.label_tauRref_rampa_tinit.Layout.Column = 1;
            app.label_tauRref_rampa_tinit.Interpreter = 'latex';
            app.label_tauRref_rampa_tinit.Text = 'Tiempo de inicio';

            % Create editField_tauRref_rampa_tinit
            app.editField_tauRref_rampa_tinit = uieditfield(app.layout_tauRref_rampa, 'numeric');
            app.editField_tauRref_rampa_tinit.Layout.Row = 3;
            app.editField_tauRref_rampa_tinit.Layout.Column = 2;

            % Create EditField9Label
            app.EditField9Label = uilabel(app.layout_tauRref_rampa);
            app.EditField9Label.HorizontalAlignment = 'right';
            app.EditField9Label.Layout.Row = 3;
            app.EditField9Label.Layout.Column = 1;
            app.EditField9Label.Text = 'Edit Field9';

            % Create label_tauRref_rampa_tfin
            app.label_tauRref_rampa_tfin = uilabel(app.layout_tauRref_rampa);
            app.label_tauRref_rampa_tfin.Layout.Row = 4;
            app.label_tauRref_rampa_tfin.Layout.Column = 1;
            app.label_tauRref_rampa_tfin.Interpreter = 'latex';
            app.label_tauRref_rampa_tfin.Text = 'Tiempo de fin';

            % Create EditField10Label
            app.EditField10Label = uilabel(app.layout_tauRref_rampa);
            app.EditField10Label.HorizontalAlignment = 'right';
            app.EditField10Label.Layout.Row = 4;
            app.EditField10Label.Layout.Column = 1;
            app.EditField10Label.Text = 'Edit Field10';

            % Create editField_tauRref_rampa_tfin
            app.editField_tauRref_rampa_tfin = uieditfield(app.layout_tauRref_rampa, 'numeric');
            app.editField_tauRref_rampa_tfin.Layout.Row = 4;
            app.editField_tauRref_rampa_tfin.Layout.Column = 2;

            % Create tab_tauRref_senoidal
            app.tab_tauRref_senoidal = uitab(app.tabGroup_tauRref_perfiles);
            app.tab_tauRref_senoidal.Title = 'Senoidal';
            
            % Create layout_tauRref_senoidal
            app.layout_tauRref_senoidal = uigridlayout(app.tab_tauRref_senoidal);
            app.layout_tauRref_senoidal.ColumnWidth = {'5x', '1x'};
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
            app.label_tauRref_senoidal_valref.Text = 'Amplitud(Valor pico)';

            % Create editField_tauRref_senoidal_valref
            app.editField_tauRref_senoidal_valref = uieditfield(app.layout_tauRref_senoidal, 'numeric');
            app.editField_tauRref_senoidal_valref.Layout.Row = 2;
            app.editField_tauRref_senoidal_valref.Layout.Column = 2;

            % Create EditField11Label
            app.EditField11Label = uilabel(app.layout_tauRref_senoidal);
            app.EditField11Label.HorizontalAlignment = 'right';
            app.EditField11Label.Layout.Row = 2;
            app.EditField11Label.Layout.Column = 1;
            app.EditField11Label.Text = 'Edit Field11';

            % Create label_tauRref_senoidal_frecuencia
            app.label_tauRref_senoidal_frecuencia = uilabel(app.layout_tauRref_senoidal);
            app.label_tauRref_senoidal_frecuencia.Layout.Row = 3;
            app.label_tauRref_senoidal_frecuencia.Layout.Column = 1;
            app.label_tauRref_senoidal_frecuencia.Interpreter = 'latex';
            app.label_tauRref_senoidal_frecuencia.Text = 'Frecuencia';

            % Create editField_tauRref_senoidal_frecuencia
            app.editField_tauRref_senoidal_frecuencia = uieditfield(app.layout_tauRref_senoidal, 'numeric');
            app.editField_tauRref_senoidal_frecuencia.Layout.Row = 3;
            app.editField_tauRref_senoidal_frecuencia.Layout.Column = 2;

            % Create EditField12Label
            app.EditField12Label = uilabel(app.layout_tauRref_senoidal);
            app.EditField12Label.HorizontalAlignment = 'right';
            app.EditField12Label.Layout.Row = 3;
            app.EditField12Label.Layout.Column = 1;
            app.EditField12Label.Text = 'Edit Field12';

            % Create label_tauRref_senoidal_tinit
            app.label_tauRref_senoidal_tinit = uilabel(app.layout_tauRref_senoidal);
            app.label_tauRref_senoidal_tinit.Layout.Row = 4;
            app.label_tauRref_senoidal_tinit.Layout.Column = 1;
            app.label_tauRref_senoidal_tinit.Interpreter = 'latex';
            app.label_tauRref_senoidal_tinit.Text = 'Tiempo de inicio';

            % Create editFIeld_tauRref_senoidal_tinit
            app.editFIeld_tauRref_senoidal_tinit = uieditfield(app.layout_tauRref_senoidal, 'numeric');
            app.editFIeld_tauRref_senoidal_tinit.Layout.Row = 4;
            app.editFIeld_tauRref_senoidal_tinit.Layout.Column = 2;

            % Create EditField13Label
            app.EditField13Label = uilabel(app.layout_tauRref_senoidal);
            app.EditField13Label.HorizontalAlignment = 'right';
            app.EditField13Label.Layout.Row = 4;
            app.EditField13Label.Layout.Column = 1;
            app.EditField13Label.Text = 'Edit Field13';


            % Create tab_tauRref_pol7
            app.tab_tauRref_pol7 = uitab(app.tabGroup_tauRref_perfiles);
            app.tab_tauRref_pol7.Title = 'Polinomio 7mo orden';

            % Create layout_tauRref_pol7
            app.layout_tauRref_pol7 = uigridlayout(app.tab_tauRref_pol7);
            app.layout_tauRref_pol7.ColumnWidth = {'5x', '1x'};
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
            app.label_tauRref_pol7_valref.Text = 'Valor de referencia';

            % Create editField_tauRref_pol7_valref
            app.editField_tauRref_pol7_valref = uieditfield(app.layout_tauRref_pol7, 'numeric');
            app.editField_tauRref_pol7_valref.Layout.Row = 2;
            app.editField_tauRref_pol7_valref.Layout.Column = 2;
            
            % Create EditField14Label
            app.EditField14Label = uilabel(app.layout_tauRref_pol7);
            app.EditField14Label.HorizontalAlignment = 'right';
            app.EditField14Label.Layout.Row = 2;
            app.EditField14Label.Layout.Column = 1;
            app.EditField14Label.Text = 'Edit Field14';

            % Create label_tauRref_pol7_tinit
            app.label_tauRref_pol7_tinit = uilabel(app.layout_tauRref_pol7);
            app.label_tauRref_pol7_tinit.Layout.Row = 3;
            app.label_tauRref_pol7_tinit.Layout.Column = 1;
            app.label_tauRref_pol7_tinit.Interpreter = 'latex';
            app.label_tauRref_pol7_tinit.Text = 'Tiempo de inicio';

            % Create editField_tauRref_pol7_tinit
            app.editField_tauRref_pol7_tinit = uieditfield(app.layout_tauRref_pol7, 'numeric');
            app.editField_tauRref_pol7_tinit.Layout.Row = 3;
            app.editField_tauRref_pol7_tinit.Layout.Column = 2;

            % Create EditField15Label
            app.EditField15Label = uilabel(app.layout_tauRref_pol7);
            app.EditField15Label.HorizontalAlignment = 'right';
            app.EditField15Label.Layout.Row = 3;
            app.EditField15Label.Layout.Column = 1;
            app.EditField15Label.Text = 'Edit Field15';

            % Create label_tauRref_pol7_tfin
            app.label_tauRref_pol7_tfin = uilabel(app.layout_tauRref_pol7);
            app.label_tauRref_pol7_tfin.Layout.Row = 4;
            app.label_tauRref_pol7_tfin.Layout.Column = 1;
            app.label_tauRref_pol7_tfin.Interpreter = 'latex';
            app.label_tauRref_pol7_tfin.Text = 'Tiempo de fin';

            % Create editField_tauRref_pol7_tfin
            app.editField_tauRref_pol7_tfin = uieditfield(app.layout_tauRref_pol7, 'numeric');
            app.editField_tauRref_pol7_tfin.Layout.Row = 4;
            app.editField_tauRref_pol7_tfin.Layout.Column = 2;

            % Create EditField16Label
            app.EditField16Label = uilabel(app.layout_tauRref_pol7);
            app.EditField16Label.HorizontalAlignment = 'right';
            app.EditField16Label.Layout.Row = 4;
            app.EditField16Label.Layout.Column = 1;
            app.EditField16Label.Text = 'Edit Field16';

            % Create tab_tauRref_escalones
            app.tab_tauRref_escalones = uitab(app.tabGroup_tauRref_perfiles);
            app.tab_tauRref_escalones.Title = 'Tren de escalones';

            % Create layout_tauRref_escalones
            app.layout_tauRref_escalones = uigridlayout(app.tab_tauRref_escalones);
            app.layout_tauRref_escalones.ColumnWidth = {'5x', '1x'};
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
            app.label_tauRref_escalones_valref.Text = 'Valor de referencia';

            % Create editField_tauRref_escalones_valref
            app.editField_tauRref_escalones_valref = uieditfield(app.layout_tauRref_escalones, 'numeric');
            app.editField_tauRref_escalones_valref.Layout.Row = 2;
            app.editField_tauRref_escalones_valref.Layout.Column = 2;

            % Create EditField17Label
            app.EditField17Label = uilabel(app.layout_tauRref_escalones);
            app.EditField17Label.HorizontalAlignment = 'right';
            app.EditField17Label.Layout.Row = 2;
            app.EditField17Label.Layout.Column = 1;
            app.EditField17Label.Text = 'Edit Field17';

            % Create label_tauRref_escalones_tescalon
            app.label_tauRref_escalones_tescalon = uilabel(app.layout_tauRref_escalones);
            app.label_tauRref_escalones_tescalon.Layout.Row = 3;
            app.label_tauRref_escalones_tescalon.Layout.Column = 1;
            app.label_tauRref_escalones_tescalon.Interpreter = 'latex';
            app.label_tauRref_escalones_tescalon.Text = 'Tiempo entre escalones';

            % Create editField_tauRref_escalones_tescalon
            app.editField_tauRref_escalones_tescalon = uieditfield(app.layout_tauRref_escalones, 'numeric');
            app.editField_tauRref_escalones_tescalon.Layout.Row = 3;
            app.editField_tauRref_escalones_tescalon.Layout.Column = 2;

            % Create EditField18Label
            app.EditField18Label = uilabel(app.layout_tauRref_escalones);
            app.EditField18Label.HorizontalAlignment = 'right';
            app.EditField18Label.Layout.Row = 3;
            app.EditField18Label.Layout.Column = 1;
            app.EditField18Label.Text = 'Edit Field18';

            % Create tab_tauRref_timeseries
            app.tab_tauRref_timeseries = uitab(app.tabGroup_tauRref_perfiles);
            app.tab_tauRref_timeseries.Title = 'Timeseries';

            % Create layout_tauRref_timeseries
            app.layout_tauRref_timeseries = uigridlayout(app.tab_tauRref_timeseries);
            app.layout_tauRref_timeseries.ColumnWidth = {'1x'};
            app.layout_tauRref_timeseries.RowHeight = {20, 20};
            app.layout_tauRref_timeseries.ColumnSpacing = 2;
            app.layout_tauRref_timeseries.RowSpacing = 2;
            app.layout_tauRref_timeseries.Padding = [2 2 2 2];

            % Create label_tauRref_timeseries_archivo
            app.label_tauRref_timeseries_archivo = uilabel(app.layout_tauRref_timeseries);
            app.label_tauRref_timeseries_archivo.Layout.Row = 2;
            app.label_tauRref_timeseries_archivo.Layout.Column = 1;
            app.label_tauRref_timeseries_archivo.Interpreter = 'latex';
            app.label_tauRref_timeseries_archivo.Text = 'Ningún archivo seleccionado';

            % Create label_tauRref_timeseries_descripcion
            app.label_tauRref_timeseries_descripcion = uilabel(app.layout_tauRref_timeseries);
            app.label_tauRref_timeseries_descripcion.Layout.Row = 1;
            app.label_tauRref_timeseries_descripcion.Layout.Column = 1;
            app.label_tauRref_timeseries_descripcion.Interpreter = 'latex';
            app.label_tauRref_timeseries_descripcion.Text = 'Timeseries de MATLAB';

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
            app.button_GuardarparamstauRref.Layout.Row = 1;
            app.button_GuardarparamstauRref.Layout.Column = 2;
            app.button_GuardarparamstauRref.Text = 'Guardar';

            % Create button_LimpiarparamstauRref
            app.button_LimpiarparamstauRref = uibutton(app.layout_tauRref_guardar_params, 'push');
            app.button_LimpiarparamstauRref.Layout.Row = 1;
            app.button_LimpiarparamstauRref.Layout.Column = 1;
            app.button_LimpiarparamstauRref.Text = 'Limpiar';

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
            title(app.axes_etorque, 'Error de seguimiento de torque')
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
            app.button_sim_corriente.Layout.Row = 1;
            app.button_sim_corriente.Layout.Column = 2;
            app.button_sim_corriente.Text = 'Corriente';

            % Create button_sim_voltaje
            app.button_sim_voltaje = uibutton(app.layout_axes_voltajecorriente, 'push');
            app.button_sim_voltaje.Layout.Row = 1;
            app.button_sim_voltaje.Layout.Column = 1;
            app.button_sim_voltaje.Text = 'Voltaje';

            % Create label_sim_comentarios
            app.label_sim_comentarios = uilabel(app.layout_Sim_Resultados);
            app.label_sim_comentarios.Layout.Row = 3;
            app.label_sim_comentarios.Layout.Column = 1;

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app2_Controlador_exported

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