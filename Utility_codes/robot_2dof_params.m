function robot_2dof = robot_2dof_params()

    l(1) = 0.45;
    l(2) = 0.45;

    lc(1) = 0.091;
    lc(2) = 0.048;

    d = zeros(2,1);
    dc = zeros(2,1);

    % yc = zeros(2,1);

    DH = [l(1) 0 0 0;
          l(2) 0 0 0];

    m(1) = 23.903;
    m(2) = 3.880;

    I1 = 1.266;
    I2 = 0.093;

    I = [I1,0;
         0,I2];

    robot_2dof = robot_model(2,l,lc,d,dc,DH,m,I);
end