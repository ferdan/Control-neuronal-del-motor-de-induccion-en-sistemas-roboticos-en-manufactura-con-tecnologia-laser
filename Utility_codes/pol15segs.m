classdef pol15segs
    properties 
        params
        num_steps
    end
    methods
        function obj = pol15segs(q0,q1,v0,v1,vmax,amax,jmax,smax,num_steps)

            tr_params = struct('q0',q0,'q1',q1,'v0',v0,'v1',v1,...
                                'vmax',vmax,'amax',amax,'jmax',jmax,'smax',smax);

            [Ts,Tj,Ta,Td,Tv] = pol15segs.calculate_times(tr_params);
            
            T = Tv + Ta + Td;
            t = 0:(T/num_steps):T;

            obj.params = struct('q0',q0,'q1',q1,'v0',v0,'v1',v1,...
                                'vmax',vmax,'amax',amax,'jmax',jmax,'smax',smax,...
                                'Ts',Ts,'Tj',Tj,'Ta',Ta,'Td',Td,'Tv',Tv,...
                                'num_steps',num_steps,'T',T,'t',t);
        end
    end
    methods (Static)
        function [Ts,Tj,Ta,Td,Tv] = calculate_times(pol15segs_params)
            vmax = pol15segs_params.vmax;
            amax = pol15segs_params.amax;
            jmax = pol15segs_params.jmax;
            smax = pol15segs_params.smax;

            v0 = pol15segs_params.v0;
            v1 = pol15segs_params.v1;
            q0 = pol15segs_params.q0;
            q1 = pol15segs_params.q1;

            Ts = jmax/smax;
            Tj = amax/jmax + Ts;
            Ta = Tj + (vmax-v0)/amax;
            Td = Tj + (vmax-v1)/amax;
            Tv = (q1-q0)/vmax - Ta/2*(1 + (v0/vmax)) ...
               - Td/2*(1+(v1/vmax));

        end
        
        function [jcheck,acheck,vcheck] = checktimes(pol15segs_params)
            vmax = pol15segs_params.vmax;
            amax = pol15segs_params.amax;
            jmax = pol15segs_params.jmax;

            v0 = pol15segs_params.v0;
            v1 = pol15segs_params.v1;

            Tv = pol15segs_params.Tv;
            Tj = pol15segs_params.Tj;
            Ts = pol15segs_params.Ts;

            jcheck = amax >= Ts*jmax;
            acheck = (vmax - v0) >= Tj*amax && (vmax - v1) >= Tj*amax;
            vcheck = Tv >= 0;

        end

        function [q,T] = bounded_tr(dist,num_steps,vel_path,amax,smax,debug)
            % 15 segments trajectory interpolation
            q0 = 0;
            q1 = dist;
            v0 = 0;
            v1 = 0;
        
            vmax1 = (-2*amax*sqrt(amax/smax)+sqrt(4*amax^3/smax + 4*amax*(q1-q0)))/2;
            vmax2 = (-2*amax*sqrt(amax/smax)-sqrt(4*amax^3/smax + 4*amax*(q1-q0)))/2;
        
            vmax = max(vmax1,vmax2)*0.975;

            pol15segs1 = pol15segs(q0,q1,v0,v1,vmax,amax,sqrt(amax*smax)*0.75,smax,num_steps);
        
            jcheck = false;
            acheck = false;
            vcheck = false;
            i = 1;

            while jcheck == false || acheck == false || vcheck == false
                if i > 1
                    if debug == 1
                        disp("Recalculate all");
                    end
                    amax = vmax/pol15segs1.params.Tj*1.1;
                end
                if vmax > vel_path
                    vmax = vel_path;
                end
            
                if smax < (2*amax^(3/2)/vmax)^2
                    while (2*amax^(3/2)/vmax)^2 > 1.5*smax
                        amax = amax*0.9;
                    end
                    if debug == 1
                        disp("Recalculate smax")
                        disp("amax reduced to " + string(amax))
                    end
                    smax = (2*amax^(3/2)/vmax)^2*1.25;
                end
            
            
                jmax = sqrt(amax*smax)*0.75;

                vmax1 = (-2*amax*sqrt(amax/smax)+sqrt(4*amax^3/smax + 4*amax*(q1-q0)))/2;
                vmax2 = (-2*amax*sqrt(amax/smax)-sqrt(4*amax^3/smax + 4*amax*(q1-q0)))/2;

                vmax = max(vmax1,vmax2)*0.975;

                if vmax > vel_path
                    vmax = vel_path;
                end
            
                pol15segs1 = pol15segs(q0,q1,v0,v1,vmax,amax,jmax,smax,num_steps);
                
                [jcheck,acheck,vcheck] = pol15segs.checktimes(pol15segs1.params);
                i = i + 1;
            end
        
            if jcheck == 0 || acheck == 0 || vcheck == 0
                disp("Trajectory has not reached max values");
                if jcheck == 0
                    disp("jmax has not been reached ")
                end
                if acheck == 0
                    disp("amax has not been reached ")
                end
                if vcheck == 0
                    disp("vmax has not been reached ")
                end
            end
        
            [q,d1q,d2q,d3q,d4q] = pol15segs.interpol_pol15segs(pol15segs1.params);
            T = pol15segs1.params.T;
        
            if debug == 1
                pol15segs.plot_pol15segs(2,pol15segs1.params,q,d1q,d2q,d3q,d4q);
                pol15segs1.params
            end
        end

        function [q,d1q,d2q,d3q,d4q] = interpol_pol15segs(pol15segs_params)
            [qa,d1qa,d2qa,d3qa,d4qa] = pol15segs.acel_phase(pol15segs_params);
            [qv,d1qv,d2qv,d3qv,d4qv] = pol15segs.velcte_phase(pol15segs_params);
            [qd,d1qd,d2qd,d3qd,d4qd] = pol15segs.decel_phase(pol15segs_params);

            d4q = [d4qa,d4qv,d4qd];
            d3q = [d3qa,d3qv,d3qd];
            d2q = [d2qa,d2qv,d2qd];
            d1q = [d1qa,d1qv,d1qd];
            q = [qa,qv,qd];

        end

        function [q,d1q,d2q,d3q,d4q] = acel_phase(pol15segs_params)
            amax = pol15segs_params.amax;
            jmax = pol15segs_params.jmax;
            smax = pol15segs_params.smax;

            v0 = pol15segs_params.v0;
            q0 = pol15segs_params.q0;

            Ta = pol15segs_params.Ta;
            Tj = pol15segs_params.Tj;
            Ts = pol15segs_params.Ts;

            t = pol15segs_params.t;


            [~,idt_Ts] = min(abs(t-(Ts)));
            [~,idt_TjTs] = min(abs(t-(Tj-Ts)));
            [~,idt_Tj] = min(abs(t-(Tj)));
            [~,idt_TaTj] = min(abs(t-(Ta-Tj)));
            [~,idt_TaTjTs] = min(abs(t-(Ta-Tj+Ts)));
            [~,idt_TaTs] = min(abs(t-(Ta-Ts)));
            [~,idt_Ta] = min(abs(t-(Ta)));
        
            t1 = t(1:(idt_Ts-1));
            t2 = t(idt_Ts:(idt_TjTs-1));
            t3 = t(idt_TjTs:(idt_Tj-1));
            t4 = t(idt_Tj:(idt_TaTj-1));
            t5 = t(idt_TaTj:(idt_TaTjTs-1));
            t6 = t(idt_TaTjTs:(idt_TaTs-1));
            t7 = t(idt_TaTs:(idt_Ta-1));
        
            % 1: [0,Ts)
            d4q_t1 = smax.*ones(size(t1));
            d3q_t1 = smax.*t1;
            d2q_t1 = smax./2.*t1.^2;
            d1q_t1 = smax./6.*t1.^3 + v0;
            q_t1 = smax./24*t1.^4 + v0.*t1 + q0;

            % 2: [Ts,Tj-Ts)
            d4q_t2 = 0.*ones(size(t2));
            d3q_t2 = jmax.*ones(size(t2));
            d2q_t2 = jmax.*t2 - 1./2*jmax*Ts;
            d1q_t2 = jmax./6.*Ts.^2 + 1./2.*jmax.*t2.*(t2 - Ts) ...
                   + v0;
            q_t2 = jmax./24.*(2.*t2 - Ts).*(2.*t2.*(t2 - Ts) + Ts.^2) ...
                   + v0.*t2 + q0;
            
            % 3: [Tj-Ts,Tj)
            d4q_t3 = -smax.*ones(size(t3));
            d3q_t3 = -smax.*(t3 - Tj);
            d2q_t3 = -smax./2.*(t3 - Tj).^2 + amax;
            d1q_t3 = smax./6.*(7.*Ts.^3 - 9.*Ts.^2.*(t3 + Ts) ...
                   + 3.*Ts.*(t3 + Ts).^2 - (t3 - Tj + Ts).^3) + v0;
            q_t3 = smax./24.*(-15.*Ts.^4 + 28.*Ts.^3.*(t3 + Ts) ...
                 - 18.*Ts.^2.*(t3 + Ts).^2 + 4.*Ts.*(t3 + Ts).^3 ...
                 - (t3 - Tj + Ts).^4) + v0.*t3 + q0;
        
            % 4: [Tj,Ta-Tj]
            d4q_t4 = 0.*ones(size(t4));
            d3q_t4 = 0.*ones(size(t4));
            d2q_t4 = amax.*ones(size(t4));
            d1q_t4 = amax/2.*(2.*t4 - Tj) + v0;
            q_t4 = amax./12.*(6.*t4.^2 - 6.*t4.*Tj + 2.*Tj.^2 ...
                 - Tj.*Ts + Ts.^2) + v0.*t4 + q0;

            % 5: [Ta-Tj,Ta-Tj+Ts]
            d4q_t5 = -smax.*ones(size(t5));
            d3q_t5 = -smax.*(t5 - Ta + Tj);
            d2q_t5 = amax - smax./2.*(t5 - Ta + Tj).^2;
            d1q_t5 = -smax./6.*(t5 - Ta + Tj).^3 ...
                   + amax./2.*(2*t5 - Tj) + v0;
            q_t5 = -smax./24.*(t5 - Ta + Tj).^4 ...
                 + amax./12.*(6.*t5.^2 - 6.*t5.*Tj + 2.*Tj.^2 ...
                 - Tj.*Ts + Ts.^2) + v0.*t5 + q0;

            % 6: [Ta-Tj+Ts,Ta-Ts]
            d4q_t6 = 0.*ones(size(t6));
            d3q_t6 = -jmax.*ones(size(t6));
            d2q_t6 = -jmax./2.*(2.*t6 - 2.*Ta + Ts);
            d1q_t6 = -jmax./6.*(3.*(t6 - Ta).^2 - 6.*Ta.*Tj ...
                   + 6.*Tj.^2 + 3.*(t6 + Ta - 2.*Tj).*Ts ...
                   + Ts.^2) + v0;
            q_t6 = -jmax./24.*(4.*(t6 - Ta).^3 - 12.*(2.*t6 - Ta).*Ta.*Tj ...
                 + 12.*(2.*t6 - Ta).*Tj.^2 + 6.*(t6.^2 + 2.*t6.*(Ta - 2.*Tj)...
                 - Ta.*(Ta - 2.*Tj)).*Ts + 4.*(t6 - Ta).*Ts.^2 ...
                 + Ts.^3) + v0.*t6 + q0;

            % 7 [Ta-Ts,Ta]
            d4q_t7 = smax.*ones(size(t7));
            d3q_t7 = smax.*(t7 - Ta);
            d2q_t7 = smax./2.*(t7 - Ta).^2;
            d1q_t7 = smax./6.*(t7 - Ta).^3 + amax.*(Ta - Tj) + v0;
            q_t7 = smax./24.*(t7 - Ta).^4 + amax./2.*(2.*t7 - Ta).*(Ta - Tj) ...
                 + v0.*t7 + q0;

            d4q = [d4q_t1,d4q_t2,d4q_t3,d4q_t4,d4q_t5,d4q_t6,d4q_t7];
            d3q = [d3q_t1,d3q_t2,d3q_t3,d3q_t4,d3q_t5,d3q_t6,d3q_t7];
            d2q = [d2q_t1,d2q_t2,d2q_t3,d2q_t4,d2q_t5,d2q_t6,d2q_t7];
            d1q = [d1q_t1,d1q_t2,d1q_t3,d1q_t4,d1q_t5,d1q_t6,d1q_t7];
            q = [q_t1,q_t2,q_t3,q_t4,q_t5,q_t6,q_t7];

        end

        function [q,d1q,d2q,d3q,d4q] = velcte_phase(pol15segs_params)
            vmax = pol15segs_params.vmax;

            v0 = pol15segs_params.v0;
            q0 = pol15segs_params.q0;

            Tv = pol15segs_params.Tv;
            Ta = pol15segs_params.Ta;

            t = pol15segs_params.t;

            [~,idt_Ta] = min(abs(t-(Ta)));
            [~,idt_TaTv] = min(abs(t-(Ta+Tv)));

            t8 = t(idt_Ta:(idt_TaTv-1));

            % 8: [Ta,Ta-Tv]
            d4q = 0.*ones(size(t8));
            d3q = 0.*ones(size(t8));
            d2q = 0.*ones(size(t8));
            d1q = vmax.*ones(size(t8));
            q = (vmax - v0)./2.*(2.*t8 - Ta) + v0.*t8 + q0;


        end

        function [q,d1q,d2q,d3q,d4q] = decel_phase(pol15segs_params)
            amax = pol15segs_params.amax;
            jmax = pol15segs_params.jmax;
            smax = pol15segs_params.smax;

            v1 = pol15segs_params.v1;
            q1 = pol15segs_params.q1;

            Tv = pol15segs_params.Tv;
            Ta = pol15segs_params.Ta;
            Td = pol15segs_params.Td;
            Tj = pol15segs_params.Tj;
            Ts = pol15segs_params.Ts;
            T = pol15segs_params.T;

            t = pol15segs_params.t;


            [~,idt_TaTv] = min(abs(t-(Ta+Tv)));
            [~,idt_TaTvTs] = min(abs(t-(Ta+Tv+Ts)));
            [~,idt_TaTvTjTs] = min(abs(t-(Ta+Tv+Tj-Ts)));
            [~,idt_TaTvTj] = min(abs(t-(Ta+Tv+Tj)));
            [~,idt_TTj] = min(abs(t-(T-Tj)));
            [~,idt_TTjTs] = min(abs(t-(T-Tj+Ts)));
            [~,idt_TTs] = min(abs(t-(T-Ts)));
            [~,idt_T] = min(abs(t-(T)));
        
            t9 = t(idt_TaTv:(idt_TaTvTs-1));
            t10 = t(idt_TaTvTs:(idt_TaTvTjTs-1));
            t11 = t(idt_TaTvTjTs:(idt_TaTvTj-1));
            t12 = t(idt_TaTvTj:(idt_TTj-1));
            t13 = t(idt_TTj:(idt_TTjTs-1));
            t14 = t(idt_TTjTs:(idt_TTs-1));
            t15 = t(idt_TTs:(idt_T));

            % 9: [Ta+Tv,Ta+Tv+Ts]
            d4q_t9 = -smax.*ones(size(t9));
            d3q_t9 = smax.*((T - t9) - Td);
            d2q_t9 = -smax./2.*((T - t9) - Td).^2;
            d1q_t9 = smax./6.*((T - t9) - Td).^3 + amax.*(Td - Tj) + v1;
            q_t9 = -smax./24.*((T - t9) - Td).^4 - amax./2.*(2.*(T - t9) - Td).*(Td - Tj) ...
                 - v1*(T - t9) + q1;

            % 10: [Ta+Tv+Ts,Ta+Tv+Tj-Ts]
            d4q_t10 = 0.*ones(size(t10));
            d3q_t10 = -jmax.*ones(size(t10));
            d2q_t10 = jmax./2.*(2.*(T - t10) - 2.*Td + Ts);
            d1q_t10 = -jmax./6.*(3.*((T - t10) - Td).^2 - 6.*Td.*Tj + 6.*Tj.^2 ...
                    + 3.*((T - t10) + Td - 2.*Tj).*Ts + Ts.^2) + v1;
            q_t10 = jmax./24.*(4.*((T - t10) - Td).^3 - 12.*(2.*(T - t10) - Td).*Td.*Tj ...
                  + 12.*(2.*(T - t10) - Td).*Tj.^2 + 6.*((T - t10).^2 + 2.*(T - t10).*(Td - 2.*Tj)...
                  - Td.*(Td - 2.*Tj)).*Ts + 4.*((T - t10) - Td).*Ts.^2 + Ts.^3)...
                  - v1.*(T - t10) + q1;

            % 11: [Ta+Tv+Tj-Ts,Ta+Tv+Tj]
            d4q_t11 = smax.*ones(size(t11));
            d3q_t11 = -smax.*((T - t11) - Td + Tj);
            d2q_t11 = -amax + smax./2.*((T - t11) - Td + Tj).^2;
            d1q_t11 = -smax./6.*((T - t11) - Td + Tj).^3 + amax./2.*(2.*(T - t11) - Tj) + v1;
            q_t11 = smax./24.*((T - t11) - Td + Tj).^4 - amax./12.*(6.*(T - t11).^2 ...
                  - 6.*(T - t11).*Tj + 2.*Tj.^2 - Tj.*Ts + Ts.^2) - v1.*(T - t11) + q1;
            
            % 12: [Ta+Tv+Tj,T-Tj]
            d4q_t12 = 0.*ones(size(t12));
            d3q_t12 = 0.*ones(size(t12));
            d2q_t12 = -amax.*ones(size(t12));
            d1q_t12 = amax./2.*(2.*(T - t12) - Tj) + v1;
            q_t12 = -amax./12.*(6.*(T - t12).^2 - 6.*(T - t12).*Tj + 2.*Tj.^2 ...
                  - Tj.*Ts + Ts.^2) - v1.*(T - t12) + q1;

            % 13: [T-Tj,T-Tj+Ts]
            d4q_t13 = smax.*ones(size(t13));
            d3q_t13 = -smax.*((T - t13) - Tj);
            d2q_t13 = smax./2.*((T - t13) - Tj).^2 - amax;
            d1q_t13 = smax./6.*(7.*Ts.^3 - 9.*Ts.^2.*((T - t13) + Ts) ...
                    + 3.*Ts.*((T - t13) + Ts).^2 - ((T - t13) - Tj + Ts).^3) + v1;
            q_t13 = -smax./24.*(-15.*Ts.^4 + 28.*Ts.^3.*((T - t13) + Ts) ...
                  - 18.*Ts.^2.*((T - t13) + Ts).^2 + 4.*Ts.*((T - t13) + Ts).^3 ...
                  - ((T - t13) - Tj + Ts).^4) - v1.*(T - t13) + q1;

            % 14: [T-Tj+Ts,T-Ts]
            d4q_t14 = 0.*ones(size(t14));
            d3q_t14 = jmax.*ones(size(t14));
            d2q_t14 = -jmax.*(T - t14) + jmax./2.*Ts;
            d1q_t14 = jmax./6.*Ts.^2 + jmax./2.*(T - t14).*((T - t14) - Ts) + v1;
            q_t14 = -jmax./24.*(2.*(T - t14) - Ts).*(2.*(T - t14).*((T - t14) - Ts) + Ts.^2)...
                  - v1.*(T - t14) + q1;

            % 15: [T-Ts,T]
            d4q_t15 = -smax.*ones(size(t15));
            d3q_t15 = smax.*(T - t15);
            d2q_t15 = -smax./2.*(T - t15).^2;
            d1q_t15 = smax./6.*(T - t15).^3 + v1;
            q_t15 = -smax./24.*(T - t15).^4 - v1.*(T - t15) + q1;

            d4q = [d4q_t9,d4q_t10,d4q_t11,d4q_t12,d4q_t13,d4q_t14,d4q_t15];
            d3q = [d3q_t9,d3q_t10,d3q_t11,d3q_t12,d3q_t13,d3q_t14,d3q_t15];
            d2q = [d2q_t9,d2q_t10,d2q_t11,d2q_t12,d2q_t13,d2q_t14,d2q_t15];
            d1q = [d1q_t9,d1q_t10,d1q_t11,d1q_t12,d1q_t13,d1q_t14,d1q_t15];
            q = [q_t9,q_t10,q_t11,q_t12,q_t13,q_t14,q_t15];
        end

        function times = transition_index_times(pol15segs_params)
        
            Tv = pol15segs_params.Tv;
            Ta = pol15segs_params.Ta;
            %Td = pol15segs_params.Td;
            Tj = pol15segs_params.Tj;
            Ts = pol15segs_params.Ts;
            T = pol15segs_params.T;
        
            t = pol15segs_params.t;
        
            [~,idt_Ts] = min(abs(t-(Ts)));
            [~,idt_TjTs] = min(abs(t-(Tj-Ts)));
            [~,idt_Tj] = min(abs(t-(Tj)));
            [~,idt_TaTj] = min(abs(t-(Ta-Tj)));
            [~,idt_TaTjTs] = min(abs(t-(Ta-Tj+Ts)));
            [~,idt_TaTs] = min(abs(t-(Ta-Ts)));
            [~,idt_Ta] = min(abs(t-(Ta)));

            [~,idt_TaTv] = min(abs(t-(Ta+Tv)));

            [~,idt_TaTvTs] = min(abs(t-(Ta+Tv+Ts)));
            [~,idt_TaTvTjTs] = min(abs(t-(Ta+Tv+Tj-Ts)));
            [~,idt_TaTvTj] = min(abs(t-(Ta+Tv+Tj)));
            [~,idt_TTj] = min(abs(t-(T-Tj)));
            [~,idt_TTjTs] = min(abs(t-(T-Tj+Ts)));
            [~,idt_TTs] = min(abs(t-(T-Ts)));
            [~,idt_T] = min(abs(t-(T)));
          
            times = [idt_Ts,idt_TjTs,idt_Tj,idt_TaTj,idt_TaTjTs,idt_TaTs,idt_Ta,idt_TaTv...
                     idt_TaTvTs,idt_TaTvTjTs,idt_TaTvTj,idt_TTj,idt_TTjTs,idt_TTs,idt_T];
            
        end

        function plot_pol15segs(num_fig,pol15segs_params,q,d1q,d2q,d3q,d4q)

            pol15segs1_times = pol15segs.transition_index_times(pol15segs_params);
            t = pol15segs_params.t;

            figure(num_fig)
            clf

            subplot(5,1,1)
            sgtitle("15 segments trajectory")
            stairs(t,q,'LineWidth',2)
            hold on
            xline(t(pol15segs1_times));
            ylabel("q")

            grid on
            grid("minor")

            subplot(5,1,2)
            stairs(t,d1q,'LineWidth',2)
            xline(t(pol15segs1_times));
            ylabel("dq")

            grid on
            grid("minor")

            subplot(5,1,3)
            stairs(t,d2q,'LineWidth',2)
            xline(t(pol15segs1_times));
            ylabel("d^{(2)}q")

            grid on
            grid("minor")

            subplot(5,1,4)
            stairs(t,d3q,'LineWidth',2)
            xline(t(pol15segs1_times));
            ylabel("d^{(3)}q")

            grid on
            grid("minor")

            subplot(5,1,5)
            stairs(t,d4q,'LineWidth',2)
            xline(t(pol15segs1_times));
            ylabel("d^{(4)}q")
            xlabel("t")

            grid on
            grid("minor")
        end
    end
end
