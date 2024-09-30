% Parametros  del motor 1hp (Hoover)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function MI_motor = MI_04HP_params()
    Pnom = 300;
    v_Srmsnom = 380;
    w_Rrpmnom = 3450;
    w_Rnom = w_Rrpmnom/60*2*pi;
    i_Srmsnom = Pnom/v_Srmsnom;
    tau_Rnom = Pnom/w_Rnom;
    
    n_p = 1;
    
    R_S = 15.6;
    R_R = 23.2;
    
    LS = 1.44;
    LR = 1.5;
    M = 1.42;
    
    %Norma del flujo magnetico nominal
    psi_Rmagnom = M*i_Srmsnom/sqrt(2);
    
    J = 0.000711;
    b = 0.00014;
    
    % Objeto modelo motor de induccion
    MI_motor = MI_model(Pnom,v_Srmsnom,i_Srmsnom,psi_Rmagnom,w_Rnom,tau_Rnom,n_p,R_S,R_R,LS,LR,M,J,b);
end