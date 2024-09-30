function [r,dr,ddr,R] = trayectoria_muestra(t,ndof,tinit,tr_sel)
    
    % posicion y orientacion
    phi = 0*pi/180;
    theta = 90*pi/180;
    gamma = 0*pi/180;
    
    R = XYZ(phi,theta,gamma);
    
    if ndof == 2
        [r,dr,ddr] = trayectoria_muestra_2dof(t);
    elseif ndof == 3
        [r,dr,ddr] = trayectoria_muestra_3dof(t,tinit,tr_sel);
    elseif ndof == 6
        [r,dr,ddr] = trayectoria_muestra_6dof(t,tinit,tr_sel);
    else
        r = zeros(3,size(t,2));
        dr = zeros(3,size(t,2));
        ddr = zeros(3,size(t,2));
        disp("Error eligiendo trayectoria muestra")
    end
end

function [r,dr,ddr] = trayectoria_muestra_6dof(t,tinit,tr_sel)

    t = (t-tinit).*double(t > tinit);

    switch tr_sel
        case 1
            Xr = 0.8*ones(size(t));     dXr = zeros(size(t));   ddXr = zeros(size(t)); % modificar a 0.8 para 6dof, 0.3 para 3dof
            Yr = 0.2*sin(2*t);          dYr = 0.4*cos(2*t);     ddYr = -0.8*sin(2*t);
            Zr = 0.2+0.15*sin(3*t);     dZr = 0.45*cos(3*t);    ddZr = -1.35*sin(3*t);
        case 2
            Xr = 0.8 + 0.1*sin(t);  Yr = 0.1*cos(t);     Zr = 0.15 + 0.1*cos(2*t); % modificar a 0.8 para 6dof, 0.35 para 3dof
           dXr = 0.1*cos(t);        dYr = -0.1*sin(t);   dZr = -0.2*sin(2*t);
          ddXr = -0.1*sin(t);      ddYr = -0.1*cos(t);  ddZr = -0.4*cos(2*t);
        case 3
            Xr = 0.8*ones(size(t));   Yr = 0.2*cos(5*t).*sin(pi + t);      Zr = 0.225 + 0.2*cos(5*t).*cos(pi + t); % modificar a 0.8 para 6dof, 0.4 para 3dof
           dXr = zeros(size(t));     dYr = 0.4*cos(4*t) - 0.6*cos(6*t);   dZr = 0.4*sin(4*t) + 0.6*sin(6*t);
          ddXr = zeros(size(t));    ddYr = 3.6*sin(6*t) - 1.6*sin(4*t);  ddZr = 1.6*cos(4*t) + 3.6*cos(6*t);
        case 4
            Xr = 0.8 + 0.1*cos(0.1*t);  Yr = 0.2*sin(0.3*t);       Zr = 0.15 + 0.1*sin(0.1*t);% modificar a 0.8 para 6dof, 0.3 para 3dof
           dXr = -0.01*sin(0.1*t);     dYr = 0.06*cos(0.3*t);     dZr = 0.01*cos(0.1*t);
          ddXr = -0.001*cos(0.1*t);   ddYr = -0.018*sin(0.3*t);  ddZr = -0.001*sin(0.1*t);
        case 5
            Xr = 0.8 + 0.05*cos(4*t);  Yr = 0.2 + 0.15*sin(t);  Zr = 0.2 + 0.15*cos(t);% modificar a [0.8,0.2] para 6dof, [0.3,0.1] para 3dof
           dXr = -0.2*sin(4*t);       dYr = 0.15*cos(t);       dZr = -0.15*sin(t);
          ddXr = -0.8*cos(4*t);      ddYr = -0.15*sin(t);     ddZr = -0.15*cos(t);
        % case 6
        %     Xr = 0.08 + 0.0375*ones(size(t));    Yr = -0.15 + 0.05*(cos(pi + t))*(sin(pi + t));  Zr = 0.4 - 0.1*(cos(pi + t))*(cos(pi + t));
        %    dXr = 0.0375;                             dYr = 0.05 - 0.1*sin(t)^2;                      dZr = 0.1*sin(2*t);
        %   ddXr = 0;                                 ddYr = -0.1*sin(2*t);                           ddZr = 0.2*cos(2*t);
        otherwise
            Xr = 0.8*ones(size(t));     dXr = zeros(size(t));   ddXr = zeros(size(t));
            Yr = 0.2*sin(2*t);          dYr = 0.4*cos(2*t);     ddYr = -0.8*sin(2*t);
            Zr = 0.2+0.15*sin(3*t);     dZr = 0.45*cos(3*t);    ddZr = -1.35*sin(3*t);
    end

    r = [Xr;Yr;Zr];
    dr = [dXr;dYr;dZr];
    ddr = [ddXr;ddYr;ddZr];
