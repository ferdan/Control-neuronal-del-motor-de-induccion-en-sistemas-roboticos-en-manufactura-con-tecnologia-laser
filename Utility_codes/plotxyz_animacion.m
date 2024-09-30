function f = plotxyz_animacion(numfig,robot_params,t,p,p_ref,opt_subplots,opt_plot_tr,strtitle,str_fig)
    disp("plotxyz_anim_fcn")
    ndof = robot_params.ndof;
    
    [L,Llim,timetextpos,ndofplot] = calcular_lims(p,p_ref,ndof,opt_plot_tr);

    
    if ~strcmp(str_fig,"")
        if isfile(str_fig+".gif")
            delete(str_fig+".gif")
        end
    end

    if opt_subplots == 1
        nfigplots = 2;
    else
        nfigplots = 1;
    end

    f = figure(numfig);
    
    clf

    f.Units = 'normalized';
    f.OuterPosition = [0 0 1 1];

    
    sgtitle(strtitle,'FontSize',24);

    for i = 1:nfigplots^2
        subplot(nfigplots,nfigplots,i)

        hold on

        pbaspect(L(2,:)-L(1,:))
        axis(Llim)

        xlabel("Eje x [m]",'FontSize',16);
        ylabel("Eje y [m]",'FontSize',16);
        zlabel("eje z [m]",'FontSize',16);
        switch i
            case 1
                %view(20,45)
                view(45,45) % isometrica
            case 2
                title('Vista superior','FontSize',16)
                view(2) % eje xy
            case 3 
                title('Perfil izquierdo','FontSize',16)
                view(0,0) % eje xz
            case 4
                title('Vista frontal','FontSize',16)
                view(90,0) % eje yz
            otherwise
                disp('Error al ajustar vistas de plotxyz animacion')
        end
        grid on
        grid minor
    end

    i = 1;
    ixtime = t(i);
    %currenttime = t(i);
    plottime = 0.01;
    num_img = -1;
    indt2 = 1;

    pplot = gobjects(ndof,int32(nfigplots^2));
    splot = gobjects(ndof,int32(nfigplots^2));
    posplot = gobjects(int32(nfigplots^2),1);
    if size(p_ref,1) ~= 0
        posrefplot = gobjects(int32(nfigplots^2),1);
    end

    pcolor = ["#0072BD","#77AC30","#A2142F","#7E2F8E","#77AC30","#D95319"];
    
    while i < size(p,1)-1
        currenttime = t(i);
        if currenttime - ixtime >= plottime
    
            indt1 = find(t==ixtime);
            indt2 = find(t==currenttime);
    
            ixtime = t(i);
    
            if indt1 == indt2
                indt2 = indt1 + 1;
            end
            
            for j = 1:nfigplots^2
                subplot(nfigplots,nfigplots,j)
                posplot(j) = plot_trayectoria(p,ndofplot(end),indt1,indt2);
                if size(p_ref,1) ~= 0
                    posrefplot(j) = plot3(p_ref(indt1:indt2,1),...
                                       p_ref(indt1:indt2,2), ...
                                       p_ref(indt1:indt2,3),'--',...
                                       'Color',"#4DBEEE",'linewidth',1.5);
                end
                [pplot(:,j),splot(:,j)] = plot_brazoManipulador(p,pcolor,ndof,ndofplot,i);
            end

            subplot(nfigplots,nfigplots,1)
            timetext = text(timetextpos(1),timetextpos(2),timetextpos(3),...
                            't = '+string(t(i,1)),'FontSize',16);
    
            if floor(currenttime/(1/12.5)) > num_img && ~strcmp(str_fig,"")
                if size(p_ref,1) ~= 0
                    lgd = legend([posplot(1),posrefplot(1)],'Posición',"Posición de referencia",...
                                'FontSize',16,'Location','northeastoutside');
                end
                exportgraphics(gcf,str_fig+'.gif','Append',true);
                num_img = num_img + 1;
                if size(p_ref,1) ~= 0
                    delete(lgd)
                end
            end

            pause(0.001)

            delete(pplot)
            delete(splot)
            delete(timetext)
        end
        i = i+1;
    end
    
    sizeP = size(p,1);

    for j = 1:nfigplots^2
        subplot(nfigplots,nfigplots,j)
        [pplot(:,j),splot(:,j)] = plot_brazoManipulador(p,pcolor,ndof,ndofplot,sizeP);
        posplot(j) = plot_trayectoria(p,ndofplot(end),indt2,sizeP);
    end
    
    if ~strcmp(str_fig,"")
        if size(p_ref,1) ~= 0
            lgd = legend([posplot(1),posrefplot(1)],'Posición',"Posición de referencia",...
                        'FontSize',16,'Location','northeastoutside');
        end
        for i = 1:15
            exportgraphics(gcf,str_fig+'.gif','Append',true);
        end
        if size(p_ref,1) ~= 0
            delete(lgd)
        end
    end
