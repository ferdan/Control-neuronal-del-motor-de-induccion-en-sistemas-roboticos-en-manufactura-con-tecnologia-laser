classdef SIMNN_GraficasHandler
    methods (Static)
        function f_data = figData(robot_params,simname,tr_sel,t,tinit,tsim,data_NN,nn_select,str_dir_graficas)
            str_sim = SIMRMA_GraficasHandler.get_simtype(simname);
            ndof = robot_params.ndof;

            [~,tinit_ind] = min(abs(t-tinit));
            [~,tfin_ind] = min(abs(t-tsim));
            ind_data = tinit_ind:tfin_ind;

            if nn_select == 1
                data_weightsWc = data_NN.BSplineNN_weights.weightsWc;
                data_weightsZc = data_NN.BSplineNN_weights.weightsZc;
                data_weightsPc = data_NN.BSplineNN_weights.weightsPc;
            elseif nn_select == 2
                data_weightsWc = data_NN.RBFNN_weights.weightsWc;
                data_weightsZc = data_NN.RBFNN_weights.weightsZc;
                data_weightsPc = data_NN.RBFNN_weights.weightsPc;
            else
                disp("Parametros del controlador constantes, no sintonizadas por redes neuronales")
                return
            end

            if ndof == 6
                nrep = 3;
            else
                nrep = ndof;
            end

            lgd_gpi_Wc = strings(1,ndof);
            lgd_gpi_Zc = strings(1,ndof);
            lgd_gpi_Pc = strings(1,ndof);

            size_nn = size(data_weightsWc,2);
            weights_str_lgd = strings(size_nn,size(data_weightsWc,2));

            for i = 1:ndof
                lgd_gpi_Wc(i) = "$W_{c(q_" + string(i) + ")}$";
                lgd_gpi_Zc(i) = "$\zeta_{c(q_" + string(i) + ")}$";
                lgd_gpi_Pc(i) = "$P_{c(q_" + string(i) + ")}$";
                for j = 1:size_nn
                    weights_str_lgd(j,i) = "$w_{" + string(j) + "(W_c,q_" + string(i) + ")}$";
                    weights_str_lgd(j,ndof+i) = "$w_{" + string(j) + "(\zeta_c,q_" + string(i) + ")}$";
                    weights_str_lgd(j,2*ndof+i) = "$w_{" + string(j) + "(P_c,q_" + string(i) + ")}$";
                end
            end

            f_data(21) = figureHandler.graficar_Fig_smallData(21,0,[3,nrep],...
                   "Parametros del controlador GPI", ...
                   t(ind_data),...
                   [data_NN.GPI_params.Wc(ind_data,1:nrep),...
                    data_NN.GPI_params.Zc(ind_data,1:nrep),...
                    data_NN.GPI_params.Pc(ind_data,1:nrep)], ...
                    "Tiempo [s]","", ...
                    horzcat(lgd_gpi_Wc(1:nrep),lgd_gpi_Zc(1:nrep),lgd_gpi_Pc(1:nrep)));

            if ndof == 6
                f_data(22) = figureHandler.graficar_Fig_smallData(22,0,[3,nrep],...
                       "Parametros del controlador GPI", ...
                       t(ind_data),...
                       [data_NN.GPI_params.Wc(ind_data,(nrep+1):ndof),...
                        data_NN.GPI_params.Zc(ind_data,(nrep+1):ndof),...
                        data_NN.GPI_params.Pc(ind_data,(nrep+1):ndof)], ...
                        "Tiempo [s]","", ...
                        horzcat(lgd_gpi_Wc((nrep+1):ndof),lgd_gpi_Zc((nrep+1):ndof),lgd_gpi_Pc((nrep+1):ndof)));
            end

            ind_strwlgd = [[1:nrep],ndof+[1:nrep],2*ndof+[1:nrep]];

            f_data(23) = figureHandler.graficar_Fig_multiplot(23,0,[3,nrep],...
                   "Pesos para los parametros de la articulacion 1-" + string(nrep), ...
                   t(ind_data),...
                   [cat(3,data_weightsWc(ind_data,:,1:nrep),...
                          data_weightsZc(ind_data,:,1:nrep),...
                          data_weightsPc(ind_data,:,1:nrep))],...
                    "Tiempo [s]","", ...
                    weights_str_lgd(:,ind_strwlgd),'northoutside');

            if ndof == 6
                f_data(24) = figureHandler.graficar_Fig_multiplot(24,0,[3,nrep],...
                       "Pesos para los parametros de las articulaciones " + string(nrep+1) + "-" + string(ndof),...
                       t(ind_data),...
                       [cat(3,data_weightsWc(ind_data,:,(nrep+1):ndof),...
                              data_weightsZc(ind_data,:,(nrep+1):ndof),...
                              data_weightsPc(ind_data,:,(nrep+1):ndof))],...
                        "Tiempo [s]","", ...
                        weights_str_lgd(:,nrep+ind_strwlgd),'northoutside');
            end

            if ~strcmp(str_dir_graficas,"")
                figureHandler.guardarGrafica(f_data(21),str_dir_graficas,"tr"+string(tr_sel),"21","GPI_params");
                if ndof == 6
                    figureHandler.guardarGrafica(f_data(22),str_dir_graficas,"tr"+string(tr_sel),"21","GPI_params_q456");
                end
                figureHandler.guardarGrafica(f_data(23),str_dir_graficas,"tr"+string(tr_sel),"23","NN_weights");

                if ndof == 6
                    figureHandler.guardarGrafica(f_data(24),str_dir_graficas,"tr"+string(tr_sel),"24","NN_weights_q456");
                end
            end
        end

        function data_NN = get_data(out,nn_select,ndof,simname)
            str_sim = SIMRMA_GraficasHandler.get_simtype(simname);
            data_NN.t = out.tout;

            data_NN.GPI_params.Wc = figureHandler.checksize(out.GPI_params.Wc.data);
            data_NN.GPI_params.Zc = figureHandler.checksize(out.GPI_params.Zc.data);
            data_NN.GPI_params.Pc = figureHandler.checksize(out.GPI_params.Pc.data);

            if nn_select ~= 0
                data_weightsWc = out.BSplineNN_weights.weightsWc.data;
                data_weightsZc = out.BSplineNN_weights.weightsZc.data;
                data_weightsPc = out.BSplineNN_weights.weightsPc.data;
                data_NN.BSplineNN_weights = ...
                    SIMNN_GraficasHandler.get_weights_data(ndof,...
                             data_weightsWc,data_weightsZc,data_weightsPc);

                data_weightsWc = out.RBFNN_weights.weightsWc.data;
                data_weightsZc = out.RBFNN_weights.weightsZc.data;
                data_weightsPc = out.RBFNN_weights.weightsPc.data;
                data_NN.RBFNN_weights = ...
                    SIMNN_GraficasHandler.get_weights_data(ndof,...
                             data_weightsWc,data_weightsZc,data_weightsPc);
            else
                disp("Los parametros del controlador no se sintonizaron con redes neuronales")
            end
        end

        function struct = get_weights_data(ndof,dataWc,dataZc,dataPc)
            for i = 1:ndof
                data_size = size(dataWc,4);
                net_size = size(dataWc,2);
                for j = 1:net_size
                    struct.weightsWc(:,j,i) = reshape(dataWc(:,j,i,:),data_size,1);
                    struct.weightsZc(:,j,i) = reshape(dataZc(:,j,i,:),data_size,1);
                    struct.weightsPc(:,j,i) = reshape(dataPc(:,j,i,:),data_size,1);
                end
            end
        end
    end
end