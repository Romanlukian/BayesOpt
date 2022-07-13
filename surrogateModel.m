classdef ( Abstract = true ) surrogateModel
    
    properties ( SetAccess = protected, Abstract = true )
        X           double                                                  % Input data
        Y           double                                                  % Response data
    end % protected and abstract properties

    properties ( Access = protected, Dependent )
        Xc          double                                                  % Coded input data [ a, b ] --> [ -1, 1 ]
    end % protected & dependent properties

    properties ( SetAccess = protected, Dependent )
        DataOk      logical     
    end % dependent properties

    methods ( Abstract = true )
        obj = trainModel( obj, varargin );
    end 

    methods
        function obj = setTrainingData( obj, X, Y )
            %--------------------------------------------------------------
            % Set the training data
            %
            % obj = obj.setTrainingData( X, Y );
            %
            % Input Arguments:
            %
            % X --> (double) NxC matrix of input data
            % Y --> (double) Nx1 matrix of response data
            %--------------------------------------------------------------
            arguments
                obj (1,1)
                X           double
                Y   (:,1)   double
            end
            obj.X = X;
            obj.Y = Y;
        end % setTrainingData

        function D = decode( obj, Dc )
            %--------------------------------------------------------------
            % Map the coded input data [-1, 1] onto the interval [a, b]
            %
            % D = obj.decode( Dc );
            %
            % Input Arguments:
            %
            % Dc --> Coded input data
            %--------------------------------------------------------------
            [ A, B, M ] = obj.dataCodingInfo( obj.X );
            D = 0.5 .* Dc .* ( B - A ) + M;
        end % decode
    end % ordinary method signatures
    
    methods
        function Ok = get.DataOk( obj )
            % Check consistency of data
            Ok = size( obj.X, 1 ) & numel( obj.Y );
            Ok = Ok & ~isempty( obj.X ) & ~isempty( obj.Y );
        end % get.DataOk

        function Xc = get.Xc( obj )
            % Return coded input data [a,b] --> [-1,1]
            Xc = obj.code( obj.X );
        end % get.Xc
    end

    methods ( Access = private, Static = true )
        function Xc = code( X )
            %--------------------------------------------------------------
            % Code data onto the interval [-1,1]
            %
            % Input Arguments:
            %
            % X --> (double) data matrix
            %--------------------------------------------------------------
            [ A, B, M ] = obj.dataCodingInfo( X );
            Xc = 2 * ( obj.X - M ) ./ ( B - A );
        end % code

        function [ A, B, M ] = dataCodingInfo( D )
            %--------------------------------------------------------------
            % Return data coding information
            %
            % [ A, B, M ] = obj.dataCodingInfo( D );
            %
            % Input Arguments:
            %
            % D --> (double) Data matrix
            %
            % Output Arguments:
            %
            % A --> lower limit for data
            % B --> upper limit for data
            % M --> median of data range
            %--------------------------------------------------------------
            A = min( D );
            B = max( D );
            M = mean( [ B; A ] );
        end % dataCodingInfo
    end % private and static method signatures
end % classdef
