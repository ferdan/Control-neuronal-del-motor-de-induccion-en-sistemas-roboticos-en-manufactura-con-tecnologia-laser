% Parametros  del motor 0.75hp (Felipe)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function MI_motor = MI_075HP_params()
    Pnom = 745.7*0.75; 
    w_Rrpmnom = 1725; % No especificado
    w_Rnom = w_Rrpmnom/60*2*pi;
    i_Srmsnom = 3;
    v_Srmsnom = Pnom/i_Srmsnom;
    tau_Rnom = Pnom/w_Rnom;
    
    n_p = 1;
    
    R_S = 4.32;
    R_R = 2.8807;
    
    LS = 0.2505;
    LR = 0.2505;
    M = 0.2374;
    
    %Norma del flujo magnetico nominal
    psi_Rmagnom = M*i_Srmsnom/sqrt(2);
    
    J = 2e-3;
    b = 1e-4; % No especificado
    
    % Objeto modelo motor de induccion
    MI_motor = MI_model(Pnom,v_Srmsnom,i_Srmsnom,psi_Rmagnom,w_Rnom,tau_Rnom,n_p,R_S,R_R,LS,LR,M,J,b);
end