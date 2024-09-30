classdef MI_model
    properties
        Pnom
        v_Srmsnom
        i_Srmsnom
        psi_Rmagnom
        w_Rnom
        tau_Rnom
        electric_params
        mechanical_params

        struct
    end

    methods
        function obj=MI_model(Pnomval,v_Srmsnomval,i_Srmsnomval,psi_Rmagnomval,w_Rnomval,tau_Rnomval,n_p,R_Sval,R_Rval,L_Sval,L_Rval,Mval,Jval,bval)
            obj.Pnom = Pnomval;
            obj.v_Srmsnom = v_Srmsnomval;
            obj.i_Srmsnom = i_Srmsnomval;
            obj.psi_Rmagnom = psi_Rmagnomval;
            obj.w_Rnom = w_Rnomval;
            obj.tau_Rnom = tau_Rnomval;
            obj.electric_params = MI_electric_parameters(n_p,R_Sval,R_Rval,L_Sval,L_Rval,Mval);
            obj.mechanical_params = MI_mechanical_parameters(Jval,bval);

            obj.struct.nomvals.Pnom = obj.Pnom;
            obj.struct.nomvals.v_Srmsnom = obj.v_Srmsnom;
            obj.struct.nomvals.i_Srmsnom = obj.i_Srmsnom;
            obj.struct.nomvals.psi_Rmagnom = psi_Rmagnomval;
            obj.struct.nomvals.w_Rnom = w_Rnomval;
            obj.struct.nomvals.tau_Rnom = obj.tau_Rnom;
            
            obj.struct.elecparams.n_p = obj.electric_params.n_p;
            obj.struct.elecparams.R_S = obj.electric_params.R_S;
            obj.struct.elecparams.R_R = obj.electric_params.R_R;
            obj.struct.elecparams.L_S = obj.electric_params.L_S;
            obj.struct.elecparams.L_R = obj.electric_params.L_R;
            obj.struct.elecparams.M = obj.electric_params.M;

            obj.struct.elecparams.sigma = obj.electric_params.sigma;
            obj.struct.elecparams.gamma = obj.electric_params.gamma;

            obj.struct.mechparams.J = obj.mechanical_params.J;
            obj.struct.mechparams.b = obj.mechanical_params.b;
        end

        function str = toString(obj)
            str = "** Maquina de induccion de " + string(obj.Pnom) + " [W], " + string(obj.Pnom/745.7) + " [hp] **\n\n"...
                + "Voltaje nominal v_Srmsnom: " + string(obj.v_Srmsnom) + " [V] \n"...
                + "Corriente nominal i_Srmsnom (P/Vrms):" + string(obj.i_Srmsnom) + " [A] \n"...
                + "Magnitud de flujo nominal psi_Rmagnom (M*irms/sqrt(2)): " + string(obj.psi_Rmagnom) + " [Wb vuelta] \n"...
                + "Velocidad nominal w_Rnom: " + string(obj.w_Rnom) + " [rad/s] \n"...
                + "Torque nominal tau_Rnom (P/w_Rnom): " + string(obj.tau_Rnom) + " [N m] \n";
            str = str + obj.electric_params.toString;
            str = str + obj.mechanical_params.toString;
            str = str + "\n\n";
        end
        function str = shortNameString(obj)
            str = "MI_" + string(round(obj.Pnom/745.7,2)) +  "hp";
        end
    end
    methods (Static)
        function [di_sab,dpsi_rab,dw_R,tau_R] = MI_space_state(MI_motor_params,u_sab,i_sab,psi_rab,w_R,tau_L)
            %R_S = MI_motor_params.elecparams.R_S;
            R_R = MI_motor_params.elecparams.R_R;
            %L_S = MI_motor_params.elecparams.L_S;
            L_R = MI_motor_params.elecparams.L_R;
            M = MI_motor_params.elecparams.M;
            n_p = MI_motor_params.elecparams.n_p;
            
            J = MI_motor_params.mechparams.J;
            b = MI_motor_params.mechparams.b;
            
            sigma = MI_motor_params.elecparams.sigma;
            gamma = MI_motor_params.elecparams.gamma;
            % sigma = L_S - M^2/L_R;
            % gamma = M^2*R_R/(sigma*L_R^2)+R_S/sigma;
            
            
            u_sa = u_sab(1);
            u_sb = u_sab(2);
            
            i_sa = i_sab(1);
            i_sb = i_sab(2);
            
            psi_ra = psi_rab(1);
            psi_rb = psi_rab(2);
            
            tau_R = n_p*M/L_R*(i_sb*psi_ra-i_sa*psi_rb);
            
            x = [i_sa;i_sb;psi_ra;psi_rb];
            
            A = [-gamma      , 0            , (M*R_R)/(sigma*L_R^2)    , (n_p*M)/(sigma*L_R)*w_R ;
                 0           , -gamma       , -(n_p*M)/(sigma*L_R)*w_R , (M*R_R)/(sigma*L_R^2)   ; 
                 (R_R*M)/L_R , 0            , -R_R/L_R                 , -n_p*w_R                ;
                 0           , (R_R*M)/L_R  , n_p*w_R                  , -R_R/L_R                ];
            
            B = [1/sigma , 0       ;
                 0       , 1/sigma ;
                 0       , 0       ;
                 0       , 0       ];
            
            dx = A*x + B*[u_sa;u_sb];
            
            di_sab = dx(1:2);
            dpsi_rab = dx(3:4);
            
            dw_R = (1/J)*tau_R - (b/J)*w_R - (1/J)*tau_L;

        end
    end
end