end


function [pplot,splot] = plot_brazoManipulador(p,pcolor,ndof,ndofplot,i)
    pplot = gobjects(ndof,1);
    splot = gobjects(ndof,1);
    
    for j = ndofplot(1):ndofplot(end)
        pplot(j) = plot_line(p,i,j,pcolor(j));
        if j < ndofplot(end)
            splot(j) = plot_joint(p,i,j);
        end
    end
end

function posplot = plot_trayectoria(p,ndofplot,indt1,indt2)
    posplot = plot3([p(indt1,1,ndofplot),p(indt2,1,ndofplot)]',...
                    [p(indt1,2,ndofplot),p(indt2,2,ndofplot)]', ...
                    [p(indt1,3,ndofplot),p(indt2,3,ndofplot)]','black',...
                     'linewidth',1.5);
end

function pplot = plot_line(p,indpdata,ind_artfin,pcolor)
    if ind_artfin == 1
        pfin = zeros(3,1);
    else
        pfin = p(indpdata,:,ind_artfin-1);
    end

    pplot = plot3([p(indpdata,1,ind_artfin),pfin(1)]',...
                  [p(indpdata,2,ind_artfin),pfin(2)]', ...
                  [p(indpdata,3,ind_artfin),pfin(3)]',...
                     'Color',pcolor,'linewidth',2);
end

function splot = plot_joint(p,indpdata,ind_art)
    splot = plot3(p(indpdata,1,ind_art)',p(indpdata,2,ind_art)',...
                  p(indpdata,3,ind_art)','o','Color','black',...
                  'MarkerSize',4,'MarkerFaceColor',"#000000",...
                  'linewidth',2);
end

function [L,Llim,timetextpos,ndofplot] = calcular_lims(p,p_ref,ndof,opt_plot_tr)
    if opt_plot_tr == 1
        if ndof == 6
            ndofplot = (4:6)';
            L = [min(min(p(:,:,4:6)),[],3);max(max(p(:,:,4:6)),[],3)];
        elseif ndof == 3
            ndofplot = 3;
            L = [min(p(:,:,3));max(p(:,:,3))];
        end
    else
        L = [min(min(p),[],3);max(max(p),[],3)];
        ndofplot = (1:ndof)';
    end

    if size(p_ref,1) ~= 0
        Lpref = [min(min(p_ref),[],3);max(max(p_ref),[],3)];
        L(1,:) = min(L(1,:),Lpref(1,:));
        L(2,:) = max(L(2,:),Lpref(2,:));
    end


    for i = 1:3
        if L(1,i) > 0
            L(1,i) = L(1,i)*0.95;
        else
            L(1,i) = L(1,i)*1.05;
        end

        if L(2,i) > 0
            L(2,i) = L(2,i)*1.05;
        else
            L(2,i) = L(2,i)*0.95;
        end

        if abs(L(2,i)-L(1,i)) < 0.05
            L(1,i) = L(1,i) - 0.05;
            L(2,i) = L(2,i) + 0.05;
        end
    end

    Llim = reshape(L,1,6);

    xpos = Llim(1) + (Llim(2)-Llim(1))*0.05;
    ypos = Llim(3) + (Llim(4)-Llim(3))*0.05;
    zpos = Llim(6) - (Llim(6)-Llim(5))*0.05;

    timetextpos = [xpos,ypos,zpos];
end