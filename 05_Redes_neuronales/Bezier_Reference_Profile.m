function [XD, dXD, ddXD] = Bezier_Reference_Profile(t, T1, T2, Y1, Y2)

if t < T1
    XD = Y1;
   dXD = 0;
  ddXD = 0;
  
elseif t > T2
    XD = Y2;
   dXD = 0;
  ddXD = 0;
  
else
    r = [252, 1050, 1800, 1575, 700, 126];
   d1 = (t - T1)/(T2 - T1);
   d2 = 1/(T2 - T1);
   
Phi_0 = d1^5*(r(1) - r(2)*d1 + r(3)*d1^2 - r(4)*d1^3 + r(5)*d1^4 - r(6)*d1^5);
Phi_1 = d1^4*d2*(5*r(1) - 6*r(2)*d1 + 7*r(3)*d1^2 - 8*r(4)*d1^3 + 9*r(5)*d1^4 - 10*r(6)*d1^5);
Phi_2 = d1^3*d2^2*(20*r(1) - 30*r(2)*d1 + 42*r(3)*d1^2 - 56*r(4)*d1^3 + 72*r(5)*d1^4 - 90*r(6)*d1^5);

    XD = Y1 + (Y2 - Y1)*Phi_0;
   dXD = (Y2 - Y1)*Phi_1;
  ddXD = (Y2 - Y1)*Phi_2;
    
end