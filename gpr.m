classdef gpr < surrogateModel
    % gaussian regression process class

    properties ( SetAccess = protected )
        X           double
        Y           double
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
        function obj = trainModel( obj )
        end % trainModel
    end
end % classdef