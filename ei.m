classdef ei < acqFcn
    % Implement the expected improvement acquisition function

    properties ( Constant = true )
        FcnName         acqFcnType   = acqFcnType( "ei" )
    end % Abstract constant properties
    
    properties ( SetAccess = protected )
        Xi  (1,1)   double { mustBePositive( Xi ), mustBeReal( Xi ) } = 0.01
    end

    methods
        function obj = ei( ModelObj, Xi )
            %--------------------------------------------------------------
            % Expected Improvement (EI) class constructor
            %
            % obj = ei( Type, ModelObj, Xi );
            %
            % Input Arguments:
            %
            % ModelObj  --> Surrogate model for system
            % Xi        --> (double) Hyperparameter {0.01}
            %--------------------------------------------------------------
            arguments
                ModelObj (1,1)          { mustBeNonempty( ModelObj ) }
                Xi       (1,1) double   { mustBeGreaterThanOrEqual( Xi, 0),...
                                          mustBeLessThanOrEqual( Xi, 1)} = 0.01
            end
            if ( nargin > 1 )
                obj.Xi = Xi;
            end
            obj.ModelObj = ModelObj;
        end % constructor

        function [ Y, Ylo, Yhi ] = eval( obj, X, Alpha )
            %--------------------------------------------------------------
            % Evaluate the EI acquisition function at the location
            % specified
            %
            % [ Y, Ylo, Yhi ] = obj.eval( X, Alpha );
            %
            % Input Arguments:
            %
            % X     --> Points to evaluate the acquisition function
            % Alpha --> Confidence level: 100( 1 - Alpha )
            %--------------------------------------------------------------
            Mu = obj.ModelObj.predict( X );
        end % eval
    end % ordinary method signatures

end % classdef