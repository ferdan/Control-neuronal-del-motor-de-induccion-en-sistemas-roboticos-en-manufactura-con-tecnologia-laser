% q0 = 0;
% q1 = 10;
% 
% v0 = 0;
% v1 = 0;
% 
% vmax = 5;
% amax = 10;
% jmax = 30;
% smax = 500;

q0 = 0;
q1 = 20;

v0 = 0;
v1 = 0;

vmax = 5;
amax = 2.5;
smax = 100;

jmax = sqrt(amax*smax);

num_steps = 15*100;


pol15segs1 = pol15segs(q0,q1,v0,v1,vmax,amax,jmax,smax,num_steps);

[jcheck,acheck,vcheck] = pol15segs.checktimes(pol15segs1.params);


if jcheck == 1 && acheck == 1 && vcheck == 1
    [q,d1q,d2q,d3q,d4q] = pol15segs.interpol_pol15segs(pol15segs1.params);
    pol15segs.plot_pol15segs(1,pol15segs1.params,q,d1q,d2q,d3q,d4q);
else 
    disp("Trajectory has not reached max values");
    if jcheck == 0
        disp("jmax has not been reached ")
    end
    if acheck == 0
        disp("amax has not been reached ")
    end
    if vcheck == 0
        disp("vmax has not been reached ")
    end
    return
end



