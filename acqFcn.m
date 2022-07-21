classdef ( Abstract = true) acqFcn < handle
    % Interface to Bayesian Optimisation acquisition functions

    properties ( Constant = true, Abstract = true)
        FcnName         acqFcnType
    end % Abstract constant properties

    properties ( SetAccess = protected )
        ModelObj (1,1)                                                      % Surrogate model object
    end % protected properties

    methods ( Abstract = true )
        Y = eval( obj, X )                                                  % Evaluate the acquisition function at the points supplied
    end % Abstract methods signatures
end % classdef