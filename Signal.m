classdef Signal
    %Signal class used to input in to various systems
    %   Detailed explanation goes here
    %   Actually add a explaination of properties
    %   One use of this class might be a signal generator for an electric
    %   field of a circuit
    
    
    properties
        
        Name;
        Type = 'Sinusoidal';%  'Fermi' 'Custom'(Piecewise) 'Imported'(COMSOL) there may be others
        
        %These properties are only used for the Sinusoidal and Fermi type
        Amplitude = 1;
        Wavelength = 1;
        Period = 1;
        Phase = pi/2;
        MeanValue = 0;
        Sharpness = .05;
        
        CellIds = []; %used to associate certain signals with certain cells. Most commonly driver polarizations
        
        
        %Electrode Properties
        InputField=0;
        CenterPosition = [0 0 0];
        Height = 1.5;
        Width = .5;
        IsDrawn = 'off';
        TopPatch;
        BottomPatch;
        
        
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
                
            elseif ( strcmp(obj.Type, 'Fermi') )
                
                % Fermi signal
                
                
            elseif ( strcmp(obj.Type, 'Piecewise') )
                
                % piecewise signal
                
                
                
            else
                %nothing for now, but eventually other types
                
            end
            
        end
        
        function obj = set.Type(obj,value)
            if (~isequal(value, 'Sinusoidal') && ~isequal(value,'Fermi') && ~isequal(value,'Custom') && ~isequal(value,'Electrode') && ~isequal(value,'Driver') )%edit this to add more types
                error('Invalid Type. Must be Standard signal Type')
            else
                obj.Type = value;
                
            end
        end
        
        function obj = set.Amplitude(obj,value)
            
            if ~isnumeric(value)
                error('Invalid Type. Must be Standard signal Type')
            else
                obj.Amplitude = value;
                
            end            
        end
        
        function obj = set.Period(obj,value)
            if ~isnumeric(value)
                error('Invalid Type. Must be Standard signal Type')
            else
                obj.Period = value;
                
            end            
        end
        
        function obj = set.Wavelength(obj,value)
            if ~isnumeric(value)
                error('Invalid Type. Must be Standard signal Type')
            else
                obj.Wavelength = value;
                
            end            
        end
        
        function obj = set.Phase(obj,value)
            if ~isnumeric(value)
                error('Invalid Type. Must be Standard signal Type')
            else
                obj.Phase = value;
                
            end            
        end
        
        function obj = set.MeanValue(obj,value)
            if ~isnumeric(value)
                error('Invalid Type. Must be Standard signal Type')
            else
                obj.MeanValue = value;
                
            end            
        end
        
        function obj = set.Sharpness(obj,value)
            if ~isnumeric(value)
                error('Invalid Type. Must be Standard signal Type')
            else
                obj.Sharpness = value;
                
            end            
        end       
        
        function EField = getClockField(obj, centerposition, time)
            %THIS FUNCTION ONLY ASSIGNS z Field RIGHT NOW
            
            %centerposition = [0,0,0]; %uncomment this line if you want uniform clock field
            
            if( isnumeric(centerposition) )
                if(size(centerposition) == [1, 3])
                    EField = [0,0,0];
                    switch obj.Type
                        case 'Sinusoidal' 
                            EField(3)=( cos((2*pi*(centerposition(1)/obj.Wavelength - time/obj.Period ) )+ obj.Phase ) )*obj.Amplitude+ obj.MeanValue;
                            
                            
                        case 'Fermi'
                            EField(3) = obj.Amplitude * PeriodicFermi(mod(centerposition(1) - time - obj.Phase , obj.Period), obj.Period, obj.Sharpness) + obj.MeanValue;
                        
                        case 'Driver'
                            EField(2) = obj.Amplitude * PeriodicFermi(mod(centerposition(1) - time - obj.Phase , obj.Period), obj.Period, obj.Sharpness) + obj.MeanValue;
                            %EField(2) = ( cos((2*pi*(centerposition(1)/obj.Wavelength - time/obj.Period ) )+ obj.Phase ) )*obj.Amplitude+ obj.MeanValue;
                            
                        otherwise
                            error(['ClockType = ''', obj.Type, ...
                                ''' is invalid.'])
                            
                    end % END [ switch obj.Type ]
                    
                    
                    
                    
                    
                else
                    error('Incorrect data input size.')
                end
            else
                error('Incorrect data input type.')
            end
            
        end
        
        function EField = getInputField(obj, centerposition, time)
            if( isnumeric(centerposition) && isequal(size(centerposition), [1, 3]))
                
                centerposition = [0, 0, 0]; % force input signals to use same position for all nodes;
                EField = [0,0,0];
                switch obj.Type
                    case 'Sinusoidal'
                        %EField(2)=( cos((2*pi*(centerposition(1)/obj.Wavelength - time/obj.Period ) )+ obj.Phase ) )*obj.Amplitude+ obj.MeanValue;
                        
                        
                    case 'Fermi'
                        EField(2) = obj.Amplitude * PeriodicFermi(mod(centerposition(1) - time - obj.Phase , obj.Period), obj.Period, obj.Sharpness) + obj.MeanValue;
                    case 'Driver'
                        %EField(2) = obj.Amplitude * PeriodicFermi(mod(centerposition(1) - time - obj.Phase , obj.Period), obj.Period, obj.Sharpness) + obj.MeanValue;
                        %EField(2) = ( cos((2*pi*(centerposition(1)/obj.Wavelength - time/obj.Period ) )+ obj.Phase ) )*obj.Amplitude+ obj.MeanValue;
                        
                    otherwise
                        error(['ClockType = ''', obj.Type, ...
                            ''' is invalid.'])
                        
                end % END [ switch obj.Type ]
                
                
            else
                error('centerposition has incorrect data type or format')
            end %centerpos is correct input type and size
            
            
            
            
        end
        
        
        function obj = drawSignal(obj, varargin)
            
            
            
            if( strcmp('Sinusoidal', obj.Type) || strcmp('Fermi', obj.Type) )
                if nargin == 4
                    nx = 200;
                    xlims = varargin{1};
                    ylims = varargin{2};
                    t = varargin{3};
                    
                    xq = linspace(xlims(1), xlims(2), nx);
                    xp = mod(xq, obj.Period);
                    
                    yq = linspace(ylims(1), ylims(2), nx);
                    
                    for idx = 1:nx
                        efield_temp = obj.getClockField([xp(idx), 0, 0], t);
                        efield(idx) = efield_temp(3);
                    end %for
                    
                    
                    Eplot = repmat(efield,[nx,1]);
                    pcolor(xq' * ones(1, nx), ones(nx, 1)* yq, Eplot');
                    
                    
                    
                    
                    % Red column
                    temp7(:,1) = [ linspace(1,0,51) zeros(1,50) ]';
                    % Green column
                    temp7(:,2) = [ linspace(1,0,51) zeros(1,50)]';
                    % Blue column
                    temp7(:,3) = [ linspace(1, 0.5625, 51) 0.5625*ones(1, 50)]';
                    BlueWhite = temp7;
                    clear temp7
                    
                    
                    
                    
                    
                    colormap(BlueWhite);
                    shading interp;
                    colorbar;
                    caxis([-obj.Amplitude obj.Amplitude])
                    
                    %plot(xq,efield)
                    
                else
                    error('incorrect number of inputs for signal type')
                end %if nargin
                
                
                %case 'Fermi'
                
            elseif( 'Custom' )
                
            elseif( 'Planar')
                
            else
                
                
            end %end if
            
            
            
        end %drawSignalFunction
        
        
        function obj = drawElectrode(obj, varargin)
            if nargin > 2
                centerpos = varargin{1};
                height = varargin{2};
                width = varargin{3};
                Efield = varargin{4};
                
                
                
                obj.CenterPosition = centerpos;
                obj.Height = height;
                obj.Width = width;
                obj.InputField = Efield;
                
            else
                centerpos = obj.CenterPosition;
                height = obj.Height;
                width = obj.Width;
                Efield = obj.InputField;
                
                
            end
            if strcmp(obj.Type,'Electrode')
                
                %draw the text box showing the electric field, and
                %lower/upper patches to denote electrodes
                
                txt = text(centerpos(1) - width/2-.7 , centerpos(2) , [num2str(Efield) ' V/m']);
                
                if and(height ,width)
                    name = text(centerpos(1) + width/2 , centerpos(2)+height/2 , num2str(obj.Name));
                    
                elseif and(~height,width)
                    name = text(centerpos(1) + width/2 , centerpos(2)+.75 , num2str(obj.Name));
                    
                elseif and(height,~width)
                    name = text(centerpos(1) + .5 , centerpos(2)+height/2 , num2str(obj.Name));
                    
                else
                    name = text(centerpos(1) + .5 , centerpos(2)+.75, num2str(obj.Name));
                    
                end
                
                obj.TopPatch = patch('FaceColor','red','XData',[centerpos(1) - width/2-.25  centerpos(1) + width/2+.25  centerpos(1) + width/2+.25 centerpos(1) - width/2-.25]...
                    ,'YData',[centerpos(2)+ height/2+.75  centerpos(2)+height/2+.75  centerpos(2) + height/2+.95   centerpos(2) + height/2+.95]);
                
                obj.BottomPatch = patch('FaceColor','black','XData',[centerpos(1) - width/2-.25  centerpos(1) + width/2+.25   centerpos(1) + width/2+.25    centerpos(1) - width/2-.25]...
                    ,'YData',[centerpos(2)- height/2-.95  centerpos(2)-height/2-.95  centerpos(2) - height/2-.75   centerpos(2) - height/2-.75]);
                Select(obj.TopPatch);
                Select(obj.BottomPatch);
                
                x0 = centerpos(1) - width/2-.25;
                x1 = centerpos(1) + width/2+.25;
                
                if height == 0
                    low = centerpos(2) - .75;
                    high= centerpos(2) + .75;
                else
                    low = centerpos(2) - height/2-.75;
                    high= centerpos(2) + height/2+.75;
                end
                
                
                Efield;
                num=0;
                
                %intervals of E field magnitude to determine number of
                %electric field lines between the electrodes
                if  Efield > 8
                    num = (x1-x0)/20;
                    
                    for i=x0 : num : x1
                        
                        
                        p1 = [i low];
                        p2 = [i high];
                        dp = p2-p1;
                        
                        hold on;
                        q=quiver(p1(1),p1(2),dp(1),dp(2),0);
                        %                             q.LineWidth = 5;
                        q.MarkerEdgeColor = 'black';
                        q.Color = 'black';
                        p.Parent = gca;
                        
                    end
                    
                elseif Efield > 6 && Efield <= 8
                    num = (x1-x0)/20;
                    for i=x0 : num : x1
                        
                        p1 = [i low];
                        p2 = [i high];
                        dp = p2-p1;
                        
                        hold on;
                        q=quiver(p1(1),p1(2),dp(1),dp(2),0);
                        %                         q.LineWidth = 3;
                        q.MarkerEdgeColor = 'black';
                        q.Color = 'black';
                        p.Parent = gca;
                    end
                    
                elseif Efield > 4 && Efield <= 6
                    num = (x1-x0)/9;
                    for i=x0 : num : x1
                        
                        p1 = [i low];
                        p2 = [i high];
                        dp = p2-p1;
                        
                        hold on;
                        q=quiver(p1(1),p1(2),dp(1),dp(2),0);
                        %                         q.LineWidth = 2;
                        q.MarkerEdgeColor = 'black';
                        q.Color = 'black';
                        p.Parent = gca;
                    end
                    
                elseif Efield > 2 && Efield <= 4
                    num = (x1-x0)/5;
                    for i=x0 : num : x1
                        
                        p1 = [i low];
                        p2 = [i high];
                        dp = p2-p1;
                        
                        hold on;
                        q=quiver(p1(1),p1(2),dp(1),dp(2),0);
                        %                         q.LineWidth = 1;
                        q.MarkerEdgeColor = 'black';
                        q.Color = 'black';
                        p.Parent = gca;
                    end
                    
                    
                    
                elseif Efield <= 2 && Efield > 0
                    num = (x1-x0)/2;
                    for i=x0 : num : x1
                        
                        p1 = [i low];
                        p2 = [i high];
                        dp = p2-p1;
                        
                        hold on;
                        q=quiver(p1(1),p1(2),dp(1),dp(2),0);
                        %                         q.LineWidth = .1;
                        q.MarkerEdgeColor = 'black';
                        q.Color = 'black';
                        p.Parent = gca;
                    end
                    
                    
                elseif Efield >= -2 && Efield < 0
                    num = (x1-x0)/2;
                    for i=x0 : num : x1
                        
                        p1 = [i low];
                        p2 = [i high];
                        dp = p1-p2;
                        
                        hold on;
                        q=quiver(p2(1),p2(2),dp(1),dp(2),0);
                        %                         q.LineWidth = .1;
                        q.MarkerEdgeColor = 'black';
                        q.Color = 'black';
                        p.Parent = gca;
                    end
                    
                    
                    
                elseif Efield < -2 && Efield >= -4
                    num = (x1-x0)/5;
                    for i=x0 : num : x1
                        
                        p1 = [i low];
                        p2 = [i high];
                        dp = p1-p2;
                        
                        hold on;
                        q=quiver(p2(1),p2(2),dp(1),dp(2),0);
                        %                         q.LineWidth = 1;
                        q.MarkerEdgeColor = 'black';
                        q.Color = 'black';
                        p.Parent = gca;
                    end
                    
                elseif Efield < -4 && Efield >= -6
                    num = (x1-x0)/9;
                    for i=x0 : num : x1
                        
                        p1 = [i low];
                        p2 = [i high];
                        dp = p1-p2;
                        
                        hold on;
                        q=quiver(p2(1),p2(2),dp(1),dp(2),0);
                        %                         q.LineWidth = 2;
                        q.MarkerEdgeColor = 'black';
                        q.Color = 'black';
                        p.Parent = gca;
                    end
                    
                elseif Efield < -6 && Efield >= -8
                    num =(x1-x0)/15;
                    for i=x0 : num : x1
                        
                        p1 = [i low];
                        p2 = [i high];
                        dp = p1-p2;
                        
                        hold on;
                        q=quiver(p2(1),p2(2),dp(1),dp(2),0);
                        %                         q.LineWidth = 3;
                        q.MarkerEdgeColor = 'black';
                        q.Color = 'black';
                        p.Parent = gca;
                    end
                    
                elseif Efield < -8
                    num = (x1-x0)/20;
                    for i=x0 : num : x1
                        
                        p1 = [i low];
                        p2 = [i high];
                        dp = p1-p2;
                        
                        hold on;
                        q=quiver(p2(1),p2(2),dp(1),dp(2),0);
                        %                         q.LineWidth = 5;
                        q.MarkerEdgeColor = 'black';
                        q.Color = 'black';
                        p.Parent = gca;
                    end
                    
                elseif Efield == 0
                    
                    %don't draw E field lines
                    
                end
                
                %we must now change the order of the Children of
                %axes.Children so the arrows are behind the cell drawings
                num;
                num=(x1-x0)*num^(-1)+1; %interval multiplied by the inverse of the iteration length plus 1;
                
                ax=gca;
                
                graphicsList = get(ax,'children'); %list we are going to change
                newList = [];
                
                for j=1:num
                    newList(end+1)= graphicsList(j);%put all the arrows into the newList
                end
                
                set(ax,'children',[ax.Children(j+1:end); newList']); %the arrows are now at the end of the Children handle
                
                
                
                hold off;
            end
            
            myCircuit=getappdata(gcf,'myCircuit');
            
            for i=1:length(myCircuit.Device)
                if isa(myCircuit.Device{i},'QCASuperCell')
                    for j=1:length(myCircuit.Device{i}.Device)
                        circCenter = myCircuit.Device{i}.Device{j}.CenterPosition;
                        if circCenter(1) > centerpos(1) && circCenter(2) > centerpos(2) && circCenter(1) < centerpos(1)+width/2 && circCenter(2) > centerpos(2)+height/2
                            myCircuit.Device{i}.Device{j}.ElectricField = Efield;
                            
                        end
                    end
                else
                    
                    circCenter = myCircuit.Device{i}.CenterPosition;
                    if circCenter(1) > centerpos(1) && circCenter(2) > centerpos(2) && circCenter(1) < centerpos(1)+width/2 && circCenter(2) > centerpos(2)+height/2
                        myCircuit.Device{i}.ElectricField = [0 Efield 0];
                        
                    end
                end
                
            end
            
            
        end
        
    end
    
end

