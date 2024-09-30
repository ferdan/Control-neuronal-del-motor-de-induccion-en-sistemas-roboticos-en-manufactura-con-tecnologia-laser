% Parametros  del motor 1hp (Hoover)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function MI_motor = MI_1HP_params()
    Pnom = 745.7*1;
    v_Srmsnom = 230;
    w_Rrpmnom = 1725;
    w_Rnom = w_Rrpmnom/60*2*pi;
    i_Srmsnom = Pnom/v_Srmsnom;
    tau_Rnom = Pnom/w_Rnom;
    
    n_p = 2;
    
    R_S = 2.516;
    R_R = 1.9461;
    
    LS = 0.234;
    LR = 0.2302;
    M = 0.2226;
    
    %Norma del flujo magnetico nominal
    psi_Rmagnom = M*i_Srmsnom/sqrt(2);
    
    J = 6.2764e-3;
    b = 1.1e-4;
    
    % Objeto modelo motor de induccion
    MI_motor = MI_model(Pnom,v_Srmsnom,i_Srmsnom,psi_Rmagnom,w_Rnom,tau_Rnom,n_p,R_S,R_R,LS,LR,M,J,b);
end