function pc = Circle_coords(p1,p2,rc,tol)
    syms x1 x2 y1 y2 h k r
    
    kc = zeros(2,2);
    hc = zeros(2,2);
    pc = zeros(4,2);
    
    
    
    c1 = (x1-h)^2 + (y1-k)^2 - r^2;
    c2 = (x2-h)^2 + (y2-k)^2 - r^2;
    
    hsol = solve(c1,h);
    
    ii = 1;
    for i = 1:size(hsol,1)
        c2h = subs(c2,h,hsol(i));
        ksol = solve(c2h,k);
        for j = 1:size(kc,1)
            kc(i,j) = double(subs(ksol(j),[x1,y1,x2,y2,r],[p1(1),p1(2),p2(1),p2(2),rc]));
            hc(i,j) = double(subs(hsol(i),[x1,y1,r,k],[p1(1),p1(2),rc,kc(j)]));
            pc(ii,:) = [hc(i,j),kc(i,j)];
            if norm(pc(ii,:)-p1) - rc > tol || norm(pc(ii,:)-p2) - rc > tol
                pc(ii,:) = [];
            else
                ii = ii + 1;
            end
        end
    end
end
