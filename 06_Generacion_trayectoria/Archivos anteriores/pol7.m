function [qpol,vpol,apol,jpol] = pol7(t,q0,q1,t0,t1)
    %Trayectoria de referencia
    
    % q0 = 0;
    % q1 = 1;
    
    v0 = 0;
    v1 = 0;
    
    ac0 = 0;
    ac1 = 0;
    
    j0 = 0;
    j1 = 0;
    
    % t0 = t1;
    % t1 = ;
    
    % Coeficientes de un polinomio de 7mo grado
    
    h = q1 - q0;
    T = t1 - t0;
    
    a = zeros(7+1,1);
    
    a(1) = q0;
    a(2) = v0;
    a(3) = ac0/2;
    a(4) = j0/6;
    a(5) = (210*h-T*((30*ac0-15*ac1)*T+(4*j0+j1)*T^2+120*v0+90*v1))/(6*T^4);
    a(6) = (-168*h-T*((20*ac0-14*ac1)*T+(2*j0+j1)*T^2+90*v0+78*v1))/(2*T^5);
    a(7) = (420*h-T*((45*ac0-39*ac1)*T+(4*j0+3*j1)*T^2+216*v0+204*v1))/(6*T^6);
    a(8) = (-120*h-T*((12*ac0-12*ac1)*T+(j0+j1)*T^2+60*v0+60*v1))/(6*T^7);
    
    qa = flip(a')';
    va = polyder(qa')';
    aa = polyder(va')';
    ja = polyder(aa')';
    

    t_interval = (t-t0).*double(t>=t0).*double(t<t1) + (t1-t0).*double(t>=t1);
    
    qpol = polyval(qa,t_interval);
    vpol = polyval(va,t_interval);
    apol = polyval(aa,t_interval);
    jpol = polyval(ja,t_interval);
end