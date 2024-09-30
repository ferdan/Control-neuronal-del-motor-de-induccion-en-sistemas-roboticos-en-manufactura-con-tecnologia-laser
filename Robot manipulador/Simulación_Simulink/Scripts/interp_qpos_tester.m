q_eq = [0;-pi/2;0];
q_cero = [0;0.4575;-1.2023];
q_tr_init = [0;0.4575;-1.2023];

t0 = 1;
t1 = 10;
t_trtr = pi/4;
tr_muestra = 1;
ndof = 3;

t = 0:0.1:10;
q = zeros(size(t,2),ndof);

for i = 1:size(t,2)
    if t(i) == t0/2 + t1/2
        q;
    elseif t(i) == t1
        q;
    end
    q(i,:) = interp_qpos(t(i),q_eq,q_cero,q_tr_init,t0,t1,t_trtr,tr_muestra,ndof);
    if max(isnan(q(1,:))) == 1
        q;
    end
end

plot(t,q(:,2))
plot(t(1:end-2),diff(diff(q(:,2))))