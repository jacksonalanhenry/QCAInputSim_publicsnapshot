classdef Signal 
    %Signal class used to input in to various systems
    %   Detailed explanation goes here
    %   Actually add a explaination of properties
    %   One use of this class might be a signal generator for an electric
    %   field of a circuit
    
    
    properties
        
        Type = 'Sinusoidal';%  'Custom'(Piecewise) 'Imported'(COMSOL) there may be others
        %These properties are only used for the sinusoidal type
        Amplitude = 1;
        Wavelength = 1;
        Period = 1;
        
        
    end
    
    methods
        function obj = Signal( varargin )
            % obj = QCACell( varargin )
           
           
            if( strcmp(obj.Type, 'Sinusoidal') )
                
                switch nargin
                    case 0
                        
                    case 1 % S = Signal( Amplitude )
                        if( isnumeric(varargin{1}) )
                            obj.Amplitude = varargin{1};
                        else
                            error('Incorrect data input type.')
                        end
                    case 2 % S = Signal( Amplitude, wavelength )
                        if( isnumeric(varargin{1}) && isnumeric(varargin{2}) )
                            obj.Amplitude = varargin{1};
                            obj.wavelength = varargin{2};
                        elseif (~isnumeric(varargin{1}))
                            error('Incorrect data input type for Amplitude.')
                        elseif(~isnumeric(varargin{2}))
                            error('Incorrect data input type for Wavelength.')                            
                        else
                            error('Incorrect data input type.')
                        end
                     case 3 % S = Signal( Amplitude, wavelength )
                        if( isnumeric(varargin{1}) && isnumeric(varargin{2}) && isnumeric(varargin{3}) )
                            obj.Amplitude = varargin{1};
                            obj.wavelength = varargin{2};
                            obj.Period = varargin{3};
                        elseif ( ~isnumeric(varargin{1}) )
                            error('Incorrect data input type for Amplitude.')
                        elseif( ~isnumeric(varargin{2}) )
                            error('Incorrect data input type for Wavelength.')
                        elseif( ~isnumeric(varargin{3}) )
                            error('Incorrect data input type for Period.') 
                        else
                            error('Incorrect data input type.')
                        end
                        
                    otherwise
                        error('Invalid number of inputs for QCACell');  
                        
                end % END: Switch nargin
                
            else
                %nothing for now, but eventually other types
                
            end
            
        end
        
        function obj = set.Type(obj,value)
            if (~isequal(value, 'Sinusoidal') && ~isequal(value,'Custom')) %edit this to add more types
                error('Invalid Type. Must be Standard signal Type')
            else
                obj.Type = value;
            end
        end
        
        function EField = getEField(obj, centerposition, time)
            if( isnumeric(centerposition) )
                if(size(centerposition) == [1, 3])
                            
                    
                    %THIS FUNCTION ONLY ASSIGNS z Field

                    EField = [0,0,0];
                    EField(3)=+0.5 *cos(2*pi*(centerposition(1)/obj.Wavelength - time/obj.Period ) ) -0.4;
                    EField(3) = EField(3)*obj.Amplitude;

                else
                    error('Incorrect data input size.')
                end
            else
                error('Incorrect data input type.')
            end

        end
        
        
    end
    
end

