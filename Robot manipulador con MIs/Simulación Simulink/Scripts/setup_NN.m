function NN = setup_NN(ndof)

    % Conjuntos de parametros [Wc,Zc,Pc]
    % Observaciones de la sintonizacion del controlador
    % Wc = Alcanzar la referencia. Entre mas alto, mejor -> menor error,
    %      pero puede volverse inestable. 
    % Zc = Amortiguamiento. Que tan subamortiguada es la respuesta. Varia
    %      en relacion inversa a Wc. Entre menor valor, menor -> menos
    %      sobretiro, a expensas de que oscile. 
    % Pc = También amortiguamiento?. Tiene que ser un valor grande para compensar Zc, en caso de
    %      que empiece a oscilar. Pero entre mas paqueño se observa un
    %      mejor desempeño. 

    % [122.222,1,5] % para 2 dof

    % [266.666,0.875,0.125] 
    % [305.555,2.5,0.5]
    % [400,1.875,0.625]

    % [122.222,5,2.5]
    % [133.333,0.625,1.25]
    % [152.777,5,2.5]
    % [166.666,1.25,0.625]
    % [166.666,1.875,0.625]
    % [166.666,0.9375,0.3125]
    % [200,1.25,0.3125]
    % [200,0.9375,0.25]
    % [233.333,1.25,0.625]
    % [233.333,0.9375,0.1875]
    % [183.333,3.75,2.5]
    % [275,3.75,2.5]
    % [300,0.875,0.1875]

    % RMA sin MI
    % 2dof: initial weights: 450,5,2.5
    % 3dof: initial weights: 600,12.5,5
    % 6dof: initial weights: 450,7,1.5

    % RMA con MI
    % 6dof: initial weights: 450,7,1.5

    deltaWc = 1e-5*ones(ndof,1);
    weightWc = 180*ones(ndof,1);%[50;50;50;50;50;50];%*ones(ndof,1);
    lambdaWc = [-4;-2;0;4].*ones(4,ndof);
    
    
    deltaZc = 1e-3*ones(ndof,1);
    weightZc = 20*ones(ndof,1);%[50;50;50;50;50;15];%*ones(ndof,1);
    lambdaZc = [-1;1;3;5].*ones(4,ndof);
    
    
    deltaPc = 1e-3*ones(ndof,1);
    weightPc = 40*ones(ndof,1);%[50;50;50;50;50;10];%*ones(ndof,1);
    lambdaPc = [-1;1;3;5].*ones(4,ndof);

    % 3dof
    % deltaWc = [1e-5;1e-5;1e-5];
    % weightWc = [500;
    %             400;
    %             400]; %[200;150];
    % lambdaWc = [-5,-4,-4;
    %             -2,-2,-2;
    %              1, 0, 0;
    %              2, 4, 4];
    % 
    % 
    % deltaZc = [1e-3;1e-3;1e-3;1e-3;1e-3;1e-3];
    % weightZc = [5;
    %             7;
    %             7];
    % lambdaZc = [-4,-1,-1;
    %             -2, 1, 1;
    %              0, 3, 3;
    %              2, 5, 5];
    % 
    % 
    % deltaPc = [1e-3;1e-3;1e-3];
    % weightPc = [1;
    %             1;
    %             1];
    % lambdaPc = [-4,-1,-1;
    %             -2, 1, 1;
    %              0, 3, 3;
    %              2, 5, 5];

    % 2dof
    % deltaWc = [1e-5;1e-5];
    % weightWc = [200,0;
    %             300,0]; %[200;150];
    % lambdaWc = [-5,-4;
    %             -2,-2;
    %              1, 0;
    %              2, 4];
    % 
    % 
    % deltaZc = [1e-3;1e-3];
    % weightZc = [2,0;
    %             4,0];
    % lambdaZc = [-4,-1;
    %             -2, 1;
    %              0, 3;
    %              2, 5];
    % 
    % 
    % deltaPc = [1e-3;1e-3];
    % weightPc = [10,0;
    %             7.5,0];
    % lambdaPc = [-4,-1;
    %             -2, 1;
    %              0, 3;
    %              2, 5];
    
    
    delta.deltaWc = deltaWc(1:ndof,1);
    delta.deltaZc = deltaZc(1:ndof,1);
    delta.deltaPc = deltaPc(1:ndof,1);
    
    weights.weightWc = weightWc(1:ndof,:);
    weights.weightZc = weightZc(1:ndof,:);
    weights.weightPc = weightPc(1:ndof,:);
    
    lambda.lambdaWc = lambdaWc(:,1:ndof);
    lambda.lambdaZc = lambdaZc(:,1:ndof);
    lambda.lambdaPc = lambdaPc(:,1:ndof);
    
    
    NN = NN_Bslipne(delta,weights,lambda);
end
