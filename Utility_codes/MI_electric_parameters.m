classdef MI_electric_parameters
    properties
        n_p % pares de polos
        R_S
        R_R
        L_S
        L_R
        M
    end

    properties (Dependent)
        sigma
        gamma 
    end

    methods
        function obj = MI_electric_parameters(npval,R_Sval,R_Rval,L_Sval,L_Rval,Mval)
            obj.n_p = npval;
            obj.R_S = R_Sval;
            obj.R_R = R_Rval;
            obj.L_S = L_Sval;
            obj.L_R = L_Rval;
            obj.M = Mval;
        end

        function sigma = get.sigma(obj)
            sigma = obj.L_S-(obj.M^2/obj.L_R);
        end

        function gamma = get.gamma(obj)
            gamma = (obj.R_S*obj.L_R^2+obj.R_R*obj.M^2)/(obj.sigma*obj.L_R^2);
        end

        function str = toString(obj)
            str = "\nParametros electricos: \n"...
                + "Pares de polos n_p: " + string(obj.n_p) + " (" + string(obj.n_p*2) + " polos)\n"...
                + "Resistencia de devanados de estator R_S: " + string(obj.R_S) + " [ohm]\n"...
                + "Resistencia de devanados de rotor R_R: " + string(obj.R_R) + " [ohm]\n"...
                + "Inductancia de devanados de estator L_S: " + string(obj.L_S) + " [H]\n"...
                + "Inductancia de devanados de rotor L_R: " + string(obj.L_R) + " [H]\n"...
                + "Inductancia mutua M: " + string(obj.M) + " [H]\n";
        end
    end
    methods (Static)
        function sigma = calculate_sigma(MI_electric_parameters)
            L_S = MI_electric_parameters.L_S;
            L_R = MI_electric_parameters.L_R;
            M = MI_electric_parameters.M;

            sigma = L_S-(M^2/L_R);
        end
        function gamma = calculate_gamma( MI_electric_parameters)
            %n_p = MI_electric_parameters.n_p;
            R_S = MI_electric_parameters.R_S;
            R_R = MI_electric_parameters.R_R;
            %L_S = MI_electric_parameters.L_S;
            L_R = MI_electric_parameters.L_R;
            M = MI_electric_parameters.M;

            sigma = MI_electric_parameters.sigma;

            gamma = (R_S*L_R^2+R_R*M^2)/(sigma*L_R^2);
        end
    end
end