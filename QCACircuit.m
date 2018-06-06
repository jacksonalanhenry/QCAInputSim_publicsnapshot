classdef QCACircuit
    % make a class "qca circuit" that contains cells and knows which ones are
    % neighbors. Should be able to individually save file without corrupting
    % the original program.
    
    properties
        Device = {}; % QCA CELL ARRAY
        RefinedDevice = {};
        GroundState = [];
        Mode='Simulation';
        
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

            
            if isa(newcell, 'QCASuperCell') 
                newcell = obj.Device{n_old+1}; %call just recently added supercell, newcell

                for x = 1:length(newcell.Device) % edit each subcell's CellID to reflect the supernode's integer
                    newcell.Device{x}.CellID = newcell.Device{x}.CellID + newcell.CellID;
                end
                obj.Device{n_old+1} = newcell;
                
                
            end
            
            
        end
        
        function obj = GenerateNeighborList( obj )
            %this function steps through each cell and assigns the neighborList for each

            
            %All CellID Array (including subcells)
            cellIDArray = [];
            
            idx = 1;
            for node = 1:length(obj.Device) %step through all the node/supernodes
                
                
                
                if(isa(obj.Device{node}, 'QCASuperCell')) %if supernode overwrite supernode ID with first subnode
                    for subnode = 1:length(obj.Device{node}.Device) %step through all subnodes
                        cellIDArray(idx) = obj.Device{node}.Device{subnode}.CellID;
                        cellpositions(idx,:) = obj.Device{node}.Device{subnode}.CenterPosition;
                        idx = idx + 1;
                    end
                else
                    cellIDArray(idx) = obj.Device{node}.CellID; %add the node
                    cellpositions(idx,:) = obj.Device{node}.CenterPosition;
                    idx = idx + 1;
                end
            end
            
            cellpositions = cellpositions';
            cellIDToplevelnodes = floor(cellIDArray);
            
            %now go through list of CellID's to find neighbors
            idx = 1;
            while idx <= length(cellIDArray)
                
                
                if(isa(obj.Device{cellIDToplevelnodes(idx)}, 'QCASuperCell')) %if supernode overwrite supernode ID with first subnode
                    superCellID = obj.Device{cellIDToplevelnodes(idx)}.CellID;

                    for subnode = 1:length(obj.Device{superCellID}.Device)

                        
                        c = obj.Device{superCellID}.Device{subnode}.CellID;
                        
                        %shift and find magnitudes
                        shifted = cellpositions - repmat(cellpositions(:,idx),1,length(cellIDArray));
                        shifted = shifted.^2;
                        shifted = sum(shifted,1);
                        
                        %give me the cellid's of the node within a certain limit
                        neighbors = cellIDArray(shifted < 5.01 & shifted > 0);
                        

                        
                        
                        
%                         disp(['id: ' num2str(c) ' neighbors: ' num2str(neighbors)])
                        obj.Device{superCellID}.Device{subnode}.NeighborList = neighbors;
                        
                        
                        idx = idx+1;
                    end
                    
                    
                else
                    %shift and find magnitudes
                    shifted = cellpositions - repmat(cellpositions(:,idx),1,length(cellIDArray));
                    shifted = shifted.^2;
                    shifted = sum(shifted,1);
                    
                    %give me the cellid's of the node within a certain limit
                    neighbors = cellIDArray(shifted < 5.01 & shifted > 0);
                    
                    
                    c= obj.Device{cellIDToplevelnodes(idx)}.CellID;
                    
%                     disp(['id: ' num2str(c) ' neighbors: ' num2str(neighbors)])
                    obj.Device{cellIDToplevelnodes(idx)}.NeighborList = neighbors;

                    idx = idx+1;
                end
                
                
                
            end
            

        end
        
        function obj = CircuitDraw(obj, targetAxes)
            cla;
            hold on
            CellIndex = length(obj.Device);
%              obj.Device{CellIndex} = obj.Device{CellIndex}.BoxDraw();
            for CellIndex = 1:length(obj.Device)

                if( isa(obj.Device{CellIndex}, 'QCASuperCell') )
                    colors= ['blue' 'green' 'red' 'cyan' 'magenta' 'yellow' 'black']; 
                    chosencolor = colors(randi(abs(6))+1)
                    for subnode = 1:length(obj.Device{CellIndex}.Device)
                        
                        obj.Device{CellIndex}.Device{subnode} = obj.Device{CellIndex}.Device{subnode}.ThreeDotElectronDraw();
                        obj.Device{CellIndex}.Device{subnode} = obj.Device{CellIndex}.Device{subnode}.BoxDraw();
                        obj.Device{CellIndex}.Device{subnode}.SelectBox.Selected = 'off'; 
                        obj.Device{CellIndex}.Device{subnode}.SelectBox.FaceAlpha = .01;
                        obj.Device{CellIndex}.Device{subnode}.SelectBox.EdgeColor = chosencolor;
                        obj.Device{CellIndex}.Device{subnode}.SelectBox.LineWidth = 1.2;
                        Select(obj.Device{CellIndex}.Device{subnode}.SelectBox);
                    end
                else
              
                    
                    obj.Device{CellIndex} = obj.Device{CellIndex}.ThreeDotElectronDraw();
                    obj.Device{CellIndex} = obj.Device{CellIndex}.BoxDraw();
                    obj.Device{CellIndex}.SelectBox.Selected = 'off';
                    obj.Device{CellIndex}.SelectBox.FaceAlpha = .01;
                    
                    Select(obj.Device{CellIndex}.SelectBox);
                end

            end
            
            hold off
            grid on
        end
        
        function obj = LayoutDraw(obj, targetAxes)
            cla;
            hold on
            CellIndex = length(obj.Device);
            %              obj.Device{CellIndex} = obj.Device{CellIndex}.BoxDraw();
            for CellIndex = 1:length(obj.Device)
                obj.Device{CellIndex} = obj.Device{CellIndex}.LayoutModeDraw();                
            end
            
            it=length(obj.Device); %throwing every cell into the select function
            for i=1:it
                Select(obj.Device{i}.LayoutBox);
            end
            
