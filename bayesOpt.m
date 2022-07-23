classdef bayesOpt 
    % Bayesian optimisation class

    properties ( SetAccess = protected  )
        AcqFcn   (1,1)   acqFcnType     = "ei"                              % Acquisition function type
    end % abstract and protected properties

    properties ( Access = protected )
        AcqObj   (1,1)                                                      % Acquisition function object
    end
    
    methods
        function obj = addNewQuery( obj, Xnew, Ynew )
            %--------------------------------------------------------------
            % Add a new function query & update surrogate model.
            %
            % obj = obj.addNewQuery( Xnew, Ynew );
            %
            %
            % Input Arguments:
            %
            % Xnew  --> (double) New input data
            % Ynew  --> (double) Function query f(Xnew)
            %--------------------------------------------------------------
            arguments
                obj     (1,1)           { mustBeNonempty( obj ) }
                Xnew    (:,:)   double  { mustBeNonempty( Xnew ) }
                Ynew    (:,1)   double  { mustBeNonempty( Ynew ) }
            end
            obj.AcqObj.addFcnSample2Data( Xnew, Ynew );
        end % addNewQuery

        function Xmax = acqFcnMaxTemplate( obj, Args )
            %--------------------------------------------------------------
            % Optimise the acquisition function given the current training
            % data. The output is the next place to sample the function.
            %
            % Xmax = obj.acqFcnTemplate( "Name1", Value1, ... );
            %
            % Input Arguments:
            %
            % "Name"    --> Fmincon input argument name
            % Value     --> Corresponding argument value
            %--------------------------------------------------------------
            arguments
                obj            (1,1)            { mustBeNonempty( obj ) }
                Args.lb        (1,:) double                
                Args.ub        (1,:) double                
                Args.options   (1,1) optim.options.Fmincon = optimoptions( "fmincon")
                Args.nonlincon (1,1) function_handle       
                Args.Aineq     (:,:) double                
                Args.bineq     (:,1) double                
                Args.Aeq       (:,:) double                
                Args.beq       (:,1) double                
            end
            %--------------------------------------------------------------
            % Parse the optional arguments
            %--------------------------------------------------------------
            Names = [ "lb", "ub", "nonlincon", "Aineq", "binq", "Aeq",...
                       "beq", "options" ];
            for Q = 1:numel( Names )
               try
                   Problem.( Names( Q ) ) = Args.( Names( Q ) );
               catch
                   Problem.( Names( Q ) ) = [];
               end
            end
            %--------------------------------------------------------------
            % Set up the optimisation problem
            %--------------------------------------------------------------
            Problem.options.Display = "iter";
            Problem.solver = "fmincon";
            Problem.objective = @(X)obj.evalFcn( X, obj.Xi );
            if isinf( obj.BestX )
                %----------------------------------------------------------
                % Select a strating point
                %----------------------------------------------------------
                [ ~, Idx ] = max( obj.ModelObj.predict( obj.Data ) );
                Problem.x0 = obj.Data( Idx, : );
            else
                %----------------------------------------------------------
                % Start from the last selected point
                %----------------------------------------------------------
                Problem.x0 = obj.BestX;
            end
            obj.BestX = Problem.x0;
            Xmax = fmincon( Problem );
        end % acqFcnMaxTemplate
    end % Concrete ordinary methods
end % classdef