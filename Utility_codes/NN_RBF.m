classdef NN_RBF
    properties
        num_inputs
        dim_inputs
        num_rbfs
        num_outputs

        rbf_params

        delta
        weights
        lambda

        struct
    end
    methods
        function obj = NN_RBF(num_inputs,dim_inputs,delta,weights,k_params)

            obj.num_inputs = num_inputs;
            obj.dim_inputs = dim_inputs;
            obj.num_rbfs = size(weights.weightWc,2);
            obj.num_outputs = size(weights.weightWc,1);

            obj.delta = delta;
            obj.weights = weights;

            obj.rbf_params = k_params;

            obj.struct.num_inputs = num_inputs;
            obj.struct.dim_inputs = dim_inputs;
            obj.struct.num_rbfs = size(weights.weightWc,2);
            obj.struct.num_outputs = size(weights.weightWc,1);


            obj.struct.delta = delta;
            obj.struct.weights = weights;

            obj.struct.rbf_params = k_params;
        end
    end
    methods (Static)
        function [param,param_weights] = Gradient_Descent(delta,weights,centers,radius,rbfnn_inputs)

            num_inputs = size(rbfnn_inputs,2);
            dim_inputs = size(rbfnn_inputs,1);
            num_rbfs = size(weights,2);
            num_outputs = size(weights,1);
        
            % mu (dim_inputs x num_rbfs)
            % sigma (1 x 1)
            % weights (num_outputs x num_rbfs x dim_inputs)
            % rbfnn_inputs (dim_inputs x num_inputs)
            param = zeros(num_outputs,dim_inputs);
            param_weights = weights;
        
            % Gradient Descent %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
            h = zeros(num_inputs,num_rbfs); % num_inputs x num_rbfs
        
            for j = 1:num_inputs
                h(j,:) = exp(-sum((rbfnn_inputs(:,j) - centers).^2,1) ./ (2 * radius.^2)); % 1 x num_rbfs
            end
            norm_h = sum(h.^2,'all'); % 1 x 1
        
            for ii = 1:dim_inputs % dim_inputs
                if norm_h ~= 0
                    % rbfnn_inputs(ii,:)*h; 1 x num_rbfs
                    % delta .* rbfnn_inputs(ii,:)'*h ./ norm_h; % num_outputs x num_rbfs
                    param_weights(:,:,ii) = param_weights(:,:,ii) + delta .* rbfnn_inputs(ii,:)*h ./ norm_h; % num_outputs x num_rbfs
                end
                % param_weights(:,:,ii) * h'; % num_outputs x num_inputs
                param(:,ii) = sum(param_weights(:,:,ii) * h',2);
            end
            
            % for i = 1:size(rbfnn_inputs,1)
            %     for j = 1:k
            %         sigma = sigma + delta(i)*(weights'*h(i,:)' - q_ref(i))*weights(j)*h(i,j)*norm(q - q_ref,2)^2/sigma^3;
            %         C(:,j) = mu(j,:)' + delta(i)*(weights'*h(i,:)' - q_ref(i))*weights(j)*h(i,j)*norm(q-mu(j,:)',2)/sigma^2;
            %     end
            % end
        
            % % Recursive Least Squares %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Rn = zeros(num_rbfs,num_rbfs); % num_rbfs x num_rbfs
            % alpha = zeros(dim_inputs,num_outputs);
            % 
            % h = exp(-sum((rbfnn_inputs - centers).^2,1) ./ (2 * radius.^2)); % 1 x num_rbfs
            % 
            % for ii = 1:dim_inputs
            %     Rn = Rn + h(:,ii)'*h(:,ii); % num_rbfs x num_rbfs
            % end
            % 
            % g = Rn^-1*h'; % num_rbfs x 1
            % 
            % for ii = 1:dim_inputs
            %     alpha(ii,:) = rbfnn_inputs(ii,:) - (param_weights(:,:,ii)*h')'; % 1 x num_outputs
            % 
            %     param_weights(:,:,ii) = param_weights(:,:,ii) + delta * g' .* alpha(ii,:); % num_outputs x num_rbfs
            %     param(:,ii) = param_weights(:,:,ii) * h';
            % end
        end
    end
end