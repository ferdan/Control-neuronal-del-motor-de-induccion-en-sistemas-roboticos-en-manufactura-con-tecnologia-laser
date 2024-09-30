classdef lmsSysObj < matlab.System
   % lmsSysObj Least mean squares (LMS) adaptive filtering. 
   % #codegen

   properties
      % Mu Step size
      Mu = 0.005;
   end

   properties (Nontunable)
      % Weights  Filter weights
      Weights = 0;
      % N  Number of filter weights
      N = 32;
   end
  
   properties (DiscreteState) 
      X;
      H;
   end
  
   methods (Access = protected)
      function setupImpl(obj)
         obj.X = zeros(obj.N,1);
         obj.H = zeros(obj.N,1);
      end
      
      function [y, e_norm] = stepImpl(obj,d,u)
         tmp = obj.X(1:obj.N-1);
         obj.X(2:obj.N,1) = tmp;
         obj.X(1,1) = u;
         y = obj.X'*obj.H;
         e = d-y;
         obj.H = obj.H + obj.Mu*e*obj.X;
         e_norm = norm(obj.Weights'-obj.H);
      end
    
      function resetImpl(obj)
         obj.X = zeros(obj.N,1);
         obj.H = zeros(obj.N,1);
      end
      
   end   

   % Block icon and dialog customizations
   methods (Static, Access = protected)
      function header = getHeaderImpl
         header = matlab.system.display.Header(...
              'lmsSysObj', ...
              'Title', 'LMS Adaptive Filter');
      end
      
      function groups = getPropertyGroupsImpl
         upperGroup = matlab.system.display.SectionGroup(...
              'Title','General',...
              'PropertyList',{'Mu'});
            
         lowerGroup = matlab.system.display.SectionGroup(...
              'Title','Coefficients', ...
              'PropertyList',{'Weights','N'});
            
         groups = [upperGroup,lowerGroup];
      end
   end
   
   methods (Access = protected)
      function icon = getIconImpl(~)
         icon = sprintf('LMS Adaptive\nFilter');
      end
      function [in1name, in2name] = getInputNamesImpl(~)
         in1name = 'Desired';
         in2name = 'Actual';
      end
      function [out1name, out2name] = getOutputNamesImpl(~)
         out1name = 'Output';
         out2name = 'EstError';
      end
   end
end