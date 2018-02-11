classdef QCACell
    %QCACell Container class for any QCA Cell
    %   Detailed explanation goes here
    %   Actually add a explaination of properties
    %   Also mention the Parent-Child interatction. 
    
    
    
    properties
        CellID = 0; % Unique Cell identifier
        Type = 'node';% Driver/Node
        CenterPosition = [ 0, 0, 0]; % poisiton of the cell center
        DotPosition = []; % [*CharacteristicLength] positions of dots 
                         %      relative to cell center
        CharacteristicLength = 1; % [nm]
        
        %Electric Field
        
    end
    
    methods
        function obj = QCACell( varargin )
            % obj = QCACell( varargin )
            %
            % Detailed
           
            
            switch nargin
                case 0
                    
                case 1 % Q = QCACell( [x,y,z] )
                    obj.CenterPosition = varargin{1};
                    %obj.Type = varargin{2}

                otherwise
                    error('Invalid number of inputs for QCACell');
                    
                    
            end % END: Switch nargin
            
            
        end
        
        function obj = translateCell(obj,TranslationVect)
            % Q = Q.translateCell( TranslationVect )
            %
            %       Q is an implicit first arguement 
            %
            %       Q is not modified outside of this method unless we
            %       reassign it (i.e. we need "Q = Q.translateCell(...)")
            obj.Position = obj.CenterPosition + TranslationVect;
            
        end
        
        
        function TrueDotPosition = getDotPosition( obj )
            % R = Q.getDotPosition returns the absolute coordinates of the
            % dots of cell Q
            % 
            % If Q has n dots, then Ris a n-by-3 matrix, with the kth row
            % representing the xyz-triple for th kth dot
            
            %number of rows in obj.DotPosition
            n = size(obj.DotPosition, 1);
            
            %position of cell dots relative to axes position
            TrueDotPosition = ones(n,1) * obj.CenterPosition + ...
                    obj.CharacteristicLength*obj.DotPosition;
        
        end
        
    end
    
end

