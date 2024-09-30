classdef handler_SimulinkBlockParams
    methods (Static)
        function setControladorIFOC(simname,context,controlador)
            load_system(simname);
            str_path = simname;
            if ~strcmp(context,"")
                str_path = str_path + "/" + context;
            end
            perfilPaths = find_system(str_path,'Type','Block');

            filtered_perfilPathsInt = perfilPaths(contains(perfilPaths,'Integrador'));
            blockHandlerInt = zeros(1,size(filtered_perfilPathsInt,1));
            for i = 1:size(filtered_perfilPathsInt,1)
                blockHandlerInt(i) = getSimulinkBlockHandle(filtered_perfilPathsInt(i),true);
            end

            filtered_perfilPathsComp = perfilPaths(contains(perfilPaths,'Compensador'));
            blockHandlerComp = zeros(1,size(filtered_perfilPathsComp,1));
            for i = 1:size(filtered_perfilPathsComp,1)
                blockHandlerComp(i) = getSimulinkBlockHandle(filtered_perfilPathsComp(i),true);
            end

            handler_SimulinkBlockParams.config_TransFcnIntegrador(controlador,blockHandlerInt);
            handler_SimulinkBlockParams.config_TransFcnCompensador(controlador,blockHandlerComp);
        end

        function setControladorPBC(simname,context,controlador)
            load_system(simname);
            str_path = simname;
            if ~strcmp(context,"")
                str_path = str_path + "/" + context;
            end
            perfilPaths = find_system(str_path,'Type','Block');
            filtered_perfilPaths = perfilPaths(contains(perfilPaths,"int_psi_R0"));
            blockHandler = zeros(1,size(filtered_perfilPaths,1));
            for i = 1:size(filtered_perfilPaths,1)
                blockHandler(i) = getSimulinkBlockHandle(filtered_perfilPaths(i),true);
            end

            set_param(blockHandler,"InitialCondition","["+string(controlador.psi_Rmagref)+";0]");
        end

        function setPerfilTrayectoria(simname,context,perfil)
            load_system(simname);
            str_path = simname;
            if ~strcmp(context,"")
                str_path = str_path + "/" + context;
            end
            perfilPaths = find_system(str_path + "/" + perfil.nombre,'IncludeCommented','on','Type','Block');

            filtered_perfilPath = perfilPaths(contains(perfilPaths,"ts_data"));
            blockHandler = getSimulinkBlockHandle(filtered_perfilPath,true);
            if perfil.sel_perfil ~= 7
                set_param(blockHandler,'Commented','on');
            else
                set_param(blockHandler,'Commented','off');
            end

            filtered_perfilPaths = perfilPaths(contains(perfilPaths,lower(perfil.sel_perfil_str)));
            blockHandler = zeros(1,size(filtered_perfilPaths,1));
            for i = 1:size(filtered_perfilPaths,1)
                blockHandler(i) = getSimulinkBlockHandle(filtered_perfilPaths(i),true);
            end
        
            switch perfil.sel_perfil
                case 1
                    %disp("Ningún bloque a configurar")
                case 2
                    handler_SimulinkBlockParams.config_escalon(perfil,blockHandler);
                case 3
                    handler_SimulinkBlockParams.config_rampa(perfil,blockHandler);
                case 4
                    handler_SimulinkBlockParams.config_senoidal(perfil,blockHandler);
                case 5
                    %disp("Ningún bloque a configurar")
                case 6
                    %disp("Ningún bloque a configurar")
                case 7
                    handler_SimulinkBlockParams.config_ts(perfil,blockHandler);
                otherwise
                    disp("Error en configuracion de bloques de perfiles")
            end
        end

        function setModelRMA(simname,robot_params,str_bloque,q)
            load_system(simname)
            str_path = simname;
            perfilPaths = find_system(str_path);
            filtered_perfilPath = perfilPaths(contains(perfilPaths,str_bloque));
            blockHandlerInt = getSimulinkBlockHandle(filtered_perfilPath,true);
            
            str_i = "[";
            for i = 1:robot_params.ndof
                str_i = str_i + string(q(i));
                if i == robot_params.ndof
                    str_i = str_i + "]";
                else
                    str_i = str_i + ";";
                end
            end
            set_param(blockHandlerInt,"InitialCondition",str_i);
        end
    end

    methods (Static,Access = protected)
        function config_escalon(perfil,blockHandler)
            % get_param(blockHandler(1),'DialogParameters')
            set_param(blockHandler(1),"Time",string(perfil.perfiles.escalon1.tiempo_inicio));
            set_param(blockHandler(1),"Before",string(perfil.perfiles.escalon1.valor_inicial));
            set_param(blockHandler(1),"After",string(perfil.perfiles.escalon1.amplitud));
        
            set_param(blockHandler(2),"Time",string(perfil.perfiles.escalon2.tiempo_inicio));
            set_param(blockHandler(2),"Before",string(perfil.perfiles.escalon2.valor_inicial));
            set_param(blockHandler(2),"After",string(perfil.perfiles.escalon2.amplitud));
        end
        
        function config_rampa(perfil,blockHandler)
            set_param(blockHandler(1),"slope",string(perfil.perfiles.rampa.pendiente));
            set_param(blockHandler(1),"start",string(perfil.perfiles.rampa.tiempo_inicio));
            set_param(blockHandler(1),"InitialOutput",string(perfil.perfiles.rampa.valor_inicial));
        
            set_param(blockHandler(2),"slope",string(-perfil.perfiles.rampa.pendiente));
            set_param(blockHandler(2),"start",string(perfil.perfiles.rampa.tiempo_fin));
            set_param(blockHandler(2),"InitialOutput",string(perfil.perfiles.rampa.valor_inicial));
        end
        
        function config_senoidal(perfil,blockHandler)
            set_param(blockHandler,"Amplitude",string(perfil.perfiles.senoidal.amplitud));
            set_param(blockHandler,"Bias",string(perfil.perfiles.senoidal.offset));
            set_param(blockHandler,"Frequency",string(perfil.perfiles.senoidal.frecuencia));
            set_param(blockHandler,"Phase",string(perfil.perfiles.senoidal.desfase));
        end

        function config_ts(perfil,blockHandler)
            str_perfil = split(perfil.nombre);
            str_perfil = str_perfil(end);
            %set_param(blockHandler,"VariableName",str_perfil+".perfiles.ts.data")
            set_param(blockHandler,"VariableName",str_perfil+"_ts")
        end

        function config_TransFcnIntegrador(controlador,blockHandler)
            numInt = string(controlador.ICAD_controller.Integrator.Gain) + "*" ...
                   + "[1 " + string(controlador.ICAD_controller.Integrator.Zero) + "]";
            
            for i = 1:size(blockHandler,2)
                set_param(blockHandler(i),"Numerator",numInt);
            end
        end

        function config_TransFcnCompensador(controlador,blockHandler)
            numComp = controlador.ICAD_controller.Compensator.Poles;
            denComp = controlador.ICAD_controller.Compensator.Zeros;

            str_numComp = handler_SimulinkBlockParams.str_polinomio(numComp);
            str_denComp = handler_SimulinkBlockParams.str_polinomio(denComp);

            for i = 1:size(blockHandler,2)
                set_param(blockHandler(i),"Numerator",str_numComp);
                set_param(blockHandler(i),"Denominator",str_denComp);
            end
        end        

        function str_poly = str_polinomio(roots)
            str_rr = string(poly(roots));
            str_poly = "[";
            for i = 1:size(str_rr,2)
                str_poly = str_poly + str_rr(i);
                if i ~= size(str_rr,2)
                    str_poly = str_poly + ",";
                end
            end
            str_poly = str_poly + "]";
        end
    end
end