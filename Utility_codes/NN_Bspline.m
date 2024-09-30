classdef NN_Bspline
    properties
        
        num_inputs
        dim_inputs
        num_bsplcoefs
        num_outputs

        delta
        weights
        lambda

        struct
    end
    methods
        function obj = NN_Bspline(num_inputs,dim_inputs,delta,weights,lambda)

            obj.num_inputs = num_inputs;
            obj.dim_inputs = dim_inputs;
            obj.num_bsplcoefs = size(lambda,2);
            obj.num_outputs = size(weights,1);

            obj.delta = delta;
            obj.weights = weights;
            obj.lambda = lambda;

            obj.struct.num_inputs = num_inputs;
            obj.struct.dim_inputs = dim_inputs;
            obj.struct.num_bsplcoefs = size(lambda,2);
            obj.struct.num_outputs = size(weights,1);


            obj.struct.delta = delta;
            obj.struct.weights = weights;
            obj.struct.lambda = lambda;
        end
    end
    methods (Static)
        function [param,param_weights] = Gradient_Descent(delta,weights,lambda,nn_inputs)

            num_inputs = size(nn_inputs,2);
            dim_inputs = size(nn_inputs,1);
            num_bsplcoefs = size(lambda,2);
            num_outputs = size(weights,1);
        
            % lambda (num_outputs x num_bsplcoefs x num_inputs x dim_inputs)
            % weights (num_outputs x num_inputs x dim_inputs)
            % nn_inputs (dim_inputs x num_inputs)
            param = zeros(num_outputs,dim_inputs);
            param_weights = weights;
        
            h = zeros(num_outputs,num_inputs,dim_inputs); % num_outputs x num_inputs x dim_inputs
        
            % Gradient Descent %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
            for ii = 1:dim_inputs
                for i = 1:num_outputs
                    for j = 1:num_inputs
                        h(i,j,ii) = NN_Bspline.FBase_Bspline_cubic(nn_inputs(ii,j),lambda(i,:,j,ii)); % 1 x 1 x 1
                    end
                end
            end
        
            norm_h = sum(h.^2,[2,3]); % num_outputs x 1 x 1
        
            for ii = 1:dim_inputs % dim_inputs
                for i = 1:num_outputs
                    if norm_h ~= 0
                        % nn_inputs(ii,:)'; % num_inputs x 1
                        % h(i,:,ii); % 1 x num_inputs x 1
                        % nn_inputs(ii,:)'*h(i,:,ii); % num_inputs x num_inputs
                        % sum(nn_inputs(ii,:)'*h(i,:,ii),1); % 1 x num_inputs
                        % delta(i) .* sum(nn_inputs(ii,:)'*h(i,:,ii),1) ./ norm_h; % 1 x num_inputs
                        param_weights(i,:,ii) = param_weights(i,:,ii) + delta(i) .* sum(nn_inputs(ii,:)'*h(i,:,ii),1) ./ norm_h(i); % 1 x num_inputs
                    end
                end
        
                % param_weights(:,:,ii); % num_outputs x num_inputs x 1
                % h(:,:,ii)'; % num_inputs x num_outputs
                % param_weights(:,:,ii) * h(:,:,ii)'; % num_outputs x num_outputs
                % sum(param_weights(i,:,ii) * h(i,:,ii)',2); % num_outputs x 1
                param(:,ii) = sum(param_weights(:,:,ii) * h(:,:,ii)',2);
            end
        end
        
        function N3_2 = FBase_Bspline_cubic(x,lambda)
        
            lambda_1 = lambda(1);
            lambda0  = lambda(2);
            lambda1  = lambda(3);
            lambda2  = lambda(4);
        
            if x >= lambda_1 && x < lambda0
                 N1_0 = 1;
              else
                 N1_0 = 0;
             end
             
             if x >= lambda0 && x < lambda1
                 N1_1 = 1;
              else
                 N1_1 = 0;
             end
             
             if x >= lambda1 && x < lambda2
                 N1_2 = 1;
              else
                 N1_2 = 0;
             end
             
            N2_1   = ((x-lambda_1)/(lambda0-lambda_1))*N1_0 + ((lambda1-x)/(lambda1-lambda0))*N1_1;
            N2_2   = ((x-lambda0)/(lambda1-lambda0))*N1_1   + ((lambda2-x)/(lambda2-lambda1))*N1_2;
            
            N3_2   = ((x-lambda_1)/(lambda1-lambda_1))*N2_1   + ((lambda2-x)/(lambda2-lambda0))*N2_2;
        
        end
    end
end