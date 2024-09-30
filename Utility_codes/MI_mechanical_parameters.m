classdef MI_mechanical_parameters
    properties
        J
        b
    end

    methods
        function obj = MI_mechanical_parameters(Jval,bval)
            obj.J = Jval;
            obj.b = bval;
        end

        function str = toString(obj)
            str = "\nParametros mecanicos: \n"...
                + "Inercia del rotor: " + string(obj.J) + " [kg m^2]\n"...
                + "Friccion del rotor: " + string(obj.b) + " [ ]\n";
        end
    end
end