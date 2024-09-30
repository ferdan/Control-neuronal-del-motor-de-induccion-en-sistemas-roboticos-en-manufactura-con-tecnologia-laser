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


    [num_inputs,dim_inputs,delta,weights,lambda] = BSplineparams1dof(ndof);

    % 2dof: initial weights: 450,5,2.5
    % 3dof: initial weights: 600,12.5,5
    % 6dof: initial weights: 450,7,1.5
    
    NN = NN_Bspline(num_inputs,dim_inputs,delta,weights,lambda);
end

function [num_inputs,dim_inputs,delta,weights,lambda] = BSplineparams1dof(ndof)
    num_inputs = 1; % 1 = e_q, 3 = [e_q,e_px,e_py], 4 = [e_q,e_px,e_py,e_pz]
    dim_inputs = ndof;

    deltaWc = 1e-3;
    weightsWc = 60*ones(1,num_inputs*ndof);
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
