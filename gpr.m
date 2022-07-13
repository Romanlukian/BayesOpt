classdef gpr < surrogateModel
    % gaussian regression process class

    properties ( SetAccess = protected )
        X           double
        Y           double
        Kernel      kernels         = kernels( "ARDsquaredExponential" )
        PredMethod  gprPredMethod   = gprPredMethod( "exact" )
        FitMethod   gprFitMethod    = gprFitMethod( "exact" )
        Yname       string                                                  % Response name 
        Xname       string                                                  % Array of predictor names
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
                M = gprPredMethod( Method );
                obj.PredMethod = M;
            catch me
                error( me.identifier , me.message );
            end        
        end % setPredMethod

        function obj = setFitMethod( obj, Method )
            %--------------------------------------------------------------
            % Set the method used to fit the data
            %
            % obj = obj.setFitMethod( Method );
            %
            % Input Arguments:
            %
            % Name  --> (string) Supported prediction method:
            %           exact {default}
            %           sd           
            %           sr              
            %           fic             
            %--------------------------------------------------------------
            arguments
                obj     (1,1)   gpr
                Method  (1,1)   string  = "exact"
            end

            try
                M = gprFitMethod( Method );
                obj.FitMethod = M;
            catch me
                error( me.identifier , me.message );
            end        
        end % setFitMethod

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

        function obj = trainModel( obj, varargin )
            %--------------------------------------------------------------
            % Train the gpr model.
            %
            % obj = trainModel( obj, Name1, Value1, ..., Name#, Value#);
            %
            % This method makes use of the RegressionGP class. A
            % RegressionGP object is composited in the ModelObj property.
            %
            % The kernel function and prediction methods can be set using
            % the setKernel and setPredMethod methods. However, all other
            % options can be set through the ( Name, Value ) pair list
            %--------------------------------------------------------------
            assert( obj.DataOk,...
                    "X-predictor name vector must have %3.0f entries",...
                    obj.N );            
            obj.ModelObj = fitrgp( obj.Xc, obj.Y,...
                    "FitMethod", string( obj.FitMethod ),...
                    "PredictMethod", string( obj.PredMethod ),...
                    "KernelFunction", string( obj.Kernel ),...
                    varargin{:});
        end % trainModel

        function [ Ypred, Ysd, Yint ] = predict( obj, Xnew, Alpha )
            %--------------------------------------------------------------
            % Model predictions
            %
            % Y = obj.predict( Xnew, Alpha );
            %
            % Input Argumentss:
            %
            % Xnew  --> (double) input data
            % Alpha --> (double) 100(1 - Alpha)% prediction interval
            %
            % Output Arguments:
            %
            % Ypred --> predicted responses
            % Ysd   --> standard deviations
            % Yint  --> prediction interval
            %--------------------------------------------------------------
            arguments
                obj   (1,1)     gpr
                Xnew            double           = obj.X     
                Alpha           double  = 0.05
            end
            Xnew = obj.code( Xnew );
            [ Ypred, Ysd, Yint ] = predict( obj.ModelObj, Xnew, 'Alpha',...
                                            Alpha );
        end % predict
    end
end % classdef