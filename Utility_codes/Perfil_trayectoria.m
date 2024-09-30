classdef Perfil_trayectoria
    properties
        nombre
        sel_perfil
        valor_referencia
        
        perfil_archivo
        perfiles
    end
    methods
        function obj = Perfil_trayectoria(nombre,tsim,tstep,sel_perfil,valor_referencia)
            obj.nombre = nombre;
            obj.sel_perfil = sel_perfil;

            if obj.sel_perfil ~= 1 && obj.sel_perfil ~= 7
                obj.valor_referencia = valor_referencia;
            else
                obj.valor_referencia = 0;
            end

            obj.perfiles.sel_perfil = obj.sel_perfil;
            obj.perfiles.valor_referencia = obj.valor_referencia;

            % 1 = constante 0, 2 = 2 escalones, 3 = rampa, 4 = senoidal, 5 = polinomio 7mo orden
            % 6 = escalones sucesivos hasta torque nominal (% de torque nominal)
            % 7 = funcion personalizada (timeseries)
            % 8 = trayectoria 15 segmentos

            % 1. Constante 0
            % 2. Parametros Escalon
            obj.perfiles.escalon1.valor_inicial = 0;
            obj.perfiles.escalon1.amplitud = obj.valor_referencia;
            obj.perfiles.escalon1.tiempo_inicio = 2.5;
            
            obj.perfiles.escalon2.valor_inicial = 0;
            obj.perfiles.escalon2.amplitud = -obj.valor_referencia;
            obj.perfiles.escalon2.tiempo_inicio = 7.5;
            
            % 3. Parametros Rampa
            obj.perfiles.rampa.tiempo_inicio = 2.5;
            obj.perfiles.rampa.tiempo_fin = 7.5;
            obj.perfiles.rampa.valor_inicial = 0;
            obj.perfiles.rampa.valor_final = obj.valor_referencia;
            obj.perfiles.rampa.pendiente = (obj.perfiles.rampa.valor_final-obj.perfiles.rampa.valor_inicial)...
                                      /(obj.perfiles.rampa.tiempo_fin-obj.perfiles.rampa.tiempo_inicio);
            
            % 4. Parametros Senoidal
            obj.perfiles.senoidal.amplitud = obj.valor_referencia;
            obj.perfiles.senoidal.offset = 0;
            obj.perfiles.senoidal.frecuencia = 3*pi; %Hz
            obj.perfiles.senoidal.desfase = pi/2;
            obj.perfiles.senoidal.tiempo_inicio = 2.5;
            
            % 5. Parametros Polinomio 7mo orden
            obj.perfiles.polinomio7.tiempo.inicial = 2.5;
            obj.perfiles.polinomio7.tiempo.final = 7.5;
            obj.perfiles.polinomio7.pos.inicial = 0;
            obj.perfiles.polinomio7.pos.final = obj.valor_referencia;
            obj.perfiles.polinomio7.vel.inicial = 0;
            obj.perfiles.polinomio7.vel.final = 0;
            obj.perfiles.polinomio7.acel.inicial = 0;
            obj.perfiles.polinomio7.acel.final = 0;
            obj.perfiles.polinomio7.jerk.inicial = 0;
            obj.perfiles.polinomio7.jerk.final = 0;
            
            % 6. tren de escalones sucesivos hasta torque nominal
            obj.perfiles.escalones.tiempo_entre_escalones = 2.5;
            obj.perfiles.escalones.amplitud = 0.25*obj.valor_referencia; %en terminos de tau_Rnom
            
            % 7. funcion personalizada (timeseries)
            obj.perfiles.ts.time = 0:tstep:tsim;
            if obj.sel_perfil == 7
                obj.perfil_archivo = valor_referencia;
                obj.perfiles.ts.data = load(valor_referencia);
            else
                obj.perfil_archivo = "";
                obj.perfiles.ts.data = zeros(size(obj.perfiles.ts.time));
            end

            % 8. Parametros trayectoria 15 segmentos
            obj.perfiles.tr15segs.tiempo.inicial = 2.5;
            obj.perfiles.tr15segs.pos.inicial = 0;
            obj.perfiles.tr15segs.pos.final = obj.valor_referencia;
            obj.perfiles.tr15segs.vel_path = 5;
            obj.perfiles.tr15segs.acel_path = 2.5;
            obj.perfiles.tr15segs.jerk_path = 10;
            obj.perfiles.tr15segs.snap_path = 100;

        end

        function perfil_ts = set_perfil_ts(obj,tsim,tstep,data_sel)
            obj.perfiles.ts.data = obj.perfiles.ts.data.tau_Rref(:,data_sel)';
            t_end = (size(obj.perfiles.ts.data,2)-1)*tstep;
            obj.perfiles.ts.time = 0:tstep:t_end;
            if t_end < tsim
                t = t_end+tstep:tstep:tsim;
                obj.perfiles.ts.data = [obj.perfiles.ts.data,...
                                          obj.perfiles.ts.data(end)*ones(size(t))];
                obj.perfiles.ts.time = [obj.perfiles.ts.time,t];
            end
            
            timeseries(obj.perfiles.ts.data,obj.perfiles.ts.time);
            perfil_ts = timeseries(obj.perfiles.ts.data,obj.perfiles.ts.time);
        end

        function str = sel_perfil_str(obj)
            switch obj.sel_perfil
                case 1
                    str = "Constante cero";
                case 2
                    str = "Escalon";
                case 3
                    str = "Rampa";
                case 4
                    str = "Senoidal";
                case 5
                    str = "Polinomio 7mo orden";
                case 6
                    str = "Tren de escalones";
                case 7
                    str = "ts";
                case 8 
                    str = "Trayectoria 15 segmentos";
                otherwise
            end
        end

        function str = sel_perfil_short_str(obj)
            switch obj.sel_perfil
                case 1
                    str = "Cero";
                case 2
                    str = "Esca";
                case 3
                    str = "Ramp";
                case 4
                    str = "Sen";
                case 5
                    str = "Pol7";
                case 6
                    str = "TrEsca";
                case 7
                    str = "ts";
                case 8
                    str = "Tr15segs";
                otherwise
            end
        end

        function str = toString(obj)

            str = obj.nombre + "\n";
            str = str + "Perfil seleccionado: " + obj.sel_perfil_str + "\n";

            switch obj.sel_perfil
                case 1
                case 2
                    str = str + "Escalon 1. \n";
                    str = str + " Valor inicial: " + obj.perfiles.escalon1.valor_inicial + "\n";
                    str = str + " Amplitud: " + obj.perfiles.escalon1.amplitud + "\n";
                    str = str + " Tiempo inicio: " + obj.perfiles.escalon1.tiempo_inicio + "\n";
        
                    str = str + "Escalon 2. \n";
                    str = str + " Valor inicial: " + obj.perfiles.escalon2.valor_inicial + "\n";
                    str = str + " Amplitud: " + obj.perfiles.escalon2.amplitud + "\n";
                    str = str + " Tiempo inicio: " + obj.perfiles.escalon2.tiempo_inicio + "\n";
                case 3
                    str = str + "Rampa \n";
                    str = str + " Tiempo: " + obj.perfiles.rampa.tiempo_inicio + " a " + obj.perfiles.rampa.tiempo_fin + "\n";
                    str = str + " Amplitud: " + obj.perfiles.rampa.valor_inicial + " a " + obj.perfiles.rampa.valor_final + "\n";
                    str = str + " Pendiente: " + obj.perfiles.rampa.pendiente + "\n";
                case 4
                    str = str + "Senoidal \n";
                    str = str + " Amplitud: " + obj.perfiles.senoidal.amplitud + "\n";
                    str = str + " Frecuencia: " + obj.perfiles.senoidal.frecuencia + "\n";
                    str = str + " Offset: " + obj.perfiles.senoidal.offset + "\n";
                    str = str + " Desfase: " + obj.perfiles.senoidal.desfase + "\n";
                case 5
                    str = str + "Polinomio de 7mo orden \n";
                    str = str + " Tiempo: " + obj.perfiles.polinomio7.tiempo.inicial + " a " + obj.perfiles.polinomio7.tiempo.final + "\n";
                    str = str + " Posicion inicial: " + obj.perfiles.polinomio7.pos.inicial + " Posicion final: " + obj.perfiles.polinomio7.pos.final + "\n";
                    str = str + " Velocidad inicial: " + obj.perfiles.polinomio7.vel.inicial + " Velocidad final: " + obj.perfiles.polinomio7.vel.final + "\n";
                    str = str + " Aceleracion inicial: " + obj.perfiles.polinomio7.acel.inicial + " Aceleracion final: " + obj.perfiles.polinomio7.acel.final + "\n";
                    str = str + " Jerk inicial: " + obj.perfiles.polinomio7.jerk.inicial + " Jerk final: " + obj.perfiles.polinomio7.jerk.final + "\n";
                case 6
                    str = str + "Tren de escalones sucesivos hasta referencia \n";
                    str = str + " Tiempo entre escalones: " + obj.perfiles.escalones.tiempo_entre_escalones + "\n";
                    str = str + " Amplitud: " + obj.perfiles.escalones.amplitud + "\n";
                case 7
                    str = str + "Señal definida por archivo timeseries: "+obj.perfil_archivo+" \n";
                case 8
                    str = str + " Tiempo: " + obj.perfiles.tr15segs.tiempo.inicial + "\n";
                    str = str + " Posicion inicial: " + obj.perfiles.tr15segs.pos.inicial + " Posicion final: " + obj.perfiles.tr15segs.pos.final + "\n";
                    str = str + "Velocidad maxima: " + obj.perfiles.tr15segs.vel_path + "\n";
                    str = str + "Aceleracion maxima: " + obj.perfiles.tr15segs.acel_path + "\n";
                    str = str + "Jerk maximo: " + obj.perfiles.tr15segs.jerk_path + "\n";
                    str = str + "Snap maximo: " + obj.perfiles.tr15segs.snap_path + "\n";
                    
                otherwise
                    str = str + "Error \n";
            end
        str = str + "\n\n";
        end
    end
    methods (Static)
        function q = trEsca(t,perfil_params)
            referencia = perfil_params.valor_referencia;
            amplitud = perfil_params.escalones.amplitud;
            tstep = perfil_params.escalones.tiempo_entre_escalones;
            
            
            num_escalones = ceil(referencia/amplitud);
            
            if floor(t/tstep)<num_escalones
                q = amplitud*floor(t/tstep);
            else
                q = amplitud*num_escalones;
            end
        end
    end
end
