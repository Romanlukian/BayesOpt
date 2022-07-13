classdef rf < surrogateModel

    properties ( SetAccess = protected, Abstract = true )
        X           double                                                  % Input data
        Y           double                                                  % Response data
        Yname       string                                                  % Response name 
        Xname       string                                                  % Array of predictor names
    end % protected and abstract properties

    methods
        function obj = rf( X, Y )
            %--------------------------------------------------------------
            % Class constructor
            %
            % obj = rf( X, Y );
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
end % classdef