classdef robot_cin
    properties
        robot_params
        T0
        A
        P
    end
    methods

        function obj = robot_cin(robot_params)
            obj.robot_params = robot_params;
            
            obj.T0 = zeros(4,4,obj.robot_params.ndof);
            obj.A = zeros(4,4,obj.robot_params.ndof);
            obj.P = zeros(3,1,obj.robot_params.ndof);
            [obj.A,obj.T0,obj.P] = obj.cin_dir(obj.robot_params.DH(:,4));

        end

        function [A,T0,P] = cin_dir(obj,theta)
            obj.robot_params.DH(:,4) = theta;

            obj.T0(:,:,1) = eye(4,4);

            obj.A(:,:,1) = robot_cin.transformacion_homogenea(obj.robot_params.DH(1,:));
            obj.T0(:,:,1) = obj.T0(:,:,1)*obj.A(:,:,1);
            obj.P(:,1,1) = obj.T0(1:3,4,1).';

            for i = 2:obj.robot_params.ndof
                obj.A(:,:,i) = robot_cin.transformacion_homogenea(obj.robot_params.DH(i,:));
                obj.T0(:,:,i) = obj.T0(:,:,i-1)*obj.A(:,:,i);
                obj.P(:,1,i) = obj.T0(1:3,4,i).';
            end
            A = obj.A;
            T0 = obj.T0;
            P = obj.P;
        end
    end

    methods (Static)

        % 2dof cinematics %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function [p,dp,ddp] = cin_dir_2dof(robot_params,q,dq,ddq)
            p = robot_cin.cin_dirp_2dof(robot_params,q);

            JP = robot_cin.JP_2dof(robot_params,q);
            dp = JP*dq;
            
            dJP = robot_cin.dJP_2dof(robot_params,q,dq);
            ddp = dJP*ddq;
        end

        function p = cin_dirp_2dof(robot_params,q)
            l1 = robot_params.l(1);
            l2 = robot_params.l(2);
            
            q1 = q(1);
            q2 = q(2);
            
            p1 = [l1*cos(q1);
                  l1*sin(q1)];
            
            p2 = [l2*cos(q1 + q2) + l1*cos(q1);
                  l2*sin(q1 + q2) + l1*sin(q1)];
            
            p = [p1,p2];
        end

        function [q,dq,ddq] = cin_inv_2dof(robot_params,r,dr,ddr)
            q = robot_cin.cin_invq_2dof(robot_params,r);
            dq = zeros(size(q));
            ddq = zeros(size(q));

            for i = 1:size(q,2)
                q1 = q(1,i);
                q2 = q(2,i);

                JP = robot_cin.JP_2dof(robot_params,[q1;q2]);
    
                JPinv = JP^-1;
                
                % Velocidades articulares
                dq(:,i) = JPinv*dr(:,i);

                dJP = robot_cin.dJP_2dof(robot_params,q,dq);
    
                % Aceleraciones articulares
                ddq(:,i) = JPinv*(ddr(:,i) - dJP*dq(:,i));
            end
        end

        function q = cin_invq_2dof(robot_params,r)
            l1 = robot_params.l(1);
            l2 = robot_params.l(2);
              
            Xr = r(1,:);
            Yr = r(2,:);

            D = (Xr.^2+Yr.^2-l1.^2-l2.^2)./(2.*l1.*l2);

            q1 = atan2(Yr,Xr) - atan2(-l2.*sqrt(1-D.^2),l1+l2.*D);
            q2 = atan2(-sqrt(1-D.^2),D);

            q = [q1;q2];

        end

        function JP = JP_2dof(robot_params,q)

            l1 = robot_params.l(1);
            %l2 = robot_params.l(2);

            lc1 = robot_params.lc(1);
            lc2 = robot_params.lc(2);

            q1 = q(1);
            q2 = q(2);

            JP = zeros(2,2);
            
            JP(1,1) = - lc2*sin(q1 + q2) - l1*sin(q1);
            JP(1,2) = lc1*sin(q1) - l1*sin(q1) - lc2*sin(q1 + q2);
            
            JP(2,1) = lc2*cos(q1 + q2) + l1*cos(q1);
            JP(2,2) = lc2*cos(q1 + q2) + l1*cos(q1) - lc1*cos(q1);
        end

        function dJP = dJP_2dof(robot_params,q,dq)
            l1 = robot_params.l(1);
            %l2 = robot_params.l(2);
            
            lc1 = robot_params.lc(1);
            lc2 = robot_params.lc(2);
            
            q1 = q(1);
            q2 = q(2);
            
            dq1 = dq(1);
            dq2 = dq(2);
            
            dJP = zeros(2,2);
            
            dJP(1,1) = - dq1*(lc2*cos(q1 + q2) + l1*cos(q1)) - dq2*lc2*cos(q1 + q2);
            dJP(1,2) = - dq1*(lc2*cos(q1 + q2) + l1*cos(q1) - lc1*cos(q1)) - dq2*lc2*cos(q1 + q2);
            
            dJP(2,1) = - dq1*(lc2*sin(q1 + q2) + l1*sin(q1)) - dq2*lc2*sin(q1 + q2);
            dJP(2,2) = - dq1*(lc2*sin(q1 + q2) + l1*sin(q1) - lc1*sin(q1)) - dq2*lc2*sin(q1 + q2);
        end

        % 3dof cinematics %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function [p,dp,ddp] = cin_dir_3dof(robot_params,q,dq,ddq)
            p = robot_cin.cin_dirp_3dof(robot_params,q);

            JP = robot_cin.JP_3dof(robot_params,q);
            dp = JP*dq;
            
            dJP = robot_cin.dJP_3dof(robot_params,q,dq);
            ddp = dJP*ddq;
        end

        function p = cin_dirp_3dof(robot_params,q)
            d1 = robot_params.d(1);
            l2 = robot_params.l(2);
            l3 = robot_params.l(3);
            
            q1 = q(1);
            q2 = q(2);
            q3 = q(3);
            
            p1 = [0;0;d1];
            
            p2 = [l2*cos(q1)*cos(q2);
                  l2*sin(q1)*cos(q2);
                  d1+l2*sin(q2)];
            
            p3 = [cos(q1)*(l2*cos(q2)+l3*cos(q2+q3));
                  sin(q1)*(l2*cos(q2)+l3*cos(q2+q3));
                  d1+l2*sin(q2)+l3*sin(q2+q3)];
            
            p = [p1,p2,p3];
        end

        function [q,dq,ddq] = cin_inv_3dof(robot_params,r,dr,ddr)
            q = robot_cin.cin_invq_3dof(robot_params,r);
            dq = zeros(size(q));
            ddq = zeros(size(q));

            for i = 1:size(q,2)
                q1 = q(1,i);
                q2 = q(2,i);
                q3 = q(3,i);

                JPinv = robot_cin.JPinv_3dof(robot_params,[q1;q2;q3]);

                % Velocidades articulares
                dq(:,i) = JPinv*dr(:,i);

                dJP = robot_cin.dJP_3dof(robot_params,q,dq);
    
                % Aceleraciones articulares
                ddq(:,i) = JPinv*(ddr(:,i) - dJP*dq(:,i));
            end
        end

        function q = cin_invq_3dof(robot_params,r)

            d1 = robot_params.d(1);
            l2 = robot_params.l(2);
            l3 = robot_params.l(3);
            
            Xr = r(1,:);
            Yr = r(2,:);
            Zr = r(3,:);

            c3 = (Xr.^2+Yr.^2+(Zr-d1).^2-l2.^2-l3.^2)./(2.*l2.*l3);
            
            q1 = atan2(Yr,Xr);
            q2 = atan2(Zr-d1,sqrt(Xr.^2+Yr.^2)) - atan2(-l3.*sqrt(1-c3.^2),l2+l3.*c3);
            q3 = atan2(-sqrt(1-c3.^2),c3);

            q = [q1;q2;q3];

        end

        function JP = JP_3dof(robot_params,q)
            l2 = robot_params.l(2);
            l3 = robot_params.l(3);
            
            q1 = q(1);
            q2 = q(2);
            q3 = q(3);
            
            JP = zeros(3,3);
            
            JP(1,1) = -sin(q1)*(l2*cos(q2) + l3*cos(q2 + q3));
            JP(1,2) = -cos(q1)*(l2*sin(q2) + l3*sin(q2 + q3));
            JP(1,3) = -l3*cos(q1)*sin(q2 + q3);
            
            JP(2,1) =  cos(q1)*(l2*cos(q2) + l3*cos(q2 + q3));
            JP(2,2) = -sin(q1)*(l2*sin(q2) + l3*sin(q2 + q3));
            JP(2,3) = -l3*sin(q1)*sin(q2 + q3);
            
            JP(3,2) = l2*cos(q2) + l3*cos(q2 + q3);
            JP(3,3) = l3*cos(q2 + q3);
        end

        function JPinv = JPinv_3dof(robot_params,q)
            l2 = robot_params.l(2);
            l3 = robot_params.l(3);
            
            q1 = q(1);
            q2 = q(2);
            q3 = q(3);
            
            JPinv = zeros(3,3);
            JPinv(1,1) = -sin(q1)/(l2*cos(q2) + l3*cos(q2 + q3));
            JPinv(1,2) = cos(q1)/(l2*cos(q2) + l3*cos(q2 + q3));
            
            JPinv(2,1) = cos(q1)*cos(q2 + q3)/(l2*sin(q3));
            JPinv(2,2) = sin(q1)*cos(q2 + q3)/(l2*sin(q3));
            JPinv(2,3) = sin(q2 + q3)/(l2*sin(q3));
            
            JPinv(3,1) = -(cos(q1)*(l2*cos(q2) + l3*cos(q2 + q3)))/(l2*l3*sin(q3));
            JPinv(3,2) = -(sin(q1)*(l2*cos(q2) + l3*cos(q2 + q3)))/(l2*l3*sin(q3));
            JPinv(3,3) = -(l2*sin(q2) + l3*sin(q2 + q3))/(l2*l3*sin(q3));
        end

        function dJP = dJP_3dof(robot_params,q,dq)
            l2 = robot_params.l(2);
            l3 = robot_params.l(3);
            
            dq1 = dq(1);
            dq2 = dq(2);
            dq3 = dq(3);
            
            q1 = q(1);
            q2 = q(2);
            q3 = q(3);
            
            dJP = zeros(3,3);
            
            dJP(1,1) = - cos(q1)*(l2*cos(q2) + l3*cos(q2 + q3))*dq1 + sin(q1)*(l2*sin(q2) + l3*sin(q2 + q3))*dq2 + l3*sin(q1)*sin(q2 + q3)*dq3;
            dJP(1,2) =   sin(q1)*(l2*sin(q2) + l3*sin(q2 + q3))*dq1 - cos(q1)*(l2*cos(q2) + l3*cos(q2 + q3))*dq2 - l3*cos(q1)*cos(q2 + q3)*dq3;
            dJP(1,3) =   l3*sin(q1)*sin(q2 + q3)*dq1 - l3*cos(q1)*cos(q2 + q3)*dq2 - l3*cos(q1)*cos(q2 + q3)*dq3;
            
            dJP(2,1) = - sin(q1)*(l2*cos(q2) + l3*cos(q2 + q3))*dq1 - cos(q1)*(l2*sin(q2) + l3*sin(q2 + q3))*dq2 - l3*cos(q1)*sin(q2 + q3)*dq3;
            dJP(2,2) = - cos(q1)*(l2*sin(q2) + l3*sin(q2 + q3))*dq1 - sin(q1)*(l2*cos(q2) + l3*cos(q2 + q3))*dq2 - l3*sin(q1)*cos(q2 + q3)*dq3;
            dJP(2,3) = - l3*cos(q1)*sin(q2 + q3)*dq1 - l3*sin(q1)*cos(q2 + q3)*dq2 - l3*sin(q1)*cos(q2 + q3)*dq3;
            
            dJP(3,1) = 0;
            dJP(3,2) = - (l2*sin(q2) + l3*sin(q2 + q3))*dq2 - l3*sin(q2 + q3)*dq3;
            dJP(3,3) = - l3*sin(q2 + q3)*(dq2 + dq3);

        end
        % 6dof cinematics %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function [p,dp,ddp] = cin_dir_6dof(robot_params,q,dq,ddq)
            p = robot_cin.cin_dirp_6dof(robot_params,q);

            JP = robot_cin.JP_6dof(robot_params,q);
            dp = JP*dq;
            
            dJP = robot_cin.dJP_6dof(robot_params,q,dq);
            ddp = dJP*ddq;
        end

        function p = cin_dirp_6dof(robot_params,q)

            DH = robot_params.DH;
            ndof = robot_params.ndof;
            p = zeros(3,6);

            A = zeros(4,4,ndof);
            T0 = zeros(4,4,ndof);

            DH(1:ndof,4) = q;

            A(:,:,1) = robot_cin.transformacion_homogenea(DH(1,:));
            T0(:,:,1) = eye(4,4)*A(:,:,1);
            p(:,1) = T0(1:3,4,1);

            for i = 2:ndof
                A(:,:,i) = robot_cin.transformacion_homogenea(DH(i,:));
                T0(:,:,i) = T0(:,:,i-1)*A(:,:,i);
                p(:,i) = T0(1:3,4,i);
            end
        end

        function [q,dq,ddq] = cin_inv_6dof(robot_params,r,dr,ddr,R)
            q = robot_cin.cin_invq_6dof(robot_params,r,R);
            dq = zeros(size(q));
            ddq = zeros(size(q));

            for i = 1:size(q,2)
                q1 = q(1,i);
                q2 = q(2,i);
                q3 = q(3,i);
                q4 = q(4,i);
                q5 = q(5,i);
                q6 = q(6,i);

                JP = robot_cin.JP_6dof(robot_params,[q1;q2;q3;q4;q5;q6]);
                % Pseudoinversa derecha JPinv = zeros(6,3)
                JPinv = JP.'*(JP*JP.')^-1;

                % Velocidades articulares
                dq(:,i) = JPinv*dr(:,i);

                dJP = robot_cin.dJP_6dof(robot_params,q,dq);
    
                % Aceleraciones articulares
                ddq(:,i) = JPinv*(ddr(:,i) - dJP*dq(:,i));
            end
        end

        function q = cin_invq_6dof(robot_params,r,R)
            %l1 = robot_params.l(1);
            l2 = robot_params.l(2);
            l3 = robot_params.l(3);
            %l4 = robot_params.l(4);
            %l5 = robot_params.l(5);
            %l6 = robot_params.l(6);
            
            d1 = robot_params.d(1);
            %d2 = robot_params.d(2);
            %d3 = robot_params.d(3);
            d4 = robot_params.d(4);
            d5 = robot_params.d(5);
            d6 = robot_params.d(6);
            
            Xr = r(1,:);
            Yr = r(2,:);
            Zr = r(3,:);
            
            A = d6*R(2,3) - Yr;
            B = Xr - d6*R(1,3);
            
            q1 = - atan2(sqrt(B.^2+A.^2-d4.^2),d4) + atan2(B,A); %signo
            
            c1 = cos(q1);
            s1 = sin(q1);
            
            C = c1.*R(1,1) + s1.*R(2,1);
            D = c1.*R(2,2) - s1.*R(1,2);
            E = s1.*R(1,1) - c1.*R(2,1);
            
            q5 = - atan2(sqrt(E.^2+D.^2),s1.*R(1,3)-c1.*R(2,3)); %signo
            
            c5 = cos(q5);
            s5 = sin(q5);
            
            q6 = atan2(D./s5,E./s5);
            
            c6 = cos(q6);
            s6 = sin(q6);
            
            F = c5.*c6;  
            
            q234 = atan2(R(3,1).*F-s6.*C,F.*C+s6.*R(3,1));
            
            c234 = cos(q234);
            s234 = sin(q234);
            
            KC = c1.*Xr + s1.*Yr - s234.*d5 + c234.*s5.*d6;
            KS = Zr - d1 + c234.*d5 + s234.*s5.*d6;
            
            c3 = (KS.^2 + KC.^2 - l2.^2 - l3.^2)/(2.*l2.*l3);
            s3 = - sqrt(1-c3.^2); % signo
            
            q3 = + atan2(s3,c3); %signo %no cambiar
            q2 = atan2(KS,KC) - atan2(s3.*l3,c3.*l3+l2);
            q4 = q234 - q2 - q3;
            
            
            q = [q1;q2;q3;q4;q5;q6];
        end

        function JP = JP_6dof(robot_params,q)

            %l1 = robot_params.l(1);
            l2 = robot_params.l(2);
            l3 = robot_params.l(3);
            %l4 = robot_params.l(4);
            %l5 = robot_params.l(5);
            %l6 = robot_params.l(6);
            
            lc1 = robot_params.lc(1);
            lc2 = robot_params.lc(2);
            lc3 = robot_params.lc(3);
            %lc4 = robot_params.lc(4);
            %lc5 = robot_params.lc(5);
            %lc6 = robot_params.lc(6);
            
            d1 = robot_params.d(1);
            %d2 = robot_params.d(2);
            %d3 = robot_params.d(3);
            d4 = robot_params.d(4);
            d5 = robot_params.d(5);
            %d6 = robot_params.d(6);
            
            dc1 = robot_params.dc(1);
            %dc2 = robot_params.dc(2);
            %dc3 = robot_params.dc(3);
            dc4 = robot_params.dc(4);
            dc5 = robot_params.dc(5);
            dc6 = robot_params.dc(6);
            
            q1 = q(1);
            q2 = q(2);
            q3 = q(3);
            q4 = q(4);
            q5 = q(5);
            %q6 = q(6);
            
            JP = zeros(3,6);
            
            JP(1,1) = -cos(q1)*(d1 + l3*sin(q2 + q3) + l2*sin(q2) - d5*cos(q2 + q3 + q4) - dc6*sin(q2 + q3 + q4)*sin(q5));
            JP(1,2) = -cos(q1)*(d1 - dc1 + l3*sin(q2 + q3) + l2*sin(q2) - d5*cos(q2 + q3 + q4) - dc6*sin(q2 + q3 + q4)*sin(q5));
            JP(1,3) = cos(q1)*(lc2*sin(q2) - l2*sin(q2) - l3*sin(q2 + q3) + d5*cos(q2 + q3 + q4) + dc6*sin(q2 + q3 + q4)*sin(q5));
            JP(1,4) = - cos(q2 + q3 + q4)*(dc6*(cos(q1)*cos(q5) + cos(q2 + q3 + q4)*sin(q1)*sin(q5)) + d4*cos(q1) - sin(q1)*(l3*cos(q2 + q3) + l2*cos(q2)) + sin(q1)*(lc3*cos(q2 + q3) + l2*cos(q2)) - d5*sin(q2 + q3 + q4)*sin(q1)) - sin(q2 + q3 + q4)*sin(q1)*(lc3*sin(q2 + q3) - l3*sin(q2 + q3) + d5*cos(q2 + q3 + q4) + dc6*sin(q2 + q3 + q4)*sin(q5));
            JP(1,5) = d5*sin(q1)*sin(q5) + d5*cos(q2 + q3 + q4)*cos(q1)*cos(q5) - d4*sin(q2 + q3 + q4)*cos(q1)*sin(q5) + dc4*sin(q2 + q3 + q4)*cos(q1)*sin(q5);
            JP(1,6) = (d5 - dc5)*(sin(q1)*sin(q5) + cos(q2 + q3 + q4)*cos(q1)*cos(q5));
            
            JP(2,1) = -sin(q1)*(d1 + l3*sin(q2 + q3) + l2*sin(q2) - d5*cos(q2 + q3 + q4) - dc6*sin(q2 + q3 + q4)*sin(q5));
            JP(2,2) = -sin(q1)*(d1 - dc1 + l3*sin(q2 + q3) + l2*sin(q2) - d5*cos(q2 + q3 + q4) - dc6*sin(q2 + q3 + q4)*sin(q5));
            JP(2,3) = sin(q1)*(lc2*sin(q2) - l2*sin(q2) - l3*sin(q2 + q3) + d5*cos(q2 + q3 + q4) + dc6*sin(q2 + q3 + q4)*sin(q5));
            JP(2,4) = sin(q2 + q3 + q4)*cos(q1)*(lc3*sin(q2 + q3) - l3*sin(q2 + q3) + d5*cos(q2 + q3 + q4) + dc6*sin(q2 + q3 + q4)*sin(q5)) - cos(q2 + q3 + q4)*(dc6*(cos(q5)*sin(q1) - cos(q2 + q3 + q4)*cos(q1)*sin(q5)) + cos(q1)*(l3*cos(q2 + q3) + l2*cos(q2)) - cos(q1)*(lc3*cos(q2 + q3) + l2*cos(q2)) + d4*sin(q1) + d5*sin(q2 + q3 + q4)*cos(q1));
            JP(2,5) = d5*cos(q2 + q3 + q4)*cos(q5)*sin(q1) - d5*cos(q1)*sin(q5) - d4*sin(q2 + q3 + q4)*sin(q1)*sin(q5) + dc4*sin(q2 + q3 + q4)*sin(q1)*sin(q5);
            JP(2,6) = -(d5 - dc5)*(cos(q1)*sin(q5) - cos(q2 + q3 + q4)*cos(q5)*sin(q1));
            
            JP(3,1) = l3*cos(q2 + q3) - (dc6*sin(q2 + q3 + q4 + q5))/2 + l2*cos(q2) + (dc6*sin(q2 + q3 + q4 - q5))/2 + d5*sin(q2 + q3 + q4);
            JP(3,2) = l3*cos(q2 + q3) - (dc6*sin(q2 + q3 + q4 + q5))/2 - lc1 + l2*cos(q2) + (dc6*sin(q2 + q3 + q4 - q5))/2 + d5*sin(q2 + q3 + q4);
            JP(3,3) = l3*cos(q2 + q3) - (dc6*sin(q2 + q3 + q4 + q5))/2 + l2*cos(q2) - lc2*cos(q2) + (dc6*sin(q2 + q3 + q4 - q5))/2 + d5*sin(q2 + q3 + q4);
            JP(3,4) = - (dc6*sin(q2 + q3 + q4 + q5))/2 - (dc6*sin(q2 + q3 + q4 - q5))/2 - d4*sin(q2 + q3 + q4);
            JP(3,5) = d4*cos(q2 + q3 + q4)*sin(q5) + d5*sin(q2 + q3 + q4)*cos(q5) - dc4*cos(q2 + q3 + q4)*sin(q5);
            JP(3,6) = sin(q2 + q3 + q4)*cos(q5)*(d5 - dc5);
        end


        function dJP = dJP_6dof(robot_params,q,dq)
            %l1 = robot_params.l(1);
            l2 = robot_params.l(2);
            l3 = robot_params.l(3);
            %l4 = robot_params.l(4);
            %l5 = robot_params.l(5);
            %l6 = robot_params.l(6);
            
            %lc1 = robot_params.lc(1);
            lc2 = robot_params.lc(2);
            lc3 = robot_params.lc(3);
            %lc4 = robot_params.lc(4);
            %lc5 = robot_params.lc(5);
            %lc6 = robot_params.lc(6);
            
            d1 = robot_params.d(1);
            %d2 = robot_params.d(2);
            %d3 = robot_params.d(3);
            d4 = robot_params.d(4);
            d5 = robot_params.d(5);
            %d6 = robot_params.d(6);
            
            dc1 = robot_params.dc(1);
            %dc2 = robot_params.dc(2);
            %dc3 = robot_params.dc(3);
            dc4 = robot_params.dc(4);
            dc5 = robot_params.dc(5);
            dc6 = robot_params.dc(6);
            
            dq1 = dq(1);
            dq2 = dq(2);
            dq3 = dq(3);
            dq4 = dq(4);
            dq5 = dq(5);
            %dq6 = dq(6);
            
            q1 = q(1);
            q2 = q(2);
            q3 = q(3);
            q4 = q(4);
            q5 = q(5);
            %q6 = q(6);
            
            dJP = zeros(3,6);
            
            dJP(1,1) = dq1*sin(q1)*(d1 + l3*sin(q2 + q3) + l2*sin(q2) - d5*cos(q2 + q3 + q4) - dc6*sin(q2 + q3 + q4)*sin(q5)) - dq3*cos(q1)*(l3*cos(q2 + q3) + d5*sin(q2 + q3 + q4) - dc6*cos(q2 + q3 + q4)*sin(q5)) - dq4*cos(q1)*(d5*sin(q2 + q3 + q4) - dc6*cos(q2 + q3 + q4)*sin(q5)) - dq2*cos(q1)*(l3*cos(q2 + q3) + l2*cos(q2) + d5*sin(q2 + q3 + q4) - dc6*cos(q2 + q3 + q4)*sin(q5)) + dc6*dq5*sin(q2 + q3 + q4)*cos(q1)*cos(q5);
            dJP(1,2) = dq1*sin(q1)*(d1 - dc1 + l3*sin(q2 + q3) + l2*sin(q2) - d5*cos(q2 + q3 + q4) - dc6*sin(q2 + q3 + q4)*sin(q5)) - dq3*cos(q1)*(l3*cos(q2 + q3) + d5*sin(q2 + q3 + q4) - dc6*cos(q2 + q3 + q4)*sin(q5)) - dq4*cos(q1)*(d5*sin(q2 + q3 + q4) - dc6*cos(q2 + q3 + q4)*sin(q5)) - dq2*cos(q1)*(l3*cos(q2 + q3) + l2*cos(q2) + d5*sin(q2 + q3 + q4) - dc6*cos(q2 + q3 + q4)*sin(q5)) + dc6*dq5*sin(q2 + q3 + q4)*cos(q1)*cos(q5);
            dJP(1,3) = dc6*dq5*sin(q2 + q3 + q4)*cos(q1)*cos(q5) - dq2*cos(q1)*(l3*cos(q2 + q3) + l2*cos(q2) - lc2*cos(q2) + d5*sin(q2 + q3 + q4) - dc6*cos(q2 + q3 + q4)*sin(q5)) - dq1*sin(q1)*(lc2*sin(q2) - l2*sin(q2) - l3*sin(q2 + q3) + d5*cos(q2 + q3 + q4) + dc6*sin(q2 + q3 + q4)*sin(q5)) - dq4*cos(q1)*(d5*sin(q2 + q3 + q4) - dc6*cos(q2 + q3 + q4)*sin(q5)) - dq3*cos(q1)*(l3*cos(q2 + q3) + d5*sin(q2 + q3 + q4) - dc6*cos(q2 + q3 + q4)*sin(q5));
            dJP(1,4) = dq1*l3*cos(q1)*cos(q4) - dq1*lc3*cos(q1)*cos(q4) - dc6*dq1*cos(q1)*sin(q5) - dc6*dq5*cos(q5)*sin(q1) - dq4*l3*sin(q1)*sin(q4) + dq4*lc3*sin(q1)*sin(q4) + d4*dq1*cos(q2)*cos(q3)*cos(q4)*sin(q1) + d4*dq2*cos(q1)*cos(q2)*cos(q3)*sin(q4) + d4*dq2*cos(q1)*cos(q2)*cos(q4)*sin(q3) + d4*dq2*cos(q1)*cos(q3)*cos(q4)*sin(q2) + d4*dq3*cos(q1)*cos(q2)*cos(q3)*sin(q4) + d4*dq3*cos(q1)*cos(q2)*cos(q4)*sin(q3) + d4*dq3*cos(q1)*cos(q3)*cos(q4)*sin(q2) + d4*dq4*cos(q1)*cos(q2)*cos(q3)*sin(q4) + d4*dq4*cos(q1)*cos(q2)*cos(q4)*sin(q3) + d4*dq4*cos(q1)*cos(q3)*cos(q4)*sin(q2) - d4*dq1*cos(q2)*sin(q1)*sin(q3)*sin(q4) - d4*dq1*cos(q3)*sin(q1)*sin(q2)*sin(q4) - d4*dq1*cos(q4)*sin(q1)*sin(q2)*sin(q3) - d4*dq2*cos(q1)*sin(q2)*sin(q3)*sin(q4) - d4*dq3*cos(q1)*sin(q2)*sin(q3)*sin(q4) - d4*dq4*cos(q1)*sin(q2)*sin(q3)*sin(q4) + dc6*dq1*cos(q2)*cos(q3)*cos(q4)*cos(q5)*sin(q1) + dc6*dq2*cos(q1)*cos(q2)*cos(q3)*cos(q5)*sin(q4) + dc6*dq2*cos(q1)*cos(q2)*cos(q4)*cos(q5)*sin(q3) + dc6*dq2*cos(q1)*cos(q3)*cos(q4)*cos(q5)*sin(q2) + dc6*dq3*cos(q1)*cos(q2)*cos(q3)*cos(q5)*sin(q4) + dc6*dq3*cos(q1)*cos(q2)*cos(q4)*cos(q5)*sin(q3) + dc6*dq3*cos(q1)*cos(q3)*cos(q4)*cos(q5)*sin(q2) + dc6*dq4*cos(q1)*cos(q2)*cos(q3)*cos(q5)*sin(q4) + dc6*dq4*cos(q1)*cos(q2)*cos(q4)*cos(q5)*sin(q3) + dc6*dq4*cos(q1)*cos(q3)*cos(q4)*cos(q5)*sin(q2) + dc6*dq5*cos(q1)*cos(q2)*cos(q3)*cos(q4)*sin(q5) - dc6*dq1*cos(q2)*cos(q5)*sin(q1)*sin(q3)*sin(q4) - dc6*dq1*cos(q3)*cos(q5)*sin(q1)*sin(q2)*sin(q4) - dc6*dq1*cos(q4)*cos(q5)*sin(q1)*sin(q2)*sin(q3) - dc6*dq2*cos(q1)*cos(q5)*sin(q2)*sin(q3)*sin(q4) - dc6*dq3*cos(q1)*cos(q5)*sin(q2)*sin(q3)*sin(q4) - dc6*dq4*cos(q1)*cos(q5)*sin(q2)*sin(q3)*sin(q4) - dc6*dq5*cos(q1)*cos(q2)*sin(q3)*sin(q4)*sin(q5) - dc6*dq5*cos(q1)*cos(q3)*sin(q2)*sin(q4)*sin(q5) - dc6*dq5*cos(q1)*cos(q4)*sin(q2)*sin(q3)*sin(q5);
            dJP(1,5) = dq5*(d5*cos(q5)*sin(q1) - d4*sin(q2 + q3 + q4)*cos(q1)*cos(q5) - d5*cos(q2 + q3 + q4)*cos(q1)*sin(q5) + dc4*sin(q2 + q3 + q4)*cos(q1)*cos(q5)) + dq1*(d5*cos(q1)*sin(q5) - d5*cos(q2 + q3 + q4)*cos(q5)*sin(q1) + d4*sin(q2 + q3 + q4)*sin(q1)*sin(q5) - dc4*sin(q2 + q3 + q4)*sin(q1)*sin(q5)) - dq2*cos(q1)*(d4*cos(q2 + q3 + q4)*sin(q5) + d5*sin(q2 + q3 + q4)*cos(q5) - dc4*cos(q2 + q3 + q4)*sin(q5)) - dq3*cos(q1)*(d4*cos(q2 + q3 + q4)*sin(q5) + d5*sin(q2 + q3 + q4)*cos(q5) - dc4*cos(q2 + q3 + q4)*sin(q5)) - dq4*cos(q1)*(d4*cos(q2 + q3 + q4)*sin(q5) + d5*sin(q2 + q3 + q4)*cos(q5) - dc4*cos(q2 + q3 + q4)*sin(q5));
            dJP(1,6) = dq1*(d5 - dc5)*(cos(q1)*sin(q5) - cos(q2 + q3 + q4)*cos(q5)*sin(q1)) + dq5*(d5 - dc5)*(cos(q5)*sin(q1) - cos(q2 + q3 + q4)*cos(q1)*sin(q5)) - dq2*sin(q2 + q3 + q4)*cos(q1)*cos(q5)*(d5 - dc5) - dq3*sin(q2 + q3 + q4)*cos(q1)*cos(q5)*(d5 - dc5) - dq4*sin(q2 + q3 + q4)*cos(q1)*cos(q5)*(d5 - dc5);
            
            dJP(2,1) = dc6*dq5*sin(q2 + q3 + q4)*cos(q5)*sin(q1) - dq1*cos(q1)*(d1 + l3*sin(q2 + q3) + l2*sin(q2) - d5*cos(q2 + q3 + q4) - dc6*sin(q2 + q3 + q4)*sin(q5)) - dq4*sin(q1)*(d5*sin(q2 + q3 + q4) - dc6*cos(q2 + q3 + q4)*sin(q5)) - dq2*sin(q1)*(l3*cos(q2 + q3) + l2*cos(q2) + d5*sin(q2 + q3 + q4) - dc6*cos(q2 + q3 + q4)*sin(q5)) - dq3*sin(q1)*(l3*cos(q2 + q3) + d5*sin(q2 + q3 + q4) - dc6*cos(q2 + q3 + q4)*sin(q5));
            dJP(2,2) = dc6*dq5*sin(q2 + q3 + q4)*cos(q5)*sin(q1) - dq4*sin(q1)*(d5*sin(q2 + q3 + q4) - dc6*cos(q2 + q3 + q4)*sin(q5)) - dq2*sin(q1)*(l3*cos(q2 + q3) + l2*cos(q2) + d5*sin(q2 + q3 + q4) - dc6*cos(q2 + q3 + q4)*sin(q5)) - dq1*cos(q1)*(d1 - dc1 + l3*sin(q2 + q3) + l2*sin(q2) - d5*cos(q2 + q3 + q4) - dc6*sin(q2 + q3 + q4)*sin(q5)) - dq3*sin(q1)*(l3*cos(q2 + q3) + d5*sin(q2 + q3 + q4) - dc6*cos(q2 + q3 + q4)*sin(q5));
            dJP(2,3) = dq1*cos(q1)*(lc2*sin(q2) - l2*sin(q2) - l3*sin(q2 + q3) + d5*cos(q2 + q3 + q4) + dc6*sin(q2 + q3 + q4)*sin(q5)) - dq2*sin(q1)*(l3*cos(q2 + q3) + l2*cos(q2) - lc2*cos(q2) + d5*sin(q2 + q3 + q4) - dc6*cos(q2 + q3 + q4)*sin(q5)) - dq3*sin(q1)*(l3*cos(q2 + q3) + d5*sin(q2 + q3 + q4) - dc6*cos(q2 + q3 + q4)*sin(q5)) - dq4*sin(q1)*(d5*sin(q2 + q3 + q4) - dc6*cos(q2 + q3 + q4)*sin(q5)) + dc6*dq5*sin(q2 + q3 + q4)*cos(q5)*sin(q1);
            dJP(2,4) = dc6*dq5*cos(q1)*cos(q5) + dq1*l3*cos(q4)*sin(q1) + dq4*l3*cos(q1)*sin(q4) - dq1*lc3*cos(q4)*sin(q1) - dq4*lc3*cos(q1)*sin(q4) - dc6*dq1*sin(q1)*sin(q5) - d4*dq1*cos(q1)*cos(q2)*cos(q3)*cos(q4) + d4*dq1*cos(q1)*cos(q2)*sin(q3)*sin(q4) + d4*dq1*cos(q1)*cos(q3)*sin(q2)*sin(q4) + d4*dq1*cos(q1)*cos(q4)*sin(q2)*sin(q3) + d4*dq2*cos(q2)*cos(q3)*sin(q1)*sin(q4) + d4*dq2*cos(q2)*cos(q4)*sin(q1)*sin(q3) + d4*dq2*cos(q3)*cos(q4)*sin(q1)*sin(q2) + d4*dq3*cos(q2)*cos(q3)*sin(q1)*sin(q4) + d4*dq3*cos(q2)*cos(q4)*sin(q1)*sin(q3) + d4*dq3*cos(q3)*cos(q4)*sin(q1)*sin(q2) + d4*dq4*cos(q2)*cos(q3)*sin(q1)*sin(q4) + d4*dq4*cos(q2)*cos(q4)*sin(q1)*sin(q3) + d4*dq4*cos(q3)*cos(q4)*sin(q1)*sin(q2) - d4*dq2*sin(q1)*sin(q2)*sin(q3)*sin(q4) - d4*dq3*sin(q1)*sin(q2)*sin(q3)*sin(q4) - d4*dq4*sin(q1)*sin(q2)*sin(q3)*sin(q4) - dc6*dq1*cos(q1)*cos(q2)*cos(q3)*cos(q4)*cos(q5) + dc6*dq1*cos(q1)*cos(q2)*cos(q5)*sin(q3)*sin(q4) + dc6*dq1*cos(q1)*cos(q3)*cos(q5)*sin(q2)*sin(q4) + dc6*dq1*cos(q1)*cos(q4)*cos(q5)*sin(q2)*sin(q3) + dc6*dq2*cos(q2)*cos(q3)*cos(q5)*sin(q1)*sin(q4) + dc6*dq2*cos(q2)*cos(q4)*cos(q5)*sin(q1)*sin(q3) + dc6*dq2*cos(q3)*cos(q4)*cos(q5)*sin(q1)*sin(q2) + dc6*dq3*cos(q2)*cos(q3)*cos(q5)*sin(q1)*sin(q4) + dc6*dq3*cos(q2)*cos(q4)*cos(q5)*sin(q1)*sin(q3) + dc6*dq3*cos(q3)*cos(q4)*cos(q5)*sin(q1)*sin(q2) + dc6*dq4*cos(q2)*cos(q3)*cos(q5)*sin(q1)*sin(q4) + dc6*dq4*cos(q2)*cos(q4)*cos(q5)*sin(q1)*sin(q3) + dc6*dq4*cos(q3)*cos(q4)*cos(q5)*sin(q1)*sin(q2) + dc6*dq5*cos(q2)*cos(q3)*cos(q4)*sin(q1)*sin(q5) - dc6*dq2*cos(q5)*sin(q1)*sin(q2)*sin(q3)*sin(q4) - dc6*dq3*cos(q5)*sin(q1)*sin(q2)*sin(q3)*sin(q4) - dc6*dq4*cos(q5)*sin(q1)*sin(q2)*sin(q3)*sin(q4) - dc6*dq5*cos(q2)*sin(q1)*sin(q3)*sin(q4)*sin(q5) - dc6*dq5*cos(q3)*sin(q1)*sin(q2)*sin(q4)*sin(q5) - dc6*dq5*cos(q4)*sin(q1)*sin(q2)*sin(q3)*sin(q5);
            dJP(2,5) = dq1*(d5*sin(q1)*sin(q5) + d5*cos(q2 + q3 + q4)*cos(q1)*cos(q5) - d4*sin(q2 + q3 + q4)*cos(q1)*sin(q5) + dc4*sin(q2 + q3 + q4)*cos(q1)*sin(q5)) - dq5*(d5*cos(q1)*cos(q5) + d4*sin(q2 + q3 + q4)*cos(q5)*sin(q1) + d5*cos(q2 + q3 + q4)*sin(q1)*sin(q5) - dc4*sin(q2 + q3 + q4)*cos(q5)*sin(q1)) - dq2*sin(q1)*(d4*cos(q2 + q3 + q4)*sin(q5) + d5*sin(q2 + q3 + q4)*cos(q5) - dc4*cos(q2 + q3 + q4)*sin(q5)) - dq3*sin(q1)*(d4*cos(q2 + q3 + q4)*sin(q5) + d5*sin(q2 + q3 + q4)*cos(q5) - dc4*cos(q2 + q3 + q4)*sin(q5)) - dq4*sin(q1)*(d4*cos(q2 + q3 + q4)*sin(q5) + d5*sin(q2 + q3 + q4)*cos(q5) - dc4*cos(q2 + q3 + q4)*sin(q5));
            dJP(2,6) = dq1*(d5 - dc5)*(sin(q1)*sin(q5) + cos(q2 + q3 + q4)*cos(q1)*cos(q5)) - dq5*(d5 - dc5)*(cos(q1)*cos(q5) + cos(q2 + q3 + q4)*sin(q1)*sin(q5)) - dq2*sin(q2 + q3 + q4)*cos(q5)*sin(q1)*(d5 - dc5) - dq3*sin(q2 + q3 + q4)*cos(q5)*sin(q1)*(d5 - dc5) - dq4*sin(q2 + q3 + q4)*cos(q5)*sin(q1)*(d5 - dc5);
            
            dJP(3,1) = dq4*((dc6*cos(q2 + q3 + q4 - q5))/2 - (dc6*cos(q2 + q3 + q4 + q5))/2 + d5*cos(q2 + q3 + q4)) - dq3*((dc6*cos(q2 + q3 + q4 + q5))/2 + l3*sin(q2 + q3) - (dc6*cos(q2 + q3 + q4 - q5))/2 - d5*cos(q2 + q3 + q4)) - dq2*((dc6*cos(q2 + q3 + q4 + q5))/2 + l3*sin(q2 + q3) - (dc6*cos(q2 + q3 + q4 - q5))/2 + l2*sin(q2) - d5*cos(q2 + q3 + q4)) - (dc6*dq5*(cos(q2 + q3 + q4 + q5) + cos(q2 + q3 + q4 - q5)))/2;
            dJP(3,2) = dq4*((dc6*cos(q2 + q3 + q4 - q5))/2 - (dc6*cos(q2 + q3 + q4 + q5))/2 + d5*cos(q2 + q3 + q4)) - dq3*((dc6*cos(q2 + q3 + q4 + q5))/2 + l3*sin(q2 + q3) - (dc6*cos(q2 + q3 + q4 - q5))/2 - d5*cos(q2 + q3 + q4)) - dq2*((dc6*cos(q2 + q3 + q4 + q5))/2 + l3*sin(q2 + q3) - (dc6*cos(q2 + q3 + q4 - q5))/2 + l2*sin(q2) - d5*cos(q2 + q3 + q4)) - (dc6*dq5*(cos(q2 + q3 + q4 + q5) + cos(q2 + q3 + q4 - q5)))/2;
            dJP(3,3) = dq4*((dc6*cos(q2 + q3 + q4 - q5))/2 - (dc6*cos(q2 + q3 + q4 + q5))/2 + d5*cos(q2 + q3 + q4)) - dq3*((dc6*cos(q2 + q3 + q4 + q5))/2 + l3*sin(q2 + q3) - (dc6*cos(q2 + q3 + q4 - q5))/2 - d5*cos(q2 + q3 + q4)) - dq2*((dc6*cos(q2 + q3 + q4 + q5))/2 + l3*sin(q2 + q3) - (dc6*cos(q2 + q3 + q4 - q5))/2 + l2*sin(q2) - lc2*sin(q2) - d5*cos(q2 + q3 + q4)) - dq5*((dc6*cos(q2 + q3 + q4 + q5))/2 + (dc6*cos(q2 + q3 + q4 - q5))/2);
            dJP(3,4) = - dq2*((dc6*cos(q2 + q3 + q4 + q5))/2 + (dc6*cos(q2 + q3 + q4 - q5))/2 + d4*cos(q2 + q3 + q4)) - dq3*((dc6*cos(q2 + q3 + q4 + q5))/2 + (dc6*cos(q2 + q3 + q4 - q5))/2 + d4*cos(q2 + q3 + q4)) - dq4*((dc6*cos(q2 + q3 + q4 + q5))/2 + (dc6*cos(q2 + q3 + q4 - q5))/2 + d4*cos(q2 + q3 + q4)) - (dc6*dq5*(cos(q2 + q3 + q4 + q5) - cos(q2 + q3 + q4 - q5)))/2;
            dJP(3,5) = dq2*(d5*cos(q2 + q3 + q4)*cos(q5) - d4*sin(q2 + q3 + q4)*sin(q5) + dc4*sin(q2 + q3 + q4)*sin(q5)) - dq5*(dc4*cos(q2 + q3 + q4)*cos(q5) - d4*cos(q2 + q3 + q4)*cos(q5) + d5*sin(q2 + q3 + q4)*sin(q5)) + dq3*(d5*cos(q2 + q3 + q4)*cos(q5) - d4*sin(q2 + q3 + q4)*sin(q5) + dc4*sin(q2 + q3 + q4)*sin(q5)) + dq4*(d5*cos(q2 + q3 + q4)*cos(q5) - d4*sin(q2 + q3 + q4)*sin(q5) + dc4*sin(q2 + q3 + q4)*sin(q5));
            dJP(3,6) = (d5 - dc5)*(dq2*cos(q2 + q3 + q4)*cos(q5) + dq3*cos(q2 + q3 + q4)*cos(q5) + dq4*cos(q2 + q3 + q4)*cos(q5) - dq5*sin(q2 + q3 + q4)*sin(q5));
        end

        function m = transformacion_homogenea(DH_i)
                a_i = DH_i(1);
                alpha_i = DH_i(2);
                d_i = DH_i(3);
                theta_i = DH_i(4);
                
                ma_i = [1 0 0 a_i;
                        0 1 0 0;
                        0 0 1 0;
                        0 0 0 1];
                
                md_i = [1 0 0 0;
                        0 1 0 0;
                        0 0 1 d_i;
                        0 0 0 1];
                
                mtheta_i = [cos(theta_i) -sin(theta_i) 0 0;
                            sin(theta_i) cos(theta_i) 0 0;
                            0 0 1 0;
                            0 0 0 1];
                
                malpha_i = [1 0 0 0;
                            0 cos(alpha_i) -sin(alpha_i) 0;
                            0 sin(alpha_i) cos(alpha_i) 0;
                            0 0 0 1];
                
                m = mtheta_i * md_i * ma_i * malpha_i;
        end
    end
end