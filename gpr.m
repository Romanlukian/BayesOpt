classdef gpr < surrogateModel
    % gaussian regression process class

    properties ( SetAccess = protected )
        X           double
        Y           double
        Kernel      kernels         = kernels( "ARDsquaredExponential" )
        PredMethod  gprFitMethod    = gprFitMethod( "exact" )
    end % protected and abstract properties

    methods
        function obj = gpr( X, Y )
            %--------------------------------------------------------------
            % Class constructor
            %
            % obj = gpr( X, Y );
            %
            % Input Arguments:
            %
            % X --> (double) Input data matrix
            % Y --> (double) Response data matrix
            %--------------------------------------------------------------
            arguments
                X   double     = [];
                Y   double     = [];
            end
            obj = obj.setTrainingData( X, Y );
        end % gpr
    end % constructor method signature    

    methods
        function obj = setPredMethod( obj, Method )
            %--------------------------------------------------------------
            % Set the method used to make predictions
            %
            % obj = obj.setPredMethod( Method );
            %
            % Input Arguments:
            %
            % Name  --> (string) Supported prediction method:
            %           exact {default}
            %           sd           
            %           sr              
            %           fic             
            %           bcd 
            %--------------------------------------------------------------
            arguments
                obj     (1,1)   gpr
                Method  (1,1)   string  = "exact"
            end

            try
                M = gprFitMethod( Method );
                obj.PredMethod = M;
            catch me
                error( me.identifier , me.message );
            end        
        end % setPredMethod

        function obj = setKernel( obj, Name )
            %--------------------------------------------------------------
            % Set the gaussian covariance function kernel
            %
            % obj = obj.setKernel( Name );
            %
            % Input Arguments:
            %
            % Name  --> (string) Supported kernel function:
            %           ARDsquaredExponential {default}
            %           ARDexponential           
            %           ARDmatern32              
            %           ARDmatern52             
            %           ARDrationalQuadratic 
            %--------------------------------------------------------------
            arguments
                obj     (1,1)   gpr
                Name    (1,1)   string  = "ARDsquaredExponential"
            end

            try
                K = kernels( Name );
                obj.Kernel = K;
            catch me
                error( me.identifier , me.message );
            end
        end % setKernel

        function obj = trainModel( obj )
        end % trainModel
    end
end % classdef