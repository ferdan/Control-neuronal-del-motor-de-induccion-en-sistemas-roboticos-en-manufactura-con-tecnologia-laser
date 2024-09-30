function robot_6dof = robot_6dof_params()

    n = 6;
    
    l = zeros(n,1);
    lc = zeros(n,1);
    d = zeros(n,1);
    dc = zeros(n,1);
    m = zeros(n,1);
    %I = zeros(n,3);
    
    % longitud de las articulaciones

    l(1) = 0;
    l(2) = 0.612;
    l(3) = 0.5723;
    l(4) = 0;
    l(5) = 0;
    l(6) = 0;
    
    d(1) = 0.1273;
    d(2) = 0;
    d(3) = 0;
    d(4) = 0.163941;
    d(5) = 0.1157;
    d(6) = 0.0922;
    
    %centros de masa

    lc(1) = - 0.021;
    lc(2) = l(2) - 0.38;
    lc(3) = l(3) - 0.24;
    lc(4) = 0;
    lc(5) = 0;
    lc(6) = 0;

    dc(1) = d(1) - 0.027;
    dc(2) = 0;
    dc(3) = 0;
    dc(4) = d(4) + 0.007;
    dc(5) = d(5) + 0.007;
    dc(6) = d(6);

    % yc(1) = 0;
    % yc(2) = - 0.158;
    % yc(3) = - 0.068;
    % yc(4) = - d(4) - 0.018;
    % yc(5) = d(1) - 0.018;
    % yc(6) = - d(4) - d(6) + 0.026;

    DH = [0     pi/2 d(1) 0;
          l(2)     0    0 0;
          l(3)     0    0 0;
          0     pi/2 d(4) 0;
          0    -pi/2 d(5) 0;
          0        0 d(6) 0];
    
    m(1) = 7.1;
    m(2) = 12.7;
    m(3) = 4.27;
    m(4) = 2;
    m(5) = 2;
    m(6) = 0.365;

    robot_6dof = robot_model(n,l,lc,d,dc,DH,m,0);

    %% Figura: Centros de masa del robot UR-10

    lc(1) = 0.021;
    lc(2) = 0.38;
    lc(3) = 0.24;
    lc(4) = 0;
    lc(5) = 0;
    lc(6) = 0;

    dc(1) = 0.027;
    dc(2) = 0;
    dc(3) = 0;
    dc(4) = 0.007;
    dc(5) = 0.007;
    dc(6) = 0;

    yc(1) = 0;
    yc(2) = 0.158;
    yc(3) = 0.068;
    yc(4) = 0.018;
    yc(5) = 0.018;
    yc(6) = 0.026;


    % f = figure(1);
    % clf
    % set(gca,'fontsize', 30,'TickLabelInterpreter','latex');
    % 
    % f.Units = 'normalized';
    % f.OuterPosition = [0 0 1 1];
    % % sgtitle("Centros de masa de del robot manipulador UR10",'FontSize',24)
    % 
    % xlabel("Eje $x$",'Interpreter','latex')
    % ylabel("Eje $y$",'Interpreter','latex')
    % zlabel("Eje $z$",'Interpreter','latex')
    % 
    % hold on
    % grid on
    % grid minor
    % view(45,45) % isometrica
    % 
    % pbaspect([l(2)+l(3),abs(d(4)+d(6)),d(1)]);
    % 
    % %% Robot manipulador
    % plot3([0,0],[0,0],[0,d(1)],'Color',"#0072BD",'LineWidth',1.5)
    % plot3(0,0,d(1),'o','Color','black','MarkerSize',6,'MarkerFaceColor',"#000000",'linewidth',2);
    % 
    % plot3([0,l(2)],[0,0],[d(1),d(1)],'Color',"#77AC30",'LineWidth',1.5)
    % plot3(l(2),0,d(1),'o','Color','black','MarkerSize',6,'MarkerFaceColor',"#000000",'linewidth',2);
    % 
    % plot3([l(2),l(2)+l(3)],[0,0],[d(1),d(1)],'Color',"#A2142F",'LineWidth',1.5)
    % plot3(l(2)+l(3),0,d(1),'o','Color','black','MarkerSize',6,'MarkerFaceColor',"#000000",'linewidth',2);
    % 
    % plot3([l(2)+l(3),l(2)+l(3)],[0,-d(4)],[d(1),d(1)],'Color',"#7E2F8E",'LineWidth',1.5)
    % plot3(l(2)+l(3),-d(4),d(1),'o','Color','black','MarkerSize',6,'MarkerFaceColor',"#000000",'linewidth',2);
    % 
    % plot3([l(2)+l(3),l(2)+l(3)],[-d(4),-d(4)],[d(1),d(1)-d(5)],'Color',"#77AC30",'LineWidth',1.5)
    % plot3(l(2)+l(3),-d(4),d(1)-d(5),'o','Color','black','MarkerSize',6,'MarkerFaceColor',"#000000",'linewidth',2);
    % 
    % plot3([l(2)+l(3),l(2)+l(3)],[-d(4),-d(4)-d(6)],[d(1)-d(5),d(1)-d(5)],'Color',"#D95319",'LineWidth',1.5)
    % %plot3(l(2)+l(3),-d(4)-d(6),d(1)-d(5),'o','Color','black','MarkerSize',4,'MarkerFaceColor',"#000000",'linewidth',2);
    % 
    % 
    % %% Centros de masa indicados por Universal Robots 
    % plot3([0,-lc(1)],[0,0],[d(1),d(1)-dc(1)],'-','Color',"#FF0000",'MarkerSize',10,'LineWidth',2)
    % pm_ref = plot3(-lc(1),0,d(1)-dc(1),'x','Color',"#FF0000",'MarkerSize',10,'LineWidth',2);
    % 
    % plot3([l(2),l(2)-lc(2)],[0,-yc(2)],[d(1),d(1)],'-','Color',"#FF0000",'MarkerSize',10,'LineWidth',2)
    % plot3(l(2)-lc(2),-yc(2),d(1),'x','Color',"#FF0000",'MarkerSize',10,'LineWidth',2)
    % 
    % plot3([l(2)+l(3),l(2)+l(3)-lc(3)],[0,-yc(3)],[d(1),d(1)],'-','Color',"#FF0000",'MarkerSize',10,'LineWidth',2)
    % plot3(l(2)+l(3)-lc(3),-yc(3),d(1),'x','Color',"#FF0000",'MarkerSize',10,'LineWidth',2)
    % 
    % plot3([l(2)+l(3),l(2)+l(3)],[-d(4),-d(4)-dc(4)],[d(1),d(1)-yc(4)],'-','Color',"#FF0000",'MarkerSize',10,'LineWidth',2)
    % plot3(l(2)+l(3),-d(4)-dc(4),d(1)-yc(4),'x','Color',"#FF0000",'MarkerSize',10,'LineWidth',2)
    % 
    % plot3([l(2)+l(3),l(2)+l(3)],[-d(4),-d(4)-yc(5)],[d(1)-d(5),d(1)-d(5)-dc(5)],'-','Color',"#FF0000",'MarkerSize',10,'LineWidth',2)
    % plot3(l(2)+l(3),-d(4)-yc(5),d(1)-d(5)-dc(5),'x','Color',"#FF0000",'MarkerSize',10,'LineWidth',2)
    % 
    % plot3([l(2)+l(3),l(2)+l(3)],[-d(4)-d(6),-d(4)-d(6)+yc(6)],[d(1)-d(5),d(1)-d(5)],'-','Color',"#FF0000",'MarkerSize',10,'LineWidth',2)
    % plot3(l(2)+l(3),-d(4)-d(6)+yc(6),d(1)-d(5),'x','Color',"#FF0000",'MarkerSize',10,'LineWidth',2)
    % 
    % %% Centros de masa simplificados (en terminos de parámetros DH)
    % pm = plot3(-lc(1),0,d(1)-dc(1),'diamond','Color',"#7E2F8E",'MarkerSize',10,'LineWidth',2);
    % plot3(l(2)-lc(2),0,d(1),'diamond','Color',"#7E2F8E",'MarkerSize',10,'LineWidth',2)
    % plot3(l(2)+l(3)-lc(3),0,d(1),'diamond','Color',"#7E2F8E",'MarkerSize',10,'LineWidth',2)
    % plot3(l(2)+l(3),-d(4)-dc(4),d(1),'diamond','Color',"#7E2F8E",'MarkerSize',10,'LineWidth',2)
    % plot3(l(2)+l(3),-d(4),d(1)-d(5)-dc(5),'diamond','Color',"#7E2F8E",'MarkerSize',10,'LineWidth',2)
    % plot3(l(2)+l(3),-d(4)-d(6),d(1)-d(5),'diamond','Color',"#7E2F8E",'MarkerSize',10,'LineWidth',2)
    % 
    % legend([pm_ref,pm],"Indicado por fabricante","Simplificado",'Interpreter','latex','FontSize',30);
    % 
    % % Obtener P de modelo_simbolico.m antes
    % % r = robot_6dof_params
    % % modificar parámetros ej. lc -> r.lc
    % % pc(:,1) = double(subs(P(:,:,1),[dc1,lc1,q1],[dc(1),lc(1),0]));
    % % pc(:,2) = double(subs(P(:,:,2),[d1,lc2,q1,q2],[d(1),lc(2),0,0]));
    % % pc(:,3) = double(subs(P(:,:,3),[d1,l2,lc3,q1,q2,q3],[d(1),l(2),lc(3),0,0,0]));
    % % pc(:,4) = double(subs(P(:,:,4),[d1,l2,l3,dc4,q1,q2,q3,q4],[d(1),l(2),l(3),dc(4),0,0,0,0]));
    % % pc(:,5) = double(subs(P(:,:,5),[d1,l2,l3,d4,dc5,q1,q2,q3,q4,q5],[d(1),l(2),l(3),d(4),dc(5),0,0,0,0,0]));
    % % pc(:,6) = double(subs(P(:,:,6),[d1,l2,l3,d4,d5,dc6,q1,q2,q3,q4,q5,q6],[d(1),l(2),l(3),d(4),d(5),dc(6),0,0,0,0,0,0]));
    % % pc

end