function NN = setup_BSpline_nets(ndof)

    % Conjuntos de parametros [Wc,Zc,Pc]
    % Observaciones de la sintonizacion del controlador
    % Wc = Alcanzar la referencia. Entre mas alto, mejor -> menor error,
    %      pero puede volverse inestable. 
    % Zc = Amortiguamiento. Que tan subamortiguada es la respuesta. Varia
    %      en relacion inversa a Wc. Entre menor valor, menor -> menos
    %      sobretiro, a expensas de que oscile. 
    % Pc = Tambien alcanza referencia junto con Wc. 

    % sizes of variables --------------------------------------------------
    % lambda (num_outputs x num_bsplcoefs x num_inputs x dim_inputs)
    % specify a num_inputs-by-num_bsplcoefs vector
    % Ej. For a Cubic BSpline (4 coefs), inputs = [e_q,e_px,e_py]:
    % Specify 3-by-4 vector

    % weights (num_outputs x num_inputs x dim_inputs)
    % specify 1-by-(num_outputs x num_inputs x dim_inputs) vector
    % Ej. For GPI(Wn,Zn,Pc), inputs=[e_q,e_px,e_py], 6dof-robot: 
    % specify 1-by-(3x3x6) = 1-by-64 vector

    % nn_inputs (dim_inputs x num_inputs)
    % specify num_inputs = 1 for e_q, 3 for [e_q,e_px,e_py] or 4 for [e_q,e_px,e_py,e_pz]
    % specify dim_inputs = ndof


    if ndof == 2
        [num_inputs,dim_inputs,delta,weights,lambda] = BSplineparams2dof(ndof);
    elseif ndof == 3
        [num_inputs,dim_inputs,delta,weights,lambda] = BSplineparams3dof(ndof);
    elseif ndof == 6
        [num_inputs,dim_inputs,delta,weights,lambda] = BSplineparams6dof(ndof);
    end

    % 2dof: initial weights: 450,5,2.5
    % 3dof: initial weights: 600,12.5,5
    % 6dof: initial weights: 450,7,1.5
    
    NN = NN_Bspline(num_inputs,dim_inputs,delta,weights,lambda);
end

function [num_inputs,dim_inputs,delta,weights,lambda] = BSplineparams6dof(ndof)
    num_inputs = 4; % 1 = e_q, 3 = [e_q,e_px,e_py], 4 = [e_q,e_px,e_py,e_pz]
    dim_inputs = ndof;

    deltaWc = 1e-3;
    weightsWc = 30*ones(1,num_inputs*ndof);
    lambdaWc = ones(num_inputs,1)*[-4,-2,0,4];
    
    
    deltaZc = 1e-3;
    weightsZc = 0.5*ones(1,num_inputs*ndof);
    lambdaZc = ones(num_inputs,1)*[-1,1,3,5];
    
   
    deltaPc = 1e-3;
    weightsPc = 0.05*ones(1,num_inputs*ndof);
    lambdaPc = ones(num_inputs,1)*[-1,1,3,5];

    % 6dof: initial weights: 450,7,1.5

    [delta,weights,lambda] = packdata(deltaWc,weightsWc,lambdaWc,...
                                      deltaZc,weightsZc,lambdaZc,...
                                      deltaPc,weightsPc,lambdaPc,...
                                           num_inputs,ndof);
end

function [num_inputs,dim_inputs,delta,weights,lambda] = BSplineparams3dof(ndof)

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

    num_inputs = 4; % 1 = e_q, 3 = [e_q,e_px,e_py], 4 = [e_q,e_px,e_py,e_pz]
    dim_inputs = ndof;

    deltaWc = 1e-5;
    weightsWc = 30*ones(1,num_inputs*ndof);
    lambdaWc = ones(num_inputs,1)*[-4,-2,0,4];
    
    
    deltaZc = 1e-3;
    weightsZc = 0.5*ones(1,num_inputs*ndof);
    lambdaZc = ones(num_inputs,1)*[-1,1,3,5];
    
   
    deltaPc = 1e-3;
    weightsPc = 0.05*ones(1,num_inputs*ndof);
    lambdaPc = ones(num_inputs,1)*[-1,1,3,5];

    % 3dof: initial weights: 600,12.5,5

    [delta,weights,lambda] = packdata(deltaWc,weightsWc,lambdaWc,...
                                      deltaZc,weightsZc,lambdaZc,...
                                      deltaPc,weightsPc,lambdaPc,...
                                           num_inputs,ndof);

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
end

function [num_inputs,dim_inputs,delta,weights,lambda] = BSplineparams2dof(ndof)
    num_inputs = 3; % 1 = e_q, 3 = [e_q,e_px,e_py], 4 = [e_q,e_px,e_py,e_pz]
    dim_inputs = ndof;

    deltaWc = 1e-5;
    weightsWc = 100*ones(1,num_inputs*ndof);
    lambdaWc = ones(num_inputs,1)*[-4,-2,0,4];
    
    
    deltaZc = 1e-3;
    weightsZc = 0.5*ones(1,num_inputs*ndof);
    lambdaZc = ones(num_inputs,1)*[-1,1,3,5];
    
   
    deltaPc = 1e-3;
    weightsPc = 0.05*ones(1,num_inputs*ndof);
    lambdaPc = ones(num_inputs,1)*[-1,1,3,5];

    % 2dof: initial weights: 450,5,2.5

    [delta,weights,lambda] = packdata(deltaWc,weightsWc,lambdaWc,...
                                      deltaZc,weightsZc,lambdaZc,...
                                      deltaPc,weightsPc,lambdaPc,...
                                           num_inputs,ndof);
end

function [delta,weights,lambda] = packdata(deltaWc,weightsWc,lambdaWc,...
                                           deltaZc,weightsZc,lambdaZc,...
                                           deltaPc,weightsPc,lambdaPc,...
                                           num_inputs,ndof)

    delta.deltaWc = deltaWc;
    delta.deltaZc = deltaZc;
    delta.deltaPc = deltaPc;
    
    weights.weightWc = reshape(weightsWc(1:num_inputs*ndof),1,num_inputs,ndof);
    weights.weightZc = reshape(weightsZc(1:num_inputs*ndof),1,num_inputs,ndof);
    weights.weightPc = reshape(weightsPc(1:num_inputs*ndof),1,num_inputs,ndof);


    lambda.lambdaWc = catparam(lambdaWc,num_inputs,ndof);
    lambda.lambdaZc = catparam(lambdaZc,num_inputs,ndof);
    lambda.lambdaPc = catparam(lambdaPc,num_inputs,ndof);    
end

function catparam = catparam(param,num_inputs,ndof)
    
    catparam = zeros(1,4,num_inputs,ndof);
    
    catparam(:,:,1,:) = repmat(param(1,1:4),[1,1,1,ndof]);

    for i = 2:num_inputs
        catparam(:,:,i,:) = repmat(param(i,1:4),[1,1,1,ndof]);
    end
end