end

function [r,dr,ddr] = trayectoria_muestra_3dof(t,tinit,tr_sel)
    t = (t-tinit).*double(t > tinit);
    
    switch tr_sel
        case 1
            Xr = 0.3*ones(size(t));     dXr = zeros(size(t));   ddXr = zeros(size(t)); % modificar a 0.8 para 6dof, 0.3 para 3dof
            Yr = 0.2*sin(2*t);          dYr = 0.4*cos(2*t);     ddYr = -0.8*sin(2*t);
            Zr = 0.2+0.15*sin(3*t);     dZr = 0.45*cos(3*t);    ddZr = -1.35*sin(3*t);
        case 2
            Xr = 0.35 + 0.1*sin(t);  Yr = 0.1*cos(t);     Zr = 0.15 + 0.1*cos(2*t); % modificar a 0.8 para 6dof, 0.35 para 3dof
           dXr = 0.1*cos(t);        dYr = -0.1*sin(t);   dZr = -0.2*sin(2*t);
          ddXr = -0.1*sin(t);      ddYr = -0.1*cos(t);  ddZr = -0.4*cos(2*t);
        case 3
            Xr = 0.4*ones(size(t));   Yr = 0.2*cos(5*t).*sin(pi + t);      Zr = 0.225 + 0.2*cos(5*t).*cos(pi + t); % modificar a 0.6 para 6dof, 0.4 para 3dof
           dXr = zeros(size(t));     dYr = 0.4*cos(4*t) - 0.6*cos(6*t);   dZr = 0.4*sin(4*t) + 0.6*sin(6*t);
          ddXr = zeros(size(t));    ddYr = 3.6*sin(6*t) - 1.6*sin(4*t);  ddZr = 1.6*cos(4*t) + 3.6*cos(6*t);
        case 4
            Xr = 0.3 + 0.1*cos(0.1*t);  Yr = 0.2*sin(0.3*t);       Zr = 0.15 + 0.1*sin(0.1*t);% modificar a 0.8 para 6dof, 0.3 para 3dof
           dXr = -0.01*sin(0.1*t);     dYr = 0.06*cos(0.3*t);     dZr = 0.01*cos(0.1*t);
          ddXr = -0.001*cos(0.1*t);   ddYr = -0.018*sin(0.3*t);  ddZr = -0.001*sin(0.1*t);
        case 5
            Xr = 0.3 + 0.05*cos(4*t);  Yr = 0.1 + 0.15*sin(t);  Zr = 0.2 + 0.15*cos(t);% modificar a [0.8,0.2] para 6dof, [0.3,0.1] para 3dof
           dXr = -0.2*sin(4*t);       dYr = 0.15*cos(t);       dZr = -0.15*sin(t);
          ddXr = -0.8*cos(4*t);      ddYr = -0.15*sin(t);     ddZr = -0.15*cos(t);
        % case 6
        %     Xr = 0.08 + 0.0375*ones(size(t));    Yr = -0.15 + 0.05*(cos(pi + t))*(sin(pi + t));  Zr = 0.4 - 0.1*(cos(pi + t))*(cos(pi + t));
        %    dXr = 0.0375;                             dYr = 0.05 - 0.1*sin(t)^2;                      dZr = 0.1*sin(2*t);
        %   ddXr = 0;                                 ddYr = -0.1*sin(2*t);                           ddZr = 0.2*cos(2*t);
        otherwise
            Xr = 0.3*ones(size(t));     dXr = zeros(size(t));   ddXr = zeros(size(t));
            Yr = 0.2*sin(2*t);          dYr = 0.4*cos(2*t);     ddYr = -0.8*sin(2*t);
            Zr = 0.2+0.15*sin(3*t);     dZr = 0.45*cos(3*t);    ddZr = -1.35*sin(3*t);
    end

    r = [Xr;Yr;Zr];
    dr = [dXr;dYr;dZr];
    ddr = [ddXr;ddYr;ddZr];
