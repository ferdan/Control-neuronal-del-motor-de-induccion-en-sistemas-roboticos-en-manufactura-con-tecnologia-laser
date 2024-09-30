classdef transforms
    methods (Static)
        function BP = Clarke_transform(opt_power_invariant)
            if opt_power_invariant == 0
                BP = 2/3*[1,-1/2,-1/2;
                          0,sqrt(3)/2,-sqrt(3)/2;
                          1/2,1/2,1/2];
            else
                % Power invariant
                BP = sqrt(2/3)*[1,-1/2,-1/2;
                                0,sqrt(3)/2,-sqrt(3)/2;
                                1/sqrt(2),1/sqrt(2),1/sqrt(2)];
            end
        end
        function [mag,angle] = Polar_transform(u)
            u1 = u(1);
            u2 = u(2);

            mag = sqrt(u1^2+u2^2);
            angle = atan2(u2,u1);
        end
        function [u_a,u_b] = Polar_inverse_transform(u)
            u1 = u(1);
            u2 = u(2);

            u_a = cos(rho)*u1 - sin(rho)*u2;
            u_b = sin(rho)*u1 + cos(rho)*u2;
        end
    end
end