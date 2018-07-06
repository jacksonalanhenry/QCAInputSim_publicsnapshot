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
        Phase = pi/2;
        
        %Piecewise Properties

        

            
        Name
%         Type
        Transition
%         Period
        PhaseDelay % radians
        MeanValue
%         Amplitude
        Sharpness
        
    
    %dependent properties
        Periodic
        InitialValue
        
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
                            obj.Wavelength = varargin{2};
                        elseif (~isnumeric(varargin{1}))
                            error('Incorrect data input type for Amplitude.')
                        elseif(~isnumeric(varargin{2}))
                            error('Incorrect data input type for Wavelength.')
                        else
                            error('Incorrect data input type.')
                        end
                        
                    case 3 % S = Signal( Amplitude, wavelength , Period )
                        if( isnumeric(varargin{1}) && isnumeric(varargin{2}) && isnumeric(varargin{3}) )
                            obj.Amplitude = varargin{1};
                            obj.Wavelength = varargin{2};
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
                        
                        
                    case 4 % S = Signal( Amplitude, wavelength , Period )
                        if( isnumeric(varargin{1}) && isnumeric(varargin{2}) && isnumeric(varargin{3}) )
                            obj.Amplitude = varargin{1};
                            obj.Wavelength = varargin{2};
                            obj.Period = varargin{3};
                            obj.Phase = varargin{4};
                        elseif ( ~isnumeric(varargin{1}) )
                            error('Incorrect data input type for Amplitude.')
                        elseif( ~isnumeric(varargin{2}) )
                            error('Incorrect data input type for Wavelength.')
                        elseif( ~isnumeric(varargin{3}) )
                            error('Incorrect data input type for Period.')
                        elseif( ~isnumeric(varargin{4}) )
                            error('Incorrect data input type for Phase.')
                        else
                            error('Incorrect data input type.')
                        end
                    otherwise
                        error('Invalid number of inputs for QCACell');
                        
                end % END: Switch nargin
                
            elseif ( strcmp(obj.Type, 'Piecewise') )
                
                % piecewise signal
                
                
                
            else
                %nothing for now, but eventually other types
                
            end
            
        end
        
        function obj = set.Type(obj,value)
            if (~isequal(value, 'Sinusoidal') && ~isequal(value,'Custom') && ~isequal(value,'Electrode') && ~isequal(value,'Fermi'))%edit this to add more types
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

                    EField(3)=( cos((2*pi*(centerposition(1)/obj.Wavelength - time/obj.Period ) )+ obj.Phase ) )*obj.Amplitude; 

                    
                    ef = EField(3);
                    x  = centerposition(1);
%                     disp(['x: ', num2str(x), ' ef: ', num2str(ef)])%'t: ', num2str(time),
                    
                    
                else
                    error('Incorrect data input size.')
                end
            else
                error('Incorrect data input type.')
            end
            
        end
        
        
        function obj = drawElectrode(obj, centerpos, height, width, Efield)
            
            if strcmp(obj.Type,'Electrode')
                top = patch('FaceColor','red','XData',[centerpos(1) - width/2-.1  centerpos(1) + width/2+.1 centerpos(1) + width/2+.1 centerpos(1) - width/2-.1]...
                    ,'YData',[centerpos(2)+ height/2+.1  centerpos(2)+height/2+.1  centerpos(2) + height/2+.3   centerpos(2) + height/2+.3]);
                
                bottom = patch('FaceColor','black','XData',[centerpos(1) - width/2-.1  centerpos(1) + width/2+.1  centerpos(1) + width/2+.1    centerpos(1) - width/2-.1]...
                    ,'YData',[centerpos(2)- height/2-.1  centerpos(2)-height/2-.1  centerpos(2) - height/2-.3   centerpos(2) - height/2-.3]);
                
                
                x0 = centerpos(1) - width/2;
                x1 = centerpos(1) + width/2;
                
                low = centerpos(2) - height/2;
                high= centerpos(2) + height/2;
                
                
                
                Efield;
                adjust=1;
                if  Efield > 1.4
                    adjust = 1;
                    
                elseif Efield > 1.0 && Efield <= 1.4
                    adjust = adjust * .8;
                    
                elseif Efield > .6 && Efield <= 1.0
                    adjust = adjust * .6;
                    
                elseif Efield > .2 && Efield <= .6
                    adjust = adjust * .4;
                    
                elseif Efield > -.2 && Efield <= .2 && Efield ~= 0
                    adjust = adjust * .2;
                    
                elseif Efield == 0 
                    adjust = 0;
                    
                elseif Efield < -.2 && Efield >= -.6
                    adjust = adjust * .4;
                    
                elseif Efield < -.6 && Efield >= -1.0
                    adjust = adjust * .6;
                    
                elseif Efield < -1.0 && Efield >= -1.4
                    adjust = adjust * .8;
                    
                elseif Efield < -1.4
                    adjust = 1;
                    
                end
                
                adjust;
                for i=x0 : (x1-x0)/10 : x1
                    
                    p1 = [i low];                         % First Point
                    p2 = [i high];                         % Second Point
                    dp = p2-p1;                         % Difference
                    
                    hold on;
                    q=quiver(p1(1),p1(2),dp(1),adjust * dp(2),0);
                    q.LineWidth = 1.5;
                    q.MarkerEdgeColor = 'black';
                    q.Color = 'black';
                end
                
                hold off;
            end
            
            
        end
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        


        % vvv ------ Value ----- vvv
        function varargout = Value( obj, centerposition, t )
            
            % disp(['QCApack.Signal.Value: ojb.Type = ', obj.Type])
            switch obj.Type
                case 'Sinusoidal'
                    V = obj.MeanValue + ...
                        obj.Amplitude*sin(2*pi*(centerposition(1)/obj.Wavelength + t/obj.Period) + obj.PhaseDelay);
                    
                case 'Fermi'
                    t = mod(t + ...
                        obj.PhaseDelay*(obj.Period/(2*pi)), ...
                        obj.Period);
                    
                    xi = obj.Sharpness;
                    
                    RestorativeScalingFactor = (2*( ...
                        -0.5 - (exp(xi*(obj.Period/4)) + 1).^(-1) ...
                        + (exp(xi*(-obj.Period/4)) + 1).^(-1) ...
                        - (exp(xi*(-3*obj.Period/4)) + 1).^(-1) ...
                        + (exp(xi*(-5*obj.Period/4)) + 1).^(-1))).^(-1);
                    
                    
                    V = RestorativeScalingFactor*2*obj.Amplitude*( ...
                        -0.5 - (exp(xi*(t + obj.Period/4)) + 1).^(-1) ...
                             + (exp(xi*(t - obj.Period/4)) + 1).^(-1) ...
                             - (exp(xi*(t - 3*obj.Period/4)) + 1).^(-1) ...
                             + (exp(xi*(t - 5*obj.Period/4)) + 1).^(-1)) ...
                             
                        ... - 5*obj.Amplitude 
                        + obj.MeanValue;


                otherwise
                    error(['ClockType = ''', obj.Type, ...
                        ''' is invalid.'])
                    
            end % END [ switch obj.Type ]

            switch nargout
                case 0
                    varargout{1} = V;
                case 1
                    varargout{1} = V;
                case 2
                    varargout{1} = V;
                    varargout{2} = dVdt;
            end
            
            
        end
        % ^^^ ------ GET: InitialValue ----- ^^^
    end
    
end