end

function [r,dr,ddr] = trayectoria_muestra_2dof(t)
        [rx1,drx1,ddrx1,~] = pol7(t,0.4,0.2,10,13);
        [ry1,dry1,ddry1,~] = pol7(t,0.3,0.4,10,13);

        [rx2,drx2,ddrx2,~] = pol7(t,0.2,-0.2,13,16);
        [ry2,dry2,ddry2,~] = pol7(t,0.4,0.45,13,16);

        [rx3,drx3,ddrx3,~] = pol7(t,-0.2,-0.4,16,19);
        [ry3,dry3,ddry3,~] = pol7(t,0.45,0.3,16,19);

        [rx4,drx4,ddrx4,~] = pol7(t,-0.4,0.2,19,22);
        [ry4,dry4,ddry4,~] = pol7(t,0.3,0.3,19,22);


        t_ind1 = find(min(abs(t-13))==abs(t-13));
        t_ind2 = find(min(abs(t-16))==abs(t-16));
        t_ind3 = find(min(abs(t-19))==abs(t-19));
        t_ind4 = find(min(abs(t-22))==abs(t-22));

        rx = horzcat(rx1(1:(t_ind1-1)),rx2(t_ind1:t_ind2-1),...
                     rx3(t_ind2:t_ind3-1),rx4(t_ind3:t_ind4));

        ry = horzcat(ry1(1:(t_ind1-1)),ry2(t_ind1:t_ind2-1),...
                     ry3(t_ind2:t_ind3-1),ry4(t_ind3:t_ind4));

        drx = horzcat(drx1(1:(t_ind1-1)),drx2(t_ind1:t_ind2-1),...
                     drx3(t_ind2:t_ind3-1),drx4(t_ind3:t_ind4));

        dry = horzcat(dry1(1:(t_ind1-1)),dry2(t_ind1:t_ind2-1),...
                     dry3(t_ind2:t_ind3-1),dry4(t_ind3:t_ind4));

        ddrx = horzcat(ddrx1(1:(t_ind1-1)),ddrx2(t_ind1:t_ind2-1),...
                     ddrx3(t_ind2:t_ind3-1),ddrx4(t_ind3:t_ind4));

        ddry = horzcat(ddry1(1:(t_ind1-1)),ddry2(t_ind1:t_ind2-1),...
                     ddry3(t_ind2:t_ind3-1),ddry4(t_ind3:t_ind4));

        r = [rx;ry];
        dr = [drx;dry];
        ddr = [ddrx;ddry];
end

function R = XYZ(phi,theta,gamma)
    R_xphi     = [1, 0       , 0        ;
                  0, cos(phi), -sin(phi);
                  0, sin(phi),  cos(phi)];

    R_yptheta  = [ cos(theta), 0, sin(theta);
                   0         , 1, 0         ;
                  -sin(theta), 0, cos(theta)];

    R_zppgamma = [cos(gamma), -sin(gamma), 0;
                  sin(gamma),  cos(gamma), 0;
                  0         , 0          , 1];
    R = R_xphi*R_yptheta*R_zppgamma;
end


