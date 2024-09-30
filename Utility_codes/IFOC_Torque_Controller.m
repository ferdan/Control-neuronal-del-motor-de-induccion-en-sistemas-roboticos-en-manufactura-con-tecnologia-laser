classdef IFOC_Torque_Controller
    properties
        psi_Rmagref
        ICAD_controller

        struct
        MImodel
    end
    methods
        function obj= IFOC_Torque_Controller(psi_Rmagref,intGain,intZero,compPoles,compZeros)
            obj.ICAD_controller.Integrator.Gain = intGain;
            obj.ICAD_controller.Integrator.Zero = intZero;
            obj.ICAD_controller.Compensator.Poles = compPoles;
            obj.ICAD_controller.Compensator.Zeros = compZeros;
            obj.psi_Rmagref = psi_Rmagref;

            obj.struct.psi_Rmagref = obj.psi_Rmagref;
            obj.struct.ICAD_controller = obj.ICAD_controller;
        end
        function str = toString(obj)
            str = "** Controlador IndirectFOC(+ICAD) para control de torque **\n\n"...
                + "Integrador(Ganancia) : " + string(obj.ICAD_controller.Integrator.Gain) + "\n"...
                + "Integrador(Cero) : " + string(obj.ICAD_controller.Integrator.Zero) + "\n\n"...
                + "Compensador(Polos) : " + join(string(obj.ICAD_controller.Compensator.Poles)) + "\n"...
                + "Compensador(Ceros) : " + join(string(obj.ICAD_controller.Compensator.Zeros)) + "\n\n"...
                + "Magnitud de flujo magnetico: " + string(obj.psi_Rmagref)...
                +"\n\n\n";
        end
    end
    methods (Static)
        function [i_Sdqref,slip_ref] = torque_controller(MI_motor_params,psi_Rmagref,tau_Rref)
            R_R = MI_motor_params.elecparams.R_R;
            L_R = MI_motor_params.elecparams.L_R;
            M = MI_motor_params.elecparams.M;
            n_p = MI_motor_params.elecparams.n_p;
            
            T_R = L_R/R_R;
            
            a44 = 1/T_R;
            a42 = M/T_R;
            
            K_T = n_p*(M/L_R);
            %K_m = n_p/(2*J);
            
            sigma_R = 1; % Perturbaciones
            
            i_Sdref = a44/a42*psi_Rmagref;
            i_Sqref = tau_Rref/(psi_Rmagref*K_T);
            
            i_Sdqref = [i_Sdref;i_Sqref];
            
            slip_N = (a42/psi_Rmagref)*i_Sqref;
            dslip = (a42*T_R)/(psi_Rmagref^2*K_T)*(sigma_R-1);
            
            slip_ref = slip_N + dslip;
        end
    end
end