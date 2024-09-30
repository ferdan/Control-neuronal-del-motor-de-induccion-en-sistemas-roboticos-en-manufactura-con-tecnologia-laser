classdef robot_dinm
    methods (Static)
        function robot_din = din_2dof(robot_params,q,dq)
        
            l1 = robot_params.l(1);
            %l2 = robot_params.l(2);
            
            lc1 = robot_params.lc(1);
            lc2 = robot_params.lc(2);
            
            m1 = robot_params.m(1);
            m2 = robot_params.m(2);
            
            I1 = 1.266;
            I2 = 0.093;
            
            g = 9.81;
            
            q1 = q(1);
            q2 = q(2);
            
            dq1 = dq(1);
            dq2 = dq(2);
            
            D = zeros(2,2);
            
            D(1,1) = l1^2*m2 + lc1^2*m1 + lc2^2*m2 + 2*l1*lc2*m2*cos(q2) + I1 + I2;
            D(1,2) = lc2*m2*(lc2 + l1*cos(q2)) + I2;
            
            D(2,1) = lc2*m2*(lc2 + l1*cos(q2)) + I2;
            D(2,2) = m2*lc2^2 + I2;
            
            C = zeros(2,2);
            
            C(1,1) = 0;
            C(1,2) = -l1*lc2*m2*sin(q2)*(2*dq1 + dq2);
            
            C(2,1) = dq1*l1*lc2*m2*sin(q2);
            C(2,2) = 0;
            
            G = zeros(2,1);
            
            G(1,1) = l1*m2*cos(q1) + lc1*m1*cos(q1) + lc2*m2*cos(q1 + q2);
            G(2,1) = lc2*m2*cos(q1 + q2);
            
            
            robot_din = struct('D',D,'C',C,'G',G,'g',9.81);
        end

        function robot_din = din_3dof(robot_params,q,dq)
            %d1 = robot_params.d(1);
            l2 = robot_params.l(2);
            lc2 = robot_params.lc(2);
            %l3 = robot_params.l(3);
            lc3 = robot_params.lc(3);
            
            %m1 = robot_params.m(1);
            m2 = robot_params.m(2);
            m3 = robot_params.m(3);
            
            Iz1 = robot_params.I(1,3);
            Iy2 = robot_params.I(2,2);
            Iz2 = robot_params.I(2,3);
            Iy3 = robot_params.I(3,2);
            Iz3 = robot_params.I(3,3);
            
            g = 9.81;
            
            q1 = q(1);
            q2 = q(2);
            q3 = q(3);
            
            dq1 = dq(1);
            dq2 = dq(2);
            dq3 = dq(3);
            
            D = zeros(3,3);
            
            D(1,1) = Iz1 + Iz2 + Iz3 + (m2/2)*lc2^2*(1+cos(2*q2)) ...
                   + (m3/2)*(l2^2*(1+cos(2*q2)) + 2*l2*lc3*(cos(2*q2+q3)+cos(q3)) ...
                   + lc3^2*(1+cos(2*q2+2*q3)));
            
            D(2,2) = Iy2 + Iy3 + m2*lc2^2 + m3*(l2^2 + 2*l2*lc3*cos(q3) + lc3^2);
            D(2,3) = Iy3 + m3*(l2*lc3*cos(q3) + lc3^2);
            
            D(3,2) = Iy3 + m3*(l2*lc3*cos(q3) + lc3^2);
            D(3,3) = Iy3 + m3*lc3^2;
            
            C = zeros(3,3);
            
            C(1,2) = - ((m2*lc2^2*sin(2*q2)) ...
                     + m3*(l2^2*sin(2*q2) + 2*l2*lc3*sin(2*q2+q3) ...
                     + lc3^2*sin(2*q2+2*q3)))*dq1;
            C(1,3) = - m3*(l2*lc3*(sin(2*q2+q3)+sin(q3)) ...
                     + lc3^2*(sin(2*q2+2*q3)))*dq1;
            
            C(2,1) =   ((m2/2)*(lc2^2*sin(2*q2)) ...
                     + (m3/2)*(l2^2*sin(2*q2) + 2*l2*lc3*sin(2*q2+q3) ...
                     + lc3^2*sin(2*q2+2*q3)))*dq1;
            C(2,2) = - 2*m3*l2*lc3*sin(q3)*dq3;
            C(2,3) = - m3*l2*lc3*sin(q3)*dq3;
            
            C(3,1) =   (m3/2)*(l2*lc3*(sin(2*q2+q3) + sin(q3)) ...
                     + lc3^2*sin(2*q2+2*q3))*dq1;
            C(3,2) =   m3*l2*lc3*sin(q3)*dq2;
            
            G = zeros(3,1);
            
            G(2,1) = m2*lc2*cos(q2) + m3*(l2*cos(q2) + lc3*cos(q2+q3));
            G(3,1) = m3*lc3*cos(q2+q3);
            
            
            robot_din = struct('D',D,'C',C,'G',G,'g',9.81);
        end

        function robot_din = din_6dof(robot_params,q,dq)

            % l1 = robot_params.l(1);
            l2 = robot_params.l(2);
            l3 = robot_params.l(3);
            % l4 = robot_params.l(4);
            % l5 = robot_params.l(5);
            % l6 = robot_params.l(6);
            
            lc1 = robot_params.lc(1);
            lc2 = robot_params.lc(2);
            lc3 = robot_params.lc(3);
            % lc4 = robot_params.lc(4);
            % lc5 = robot_params.lc(5);
            % lc6 = robot_params.lc(6);
            
            d1 = robot_params.d(1);
            d2 = robot_params.d(2);
            d3 = robot_params.d(3);
            d4 = robot_params.d(4);
            d5 = robot_params.d(5);
            d6 = robot_params.d(6);
            
            % dc1 = robot_params.dc(1);
            % dc2 = robot_params.dc(2);
            % dc3 = robot_params.dc(3);
            dc4 = robot_params.dc(4);
            dc5 = robot_params.dc(5);
            dc6 = robot_params.dc(6);
            
            m1 = robot_params.m(1);
            m2 = robot_params.m(2);
            m3 = robot_params.m(3);
            m4 = robot_params.m(4);
            m5 = robot_params.m(5);
            m6 = robot_params.m(6);
            
            %Posiciones angulares
            % q1 = q(1);
            q2 = q(2);
            q3 = q(3);
            q4 = q(4);
            q5 = q(5);
            % q6 = q(6);
            
            %Velocidades angulares
            dq1 = dq(1);
            dq2 = dq(2);
            dq3 = dq(3);
            dq4 = dq(4);
            dq5 = dq(5);
            % dq6 = dq(6);
            
            % Matriz de Inercia D
            D = zeros(6,6);
            
            D(1,1) = (d1*m1)/2 + (d2*m2)/2 + (d3*m3)/2 + (d4*m4)/2 + (d5*m5)/2 + (d6*m6)/2 + d4^2*m5 + d4^2*m6 + (d5^2*m6)/2 + dc4^2*m4 + (dc5^2*m5)/2 + (3*dc6^2*m6)/4 + (l2^2*m3)/2 + (l2^2*m4)/2 + (l2^2*m5)/2 + (l3^2*m4)/2 + (l2^2*m6)/2 + (l3^2*m5)/2 + (l3^2*m6)/2 + lc1^2*m1 + (lc2^2*m2)/2 + (lc3^2*m3)/2 - (dc6^2*m6*cos(2*q2 + 2*q3 + 2*q4 - 2*q5))/8 - (dc6^2*m6*cos(2*q2 + 2*q3 + 2*q4 + 2*q5))/8 - (d5^2*m6*cos(2*q2 + 2*q3 + 2*q4))/2 + (dc6^2*m6*cos(2*q5))/4 - (dc5^2*m5*cos(2*q2 + 2*q3 + 2*q4))/2 + (dc6^2*m6*cos(2*q2 + 2*q3 + 2*q4))/4 + (l2^2*m3*cos(2*q2))/2 + (l2^2*m4*cos(2*q2))/2 + (l2^2*m5*cos(2*q2))/2 + (l2^2*m6*cos(2*q2))/2 + (lc2^2*m2*cos(2*q2))/2 + (l3^2*m4*cos(2*q2 + 2*q3))/2 + (l3^2*m5*cos(2*q2 + 2*q3))/2 + (l3^2*m6*cos(2*q2 + 2*q3))/2 + (lc3^2*m3*cos(2*q2 + 2*q3))/2 + d5*l2*m6*sin(2*q2 + q3 + q4) + dc5*l2*m5*sin(2*q2 + q3 + q4) + (dc6*l2*m6*sin(q3 + q4 - q5))/2 + (d5*dc6*m6*cos(2*q2 + 2*q3 + 2*q4 + q5))/2 + d5*l2*m6*sin(q3 + q4) + dc5*l2*m5*sin(q3 + q4) - (dc6*l3*m6*sin(q4 + q5))/2 + (dc6*l3*m6*sin(2*q2 + 2*q3 + q4 - q5))/2 + 2*d4*dc6*m6*cos(q5) + l2*l3*m4*cos(q3) + l2*l3*m5*cos(q3) + l2*l3*m6*cos(q3) + l2*lc3*m3*cos(q3) + d5*l3*m6*sin(q4) + d5*l3*m6*sin(2*q2 + 2*q3 + q4) + dc5*l3*m5*sin(q4) + dc5*l3*m5*sin(2*q2 + 2*q3 + q4) - (dc6*l2*m6*sin(2*q2 + q3 + q4 + q5))/2 - (d5*dc6*m6*cos(2*q2 + 2*q3 + 2*q4 - q5))/2 + l2*l3*m4*cos(2*q2 + q3) + l2*l3*m5*cos(2*q2 + q3) + l2*l3*m6*cos(2*q2 + q3) + l2*lc3*m3*cos(2*q2 + q3) + (dc6*l3*m6*sin(q4 - q5))/2 - (dc6*l2*m6*sin(q3 + q4 + q5))/2 + (dc6*l2*m6*sin(2*q2 + q3 + q4 - q5))/2 - (dc6*l3*m6*sin(2*q2 + 2*q3 + q4 + q5))/2;
            D(1,2) = (dc6^2*m6*cos(q2 + q3 + q4 - 2*q5))/4 - (dc6^2*m6*cos(q2 + q3 + q4 + 2*q5))/4 - (d4*dc6*m6*cos(q2 + q3 + q4 + q5))/2 + (d5*dc6*m6*cos(q2 + q3 + q4 + q5))/2 - (dc6*l3*m6*sin(q2 + q3 - q5))/2 - d4*l3*m5*sin(q2 + q3) - d4*l3*m6*sin(q2 + q3) - dc4*l3*m4*sin(q2 + q3) - (dc6*l2*m6*sin(q2 + q5))/2 + (d4*dc6*m6*cos(q2 + q3 + q4 - q5))/2 + (d5*dc6*m6*cos(q2 + q3 + q4 - q5))/2 - d4*l2*m5*sin(q2) - d4*l2*m6*sin(q2) - dc4*l2*m4*sin(q2) + d4*d5*m6*cos(q2 + q3 + q4) + d4*dc5*m5*cos(q2 + q3 + q4) - (dc6*l2*m6*sin(q2 - q5))/2 - (dc6*l3*m6*sin(q2 + q3 + q5))/2;
            D(1,3) = (dc6^2*m6*cos(q2 + q3 + q4 - 2*q5))/4 - (dc6^2*m6*cos(q2 + q3 + q4 + 2*q5))/4 - (d4*dc6*m6*cos(q2 + q3 + q4 + q5))/2 + (d5*dc6*m6*cos(q2 + q3 + q4 + q5))/2 - (dc6*l3*m6*sin(q2 + q3 - q5))/2 - d4*l3*m5*sin(q2 + q3) - d4*l3*m6*sin(q2 + q3) - dc4*l3*m4*sin(q2 + q3) + (d4*dc6*m6*cos(q2 + q3 + q4 - q5))/2 + (d5*dc6*m6*cos(q2 + q3 + q4 - q5))/2 + d4*d5*m6*cos(q2 + q3 + q4) + d4*dc5*m5*cos(q2 + q3 + q4) - (dc6*l3*m6*sin(q2 + q3 + q5))/2;
            D(1,4) = (dc6^2*m6*cos(q2 + q3 + q4 - 2*q5))/4 - (dc6^2*m6*cos(q2 + q3 + q4 + 2*q5))/4 - (d4*dc6*m6*cos(q2 + q3 + q4 + q5))/2 + (d5*dc6*m6*cos(q2 + q3 + q4 + q5))/2 + (d4*dc6*m6*cos(q2 + q3 + q4 - q5))/2 + (d5*dc6*m6*cos(q2 + q3 + q4 - q5))/2 + d4*d5*m6*cos(q2 + q3 + q4) + d4*dc5*m5*cos(q2 + q3 + q4);
            D(1,5) = -(dc6*m6*(d4*cos(q2 + q3 + q4 + q5) + d5*cos(q2 + q3 + q4 + q5) + l3*sin(q2 + q3 - q5) - l2*sin(q2 + q5) + d4*cos(q2 + q3 + q4 - q5) - d5*cos(q2 + q3 + q4 - q5) + 2*dc6*cos(q2 + q3 + q4) + l2*sin(q2 - q5) - l3*sin(q2 + q3 + q5)))/2;
            D(1,6) = 0;
            
            D(2,1) = (dc6^2*m6*cos(q2 + q3 + q4 - 2*q5))/4 - (dc6^2*m6*cos(q2 + q3 + q4 + 2*q5))/4 - (d4*dc6*m6*cos(q2 + q3 + q4 + q5))/2 + (d5*dc6*m6*cos(q2 + q3 + q4 + q5))/2 - (dc6*l3*m6*sin(q2 + q3 - q5))/2 - d4*l3*m5*sin(q2 + q3) - d4*l3*m6*sin(q2 + q3) - dc4*l3*m4*sin(q2 + q3) - (dc6*l2*m6*sin(q2 + q5))/2 + (d4*dc6*m6*cos(q2 + q3 + q4 - q5))/2 + (d5*dc6*m6*cos(q2 + q3 + q4 - q5))/2 - d4*l2*m5*sin(q2) - d4*l2*m6*sin(q2) - dc4*l2*m4*sin(q2) + d4*d5*m6*cos(q2 + q3 + q4) + d4*dc5*m5*cos(q2 + q3 + q4) - (dc6*l2*m6*sin(q2 - q5))/2 - (dc6*l3*m6*sin(q2 + q3 + q5))/2;
            D(2,2) = (d2*m2)/2 + (d3*m3)/2 + (d4*m4)/2 + (d5*m5)/2 + (d6*m6)/2 + d5^2*m6 + dc5^2*m5 + (dc6^2*m6)/2 + l2^2*m3 + l2^2*m4 + l2^2*m5 + l3^2*m4 + l2^2*m6 + l3^2*m5 + l3^2*m6 + lc2^2*m2 + lc3^2*m3 - (dc6^2*m6*cos(2*q5))/2 + 2*d5*l2*m6*sin(q3 + q4) + 2*dc5*l2*m5*sin(q3 + q4) + 2*l2*l3*m4*cos(q3) + 2*l2*l3*m5*cos(q3) + 2*l2*l3*m6*cos(q3) + 2*l2*lc3*m3*cos(q3) + 2*d5*l3*m6*sin(q4) + 2*dc5*l3*m5*sin(q4) - 2*dc6*l3*m6*cos(q4)*sin(q5) - 2*dc6*l2*m6*cos(q3)*cos(q4)*sin(q5) + 2*dc6*l2*m6*sin(q3)*sin(q4)*sin(q5);
            D(2,3) = d5^2*m6 + dc5^2*m5 + (dc6^2*m6)/2 + l3^2*m4 + l3^2*m5 + l3^2*m6 + lc3^2*m3 - (dc6^2*m6*cos(2*q5))/2 + d5*l2*m6*sin(q3 + q4) + dc5*l2*m5*sin(q3 + q4) + l2*l3*m4*cos(q3) + l2*l3*m5*cos(q3) + l2*l3*m6*cos(q3) + l2*lc3*m3*cos(q3) + 2*d5*l3*m6*sin(q4) + 2*dc5*l3*m5*sin(q4) - 2*dc6*l3*m6*cos(q4)*sin(q5) - dc6*l2*m6*cos(q3)*cos(q4)*sin(q5) + dc6*l2*m6*sin(q3)*sin(q4)*sin(q5);
            D(2,4) = d5^2*m6 + dc5^2*m5 + (dc6^2*m6)/2 - (dc6^2*m6*cos(2*q5))/2 + d5*l2*m6*sin(q3 + q4) + dc5*l2*m5*sin(q3 + q4) + d5*l3*m6*sin(q4) + dc5*l3*m5*sin(q4) - dc6*l3*m6*cos(q4)*sin(q5) - dc6*l2*m6*cos(q3)*cos(q4)*sin(q5) + dc6*l2*m6*sin(q3)*sin(q4)*sin(q5);
            D(2,5) = -dc6*m6*cos(q5)*(d5 + l2*sin(q3 + q4) + l3*sin(q4));
            D(2,6) = 0;
            
            D(3,1) = (dc6^2*m6*cos(q2 + q3 + q4 - 2*q5))/4 - (dc6^2*m6*cos(q2 + q3 + q4 + 2*q5))/4 - (d4*dc6*m6*cos(q2 + q3 + q4 + q5))/2 + (d5*dc6*m6*cos(q2 + q3 + q4 + q5))/2 - (dc6*l3*m6*sin(q2 + q3 - q5))/2 - d4*l3*m5*sin(q2 + q3) - d4*l3*m6*sin(q2 + q3) - dc4*l3*m4*sin(q2 + q3) + (d4*dc6*m6*cos(q2 + q3 + q4 - q5))/2 + (d5*dc6*m6*cos(q2 + q3 + q4 - q5))/2 + d4*d5*m6*cos(q2 + q3 + q4) + d4*dc5*m5*cos(q2 + q3 + q4) - (dc6*l3*m6*sin(q2 + q3 + q5))/2;
            D(3,2) = d5^2*m6 + dc5^2*m5 + (dc6^2*m6)/2 + l3^2*m4 + l3^2*m5 + l3^2*m6 + lc3^2*m3 - (dc6^2*m6*cos(2*q5))/2 + d5*l2*m6*sin(q3 + q4) + dc5*l2*m5*sin(q3 + q4) + l2*l3*m4*cos(q3) + l2*l3*m5*cos(q3) + l2*l3*m6*cos(q3) + l2*lc3*m3*cos(q3) + 2*d5*l3*m6*sin(q4) + 2*dc5*l3*m5*sin(q4) - 2*dc6*l3*m6*cos(q4)*sin(q5) - dc6*l2*m6*cos(q3)*cos(q4)*sin(q5) + dc6*l2*m6*sin(q3)*sin(q4)*sin(q5);
            D(3,3) = (d3*m3)/2 + (d4*m4)/2 + (d5*m5)/2 + (d6*m6)/2 + d5^2*m6 + dc5^2*m5 + l3^2*m4 + l3^2*m5 + l3^2*m6 + lc3^2*m3 + dc6^2*m6*sin(q5)^2 + 2*d5*l3*m6*sin(q4) + 2*dc5*l3*m5*sin(q4) - 2*dc6*l3*m6*cos(q4)*sin(q5);
            D(3,4) = d5^2*m6 + dc5^2*m5 + dc6^2*m6*sin(q5)^2 + d5*l3*m6*sin(q4) + dc5*l3*m5*sin(q4) - dc6*l3*m6*cos(q4)*sin(q5);
            D(3,5) = -dc6*m6*cos(q5)*(d5 + l3*sin(q4));
            D(3,6) = 0;
            
            D(4,1) = (dc6^2*m6*cos(q2 + q3 + q4 - 2*q5))/4 - (dc6^2*m6*cos(q2 + q3 + q4 + 2*q5))/4 - (d4*dc6*m6*cos(q2 + q3 + q4 + q5))/2 + (d5*dc6*m6*cos(q2 + q3 + q4 + q5))/2 + (d4*dc6*m6*cos(q2 + q3 + q4 - q5))/2 + (d5*dc6*m6*cos(q2 + q3 + q4 - q5))/2 + d4*d5*m6*cos(q2 + q3 + q4) + d4*dc5*m5*cos(q2 + q3 + q4);
            D(4,2) = d5^2*m6 + dc5^2*m5 + (dc6^2*m6)/2 - (dc6^2*m6*cos(2*q5))/2 + d5*l2*m6*sin(q3 + q4) + dc5*l2*m5*sin(q3 + q4) + d5*l3*m6*sin(q4) + dc5*l3*m5*sin(q4) - dc6*l3*m6*cos(q4)*sin(q5) - dc6*l2*m6*cos(q3)*cos(q4)*sin(q5) + dc6*l2*m6*sin(q3)*sin(q4)*sin(q5);
            D(4,3) = d5^2*m6 + dc5^2*m5 + dc6^2*m6*sin(q5)^2 + d5*l3*m6*sin(q4) + dc5*l3*m5*sin(q4) - dc6*l3*m6*cos(q4)*sin(q5);
            D(4,4) = (d4*m4)/2 + (d5*m5)/2 + (d6*m6)/2 + d5^2*m6 + dc5^2*m5 + dc6^2*m6 - dc6^2*m6*cos(q5)^2;
            D(4,5) = -d5*dc6*m6*cos(q5);
            D(4,6) = 0;
            
            D(5,1) = -(dc6*m6*(d4*cos(q2 + q3 + q4 + q5) + d5*cos(q2 + q3 + q4 + q5) + l3*sin(q2 + q3 - q5) - l2*sin(q2 + q5) + d4*cos(q2 + q3 + q4 - q5) - d5*cos(q2 + q3 + q4 - q5) + 2*dc6*cos(q2 + q3 + q4) + l2*sin(q2 - q5) - l3*sin(q2 + q3 + q5)))/2;
            D(5,2) = -dc6*m6*cos(q5)*(d5 + l2*sin(q3 + q4) + l3*sin(q4));
            D(5,3) = -dc6*m6*cos(q5)*(d5 + l3*sin(q4));
            D(5,4) = -d5*dc6*m6*cos(q5);
            D(5,5) = (d5*m5)/2 + (d6*m6)/2 + dc6^2*m6;
            D(5,6) = 0;
            
            D(6,1) = 0;
            D(6,2) = 0;
            D(6,3) = 0;
            D(6,4) = 0;
            D(6,5) = 0;
            D(6,6) = 1;
            
            % Matriz de Coriollis C
            C = zeros(6,6);
            
            C(1,1) = 0;
            C(1,2) = (dc6^2*dq1*m6*sin(2*q2 + 2*q3 + 2*q4 - 2*q5))/4 + (dc6^2*dq1*m6*sin(2*q2 + 2*q3 + 2*q4 + 2*q5))/4 + d5^2*dq1*m6*sin(2*q2 + 2*q3 + 2*q4) + dc5^2*dq1*m5*sin(2*q2 + 2*q3 + 2*q4) - (dc6^2*dq1*m6*sin(2*q2 + 2*q3 + 2*q4))/2 - dq1*l2^2*m3*sin(2*q2) - dq1*l2^2*m4*sin(2*q2) - dq1*l2^2*m5*sin(2*q2) - dq1*l2^2*m6*sin(2*q2) - dq1*lc2^2*m2*sin(2*q2) - dq1*l3^2*m4*sin(2*q2 + 2*q3) - dq1*l3^2*m5*sin(2*q2 + 2*q3) - dq1*l3^2*m6*sin(2*q2 + 2*q3) - dq1*lc3^2*m3*sin(2*q2 + 2*q3) - (dc6^2*dq2*m6*sin(q2 + q3 + q4 - 2*q5))/4 + (dc6^2*dq2*m6*sin(q2 + q3 + q4 + 2*q5))/4 - (dc6*dq2*l2*m6*cos(q2 - q5))/2 + d5*dc6*dq1*m6*sin(2*q2 + 2*q3 + 2*q4 - q5) - (dc6*dq2*l3*m6*cos(q2 + q3 + q5))/2 - 2*dq1*l2*l3*m4*sin(2*q2 + q3) - 2*dq1*l2*l3*m5*sin(2*q2 + q3) - 2*dq1*l2*l3*m6*sin(2*q2 + q3) - 2*dq1*l2*lc3*m3*sin(2*q2 + q3) - d4*d5*dq2*m6*sin(q2 + q3 + q4) - d4*dc5*dq2*m5*sin(q2 + q3 + q4) + dc6*dq1*l2*m6*cos(2*q2 + q3 + q4 - q5) - dc6*dq1*l3*m6*cos(2*q2 + 2*q3 + q4 + q5) + 2*d5*dq1*l2*m6*cos(2*q2 + q3 + q4) + 2*dc5*dq1*l2*m5*cos(2*q2 + q3 + q4) - (dc6*dq2*l3*m6*cos(q2 + q3 - q5))/2 + (d4*dc6*dq2*m6*sin(q2 + q3 + q4 + q5))/2 - (d5*dc6*dq2*m6*sin(q2 + q3 + q4 + q5))/2 - d4*dq2*l3*m5*cos(q2 + q3) - d4*dq2*l3*m6*cos(q2 + q3) - dc4*dq2*l3*m4*cos(q2 + q3) - (dc6*dq2*l2*m6*cos(q2 + q5))/2 + dc6*dq1*l3*m6*cos(2*q2 + 2*q3 + q4 - q5) - d5*dc6*dq1*m6*sin(2*q2 + 2*q3 + 2*q4 + q5) - d4*dq2*l2*m5*cos(q2) - d4*dq2*l2*m6*cos(q2) + 2*d5*dq1*l3*m6*cos(2*q2 + 2*q3 + q4) - dc4*dq2*l2*m4*cos(q2) + 2*dc5*dq1*l3*m5*cos(2*q2 + 2*q3 + q4) - dc6*dq1*l2*m6*cos(2*q2 + q3 + q4 + q5) - (d4*dc6*dq2*m6*sin(q2 + q3 + q4 - q5))/2 - (d5*dc6*dq2*m6*sin(q2 + q3 + q4 - q5))/2;
            C(1,3) = (dc6^2*dq1*m6*sin(2*q2 + 2*q3 + 2*q4 - 2*q5))/4 + (dc6^2*dq1*m6*sin(2*q2 + 2*q3 + 2*q4 + 2*q5))/4 + d5^2*dq1*m6*sin(2*q2 + 2*q3 + 2*q4) + dc5^2*dq1*m5*sin(2*q2 + 2*q3 + 2*q4) - (dc6^2*dq1*m6*sin(2*q2 + 2*q3 + 2*q4))/2 - dq1*l3^2*m4*sin(2*q2 + 2*q3) - dq1*l3^2*m5*sin(2*q2 + 2*q3) - dq1*l3^2*m6*sin(2*q2 + 2*q3) - dq1*lc3^2*m3*sin(2*q2 + 2*q3) - (dc6^2*dq2*m6*sin(q2 + q3 + q4 - 2*q5))/2 + (dc6^2*dq2*m6*sin(q2 + q3 + q4 + 2*q5))/2 - (dc6^2*dq3*m6*sin(q2 + q3 + q4 - 2*q5))/4 + (dc6^2*dq3*m6*sin(q2 + q3 + q4 + 2*q5))/4 + d5*dc6*dq1*m6*sin(2*q2 + 2*q3 + 2*q4 - q5) - (dc6*dq1*l2*m6*cos(q3 + q4 + q5))/2 - dc6*dq2*l3*m6*cos(q2 + q3 + q5) - (dc6*dq3*l3*m6*cos(q2 + q3 + q5))/2 - dq1*l2*l3*m4*sin(2*q2 + q3) - dq1*l2*l3*m5*sin(2*q2 + q3) - dq1*l2*l3*m6*sin(2*q2 + q3) - dq1*l2*lc3*m3*sin(2*q2 + q3) - 2*d4*d5*dq2*m6*sin(q2 + q3 + q4) - d4*d5*dq3*m6*sin(q2 + q3 + q4) - 2*d4*dc5*dq2*m5*sin(q2 + q3 + q4) - d4*dc5*dq3*m5*sin(q2 + q3 + q4) + (dc6*dq1*l2*m6*cos(2*q2 + q3 + q4 - q5))/2 - dc6*dq1*l3*m6*cos(2*q2 + 2*q3 + q4 + q5) + d5*dq1*l2*m6*cos(2*q2 + q3 + q4) + dc5*dq1*l2*m5*cos(2*q2 + q3 + q4) + (dc6*dq1*l2*m6*cos(q3 + q4 - q5))/2 - dc6*dq2*l3*m6*cos(q2 + q3 - q5) - (dc6*dq3*l3*m6*cos(q2 + q3 - q5))/2 + d4*dc6*dq2*m6*sin(q2 + q3 + q4 + q5) + (d4*dc6*dq3*m6*sin(q2 + q3 + q4 + q5))/2 - d5*dc6*dq2*m6*sin(q2 + q3 + q4 + q5) - (d5*dc6*dq3*m6*sin(q2 + q3 + q4 + q5))/2 - 2*d4*dq2*l3*m5*cos(q2 + q3) - 2*d4*dq2*l3*m6*cos(q2 + q3) - d4*dq3*l3*m5*cos(q2 + q3) - d4*dq3*l3*m6*cos(q2 + q3) + d5*dq1*l2*m6*cos(q3 + q4) - 2*dc4*dq2*l3*m4*cos(q2 + q3) - dc4*dq3*l3*m4*cos(q2 + q3) + dc5*dq1*l2*m5*cos(q3 + q4) + dc6*dq1*l3*m6*cos(2*q2 + 2*q3 + q4 - q5) - d5*dc6*dq1*m6*sin(2*q2 + 2*q3 + 2*q4 + q5) + 2*d5*dq1*l3*m6*cos(2*q2 + 2*q3 + q4) + 2*dc5*dq1*l3*m5*cos(2*q2 + 2*q3 + q4) - (dc6*dq1*l2*m6*cos(2*q2 + q3 + q4 + q5))/2 - dq1*l2*l3*m4*sin(q3) - dq1*l2*l3*m5*sin(q3) - dq1*l2*l3*m6*sin(q3) - dq1*l2*lc3*m3*sin(q3) - d4*dc6*dq2*m6*sin(q2 + q3 + q4 - q5) - (d4*dc6*dq3*m6*sin(q2 + q3 + q4 - q5))/2 - d5*dc6*dq2*m6*sin(q2 + q3 + q4 - q5) - (d5*dc6*dq3*m6*sin(q2 + q3 + q4 - q5))/2;
            C(1,4) = (dc6^2*dq1*m6*sin(2*q2 + 2*q3 + 2*q4 - 2*q5))/4 + (dc6^2*dq1*m6*sin(2*q2 + 2*q3 + 2*q4 + 2*q5))/4 + d5^2*dq1*m6*sin(2*q2 + 2*q3 + 2*q4) + dc5^2*dq1*m5*sin(2*q2 + 2*q3 + 2*q4) - (dc6^2*dq1*m6*sin(2*q2 + 2*q3 + 2*q4))/2 - (dc6^2*dq2*m6*sin(q2 + q3 + q4 - 2*q5))/2 + (dc6^2*dq2*m6*sin(q2 + q3 + q4 + 2*q5))/2 - (dc6^2*dq3*m6*sin(q2 + q3 + q4 - 2*q5))/2 + (dc6^2*dq3*m6*sin(q2 + q3 + q4 + 2*q5))/2 - (dc6^2*dq4*m6*sin(q2 + q3 + q4 - 2*q5))/4 + (dc6^2*dq4*m6*sin(q2 + q3 + q4 + 2*q5))/4 + (dc6*dq1*l3*m6*cos(q4 - q5))/2 + d5*dc6*dq1*m6*sin(2*q2 + 2*q3 + 2*q4 - q5) - (dc6*dq1*l2*m6*cos(q3 + q4 + q5))/2 - 2*d4*d5*dq2*m6*sin(q2 + q3 + q4) - 2*d4*d5*dq3*m6*sin(q2 + q3 + q4) - d4*d5*dq4*m6*sin(q2 + q3 + q4) - 2*d4*dc5*dq2*m5*sin(q2 + q3 + q4) - 2*d4*dc5*dq3*m5*sin(q2 + q3 + q4) - d4*dc5*dq4*m5*sin(q2 + q3 + q4) + (dc6*dq1*l2*m6*cos(2*q2 + q3 + q4 - q5))/2 - (dc6*dq1*l3*m6*cos(2*q2 + 2*q3 + q4 + q5))/2 + d5*dq1*l2*m6*cos(2*q2 + q3 + q4) + dc5*dq1*l2*m5*cos(2*q2 + q3 + q4) + (dc6*dq1*l2*m6*cos(q3 + q4 - q5))/2 + d4*dc6*dq2*m6*sin(q2 + q3 + q4 + q5) + d4*dc6*dq3*m6*sin(q2 + q3 + q4 + q5) - d5*dc6*dq2*m6*sin(q2 + q3 + q4 + q5) + (d4*dc6*dq4*m6*sin(q2 + q3 + q4 + q5))/2 - d5*dc6*dq3*m6*sin(q2 + q3 + q4 + q5) - (d5*dc6*dq4*m6*sin(q2 + q3 + q4 + q5))/2 + d5*dq1*l2*m6*cos(q3 + q4) + dc5*dq1*l2*m5*cos(q3 + q4) - (dc6*dq1*l3*m6*cos(q4 + q5))/2 + (dc6*dq1*l3*m6*cos(2*q2 + 2*q3 + q4 - q5))/2 - d5*dc6*dq1*m6*sin(2*q2 + 2*q3 + 2*q4 + q5) + d5*dq1*l3*m6*cos(q4) + d5*dq1*l3*m6*cos(2*q2 + 2*q3 + q4) + dc5*dq1*l3*m5*cos(q4) + dc5*dq1*l3*m5*cos(2*q2 + 2*q3 + q4) - (dc6*dq1*l2*m6*cos(2*q2 + q3 + q4 + q5))/2 - d4*dc6*dq2*m6*sin(q2 + q3 + q4 - q5) - d4*dc6*dq3*m6*sin(q2 + q3 + q4 - q5) - d5*dc6*dq2*m6*sin(q2 + q3 + q4 - q5) - (d4*dc6*dq4*m6*sin(q2 + q3 + q4 - q5))/2 - d5*dc6*dq3*m6*sin(q2 + q3 + q4 - q5) - (d5*dc6*dq4*m6*sin(q2 + q3 + q4 - q5))/2;
            C(1,5) = (dc6*m6*(4*d4*dq2*sin(q2 + q3 + q4 - q5) - 2*dq1*l2*cos(2*q2 + q3 + q4 + q5) - 8*d4*dq1*sin(q5) + 4*d4*dq3*sin(q2 + q3 + q4 - q5) + 4*d4*dq4*sin(q2 + q3 + q4 - q5) - 2*d4*dq5*sin(q2 + q3 + q4 - q5) + 2*d5*dq5*sin(q2 + q3 + q4 - q5) + 2*dc6*dq2*sin(q2 + q3 + q4 - 2*q5) + 2*dc6*dq2*sin(q2 + q3 + q4 + 2*q5) + 2*dc6*dq3*sin(q2 + q3 + q4 - 2*q5) + 2*dc6*dq3*sin(q2 + q3 + q4 + 2*q5) + 2*dc6*dq4*sin(q2 + q3 + q4 - 2*q5) + 2*dc6*dq4*sin(q2 + q3 + q4 + 2*q5) - 2*dq1*l3*cos(q4 - q5) + 2*dq5*l2*cos(q2 - q5) - 2*d5*dq1*sin(2*q2 + 2*q3 + 2*q4 - q5) - dc6*dq1*sin(2*q2 + 2*q3 + 2*q4 - 2*q5) + dc6*dq1*sin(2*q2 + 2*q3 + 2*q4 + 2*q5) - 2*dq1*l2*cos(q3 + q4 + q5) + 2*dq5*l3*cos(q2 + q3 + q5) + 4*dc6*dq2*sin(q2 + q3 + q4) + 4*dc6*dq3*sin(q2 + q3 + q4) + 4*dc6*dq4*sin(q2 + q3 + q4) - 2*dc6*dq1*sin(2*q5) - 2*dq1*l2*cos(2*q2 + q3 + q4 - q5) - 2*dq1*l3*cos(2*q2 + 2*q3 + q4 + q5) - 2*dq1*l2*cos(q3 + q4 - q5) + 2*dq5*l3*cos(q2 + q3 - q5) + 4*d4*dq2*sin(q2 + q3 + q4 + q5) + 4*d4*dq3*sin(q2 + q3 + q4 + q5) + 4*d4*dq4*sin(q2 + q3 + q4 + q5) + 2*d4*dq5*sin(q2 + q3 + q4 + q5) + 2*d5*dq5*sin(q2 + q3 + q4 + q5) - 2*dq1*l3*cos(q4 + q5) + 2*dq5*l2*cos(q2 + q5) - 2*dq1*l3*cos(2*q2 + 2*q3 + q4 - q5) - 2*d5*dq1*sin(2*q2 + 2*q3 + 2*q4 + q5)))/4;
            C(1,6) = 0;
            
            C(2,1) = (dc6^2*dq1*m6*sin(2*q2 + 2*q3 + 2*q4))/4 - (dc6^2*dq1*m6*sin(2*q2 + 2*q3 + 2*q4 + 2*q5))/8 - (d5^2*dq1*m6*sin(2*q2 + 2*q3 + 2*q4))/2 - (dc5^2*dq1*m5*sin(2*q2 + 2*q3 + 2*q4))/2 - (dc6^2*dq1*m6*sin(2*q2 + 2*q3 + 2*q4 - 2*q5))/8 + (dq1*l2^2*m3*sin(2*q2))/2 + (dq1*l2^2*m4*sin(2*q2))/2 + (dq1*l2^2*m5*sin(2*q2))/2 + (dq1*l2^2*m6*sin(2*q2))/2 + (dq1*lc2^2*m2*sin(2*q2))/2 + (dq1*l3^2*m4*sin(2*q2 + 2*q3))/2 + (dq1*l3^2*m5*sin(2*q2 + 2*q3))/2 + (dq1*l3^2*m6*sin(2*q2 + 2*q3))/2 + (dq1*lc3^2*m3*sin(2*q2 + 2*q3))/2 - (d5*dc6*dq1*m6*sin(2*q2 + 2*q3 + 2*q4 - q5))/2 + dq1*l2*l3*m4*sin(2*q2 + q3) + dq1*l2*l3*m5*sin(2*q2 + q3) + dq1*l2*l3*m6*sin(2*q2 + q3) + dq1*l2*lc3*m3*sin(2*q2 + q3) - (dc6*dq1*l2*m6*cos(2*q2 + q3 + q4 - q5))/2 + (dc6*dq1*l3*m6*cos(2*q2 + 2*q3 + q4 + q5))/2 - d5*dq1*l2*m6*cos(2*q2 + q3 + q4) - dc5*dq1*l2*m5*cos(2*q2 + q3 + q4) - (dc6*dq1*l3*m6*cos(2*q2 + 2*q3 + q4 - q5))/2 + (d5*dc6*dq1*m6*sin(2*q2 + 2*q3 + 2*q4 + q5))/2 - d5*dq1*l3*m6*cos(2*q2 + 2*q3 + q4) - dc5*dq1*l3*m5*cos(2*q2 + 2*q3 + q4) + (dc6*dq1*l2*m6*cos(2*q2 + q3 + q4 + q5))/2;
            C(2,2) = 0;
            C(2,3) = -l2*(2*dq2 + dq3)*(l3*m4*sin(q3) + l3*m5*sin(q3) + l3*m6*sin(q3) + lc3*m3*sin(q3) - d5*m6*cos(q3 + q4) - dc5*m5*cos(q3 + q4) - dc6*m6*cos(q3)*sin(q4)*sin(q5) - dc6*m6*cos(q4)*sin(q3)*sin(q5));
            C(2,4) = (dc6*dq4*l3*m6*cos(q4 - q5))/2 + 2*d5*dq2*l2*m6*cos(q3 + q4) + 2*d5*dq3*l2*m6*cos(q3 + q4) + d5*dq4*l2*m6*cos(q3 + q4) + 2*dc5*dq2*l2*m5*cos(q3 + q4) + 2*dc5*dq3*l2*m5*cos(q3 + q4) + dc5*dq4*l2*m5*cos(q3 + q4) - (dc6*dq4*l3*m6*cos(q4 + q5))/2 + 2*d5*dq2*l3*m6*cos(q4) + 2*d5*dq3*l3*m6*cos(q4) + d5*dq4*l3*m6*cos(q4) + 2*dc5*dq2*l3*m5*cos(q4) + 2*dc5*dq3*l3*m5*cos(q4) + dc5*dq4*l3*m5*cos(q4) + 2*dc6*dq2*l3*m6*sin(q4)*sin(q5) + 2*dc6*dq3*l3*m6*sin(q4)*sin(q5) + 2*dc6*dq2*l2*m6*cos(q3)*sin(q4)*sin(q5) + 2*dc6*dq2*l2*m6*cos(q4)*sin(q3)*sin(q5) + 2*dc6*dq3*l2*m6*cos(q3)*sin(q4)*sin(q5) + 2*dc6*dq3*l2*m6*cos(q4)*sin(q3)*sin(q5) + dc6*dq4*l2*m6*cos(q3)*sin(q4)*sin(q5) + dc6*dq4*l2*m6*cos(q4)*sin(q3)*sin(q5);
            C(2,5) = -(dc6*m6*(2*dq2*l3*cos(q4 - q5) - 2*d5*dq1*sin(q2 + q3 + q4 - q5) - dc6*dq1*sin(q2 + q3 + q4 - 2*q5) - dc6*dq1*sin(q2 + q3 + q4 + 2*q5) - 2*dq1*l2*cos(q2 - q5) - 2*d5*dq5*sin(q5) + 2*dq3*l3*cos(q4 - q5) + 2*dq4*l3*cos(q4 - q5) - dq5*l3*cos(q4 - q5) + 2*dq1*l3*cos(q2 + q3 + q5) + 2*dq2*l2*cos(q3 + q4 + q5) + 2*dq3*l2*cos(q3 + q4 + q5) + 2*dq4*l2*cos(q3 + q4 + q5) + dq5*l2*cos(q3 + q4 + q5) + 2*dc6*dq1*sin(q2 + q3 + q4) - 2*dc6*dq2*sin(2*q5) - 2*dc6*dq3*sin(2*q5) - 2*dc6*dq4*sin(2*q5) - 2*dq1*l3*cos(q2 + q3 - q5) + 2*dq2*l2*cos(q3 + q4 - q5) + 2*dq3*l2*cos(q3 + q4 - q5) + 2*dq4*l2*cos(q3 + q4 - q5) - dq5*l2*cos(q3 + q4 - q5) + 2*d5*dq1*sin(q2 + q3 + q4 + q5) + 2*dq1*l2*cos(q2 + q5) + 2*dq2*l3*cos(q4 + q5) + 2*dq3*l3*cos(q4 + q5) + 2*dq4*l3*cos(q4 + q5) + dq5*l3*cos(q4 + q5)))/2;
            C(2,6) = 0;
            
            C(3,1) = (dc6^2*dq1*m6*sin(2*q2 + 2*q3 + 2*q4))/4 - (dc6^2*dq1*m6*sin(2*q2 + 2*q3 + 2*q4 + 2*q5))/8 - (d5^2*dq1*m6*sin(2*q2 + 2*q3 + 2*q4))/2 - (dc5^2*dq1*m5*sin(2*q2 + 2*q3 + 2*q4))/2 - (dc6^2*dq1*m6*sin(2*q2 + 2*q3 + 2*q4 - 2*q5))/8 + (dq1*l3^2*m4*sin(2*q2 + 2*q3))/2 + (dq1*l3^2*m5*sin(2*q2 + 2*q3))/2 + (dq1*l3^2*m6*sin(2*q2 + 2*q3))/2 + (dq1*lc3^2*m3*sin(2*q2 + 2*q3))/2 - (d5*dc6*dq1*m6*sin(2*q2 + 2*q3 + 2*q4 - q5))/2 + (dc6*dq1*l2*m6*cos(q3 + q4 + q5))/4 + (dq1*l2*l3*m4*sin(2*q2 + q3))/2 + (dq1*l2*l3*m5*sin(2*q2 + q3))/2 + (dq1*l2*l3*m6*sin(2*q2 + q3))/2 + (dq1*l2*lc3*m3*sin(2*q2 + q3))/2 - (dc6*dq1*l2*m6*cos(2*q2 + q3 + q4 - q5))/4 + (dc6*dq1*l3*m6*cos(2*q2 + 2*q3 + q4 + q5))/2 - (d5*dq1*l2*m6*cos(2*q2 + q3 + q4))/2 - (dc5*dq1*l2*m5*cos(2*q2 + q3 + q4))/2 - (dc6*dq1*l2*m6*cos(q3 + q4 - q5))/4 - (d5*dq1*l2*m6*cos(q3 + q4))/2 - (dc5*dq1*l2*m5*cos(q3 + q4))/2 - (dc6*dq1*l3*m6*cos(2*q2 + 2*q3 + q4 - q5))/2 + (d5*dc6*dq1*m6*sin(2*q2 + 2*q3 + 2*q4 + q5))/2 - d5*dq1*l3*m6*cos(2*q2 + 2*q3 + q4) - dc5*dq1*l3*m5*cos(2*q2 + 2*q3 + q4) + (dc6*dq1*l2*m6*cos(2*q2 + q3 + q4 + q5))/4 + (dq1*l2*l3*m4*sin(q3))/2 + (dq1*l2*l3*m5*sin(q3))/2 + (dq1*l2*l3*m6*sin(q3))/2 + (dq1*l2*lc3*m3*sin(q3))/2;
            C(3,2) = dq2*l2*(l3*m4*sin(q3) + l3*m5*sin(q3) + l3*m6*sin(q3) + lc3*m3*sin(q3) - d5*m6*cos(q3 + q4) - dc5*m5*cos(q3 + q4) - dc6*m6*cos(q3)*sin(q4)*sin(q5) - dc6*m6*cos(q4)*sin(q3)*sin(q5));
            C(3,3) = 0;
            C(3,4) = l3*(2*dq2 + 2*dq3 + dq4)*(d5*m6*cos(q4) + dc5*m5*cos(q4) + dc6*m6*sin(q4)*sin(q5));
            C(3,5) = -dc6*m6*(dq2*l3*cos(q4 - q5) - d5*dq1*sin(q2 + q3 + q4 - q5) - (dc6*dq1*sin(q2 + q3 + q4 - 2*q5))/2 - (dc6*dq1*sin(q2 + q3 + q4 + 2*q5))/2 - d5*dq5*sin(q5) + dq3*l3*cos(q4 - q5) + dq4*l3*cos(q4 - q5) - (dq5*l3*cos(q4 - q5))/2 + dq1*l3*cos(q2 + q3 + q5) + dc6*dq1*sin(q2 + q3 + q4) - dc6*dq2*sin(2*q5) - dc6*dq3*sin(2*q5) - dc6*dq4*sin(2*q5) - dq1*l3*cos(q2 + q3 - q5) + d5*dq1*sin(q2 + q3 + q4 + q5) + dq2*l3*cos(q4 + q5) + dq3*l3*cos(q4 + q5) + dq4*l3*cos(q4 + q5) + (dq5*l3*cos(q4 + q5))/2);
            C(3,6) = 0;
            
            C(4,1) = (dc6^2*dq1*m6*sin(2*q2 + 2*q3 + 2*q4))/4 - (dc6^2*dq1*m6*sin(2*q2 + 2*q3 + 2*q4 + 2*q5))/8 - (d5^2*dq1*m6*sin(2*q2 + 2*q3 + 2*q4))/2 - (dc5^2*dq1*m5*sin(2*q2 + 2*q3 + 2*q4))/2 - (dc6^2*dq1*m6*sin(2*q2 + 2*q3 + 2*q4 - 2*q5))/8 - (dc6*dq1*l3*m6*cos(q4 - q5))/4 - (d5*dc6*dq1*m6*sin(2*q2 + 2*q3 + 2*q4 - q5))/2 + (dc6*dq1*l2*m6*cos(q3 + q4 + q5))/4 - (dc6*dq1*l2*m6*cos(2*q2 + q3 + q4 - q5))/4 + (dc6*dq1*l3*m6*cos(2*q2 + 2*q3 + q4 + q5))/4 - (d5*dq1*l2*m6*cos(2*q2 + q3 + q4))/2 - (dc5*dq1*l2*m5*cos(2*q2 + q3 + q4))/2 - (dc6*dq1*l2*m6*cos(q3 + q4 - q5))/4 - (d5*dq1*l2*m6*cos(q3 + q4))/2 - (dc5*dq1*l2*m5*cos(q3 + q4))/2 + (dc6*dq1*l3*m6*cos(q4 + q5))/4 - (dc6*dq1*l3*m6*cos(2*q2 + 2*q3 + q4 - q5))/4 + (d5*dc6*dq1*m6*sin(2*q2 + 2*q3 + 2*q4 + q5))/2 - (d5*dq1*l3*m6*cos(q4))/2 - (d5*dq1*l3*m6*cos(2*q2 + 2*q3 + q4))/2 - (dc5*dq1*l3*m5*cos(q4))/2 - (dc5*dq1*l3*m5*cos(2*q2 + 2*q3 + q4))/2 + (dc6*dq1*l2*m6*cos(2*q2 + q3 + q4 + q5))/4;
            C(4,2) = - dq2*(l2*cos(q3 + q4) + l3*cos(q4))*(d5*m6 + dc5*m5) - dc6*dq2*l3*m6*sin(q4)*sin(q5) - dc6*dq2*l2*m6*cos(q3)*sin(q4)*sin(q5) - dc6*dq2*l2*m6*cos(q4)*sin(q3)*sin(q5);
            C(4,3) = -l3*(2*dq2 + dq3)*(d5*m6*cos(q4) + dc5*m5*cos(q4) + dc6*m6*sin(q4)*sin(q5));
            C(4,4) = 0;
            C(4,5) = (dc6*m6*(2*d5*dq5*sin(q5) + 2*d5*dq1*sin(q2 + q3 + q4 - q5) + dc6*dq1*sin(q2 + q3 + q4 - 2*q5) + dc6*dq1*sin(q2 + q3 + q4 + 2*q5) - 2*dc6*dq1*sin(q2 + q3 + q4) + 2*dc6*dq2*sin(2*q5) + 2*dc6*dq3*sin(2*q5) + 2*dc6*dq4*sin(2*q5) - 2*d5*dq1*sin(q2 + q3 + q4 + q5)))/2;
            C(4,6) = 0;
            
            C(5,1) = (dc6*dq1*m6*(2*dc6*sin(2*q5) + 2*l2*cos(2*q2 + q3 + q4 - q5) + 2*l3*cos(2*q2 + 2*q3 + q4 + q5) + 2*l2*cos(q3 + q4 - q5) + 2*l3*cos(q4 + q5) + 2*l3*cos(2*q2 + 2*q3 + q4 - q5) + 2*d5*sin(2*q2 + 2*q3 + 2*q4 + q5) + 8*d4*sin(q5) + 2*l2*cos(2*q2 + q3 + q4 + q5) + 2*l3*cos(q4 - q5) + 2*d5*sin(2*q2 + 2*q3 + 2*q4 - q5) + dc6*sin(2*q2 + 2*q3 + 2*q4 - 2*q5) - dc6*sin(2*q2 + 2*q3 + 2*q4 + 2*q5) + 2*l2*cos(q3 + q4 + q5)))/8;
            C(5,2) = (dc6*m6*(dq2*l3*cos(q4 - q5) - dc6*dq1*sin(q2 + q3 + q4 - 2*q5) - dc6*dq1*sin(q2 + q3 + q4 + 2*q5) - 2*dq1*l2*cos(q2 - q5) - 2*d5*dq1*sin(q2 + q3 + q4 - q5) + 2*dq1*l3*cos(q2 + q3 + q5) + dq2*l2*cos(q3 + q4 + q5) + 2*dc6*dq1*sin(q2 + q3 + q4) - dc6*dq2*sin(2*q5) - 2*dq1*l3*cos(q2 + q3 - q5) + dq2*l2*cos(q3 + q4 - q5) + 2*d5*dq1*sin(q2 + q3 + q4 + q5) + 2*dq1*l2*cos(q2 + q5) + dq2*l3*cos(q4 + q5)))/2;
            C(5,3) = (dc6*m6*(2*dq2*l3*cos(q4 - q5) - dc6*dq1*sin(q2 + q3 + q4 - 2*q5) - dc6*dq1*sin(q2 + q3 + q4 + 2*q5) - 2*d5*dq1*sin(q2 + q3 + q4 - q5) + dq3*l3*cos(q4 - q5) + 2*dq1*l3*cos(q2 + q3 + q5) + 2*dc6*dq1*sin(q2 + q3 + q4) - 2*dc6*dq2*sin(2*q5) - dc6*dq3*sin(2*q5) - 2*dq1*l3*cos(q2 + q3 - q5) + 2*d5*dq1*sin(q2 + q3 + q4 + q5) + 2*dq2*l3*cos(q4 + q5) + dq3*l3*cos(q4 + q5)))/2;
            C(5,4) = -(dc6*m6*(2*d5*dq1*sin(q2 + q3 + q4 - q5) + dc6*dq1*sin(q2 + q3 + q4 - 2*q5) + dc6*dq1*sin(q2 + q3 + q4 + 2*q5) - 2*dc6*dq1*sin(q2 + q3 + q4) + 2*dc6*dq2*sin(2*q5) + 2*dc6*dq3*sin(2*q5) + dc6*dq4*sin(2*q5) - 2*d5*dq1*sin(q2 + q3 + q4 + q5)))/2;
            C(5,5) = 0;
            C(5,6) = 0;
            
            C(6,1) = 0;
            C(6,2) = 0;
            C(6,3) = 0;
            C(6,4) = 0;
            C(6,5) = 0;
            C(6,6) = 0;
            
            
            
            % Matriz de Gravedad G: 
            G = zeros(6,1);
            
            G(1,1) = 0;
            
            G(2,1) = l2*m3*cos(q2) + l2*m4*cos(q2) + l2*m5*cos(q2) + l2*m6*cos(q2) + lc2*m2*cos(q2) + (dc6*m6*sin(q2 + q3 + q4 - q5))/2 + d5*m6*sin(q2 + q3 + q4) + dc5*m5*sin(q2 + q3 + q4) - (dc6*m6*sin(q2 + q3 + q4 + q5))/2 + l3*m4*cos(q2 + q3) + l3*m5*cos(q2 + q3) + l3*m6*cos(q2 + q3) + lc3*m3*cos(q2 + q3);
            
            G(3,1) = (dc6*m6*sin(q2 + q3 + q4 - q5))/2 + d5*m6*sin(q2 + q3 + q4) + dc5*m5*sin(q2 + q3 + q4) - (dc6*m6*sin(q2 + q3 + q4 + q5))/2 + l3*m4*cos(q2 + q3) + l3*m5*cos(q2 + q3) + l3*m6*cos(q2 + q3) + lc3*m3*cos(q2 + q3);
            
            G(4,1) = (dc6*m6*sin(q2 + q3 + q4 - q5))/2 + d5*m6*sin(q2 + q3 + q4) + dc5*m5*sin(q2 + q3 + q4) - (dc6*m6*sin(q2 + q3 + q4 + q5))/2;
            
            G(5,1) = -(dc6*m6*(sin(q2 + q3 + q4 + q5) + sin(q2 + q3 + q4 - q5)))/2;
            
            G(6,1) = 0;
            
            robot_din = struct('D',D,'C',C,'G',G,'g',9.81);
        end
    end
end