classdef figureHandler
    methods (Static)
        function resized_data = checksize(data)
            s_data = size(size(data));
            if s_data(2) > 2
                resized_data = reshape(data,[],size(data,3),1)';
            else
                resized_data = data;
            end
        end

        function f = graficar_Fig(numfig,posfig,numsubplots,strtitle,datax,datay,strxlabel,strylabel,strlegend,loclegend)
        
            f = figure(numfig);
            clf
            f.Units = 'normalized';
            if posfig == 1
                f.OuterPosition = [0 0 0.5 1];
            else
                f.OuterPosition = [0 0 1 1];
            end
        
            % sgtitle(strtitle,'interpreter','latex','FontSize',30)
        
            for i = 1:size(datay,2)
                if numsubplots(1) ~= 1 || numsubplots(2) ~= 1
                    subplot(numsubplots(1),numsubplots(2),i)
                end
                
                if numsubplots(1) ~= 1 || numsubplots(2) ~= 1
                    if min(min(datay(:,i))) > 0
                        ymin = min(min(datay(:,i)))*0.95;
                    else
                        ymin = min(min(datay(:,i)))*1.05;
                    end
    
                    if max(max(datay(:,i))) > 0
                        ymax = max(max(datay(:,i)))*1.05;
                    else
                        ymax = max(max(datay(:,i)))*0.95;
                    end
                else
                    if min(min(datay)) > 0
                        ymin = min(min(datay))*0.95;
                    else
                        ymin = min(min(datay))*1.05;
                    end
    
                    if max(max(datay)) > 0
                        ymax = max(max(datay))*1.05;
                    else
                        ymax = max(max(datay))*0.95;
                    end
                end

                if ymin == ymax
                    ymax = ymin + 0.001;
                end
                
                mindatax = min(datax);
                maxdatax = max(datax);

                xlim([mindatax,maxdatax])
                ylim([ymin,ymax])
                % yticks(linspace(ymin,ymax,4))
        
                grid on
                hAx=gca; 
                set(hAx,'xminorgrid','on','yminorgrid','on','TickLabelInterpreter','latex')
        
                hold on
                plot(datax,datay(:,i),'LineWidth',2)
        
                set(gca,'FontSize',30)

                if size(strxlabel,2) > 1
                    xlabel(strxlabel(i),'interpreter','latex','FontSize',30)
                else
                    xlabel(strxlabel,'interpreter','latex','FontSize',30)
                end

                if size(strylabel,2) > 1
                    ylabel(strylabel(i),'interpreter','latex','FontSize',30)
                else
                    ylabel(strylabel,'interpreter','latex','FontSize',30)
                end

                if numsubplots(1) ~= 1 || numsubplots(2) ~= 1
                    legend(strlegend(i),'interpreter','latex','FontSize',30,'Location',loclegend)
                end
            end
            
            if numsubplots(1) == 1 && numsubplots(2) == 1
                legend(strlegend,'interpreter','latex','FontSize',30,'Location',loclegend)
            end
        end

        function f = graficar_Fig_smallData(numfig,posfig,numsubplots,strtitle,datax,datay,strxlabel,strylabel,strlegend)
        
            f = figure(numfig);
            clf
            f.Units = 'normalized';
            if posfig == 1
                f.OuterPosition = [0 0 0.5 1];
            else
                f.OuterPosition = [0 0 1 1];
            end
        
            % sgtitle(strtitle,'interpreter','latex','FontSize',30)
        
            for i = 1:size(datay,2)
                if numsubplots(1) ~= 1 || numsubplots(2) ~= 1
                    subplot(numsubplots(1),numsubplots(2),i)
                end
                
                xlim([min(datax),max(datax)])
                ylim([min(min(datay(:,i))),max(max(datay(:,i)))])
        
                grid on
                hAx=gca; 
                set(hAx,'xminorgrid','on','yminorgrid','on')
        
                hold on
                plot(datax,datay(:,i),'LineWidth',2)
        
                set(gca,'FontSize',30)
                xlabel(strxlabel,'interpreter','latex','FontSize',30)
                ylabel(strylabel,'interpreter','latex','FontSize',30)
                if numsubplots(1) ~= 1 || numsubplots(2) ~= 1
                    legend(strlegend(i),'interpreter','latex','FontSize',30,'Location','best')
                end
            end
            
            if numsubplots(1) == 1 && numsubplots(2) == 1
                legend(strlegend,'interpreter','latex','FontSize',16,'Location','best')
            end
        end

        function f = graficar_Fig_multiplot(numfig,posfig,numsubplots,strtitle,datax,datay,strxlabel,strylabel,strlegend,loclegend)
        
            f = figure(numfig);
            clf
            f.Units = 'normalized';
            if posfig == 1
                f.OuterPosition = [0 0 0.5 1];
            else
                f.OuterPosition = [0 0 1 1];
            end
        
            % sgtitle(strtitle,'interpreter','latex','FontSize',30)
        
            for i = 1:size(datay,3)
                if numsubplots(1) ~= 1 || numsubplots(2) ~= 1
                    subplot(numsubplots(1),numsubplots(2),i)
                end
                
                xlim([min(datax),max(datax)])
                ylim([min(min(min(datay(:,:,i)))),max(max(max(datay(:,:,i))))])
        
                grid on
                hAx=gca; 
                set(hAx,'xminorgrid','on','yminorgrid','on','TickLabelInterpreter','latex')
        
                hold on
                plot(datax,datay(:,:,i),'LineWidth',2)
        
                set(gca,'FontSize',30)
                xlabel(strxlabel,'interpreter','latex','FontSize',30)
                ylabel(strylabel,'interpreter','latex','FontSize',30)
                if numsubplots(1) ~= 1 || numsubplots(2) ~= 1
                    legend(strlegend(:,i),'interpreter','latex','FontSize',30,'Location',loclegend)
                end
            end
            
            if numsubplots(1) == 1 && numsubplots(2) == 1
                legend(strlegend,'interpreter','latex','FontSize',16,'Location',loclegend)
            end
        end

        function graficar_UIFig(figaxes,strtitle,datax,datay,font_size,strxlabel,strylabel,strlegend)

            cla(figaxes);

            title(figaxes,strtitle,'interpreter','latex','FontSize',font_size)

            % disp(strtitle)
            % disp("size(datay,2):"+string(size(datay,2)))

            for i = 1:size(datay,2)
                % disp("min(min(datay)):"+string(min(min(datay))))
                % disp("max(max(datay*1.1)):"+string(max(max(datay*1.1))))
                
                if min(min(datay)) > 0
                    ymin = min(min(datay))*0.95;
                else
                    ymin = min(min(datay))*1.05;
                end

                if max(max(datay)) >= 0
                    ymax = max(max(datay))*1.05;
                else
                    ymax = max(max(datay))*0.95;
                end
                
                if ymin == ymax
                    ymax = ymin + 0.001;
                end
                
                xlim(figaxes,[min(datax),max(datax)])
                ylim(figaxes,[ymin,ymax])
        
                figaxes.XGrid = "on";
                figaxes.YGrid = "on";
                figaxes.XMinorGrid = "on";
                figaxes.YMinorGrid = "on";
        
                hold(figaxes,"on");
                plot(figaxes,datax,datay(:,i),'LineWidth',2)
        
                
                figaxes.FontSize = font_size;
                xlabel(figaxes,strxlabel,'interpreter','latex','FontSize',font_size)
                ylabel(figaxes,strylabel,'interpreter','latex','FontSize',font_size)
            end

            % disp("\n")
          
            legend(figaxes,strlegend,'interpreter','latex','FontSize',round(font_size*2/3))
        end
        
        function guardarGrafica(fig,str_dir_graficas,str_dir,numfig,str_fig_nombre)
            figure(fig);
            str_dir_sim = "";
            for  i = size(str_dir,2)
                if i ~= size(str_dir,2)
                    str_dir_sim = str_dir_sim + str_dir(i) + "_";
                else
                    str_dir_sim = str_dir_sim + str_dir(i);
                end
            end
        
            str_dir_fig = str_dir_graficas + "/" + str_dir_sim + "/";
            
            if ~exist(str_dir_graficas+"/", 'dir')
               mkdir(str_dir_graficas)
            end
            if ~exist(str_dir_fig, 'dir')
               mkdir(str_dir_fig)
            end
        
            strfig = str_dir_fig + numfig + '_' + str_fig_nombre + '.fig';
            strpng = str_dir_fig + numfig + '_' + str_fig_nombre + '.png';
            saveas(gcf,strfig)
            saveas(gcf,strpng)
        end
    end
end