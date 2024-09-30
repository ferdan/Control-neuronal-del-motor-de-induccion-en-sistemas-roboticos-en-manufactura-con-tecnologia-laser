

fig = uifigure("Name","Simulacion del modelo ab de un motor de induccion", ...
               'Position',[0 0 1024 576],'WindowStyle');

%fig.WindowState = "maximized";

% Main Layout
main_layout = uigridlayout(fig,"RowHeight",{'1x'},"ColumnWidth",{'1x','1x','1x'},...
                           "Padding",[10,10,10,10]);

% Simulation parameters layout %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
params_main_layout = uigridlayout(main_layout,"RowHeight",{'3x','4x'},...
                           "ColumnWidth",{'1x'},"Padding",[0,0,0,0]);
params_main_layout.Layout.Row = 1;
params_main_layout.Layout.Column = 1;

% Motor parameters layout
MI_params_main_layout = uigridlayout(params_main_layout,"RowHeight",{20,'1x',20,20},...
                           "ColumnWidth",{'1x'},"Padding",[0,0,0,0]);
MI_params_main_layout.Layout.Row = [1 3];
MI_params_main_layout.Layout.Column = 1;
% 
% % Motor data layout
MI_data_layout = uigridlayout(MI_params_main_layout,"RowHeight",...
                              {'18x','18x','18x','18x','18x','18x','18x','18x','18x',...
                               '18x','18x','18x','18x','18x','18x','18x','18x','18x'},...
                               "ColumnWidth",{'1x'},"Padding",[0,0,0,0]);
MI_data_layout.Layout.Row = 2;
MI_data_layout.Layout.Column = 1;



% Motor parameters panel

MI_params_panel = uipanel(MI_params_main_layout,"Title","Parametros del motor de induccion");
MI_params_panel.Layout.Row = [1 4];
MI_params_panel.Layout.Column = 1;


% Title
%main_layout_title = uitextarea(fig,"Placeholder","Simulacion");
%main_layout_title = uilabel(fig,"Text","Simulacion");
%main_layout_title.Layout.Row = 1;
%main_layout_title.Layout.Column = [1 3];



% Device drop-down
% dd1 = uidropdown(main_layout);
% dd1.Items = {'Select a device'};

% Range drop-down
% dd2 = uidropdown(main_layout);
% dd2.Items = {'Select a range'};
% dd2.Layout.Row = 2;
% dd2.Layout.Column = 1;

% List box
% chanlist = uilistbox(main_layout);
% chanlist.Items = {'Channel 1','Channel 2','Channel 3'};
% chanlist.Layout.Row = 3;
% chanlist.Layout.Column = 1;

% Axes
% ax = uiaxes(main_layout);
% ax.Layout.Row = [1 3];
% ax.Layout.Column = [2 3];

%setMousePointer(fig)
%fig.CloseRequestFcn = @(src,event)my_closereq(src);




% function setMousePointer(fig)
%     %fig = uifigure('Position',[500 500 375 275]);
%     fig.WindowButtonMotionFcn = @mouseMoved;
% 
%     btn = uibutton(fig);
%     btnX = 50;
%     btnY = 50;
%     btnWidth = 100;
%     btnHeight = 22;
%     btn.Position = [btnX btnY btnWidth btnHeight];
%     btn.Text = 'Submit Changes';
% 
%     function mouseMoved(src,event)
%         mousePos = fig.CurrentPoint;
%         if (mousePos(1) >= btnX) && (mousePos(1) <= btnX + btnWidth) ...
%                 && (mousePos(2) >= btnY) && (mousePos(2) <= btnY + btnHeight)
%               fig.Pointer = 'hand';
%         else
%               fig.Pointer = 'arrow';
%         end
%     end
% end


function my_closereq(fig)
    selection = uiconfirm(fig,'Cerrar ventana?','Confirmation');
    
    switch selection
        case 'OK'
            delete(fig)
        case 'Cancel'
            return
    end
end
