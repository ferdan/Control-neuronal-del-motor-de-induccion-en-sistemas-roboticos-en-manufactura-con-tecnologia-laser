classdef SIM_model
    properties
        tsim
        tstep
        
        out

        MI_bus
        Contr_bus
        Perfil_bus
    end
    methods
        function obj = SIM_model(tsim,tstep)
            obj.tsim = tsim;
            obj.tstep = tstep;
        end
    end
end