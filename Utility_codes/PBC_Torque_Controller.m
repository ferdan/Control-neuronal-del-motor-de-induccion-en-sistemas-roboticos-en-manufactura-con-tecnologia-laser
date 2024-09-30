classdef PBC_Torque_Controller
    properties
        psi_Rmagref
        epsilon_KiS
        
        struct
        MImodel
    end
    methods
        function obj= PBC_Torque_Controller(psi_Rmagref,epsilon_KiS)
            obj.psi_Rmagref = psi_Rmagref;
            obj.epsilon_KiS = epsilon_KiS;

            obj.struct.psi_Rmagref = obj.psi_Rmagref;
            obj.struct.epsilon_KiS = obj.epsilon_KiS;
        end
        function str = toString(obj)
            str = "** Controlador PBC para control de torque **\n\n"...
                + "Amortiguamiento del subsistema electrico epsilon_KiS: " ...
                + string(obj.epsilon_KiS) + " [ohm]\n"...
                + "Magnitud de flujo magnetico: " + string(obj.psi_Rmagref)...
                +"\n\n\n";
        end
    end
    methods (Static)
        function u_S = ley_control_uS(MI_motor_params,i_Sref,d_iSref,psi_Rref,w_R,e_is,Ki_s)
            R_R = MI_motor_params.elecparams.R_R;
            L_R = MI_motor_params.elecparams.L_R;
            M = MI_motor_params.elecparams.M;
            n_p = MI_motor_params.elecparams.n_p;
            
            sigma = MI_motor_params.elecparams.sigma;
            gamma = MI_motor_params.elecparams.gamma;
            
            di_Saref = d_iSref(1);
            di_Sbref = d_iSref(2);
            
            i_Saref = i_Sref(1);
            i_Sbref = i_Sref(2);
            
            psi_Raref = psi_Rref(1);
            psi_Rbref = psi_Rref(2);
            
            e_iSa = e_is(1);
            e_iSb = e_is(2);
            
            u_Sa = sigma*di_Saref - n_p*M/L_R*w_R*psi_Rbref + sigma*gamma*i_Saref - R_R*M/L_R^2*psi_Raref - Ki_s*e_iSa;
            u_Sb = sigma*di_Sbref + n_p*M/L_R*w_R*psi_Raref + sigma*gamma*i_Sbref - R_R*M/L_R^2*psi_Rbref - Ki_s*e_iSb;
            
            u_S = [u_Sa;u_Sb];
        end

        function K_iS = K_iS(MI_motor_params,w_R,epsilon)
            R_R = MI_motor_params.elecparams.R_R;
            M = MI_motor_params.elecparams.M;
            L_R = MI_motor_params.elecparams.L_R;
            n_p = MI_motor_params.elecparams.n_p;

            w_Rnom = MI_motor_params.nomvals.w_Rnom/6;
            
            
            % K_iS = M^2*L_R*n_p^2*w_R^2/(epsilon*4*R_R);
            K_iS = M^2*L_R*n_p^2*w_Rnom^2/(epsilon*4*R_R);
        end

        function d_iSref = d_iSref(MI_motor_params,psi_Rref,dpsi_Rref,psi_Rmagref,dpsi_Rmagref,ddpsi_Rmagref,tau_Rref,dtau_Rref)
            R_R = MI_motor_params.elecparams.R_R;
            L_R = MI_motor_params.elecparams.L_R;
            M = MI_motor_params.elecparams.M;
            n_p = MI_motor_params.elecparams.n_p;
            
            dpsi_Raref = dpsi_Rref(1);
            dpsi_Rbref = dpsi_Rref(2);
            
            psi_Raref = psi_Rref(1);
            psi_Rbref = psi_Rref(2);
            
            d_iSaref = L_R/(M*n_p)*(- ((dtau_Rref-2*tau_Rref*dpsi_Rmagref)/psi_Rmagref)*psi_Rbref - tau_Rref/psi_Rmagref^2*dpsi_Rbref) + dpsi_Raref/M ...
                     + L_R/(R_R*M)*(((ddpsi_Rmagref*psi_Rmagref-dpsi_Rmagref^2)/psi_Rmagref^2)*psi_Raref + dpsi_Rmagref/psi_Rmagref*dpsi_Raref);
            
            d_iSbref = L_R/(M*n_p)*(+ ((dtau_Rref-2*tau_Rref*dpsi_Rmagref)/psi_Rmagref)*psi_Raref + tau_Rref/psi_Rmagref^2*dpsi_Raref) + dpsi_Rbref/M ...
                     + L_R/(R_R*M)*(((ddpsi_Rmagref*psi_Rmagref-dpsi_Rmagref^2)/psi_Rmagref^2)*psi_Rbref + dpsi_Rmagref/psi_Rmagref*dpsi_Rbref);
            
            d_iSref = [d_iSaref;d_iSbref];
        end

        function i_Sref = i_Sref(MI_motor_params,psi_Rref,tau_Rref,psi_Rmagref,dpsi_Rmagref)
            R_R = MI_motor_params.elecparams.R_R;
            L_R = MI_motor_params.elecparams.L_R;
            M = MI_motor_params.elecparams.M;
            n_p = MI_motor_params.elecparams.n_p;

            psi_Raref = psi_Rref(1);
            psi_Rbref = psi_Rref(2);

            i_Saref =  - L_R/(M*n_p*psi_Rmagref^2)*tau_Rref*psi_Rbref + 1/M*psi_Raref + L_R/(R_R*M)*dpsi_Rmagref/psi_Rmagref*psi_Raref;
            i_Sbref =  + L_R/(M*n_p*psi_Rmagref^2)*tau_Rref*psi_Raref + 1/M*psi_Rbref + L_R/(R_R*M)*dpsi_Rmagref/psi_Rmagref*psi_Rbref;
            
            i_Sref = [i_Saref;i_Sbref];
        end

        function dpsi_Rref = dpsi_Ref(MI_motor_params,w_R,psi_Rref,tau_Rref,psi_Rmagref,dpsi_Rmagref)
            R_R = MI_motor_params.elecparams.R_R;
            n_p = MI_motor_params.elecparams.n_p;
            
            psi_Raref = psi_Rref(1);
            psi_Rbref = psi_Rref(2);
            
            dpsi_Raref = - (n_p*w_R + R_R/(n_p*psi_Rmagref^2)*tau_Rref)*psi_Rbref + dpsi_Rmagref/psi_Rmagref*psi_Raref;
            dpsi_Rbref = + (n_p*w_R + R_R/(n_p*psi_Rmagref^2)*tau_Rref)*psi_Raref + dpsi_Rmagref/psi_Rmagref*psi_Rbref;
            
            dpsi_Rref = [dpsi_Raref;dpsi_Rbref];
        end
    end
end