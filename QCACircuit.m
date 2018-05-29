classdef QCACircuit
    % make a class "qca circuit" that contains cells and knows which ones are
    % neighbors. Should be able to individually save file without corrupting
    % the original program.
    
    properties
        Device = {}; % QCA CELL ARRAY
        RefinedDevice = {};
        GroundState = [];
        LayoutMode='';
        
    end
    
    methods
        function obj = QCACircuit( varargin ) % constructor class
            
            if nargin > 0
                placeholder = obj.Device;
                obj.Device = {placeholder varargin};
                
            else
                % Nothing happens
                
            end
            
        end
        
        function obj = addNode( obj, newcell )
            n_old = length(obj.Device);
            obj.Device{n_old+1} = newcell;
            obj.Device{n_old+1}.CellID = length(obj.Device);
            
        end
        
        function NeighborCheck( obj ) %Checks for each cell
            
            obj.RefinedDevice = obj.Device;
            for n = 1:length(obj.Device)
                normarray = [];
                Stationary = obj.Device{n};
                
                for m = 1:length(obj.Device)
                    if m ~= n
                        Comparison = obj.Device{m};
                        normarray(m) = norm(Stationary.CenterPosition - Comparison.CenterPosition);
                        
                        
                    end
                end
                SmallestNorm = find(normarray == min(normarray)); %returns indicie of smallest normalized vector
                obj.RefinedDevice{n+1} = obj.Device{SmallestNorm};
                
            end
            
        end         
        
        
        function obj = GenerateNeighborList( obj )
            %this function steps through each cell and assigns the neighborList for each
            
            for node = 1:length(obj.Device)%go through each node
                for checknode = 1:length(obj.Device)%compare against every node
                    if(obj.Device{node}.CellID ~= obj.Device{checknode}.CellID) %don't check yourself
                        
                        nodePos = obj.Device{node}.CenterPosition;
                        checknodePos = obj.Device{checknode}.CenterPosition;
                        a = obj.Device{node}.CharacteristicLength;
                        
                        vector = checknodePos - nodePos;
                        vector = vector.^2;
                        magnitude = sum(vector);
                        
                        
                        if( magnitude <= 5.01*a)
                            l = length(obj.Device{node}.NeighborList);
                            obj.Device{node}.NeighborList(l+1) = obj.Device{checknode}.CellID;
                            
                        end
                            
                        end %dont check self
                    end %checknodeloop

                end %nodeloop
                
                
            end
            
            function obj = CircuitDraw(obj, targetAxes)
                hold on
                for CellIndex = 1:length(obj.Device)
                    obj.Device{CellIndex} = obj.Device{CellIndex}.ThreeDotElectronDraw();
                    
                end
                
                hold off
            end
            
            %reference this based on CellId
            function sref = subsref(obj,s)
                % obj(index) is the same as obj.Device(index)
                
                switch s(1).type
                    case '.'
                        sref = builtin('subsref',obj,s);
                    case '()'
                        
                        if length(s) < 2
                            s.type = '{}';
                            sref = builtin('subsref',obj.Device,s);
                            return
                        else
                            s(1).type = '{}';
                            sref = builtin('subsref',obj.Device,s);
                        end
                    case '{}'
                        if length(s) < 2
                            sref = builtin('subsref',obj.Device,s);
                            return
                        else
                            sref = builtin('subsref',obj,s);
                        end
                end
            end
            
            %assign this based on CellId
            function obj = subasgn(obj,s,val)
                if isempty(s) && isa(val,'QCACircuit')
                    obj = QCACircuit(val.Device,val.Description);
                end
                switch s(1).type
                    case '.'
                        obj = builtin('subsasgn',obj,s,val);
                    case '()'
                        
                    case '{}'
                        if length(s)<2
                            if isa(val,'QCACircuit')
                                error('Error: Invalid Indexing')
                            elseif isa(val,'double')
                                % Redefine the struct s to make the call: obj.Device(i)
                                snew = substruct('.','Device','()',s(1).subs(:));
                                obj = subsasgn(obj,snew,val);
                            end
                        end
                end
            end
            
            function obj = Relax2GroundState(obj)
                %iterate to self consistent instantaeous ground state
                
                NewPolarization = ones(1,length(obj.Device));
                
                converganceTolerance = 1;
                while(converganceTolerance > 0.001)
                    OldPolarization = NewPolarization;
                    
                    for x = 1:length(obj.Device)
                        
                        if( strcmp(obj.Device{x}.Type , 'Driver' ))
                            %don't try to relax this cell
                        else
                            %relax
                            
                            neighborList = obj.Device(obj.Device{x}.NeighborList);
                            %calculate hamiltonian
                            hamiltonian = obj.Device{x}.GetHamiltonian(neighborList);
                            obj.Device{x}.Hamiltonian = hamiltonian;
                            %calculate Polarization and Activation of Cells in
                            %Circuit
                            obj.Device{x} = obj.Device{x}.Calc_Polarization_Activation();
                            
                        end
                        NewPolarization(x) = abs(obj.Device{x}.Polarization);
                        %DeltaPolarization(x) = DeltaPolarization(x) - abs(obj.Device{x}.Polarization)
                        
                    end
                    
                    DeltaPolarization = OldPolarization - NewPolarization;
                    converganceTolerance = max(abs(DeltaPolarization));
                    
                    
                end
                
            end
            
            function obj = pipeline(obj,varargin)
                %Create E
                Eo = 0.4217;% qe^2*(1.602e-19)/(4*pi*epsilon_0*a)*(1-1/sqrt(2));
                
                c = 3e8;
                fs = 3012;  % Sampling frequency (samples per second)
                dt = 1/fs;  % seconds per sample
                T = 100/fs; % how long do you want to play sinewave
                lambda = 50*obj.Device{1}.CharacteristicLength;
                
                tt = 0:dt:T;
                d = 1.5*Eo/2*(sin(2*pi*c/lambda*tt)-1);
                frames = length(tt);
                E = zeros(frames,3);
                E(:,3) = d;
                
                myaxis = axes; %%%%%%%%%%%%%%%THIS IS CHEATING
                
                Frame(frames) = struct('cdata',[],'colormap',[]);
                v = VideoWriter('sinusoidUniformEField.mp4','MPEG-4');
                open(v);
                for t = 1:frames %time step
                    
                    %edit Efield for all cells in circuit
                    for x = 1:length(obj.Device)
                        obj.Device{x}.ElectricField(2) = E(t,2); %changes Ey Field.
                        obj.Device{x}.ElectricField(3) = E(t,3); %changes Ez Field.
                    end
                    
                    %relax2Groundstate
                    obj = obj.Relax2GroundState();
                    
                    %visualize
                    obj.CircuitDraw(myaxis);
                    drawnow
                    %save it
                    Frame(t) = getframe(gcf);
                    writeVideo(v,Frame(t));
                end %time step loop
                
                
                fig = figure;
                movie(fig,Frame,1)
                close(v);
                
                
            end
            
        end
        
    end
    
