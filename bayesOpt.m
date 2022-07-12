classdef ( Abstract = true ) bayesOpt 
    % Bayesian optimisation abstract class

    properties ( Abstract = true, SetAccess = protected  )
        AcqFcn (1,1)   string
    end % abstract and protected properties

    methods
    end % Concrete ordinary methods

    methods ( Abstract = true )
    end % abstract methods signatures
end % classdef