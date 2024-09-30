classdef SIMMI_GraficasHandler
    methods (Static)
        function f_data = figData(simname,t,tinit,tfin,data,str_dir_graficas,str_dir)
            [~,tinit_ind] = min(abs(t-tinit));
            [~,tfin_ind] = min(abs(t-tfin));
            ind_data = tinit_ind:tfin_ind;

            f_data(1) = figureHandler.graficar_Fig(1,0,[1,1],"Torque $\tau_R$", ...
                          t(ind_data),[data.tau_R(ind_data),data.tau_L(ind_data)], ...
                          "Tiempo [s]","Torque [N m]",["$\tau_R$","$\tau_L$"],'northeast');
        
            f_data(2) = figureHandler.graficar_Fig(2,0,[1,1],"Velocidad $w_R$", ...
                          t(ind_data),[data.w_R(ind_data)], ...
                          "Tiempo [s]","Velocidad [rad/s]","$w_R$",'northeast');
        
            f_data(3) = figureHandler.graficar_Fig(3,1,[3,1],"Voltajes de estator trifasicas $u_S$", ...
                          t(ind_data),data.u_S3abc(ind_data,:), ...
                          "Tiempo [s]","Voltaje [V]",["$u_{SA}$","$u_{SB}$","$u_{SC}$"],'northeast');
        
            f_data(4) = figureHandler.graficar_Fig(4,1,[3,1],"Corrientes de estator trifasicas $i_S$", ...
                          t(ind_data),data.i_S3abc(ind_data,:), ...
                          "Tiempo [s]","Corriente [A]", ...
                          ["$i_{SA}$","$i_{SB}$","$i_{SC}$"],'northeast');
        
            f_data(5) = figureHandler.graficar_Fig(5,0,[1,1],"Potencia", ...
                          t(ind_data),...
                          [data.P_elect(ind_data),data.P_mech(ind_data)], ...
                          "Tiempo [s]","Potencia [W]", ...
                          ["Potencia electrica","Potencia mecanica"],'northeast');
        
            if contains(simname,"control")
                f_data(6) = figureHandler.graficar_Fig(6,0,[1,1],"Error de seguimiento de torque", ...
                              t(ind_data),...
                              data.tau_L(ind_data)-data.tau_R(ind_data), ...
                              "Tiempo [s]","Torque [N m]", ...
                              "$e_{\tau_R}$",'northeast');

                if contains(simname,"Speed")
                    f_data(7) = figureHandler.graficar_Fig(7,0,[1,1],"Error de seguimiento de velocidad", ...
                                  t(ind_data),data.w_R(ind_data)-data.w_Rref(ind_data), ...
                                  "Tiempo [s]","Torque [N m]", ...
                                  "$e_{\tau_R}$",'northwest');
                end
            end
        
            if str_dir_graficas ~= ""
                figureHandler.guardarGrafica(f_data(1),str_dir_graficas,str_dir,"01","Torque");
                figureHandler.guardarGrafica(f_data(2),str_dir_graficas,str_dir,"02","Velocidad");
                figureHandler.guardarGrafica(f_data(3),str_dir_graficas,str_dir,"03","Voltaje");
                figureHandler.guardarGrafica(f_data(4),str_dir_graficas,str_dir,"04","Corriente");
                figureHandler.guardarGrafica(f_data(5),str_dir_graficas,str_dir,"05","Potencia");

                if contains(simname,"control")
                    figureHandler.guardarGrafica(f_data(6),str_dir_graficas,str_dir,"06","ErrorTorque");

                    if contains(simname,"Speed")
                        figureHandler.guardarGrafica(f_data(7),str_dir_graficas,str_dir,"07","ErrorSpeed");
                    end
                end
            end

        end

        function f_data = figData_simRMA(num_fig_init,tr_sel,t,tinit,tfin,data,str_dir_graficas,str_MI)
            [~,tinit_ind] = min(abs(t-tinit));
            [~,tfin_ind] = min(abs(t-tfin));
            ind_data = tinit_ind:tfin_ind;

            f_data(num_fig_init+1) = figureHandler.graficar_Fig(1,0,[1,1],"Torque $\tau_{RMI}$", ...
                          t(ind_data),[data.tau_R(ind_data)], ...
                          "Tiempo [s]","Torque [N m]","$\tau_{RMI}$",...
                          "northeast");
        
            f_data(num_fig_init+2) = figureHandler.graficar_Fig(2,0,[1,1],"Velocidad $w_R$", ...
                          t(ind_data),[data.w_R(ind_data)], ...
                          "Tiempo [s]","Velocidad [rad/s]","$w_R$",...
                          "northeast");
        
            f_data(num_fig_init+3) = figureHandler.graficar_Fig(3,1,[3,1],"Voltajes de estator trifasicas $u_S$", ...
                          t(ind_data),data.u_S3abc(ind_data,:), ...
                          "Tiempo [s]","Voltaje [V]",["$u_{SA}$","$u_{SB}$","$u_{SC}$"],...
                          "northeast");
        
            f_data(num_fig_init+4) = figureHandler.graficar_Fig(4,1,[3,1],"Corrientes de estator trifasicas $i_S$", ...
                          t(ind_data),data.i_S3abc(ind_data,:), ...
                          "Tiempo [s]","Corriente [A]", ...
                          ["$i_{SA}$","$i_{SB}$","$i_{SC}$"],...
                          "northeast");
        
            f_data(num_fig_init+5) = figureHandler.graficar_Fig(5,0,[1,1],"Potencia", ...
                          t(ind_data),...
                          [data.P_elect(ind_data),data.P_mech(ind_data)], ...
                          "Tiempo [s]","Potencia [W]", ...
                          ["Potencia electrica","Potencia mecanica"],...
                          "northeast");
        
        
            if str_dir_graficas ~= ""
                figureHandler.guardarGrafica(f_data(num_fig_init+1),str_dir_graficas,"tr"+string(tr_sel)+"\"+str_MI,string(num_fig_init + 1),"Torque");
                figureHandler.guardarGrafica(f_data(num_fig_init+2),str_dir_graficas,"tr"+string(tr_sel)+"\"+str_MI,string(num_fig_init + 2),"Velocidad");
                figureHandler.guardarGrafica(f_data(num_fig_init+3),str_dir_graficas,"tr"+string(tr_sel)+"\"+str_MI,string(num_fig_init + 3),"Voltaje");
                figureHandler.guardarGrafica(f_data(num_fig_init+4),str_dir_graficas,"tr"+string(tr_sel)+"\"+str_MI,string(num_fig_init + 4),"Corriente");
                figureHandler.guardarGrafica(f_data(num_fig_init+5),str_dir_graficas,"tr"+string(tr_sel)+"\"+str_MI,string(num_fig_init + 5),"Potencia");
            end
        end

        function data = get_data(out,simname)
            str_sim = SIMMI_GraficasHandler.get_simtype(simname);

            data.t = out.tout;
            
            data.u_S3abc = figureHandler.checksize(out.u_S3abc.data);
            data.i_S3abc = figureHandler.checksize(out.i_S3abc.data);

            data.psiRab = figureHandler.checksize(out.psi_Rab.data);

            data.tau_R = figureHandler.checksize(out.tau_R.data);
            data.tau_L = figureHandler.checksize(out.tau_L.data);
            data.w_R = figureHandler.checksize(out.w_R.data);

            data.P_elect = figureHandler.checksize(out.P_elect.data);
            data.P_mech = figureHandler.checksize(out.P_mech.data);

            if contains(str_sim,"control") && contains(str_sim,"Torque")
                data.tau_Rref = figureHandler.checksize(out.tau_Rref.data);
            elseif contains(str_sim,"control") && contains(str_sim,"Speed")
                data.w_Rref = figureHandler.checksize(out.w_Rref.data);
            end
            
        end

        function data = get_data_simRMA(out,simname,tinit_ind,tfin_ind)
            str_sim = SIMMI_GraficasHandler.get_simtype(simname);
            
            data.u_S3abc = figureHandler.checksize(out.u_S3abc.data);
            data.i_S3abc = figureHandler.checksize(out.i_S3abc.data);

            data.psiRab = figureHandler.checksize(out.psi_Rab.data);

            data.tau_R = figureHandler.checksize(out.tau_R.data);
            data.w_R = figureHandler.checksize(out.w_R.data);

            data.P_elect = figureHandler.checksize(out.P_elect.data);
            data.P_mech = figureHandler.checksize(out.P_mech.data);

            data.u_S3abc = data.u_S3abc(tinit_ind:tfin_ind,:);
            data.i_S3abc = data.i_S3abc(tinit_ind:tfin_ind,:);

            data.psiRab = data.psiRab(tinit_ind:tfin_ind,:);

            data.tau_R = data.tau_R(tinit_ind:tfin_ind,:);
            data.w_R = data.w_R(tinit_ind:tfin_ind,:);

            data.P_elect = data.P_elect(tinit_ind:tfin_ind,:);
            data.P_mech = data.P_mech(tinit_ind:tfin_ind,:);
            
        end

        function str_sim = get_simtype(simname)
            str_sim = simname;
        end
    end
end