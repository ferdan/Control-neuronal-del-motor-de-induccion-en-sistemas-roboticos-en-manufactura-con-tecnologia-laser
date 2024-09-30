classdef PBC_Speed_Controller
    properties
        psi_Rmagref
        epsilon_KiS
        K_wR
        Kp_eWR
        Ki_eWR

        struct
        MImodel
    end
    methods
        function obj= PBC_Speed_Controller(psi_Rmagref,epsilon_KiS,K_wR,Kp_eWR,Ki_eWR)
            obj.psi_Rmagref = psi_Rmagref;
            obj.epsilon_KiS = epsilon_KiS;

            obj.K_wR = K_wR;
            obj.Kp_eWR = Kp_eWR;
            obj.Ki_eWR = Ki_eWR;

            obj.struct.psi_Rmagref = obj.psi_Rmagref;
            obj.struct.epsilon_KiS = obj.epsilon_KiS;
            obj.struct.K_wR = obj.K_wR;
            obj.struct.Kp_eWR = obj.Kp_eWR;
            obj.struct.Ki_eWR = obj.Ki_eWR;
        end
        function str = toString(obj)
            str = "** Controlador PBC para control de velocidad **\n\n"...
                + "Amortiguamiento del subsistema electrico epsilon_KiS: " ...
                + string(obj.epsilon_KiS) + " [ohm] \n"...
                + "Amortiguamiento del subsistema mecanico K_wR: " ...
                + string(obj.K_wR) + " \n"...
                + "Filtro de error de velocidad de primer orden. Kp_eWR: " ...
                + string(obj.Kp_eWR) + " Ki_eWR: " + string(obj.Ki_eWR) + "\n"...
                + "Magnitud de flujo magnetico: " + string(obj.psi_Rmagref)...
                + "\n\n\n";
        end
    end
    methods (Static)
        function dT_Lest = dT_Lest(K_wR,e_wR)
            dT_Lest = -K_wR*e_wR;
        end

        function dz = filter_1storder(Kp,Ki,e_wR,z)
            dz = Kp*z+Ki*e_wR;
        end

        function tau_Rref = tau_Rref(MI_motor_params,w_Rref,dw_Rref,tau_Lest,z)
            J = MI_motor_params.mechparams.J;
            b = MI_motor_params.mechparams.b;
            
            tau_Rref = J*dw_Rref + b*w_Rref + tau_Lest - z;
        end
    end
end