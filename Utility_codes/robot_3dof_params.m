function robot_3dof = robot_3dof_params()

    d1  = 0.14;
    d = [d1,0,0];
    dc = zeros(1,3);
    
    l2  = 0.2;
    l3  = 0.3;
    l = [0,l2,l3];
    
    lc2 = 0.1;
    lc3 = 0.2;
    lc = [0,lc2,lc3];

    % yc = zeros(3,1);
    
    DH = [0    pi/2 d(1) 0;
          l(2)    0    0 0;
          l(3)    0    0 0];

    m1 = 0.73;
    m2 = 0.85;
    m3 = 0.51;
    m = [m1,m2,m3];
    
    Iz1 = 0.0015;
    Iy2 = 0.0054;
    Iz2 = 0.0013;
    Iy3 = 0.0031;
    Iz3 = 0.0032;
    
    I = [0  ,0  ,Iz1;
         0  ,Iy2,Iz2;
         0  ,Iy3,Iz3];

    robot_3dof = robot_model(3,l,lc,d,dc,DH,m,I);
end