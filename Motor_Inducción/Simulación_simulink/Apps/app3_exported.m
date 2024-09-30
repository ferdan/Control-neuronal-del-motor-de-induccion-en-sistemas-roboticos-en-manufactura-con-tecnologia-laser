classdef app3_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure      matlab.ui.Figure
        Spinner       matlab.ui.control.Spinner
        SpinnerLabel  matlab.ui.control.Label
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create SpinnerLabel
            app.SpinnerLabel = uilabel(app.UIFigure);
            app.SpinnerLabel.HorizontalAlignment = 'right';
            app.SpinnerLabel.Position = [321 256 46 22];
            app.SpinnerLabel.Text = 'Spinner';

            % Create Spinner
            app.Spinner = uispinner(app.UIFigure);
            app.Spinner.Position = [382 256 100 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app3_exported

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