% Parametros del controlador %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function MI_speed_controller = MI_Controller_PBC_Speed_params(MI_motor)

    % Amortiguamiento del subsistema electrico
    epsilon_KiS = 8*MI_motor.electric_params.R_R; % Dejar en terminos de R_R
    
    % Amortiguamiento del subsistema mecanico
    K_wR = 2.5;
    
    % Filtro de primer orden para el error de velocidad
    Kp_eWR = 0;
    Ki_eWR = 0;
    
    % Objeto controlador
    MI_speed_controller = PBC_Speed_Controller(epsilon_KiS,K_wR,Kp_eWR,Ki_eWR);
end