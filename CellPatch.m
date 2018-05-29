classdef CellPatch
    %UNTITLED9 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        CellID = 0; % Unique Cell identifier
        Type = 'node';% Driver/Node
        CenterPosition = [0, 0, 0]; % poisiton of the cell center

        CharacteristicLength = 1; % [nm]
        
        LayoutMode='';
    end
    
    methods
        
        function obj = QCACell( varargin )
            % obj = QCACell( varargin )
            %
            % Detailed
            
            
            switch nargin
                case 0
                    
                case 1 % Q = QCACell( [x,y,z] )
                    if( isnumeric(varargin{1}) )
                        if(size(varargin{1}) == [1, 3])
                            obj.CenterPosition = varargin{1};
                        else
                            error('Incorrect data input size.')
                        end
                    else
                        error('Incorrect data input type.')
                    end
                    
                otherwise
                    error('Invalid number of inputs for QCACell');
                    
                    
            end % END: Switch nargin
            
            
        end
        
        function obj = set.Type(obj,value)
            if (~isequal(value, 'Driver') && ~isequal(value,'Node'))
                error('Invalid Type. Must be Driver or Node')
            else
                obj.Type = value;
            end
        end
        
        
        
        
    end
    
end

