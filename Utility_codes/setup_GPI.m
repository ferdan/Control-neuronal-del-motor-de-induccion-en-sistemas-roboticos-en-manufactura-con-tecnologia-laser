%% Controlador GPI

if strcmp(SIMRMA_GraficasHandler.get_simtype(simname),"control_conMI") == 1
    [Wc,Zc,Pc] = simRMA_conMIs(ndof,unc_sel);
elseif strcmp(SIMRMA_GraficasHandler.get_simtype(simname),"control_sinMI") == 1
    [Wc,Zc,Pc] = simRMA_sinMIs(ndof);
else
    Wc = 60*ones(1,ndof); % Funciona en todos, sin utilizar NNs. 
    Zc = 1.875*ones(1,ndof);
    Pc = 0.05*ones(1,ndof);
end

contr_robot_params = robot_params.struct;
contr_robot_params.m = contr_robot_params.m*unc_sel;
contr_robot_params.I = contr_robot_params.I*unc_sel;
contr_robot_params.l = contr_robot_params.l*unc_sel;
contr_robot_params.lc = contr_robot_params.lc*unc_sel;
contr_robot_params.d = contr_robot_params.d*unc_sel;
contr_robot_params.dc = contr_robot_params.dc*unc_sel;

function [Wc,Zc,Pc] = simRMA_sinMIs(ndof)
    if ndof == 2
        % B spline
        Wc = 300*ones(1,ndof);
        Zc = 0.625*ones(1,ndof);
        Pc = 0.3125*ones(1,ndof);
        % RBF - sigma mean
        Wc = 227.807*ones(1,ndof);
        Zc = 10.251*ones(1,ndof);
        Pc = 569.517*ones(1,ndof);
        % Combinado
        Wc = 124*ones(1,ndof);%400*ones(1,n);
        Zc = 0.6293*ones(1,ndof);%0.625*ones(1,n);
        Pc = 124*ones(1,ndof);
    
        % Wc = 60*ones(1,ndof);%400*ones(1,n);
        % Zc = 2.5*ones(1,ndof);%0.625*ones(1,n);
        % Pc = 0.05*ones(1,ndof);
    elseif ndof == 3
        % B spline
        Wc = 400*ones(1,ndof);
        Zc = 1.875*ones(1,ndof);
        Pc = 0.625*ones(1,ndof);
        % RBF - sigma mean
        % Combinado
        Wc = 400*ones(1,ndof);
        Zc = 1.875*ones(1,ndof);
        Pc = 570*ones(1,ndof);
        %
        Wc = 124*ones(1,ndof);%400*ones(1,n);
        Zc = 0.6293*ones(1,ndof);%0.625*ones(1,n);
        Pc = 124*ones(1,ndof);
    
    elseif ndof == 6
        Wc = 200*ones(1,ndof);
        Zc = 0.875*ones(1,ndof);
        Pc = 0.1875*ones(1,ndof);
        %
        Wc = 186.669567*ones(1,ndof);%120,400*ones(1,n);// Trayectorias de muestra sen/cos
        Zc = 0.622318*ones(1,ndof);%0.625*ones(1,n);
        Pc = 186.669567*ones(1,ndof); %120
    
        % Wc = 100*ones(1,ndof);%120,400*ones(1,n); 
        % Zc = 100*ones(1,ndof);%0.625*ones(1,n);
        % Pc = 100*ones(1,ndof); %120
    else
        Wc = 60*ones(1,ndof); % Funciona en todos, sin utilizar NNs. 
        Zc = 1.875*ones(1,ndof);
        Pc = 0.05*ones(1,ndof);
    end
end

function [Wc,Zc,Pc] = simRMA_conMIs(ndof,unc_sel)
    if ndof == 2
        % B spline
        Wc = 300*ones(1,ndof);
        Zc = 0.625*ones(1,ndof);
        Pc = 0.3125*ones(1,ndof);
        % RBF - sigma mean
        Wc = 227.807*ones(1,ndof);
        Zc = 10.251*ones(1,ndof);
        Pc = 569.517*ones(1,ndof);
        % Combinado
        Wc = 124*ones(1,ndof);%400*ones(1,ndof);
        Zc = 0.6293*ones(1,ndof);%0.625*ones(1,ndof);
        Pc = 124*ones(1,ndof);
    
        % Wc = 60*ones(1,ndof);%400*ones(1,ndof);
        % Zc = 2.5*ones(1,ndof);%0.625*ones(1,ndof);
        % Pc = 0.05*ones(1,ndof);
    elseif ndof == 3
        % B spline
        Wc = 400*ones(1,ndof);
        Zc = 1.875*ones(1,ndof);
        Pc = 0.625*ones(1,ndof);
        % RBF - sigma mean
        % Combinado
        Wc = 400*ones(1,ndof);
        Zc = 1.875*ones(1,ndof);
        Pc = 570*ones(1,ndof);
        %
        Wc = 124*ones(1,ndof);%400*ones(1,ndof);
        Zc = 0.6293*ones(1,ndof);%0.625*ones(1,ndof);
        Pc = 124*ones(1,ndof);
    elseif ndof == 6
        Wc = 200*ones(1,ndof);
        Zc = 0.875*ones(1,ndof);
        Pc = 0.1875*ones(1,ndof);
        %
        Wc = 112.0567*ones(1,ndof);%120,400*ones(1,ndof);112.0567
        Zc = 0.6222537*ones(1,ndof);%0.625*ones(1,ndof);0.622537
        Pc = 112.0567*ones(1,ndof); %120
    
        Wc = 112*ones(1,ndof);%120,400*ones(1,ndof);112.0567
        Pc = 112*ones(1,ndof); %120
        if unc_sel == 0.8
            Zc = 1.244*ones(1,ndof);
        elseif unc_sel == 0.9
            Zc = 0.995*ones(1,ndof);
        elseif unc_sel == 1
            Zc = 0.871*ones(1,ndof);
        elseif unc_sel == 1.1
            Zc = 0.684*ones(1,ndof);
        elseif unc_sel == 1.2
            Zc = 0.435*ones(1,ndof);
        else
            Zc = 0.622*ones(1,ndof);
        end
        % Zc = 0.622*ones(1,ndof);
    
        % Wc = 40*ones(1,ndof);%120,400*ones(1,ndof);112.0567
        % Zc = 0.5*ones(1,ndof);%0.625*ones(1,ndof);0.622537
        % Pc = 40*ones(1,ndof); %120
        %
        % Wc = 186.669567*ones(1,ndof);%120,400*ones(1,n);
        % Zc = 1*ones(1,ndof);%0.625*ones(1,n);
        % Pc = 186.669567*ones(1,ndof); %120
    else
        Wc = 40*ones(1,ndof); % Funciona en todos, sin utilizar NNs. 
        Zc = 0.875*ones(1,ndof);
        Pc = 40*ones(1,ndof);
    end
end