%             hold off
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
            %Iterate to Selfconsistency
            
            NewCircuitPols = ones(1,length(obj.Device));
            converganceTolerance = 1;
            
            while (converganceTolerance > 0.001)
                OldCircuitPols = NewCircuitPols;
                
                idx = 1;
                while idx <= length(obj.Device)
                    
                    if( isa(obj.Device{idx}, 'QCASuperCell') )
                        
                        
                        NewPols = ones(1,length(obj.Device{idx}.Device));
                        subnodeTolerance = 1;
                        
                        while (subnodeTolerance > 0.001)
                            OldPols = NewPols;
                            
                            supernode = floor(obj.Device{idx}.Device{1}.CellID);
                            
                            for subnode = 1:length(obj.Device{supernode}.Device)
                                
                                if( strcmp(obj.Device{supernode}.Device{subnode}.Type, 'Driver') )
                                    %don't relax
                                else
                                    
                                    id = obj.Device{supernode}.Device{subnode}.CellID;
                                    nl = obj.Device{supernode}.Device{subnode}.NeighborList;
                                    pol = obj.Device{supernode}.Device{subnode}.Polarization;
                                    
                                    %get Neighbor Objects
                                    nl_obj = obj.getCellArray(nl);
                                    
                                    %get hamiltonian for current cell
                                    hamiltonian = obj.Device{supernode}.Device{subnode}.GetHamiltonian(nl_obj);
                                    obj.Device{supernode}.Device{subnode}.Hamiltonian = hamiltonian;
                                    
                                    %calculate polarization
                                    obj.Device{supernode}.Device{subnode} = obj.Device{supernode}.Device{subnode}.Calc_Polarization_Activation();
                                    
                                    NewPols(subnode) = obj.Device{supernode}.Device{subnode}.Polarization;
                                    %disp(['id: ', num2str(id), ' pol: ', num2str(pol)]) %, ' nl: ', num2str(nl)
                                    
                                end
                                
                            end
                            
                            deltaPols = OldPols - NewPols;
                            subnodeTolerance = max(abs(deltaPols));
                            
                        end
                        
                        idx=idx+1;
                        
                    else
                        %obj.Device{idx} = obj.Device{idx}.Calc_Polarization_Activation();
                        id = obj.Device{idx}.CellID;
                        nl = obj.Device{idx}.NeighborList;
                        pol = obj.Device{idx}.Polarization;
                        
                        %get Neighbor Objects
                        nl_obj = obj.getCellArray(nl);
                        
                        %get hamiltonian for current cell
                        hamiltonian = obj.Device{idx}.GetHamiltonian(nl_obj);
                        obj.Device{idx}.Hamiltonian = hamiltonian;
                        
                        %calculate polarization
                        obj.Device{idx} = obj.Device{idx}.Calc_Polarization_Activation();
                        
                        if(isa(obj.Device{idx}, 'QCASuperCell'))
                            NewCircuitPols(idx) = 0;
                        else
                            NewCircuitPols(idx) = obj.Device{idx}.Polarization;
                        end
                        %disp(['id: ', num2str(id), ' pol: ', num2str(pol)]) %, ' nl: ', num2str(nl)
                        
                        idx = idx+1;
                    end
                    
                    
                end
                
                
                deltaCircuitPols = OldCircuitPols - NewCircuitPols;
                converganceTolerance = max(abs(deltaCircuitPols));
                
                
            end
            
        end
        
        function cell_obj = getCellArray(obj, CellIDArray)
            %this function returns an array of QCACell objects given a list
            %of IDs
            
            for idx = 1:length(CellIDArray)
                if floor(CellIDArray(idx)) ~= CellIDArray(idx)
                    superID = floor(CellIDArray(idx));
                    subID = round((CellIDArray(idx)-superID)*100);
                    cell_obj{idx} = obj.Device{superID}.Device{subID};
                    
                else
                    cell_obj{idx} = obj.Device{CellIDArray(idx)}; 
                end
                
                
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

