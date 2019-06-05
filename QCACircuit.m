classdef QCACircuit
    % make a class "qca circuit" that contains cells and knows which ones are
    % neighbors. Should be able to individually save file without corrupting
    % the original program.
    
    %%
    properties
        Device = {}; % QCA CELL ARRAY
        RefinedDevice = {};
        GroundState = [];
        Mode='Simulation';
        SnapToGrid = 'off';
        Simulating = 'off';
    end
    %%
    methods
        %%
        function obj = QCACircuit( varargin ) % constructor class
            
            if nargin > 0
                placeholder = obj.Device;
                obj.Device = {placeholder varargin};
                
            else
                % Nothing happens
                
            end
            
        end
        %%
        function obj = addNode( obj, newcell )
            n_old = length(obj.Device);
            ids=[];
            
            if length(obj.Device)
                ids = obj.GetCellIDs(obj.Device);
            end
            
            obj.Device{n_old+1} = newcell;
            obj.Device{n_old+1}.CellID = length(obj.Device);
            
            
            
            if length(ids)
                for i=1:n_old  %ensuring that CellIDs cannot be repeated
                    
                    
                    compare = (obj.Device{n_old+1}.CellID==floor(ids));
                    maxID = floor(max(ids));
                    if sum(compare)>0
                        obj.Device{n_old+1}.CellID = maxID +1;
                    end
                    
                end
            end
            compare = (obj.Device{n_old+1}.CellID==ids);
            ids = obj.GetCellIDs(obj.Device);
            
            newIDs = obj.GetCellIDs(obj.Device);
            if isa(newcell, 'QCASuperCell')
                newcell = obj.Device{n_old+1}; %call just recently added supercell, newcell
                
                for x = 1:length(newcell.Device) % edit each subcell's CellID to reflect the supernode's integer
                    newcell.Device{x}.CellID = newcell.Device{x}.CellID + newcell.CellID;
                end
                obj.Device{n_old+1} = newcell;
                
                
            end
            
            
        end
        %%
        function obj = GenerateNeighborList( obj )
            %this function steps through each cell and assigns the neighborList for each
            
            %All CellID Array (including subcells)
            cellIDArray = [];
            cellpositions=[];
            
            
            node = 1;
            for node=1:length(obj.Device)
                if(isa(obj.Device{node}, 'QCASuperCell'))
                    for subnode = 1:length(obj.Device{node}.Device)
                        cellpositions(end+1,:) = obj.Device{node}.Device{subnode}.CenterPosition;
                        
                    end
                    
                else
                    cellpositions(end+1,:) = obj.Device{node}.CenterPosition;
                    
                end
                
            end
            
            cellIDArray = obj.GetCellIDs(obj.Device);
            cellpositions = cellpositions';
            
            cellIDToplevelnodes = floor(cellIDArray);
            
            
            %now go through list of CellID's to find neighbors
            
            
            cellposit = 1;
            for idx=1:length(obj.Device)
                idx;
                
                
                
                %                 cellIDToplevelnodes(idx);
                %                 max(cellIDToplevelnodes);
                
                leng = length(obj.Device);
                
                
                if(isa(obj.Device{idx}, 'QCASuperCell')) %if supernode overwrite supernode ID with first subnode
                    superCellID = obj.Device{idx}.CellID;
                    
                    len=length(obj.Device{idx}.Device);
                    
                    for subnode = 1:length(obj.Device{idx}.Device)
                        
                        subnode;
                        c = obj.Device{idx}.Device{subnode}.CellID;
                        cellpositions(:,idx+subnode-1);
                        %shift and find magnitudes  idx+subnode-1
                        shifted = cellpositions - repmat(cellpositions(:,cellposit),1,length(cellIDArray));
                        shifted = shifted.^2;
                        shifted = sum(shifted,1);
                        shifted = shifted.^(.5);
                        
                        
                        %give me the cellid's of the node within a certain
                        %limit. Limit depends on object type
                        switch class(obj.Device{idx}.Device{subnode})
                            case 'ThreeDotCell'
                                neighbors = cellIDArray(shifted < 2.25 & shifted > 0.1); %or 2.25
                            case 'SixDotCell'
                                neighbors = cellIDArray(shifted < 4.1 & shifted > 0.1); %or 2.25
                        end
                        
                        
                        
                        
                        
                        %                         disp(['id: ' num2str(c) ' neighbors: ' num2str(neighbors)])
                        
                        %                             newNeighbors=[];
                        %                             first = neighbors
                        %                            for i=1:length(neighbors)
                        %                                if neighbors(i) ~= obj.Device{idx}.Device{subnode}.CellID
                        %                                     newNeighbors(end+1) = neighbors(i);
                        %                                end
                        %                            end
                        %
                        %
                        %                            neighbors = newNeighbors
                        
                        obj.Device{idx}.Device{subnode}.NeighborList = neighbors;
                        cellposit = cellposit+1;
                    end
                    %                     idx = idx+length(obj.Device{idx}.Device);
                    
                else
                    %shift and find magnitudes
                    
                    
                    
                    shifted = cellpositions - repmat(cellpositions(:,cellposit),1,length(cellIDArray));
                    shifted = shifted.^2;
                    shifted = sum(shifted,1);
                    shifted = shifted.^(.5);
                    
                    %give me the cellid's of the node within a certain limit
                    id = obj.Device{idx}.CellID;
                    
                    switch class(obj.Device{idx})
                        case 'ThreeDotCell'
                            neighbors = cellIDArray(shifted < 2.25 & shifted > 0.1); %or 2.25
                        case 'SixDotCell'
                            neighbors = cellIDArray(shifted < 4.1 & shifted > 0.1); %or 2.25
                    end
                    
                    
                    %                     disp(['id: ' num2str(id) ' neighbors: ' num2str(neighbors)])
                    obj.Device{idx}.NeighborList = neighbors;
                    cellposit = cellposit+1;
                    
                end
                
                
                
                
            end
            
            
        end
        %%
        function obj = CircuitDraw(obj,time,targetaxis,varargin)
            %cla;
            
            
            hold on
            CellIndex = length(obj.Device);
            snapmode = obj.SnapToGrid;
            
            if length(varargin) == 1
                polact = varargin{1};
                pols = polact(1,:);
                acts = polact(2,:);
                
                it = 1;
                % format for iterating through circuit
                for idx=1:length(obj.Device)
                    if isa(obj.Device{idx},'QCASuperCell')
                        for sub=1:length(obj.Device{idx}.Device)
                            %assign pol and act
                            obj.Device{idx}.Device{sub}.Polarization = pols(it);
                            obj.Device{idx}.Device{sub}.Activation = acts(it);
                            it = it + 1;
                        end
                        
                    else
                        %assign pol and act
                        obj.Device{idx}.Polarization = pols(it);
                        obj.Device{idx}.Activation = acts(it);
                        it = it + 1;
                    end
                end
                
                
            elseif length(varargin) > 1
                error('Too many arguments')
                
                
            end
            %normal functionality
            
            switch snapmode %snapping to grid mode
                case 'off' %do nothing extra
                    
                case 'on' %begin snapping each cell to the grid, skipping every .5
                    obj = obj.Snap2Grid();
                    
            end %end snap to grid
            
            
            obj = obj.AntiOverlap();
            
            if strcmp(obj.Simulating,'off')
                cla;
                
            end
            
            
            
            for CellIndex = 1:length(obj.Device)
                if( isa(obj.Device{CellIndex}, 'QCASuperCell') )
                    
                    %check to see if there is a color for the SC
                    if strcmp(obj.Device{CellIndex}.BoxColor,'')
                        
                        %We make a cell array of all colors that have been
                        %used
                        colors=0;
                        for j=1:length(obj.Device)
                            if isa(obj.Device{j},'QCASuperCell') && ~isempty(obj.Device{j}.BoxColor) && j~= CellIndex
                                colors =  colors+1;
                            end
                            
                        end
                        
                        if colors>0
                            id = floor(obj.Device{CellIndex}.Device{1}.CellID);
                            
                            color(1)= abs(sin(.4*id*now/100000-id));
                            color(3)= abs(sin(colors*id-(id^2))*abs(cos(id)));
                            color(2)= abs(cos(colors*id + id*(id-1)*now/100000));
                            
                            obj.Device{CellIndex}.BoxColor=color;
                        else
                            obj.Device{CellIndex}.BoxColor=[rand rand rand]; %the color will remain the same for the same super cell
                        end
                        
                    else
                        %don't make a new color
                    end
                    
                    for subnode = 1:length(obj.Device{CellIndex}.Device)
                        
                        obj.Device{CellIndex}.Device{subnode} = obj.Device{CellIndex}.Device{subnode}.ElectronDraw(time,targetaxis);
                        %obj.Device{CellIndex}.Device{subnode} = obj.Device{CellIndex}.Device{subnode}.ColorDraw(targetaxis);
                        obj.Device{CellIndex}.Device{subnode} = obj.Device{CellIndex}.Device{subnode}.BoxDraw();
                        obj.Device{CellIndex}.Device{subnode}.SelectBox.Selected = 'off';
                        %obj.Device{CellIndex}.Device{subnode}.SelectBox.EdgeColor = obj.Device{CellIndex}.BoxColor; %turns on and off the supercell color
                        obj.Device{CellIndex}.Device{subnode}.SelectBox.LineWidth = 3;
                        Select(obj.Device{CellIndex}.Device{subnode}.SelectBox);
                    end
                else
                    
                    %obj.Device{CellIndex} = obj.Device{CellIndex}.ElectronDraw(time,targetaxis);
                    obj.Device{CellIndex} = obj.Device{CellIndex}.ColorDraw(targetaxis);
                    obj.Device{CellIndex} = obj.Device{CellIndex}.BoxDraw();
                    obj.Device{CellIndex}.SelectBox.Selected = 'off';
                    %obj.Device{CellIndex}.SelectBox.FaceAlpha = .01;
                    
                    Select(obj.Device{CellIndex}.SelectBox);
                    
                end
                
            end
            
            RightClickThings();   %uicontextmenu available upon drawing
            
            hold off
            grid on
            
            %DrawElectrodes();
            
            axis equal
            
        end
        %%
        function obj =  AntiOverlap(obj)
            %             clc;
            IDList = obj.GetCellIDs(obj.Device);
            cellList = obj.getCellArray(IDList);
            
            
            
            
            diffs=[];
            
            for i=1:length(cellList)
                for j=1:length(cellList)%j=length(cellList):-1:i+1
                    if i~=j
                        diffs(1,end+1) = cellList{i}.CenterPosition(1) - cellList{j}.CenterPosition(1);
                        diffs(2,end) = cellList{i}.CenterPosition(2) - cellList{j}.CenterPosition(2);
                        diffs(3,end) = cellList{i}.CellID;
                        
                    end
                end
            end
            
            
            diffs;
            sizeof = size(diffs);
            
            OL=[];
            overlap = 0;
            for i=1:sizeof(2)
                if abs(diffs(1,i)) < .499 && abs(diffs(2,i)) < 1.499
                    overlap = overlap +1;
                    OL(end+1) = diffs(3,i);
                    
                end
            end
            
            
            for i=1:length(obj.Device)
                if isa(obj.Device{i},'QCASuperCell')
                    
                    for j=1:length(obj.Device{i}.Device)
                        
                        if sum(obj.Device{i}.Device{j}.CellID == OL) > 0
                            obj.Device{i}.Device{j}.Overlapping = 'on';
                            
                        else
                            obj.Device{i}.Device{j}.Overlapping = 'off';
                            
                        end
                        
                        
                        
                        
                    end
                    
                else
                    
                    if sum(obj.Device{i}.CellID == OL) > 0
                        
                        obj.Device{i}.Overlapping = 'on';
                        
                    else
                        
                        obj.Device{i}.Overlapping = 'off';
                        
                    end
                    obj.Device{i}.CellID;
                    obj.Device{i}.Overlapping;
                end
            end
        end
        %%
        function sref = subsref(obj,s) %reference this based on CellId
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
        
        %%
        function obj = subasgn(obj,s,val)%assign this based on CellId
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
        
        
        %%
        function all_energy = calculateEnergy( obj, time, varargin )
            
            % use varargin to add in Clock Field Biases
            
            all_energy = zeros(length(obj.Device),1);
            for nodeIdx = 1:length(obj.Device)
                
                nl = obj.Device{nodeIdx}.NeighborList;
                nl_obj = obj.getCellArray(nl);
                
                node = obj.Device{nodeIdx};
                
                objDotpotential = zeros(size(node.DotPosition,1),1);
                objDotPosition = node.getDotPosition();
                mobileCharges = node.getMobileCharge(time);
                node_energy = zeros(length(nl_obj),1);
                
                for neighborIdx = 1:length(nl_obj)
                    for x = 1:length(objDotPosition)
                        %V_neighbors(x,:) = obj2.Potential( objDotPosition(x,:), time );
                        potential_energy = nl_obj{neighborIdx}.Potential( objDotPosition(x,:), time );
                        
                        node_energy(neighborIdx) = node_energy(neighborIdx) + potential_energy*mobileCharges(x);
                    end
                    
                    
                end
                
                all_energy(nodeIdx) = sum(node_energy);
                
                
                
            end
            
            
        end
        
        
        
        %%
        function obj = Relax2GroundState(obj, time, varargin)
            
            %Iterate to Self consistency
            
            if length(varargin) == 1
                disp(num2str(varargin{1}))
            end
            
            NewCircuitPols = ones(1,length(obj.Device));
            converganceTolerance = 1;
            sub = 1;
            chi = 0.6;
            it=1;
            oldmit = 5;
            while (converganceTolerance > 0.1 ) %&& it < 600
                if(it > 500)
                    
                    newmit = fix(it/100);
                    if newmit > oldmit
                        chi = chi - 0.1 % or multiply by 0.9
                    end
                    
                    if chi <= 0
                        chi = 0.1
                    end
                    oldmit = newmit;
                end
                
                
                OldCircuitPols = NewCircuitPols;
                
                idx = 1;
                
                while idx <= length(obj.Device)
                    
                    if( isa(obj.Device{idx}, 'QCASuperCell') )
                        
                        NewPols = ones(1,length(obj.Device{idx}.Device));
                        subnodeTolerance = 1;
                        super = 1;
                        
                        
                        while (subnodeTolerance > 0.00001)
                            OldPols = NewPols;
                            
                            %supernode = floor(obj.Device{idx}.Device{1}.CellID)
                            
                            
                            L=length(obj.Device);
                            for subnode = 1:length(obj.Device{idx}.Device)
                                
                                if( strcmp(obj.Device{idx}.Device{subnode}.Type, 'Driver') )
                                    %don't relax
                                else
                                    
                                    id = obj.Device{idx}.Device{subnode}.CellID;
                                    nl = obj.Device{idx}.Device{subnode}.NeighborList;
                                    pol = obj.Device{idx}.Device{subnode}.Polarization;
                                    %disp(['id: ', num2str(id),' nl: ', num2str(nl)  ,' pol: ', num2str(pol)])
                                    
                                    if length(varargin) == 1
                                        obj.Device{idx}.Device{subnode}.ElectricField(3) = varargin{1};
                                    end
                                    
                                    if ~isempty(nl)
                                        
                                        %get Neighbor Objects
                                        
                                        nl_obj = obj.getCellArray(nl);
                                        
                                        %get hamiltonian for current cell
                                        hamiltonian = obj.Device{idx}.Device{subnode}.GetHamiltonian(nl_obj, time);
                                        
                                        obj.Device{idx}.Device{subnode}.Hamiltonian = hamiltonian;
                                        
                                        
                                        [V, EE] = eig(hamiltonian);
                                        newpsi = V(:,1);
                                        
                                        normpsi = (1-chi)*obj.Device{idx}.Device{subnode}.Wavefunction + chi*newpsi;
                                        normpsi = normalize_psi_1D(normpsi');
                                        
                                        
                                        %calculate polarization
                                        obj.Device{idx}.Device{subnode} = obj.Device{idx}.Device{subnode}.Calc_Polarization_Activation(normpsi');
                                        
                                        NewPols(subnode) = obj.Device{idx}.Device{subnode}.Polarization;
                                        
                                        
                                        % disp(['id: ', num2str(id), ' pol: ', num2str(pol)]) %, ' nl: ', num2str(nl)
                                    else
                                        disp('potential room for thinking')%else nl is empty
                                    end
                                    
                                end
                                
                            end
                            
                            deltaPols = abs(OldPols) - abs(NewPols);
                            subnodeTolerance = max(abs(deltaPols));
                            super = super + 1;
                        end
                        
                        idx=idx+1;
                        
                        
                    else
                        %obj.Device{idx} = obj.Device{idx}.Calc_Polarization_Activation();
                        id = obj.Device{idx}.CellID;
                        nl = obj.Device{idx}.NeighborList;
                        pol = obj.Device{idx}.Polarization;
                        if length(varargin) == 1
                            obj.Device{idx}.ElectricField(3) = varargin{1};
                        end
                        
                        if ~isempty(nl)
                            
                            
                            
                            %get Neighbor Objects
                            nl_obj = obj.getCellArray(nl);
                            
                            
                            %get hamiltonian for current cell
                            hamiltonian = obj.Device{idx}.GetHamiltonian(nl_obj,time);
                            obj.Device{idx}.Hamiltonian = hamiltonian;
                            
                            %get the new groundstate, average and normalize
                            %the current groundstate and the new
                            %groundstate then calculate pol with that psi
                            [V, EE] = eig(hamiltonian);
                            newpsi = V(:,1);
                            
                            
                            
                            normpsi = (1-chi)*obj.Device{idx}.Wavefunction + chi*newpsi;
                            normpsi = normalize_psi_1D(normpsi');
                            
                            
                            
                            %calculate polarization
                            obj.Device{idx} = obj.Device{idx}.Calc_Polarization_Activation(normpsi');
                            
                            if(isa(obj.Device{idx}, 'QCASuperCell'))
                                NewCircuitPols(idx) = 0;
                            else
                                NewCircuitPols(idx) = obj.Device{idx}.getPolarization(time);
                            end
                            
                            %disp(['id: ', num2str(id), ' pol: ', num2str(pol)  ' nl: ', num2str(nl)])
                            
                        end
                        idx = idx+1;
                    end
                    
                    
                end
                %                 fprintf('\n');
                deltaCircuitPols = abs(OldCircuitPols) - abs(NewCircuitPols);
                [converganceTolerance, cellindex] = max(abs(deltaCircuitPols));
                
                sub=sub+1;
                it=it+1;
            end
            %disp(['it:', num2str(it)]);
        end
        
                
        
          
        %%
%         function obj = Relax2GroundState_mobilecharge(obj, time, varargin)
%             
%             
%                         %optional changes
%             args = varargin(1:end);
%             while length(args) >= 2
%                 prop = args{1};
%                 val = args{2};
%                 args = args(3:end);
%                 switch prop
%                     case 'randomizedRelaxation'
%                         randFlag = val;
%                         %disp(['randomized' num2str(1)])
%                     otherwise
%                         error(['QCACircuit.pipeline ', prop, ' is an invalid property specifier.']);
%                 end
%             end
%             
%             
%             %Iterate to Self consistency
%             
%             if length(varargin) == 1
%                 disp(num2str(varargin{1}))
%             end
%             
%             NewMobileCharges = zeros(6,length(obj.Device));
%             converganceTolerance = 1;
%             sub = 1;
%             chi = 0.6;
%             it=1;
%             oldmit = 5;
%             while (converganceTolerance > 0.001 ) %&& it < 600
%                 if(it > 500)
%                     
%                     newmit = fix(it/100);
%                     if newmit > oldmit
%                         chi = chi * 0.9; % or multiply by 0.9
%                     end
%                     
%                     if chi <= 0
%                         chi = 0.1;
%                     end
%                     oldmit = newmit;
%                 end
%                 
%                 
%                 OldMobileCharges = NewMobileCharges;
% 
%                 
%                 idx = 1;
%                 
%                 r = 1:length(obj.Device);
%                 if randFlag
%                     r = rand(1,length(obj.Device));
%                 end
%                 circuit_idx = 1:length(obj.Device);
%                 [~,s] = sort(r);
%                 circuit_idx_random = circuit_idx(s);
%                 
%                 
%                 while idx <= length(obj.Device)
%                     
%                     if( isa(obj.Device{circuit_idx_random(idx)}, 'QCASuperCell') )
%                         
%                         NewPols = ones(1,length(obj.Device{circuit_idx_random(idx)}.Device));
%                         NewCharges = zeros(6,length(obj.Device{circuit_idx_random(idx)}.Device));
% 
%                         subnodeTolerance = 1;
%                         super = 1;
%                         
%                         
%                         while (subnodeTolerance > 0.01)
%                             OldPols = NewPols;
%                             OldCharges = NewCharges;
%                                                         
%                             
%                             for subnode = 1:length(obj.Device{circuit_idx_random(idx)}.Device)
%                                 
%                                 if( strcmp(obj.Device{circuit_idx_random(idx)}.Device{subnode}.Type, 'Driver') )
%                                     %don't relax
%                                 else
%                                     
%                                     id = obj.Device{circuit_idx_random(idx)}.Device{subnode}.CellID;
%                                     nl = obj.Device{circuit_idx_random(idx)}.Device{subnode}.NeighborList;
%                                     pol = obj.Device{circuit_idx_random(idx)}.Device{subnode}.Polarization;
%                                     %disp(['id: ', num2str(id),' nl: ', num2str(nl)  ,' pol: ', num2str(pol)])
%                                     
%                                  
%                                     
%                                     if ~isempty(nl)
%                                         
%                                         %get Neighbor Objects
%                                         
%                                         nl_obj = obj.getCellArray(nl);
%                                         
%                                         %get hamiltonian for current cell
%                                         hamiltonian = obj.Device{circuit_idx_random(idx)}.Device{subnode}.GetHamiltonian(nl_obj, time);
%                                         
%                                         obj.Device{circuit_idx_random(idx)}.Device{subnode}.Hamiltonian = hamiltonian;
%                                         
%                                         
%                                         [V, EE] = eig(hamiltonian);
%                                         newpsi = V(:,1);
%                                         
%                                         normpsi = (1-chi)*obj.Device{circuit_idx_random(idx)}.Device{subnode}.Wavefunction + chi*newpsi;
%                                         normpsi = normalize_psi_1D(normpsi');
%                                         
%                                         
%                                         %calculate polarization
%                                         obj.Device{circuit_idx_random(idx)}.Device{subnode} = obj.Device{idx}.Device{subnode}.Calc_Polarization_Activation(normpsi');
%                                         
%                                         NewPols(subnode) = obj.Device{circuit_idx_random(idx)}.Device{subnode}.Polarization;
%                                         
%                                         if(isa(obj.Device{circuit_idx_random(idx)}.Device{subnode},'SixDotCell'))
%                                             NewCharges(:,subnode) = obj.Device{circuit_idx_random(idx)}.Device{subnode}.getMobileCharge(time);
%                                         else
%                                             NewCharges(1:3,subnode) = obj.Device{circuit_idx_random(idx)}.Device{subnode}.getMobileCharge(time);
%                                         end
%                                         
%                                         % disp(['id: ', num2str(id), ' pol: ', num2str(pol)]) %, ' nl: ', num2str(nl)
%                                     else
%                                         disp('potential room for thinking')%else nl is empty
%                                     end
%                                     
%                                 end
%                                 
%                             end
%                             
%                             deltaPols = abs(OldPols) - abs(NewPols);
%                             deltaCharges = OldCharges - NewCharges;
% 
%                             subnodeTolerance = max(max(abs(deltaCharges)));
%                             super = super + 1;
%                         end
%                         
%                         idx=idx+1;
%                         
%                         
%                     else
%                         %obj.Device{idx} = obj.Device{idx}.Calc_Polarization_Activation();
%                         id = obj.Device{circuit_idx_random(idx)}.CellID;
%                         nl = obj.Device{circuit_idx_random(idx)}.NeighborList;
%                         pol = obj.Device{circuit_idx_random(idx)}.Polarization;
%                         
%                         
%                         if ~isempty(nl)
% 
%                             
%                             %get Neighbor Objects
%                             nl_obj = obj.getCellArray(nl);
%                             
%                             
%                             %get hamiltonian for current cell
%                             hamiltonian = obj.Device{circuit_idx_random(idx)}.GetHamiltonian(nl_obj,time);
%                             obj.Device{circuit_idx_random(idx)}.Hamiltonian = hamiltonian;
%                             
%                             %get the new groundstate, average and normalize
%                             %the current groundstate and the new
%                             %groundstate then calculate pol with that psi
%                             [V, EE] = eig(hamiltonian);
%                             newpsi = V(:,1);
%                             
%                             
%                             
%                             normpsi = (1-chi)*obj.Device{circuit_idx_random(idx)}.Wavefunction + chi*newpsi;
%                             normpsi = normalize_psi_1D(normpsi');
%                             
%                             
%                             
%                             %calculate polarization
%                             obj.Device{circuit_idx_random(idx)} = obj.Device{circuit_idx_random(idx)}.Calc_Polarization_Activation(normpsi');
%                             
%                             if(isa(obj.Device{circuit_idx_random(idx)}, 'QCASuperCell'))
%                                 NewMobileCharges(idx) = [0;0;0;0;0;0];
%                             else
%                                 if(isa(obj.Device{circuit_idx_random(idx)},'SixDotCell'))
%                                     NewMobileCharges(:,idx) = obj.Device{circuit_idx_random(idx)}.getMobileCharge(time);
%                                 else
%                                     NewMobileCharges(1:3,idx) = obj.Device{circuit_idx_random(idx)}.getMobileCharge(time);
%                                 end
%                             end
%                             
%                             %disp(['id: ', num2str(id), ' pol: ', num2str(pol)  ' nl: ', num2str(nl)])
%                             
%                         end
%                         idx = idx+1;
%                     end
%                     
%                     
%                 end
%                 
%                 deltaMobileCharges = OldMobileCharges - NewMobileCharges;
% 
%                 [converganceTolerance, cellindex] = max(max(abs(deltaMobileCharges)));
% %                 disp(num2str(converganceTolerance));
%                 
%                 sub=sub+1;
%                 it=it+1;
%             end
%             disp(['-------------it:', num2str(it)]);
%         end
        
        %%
        function obj = Relax2GroundState_mobilecharge_serial(obj, time, varargin)
            
            
            %optional changes
            args = varargin(1:end);
            while length(args) >= 2
                prop = args{1};
                val = args{2};
                args = args(3:end);
                switch prop
                    case 'randomizedRelaxation'
                        randFlag = val;
                        %disp(['randomized' num2str(1)])
                    otherwise
                        error(['QCACircuit.Relax2GroundState_mobilecharge_serial ', prop, ' is an invalid property specifier.']);
                end
            end
            
                        
%             if length(varargin) == 1
%                 disp(num2str(varargin{1}))
%             end
            
            NewMobileCharges = zeros(6,length(obj.Device));
            converganceTolerance = 1;
            sub = 1;
            chi = 0.6;
            it=1;
            oldmit = 5;
            
            
            %set up randomization
            r = 1:length(obj.Device);
            if randFlag
                r = rand(1,length(obj.Device));
            end
            circuit_idx = 1:length(obj.Device);
            [~,s] = sort(r);
            circuit_idx_random = circuit_idx(s);
            
            
            
            while (converganceTolerance > 0.001 ) %&& it < 600
                if(it > 500)
                    
                    newmit = fix(it/100);
                    if newmit > oldmit
                        chi = chi * 0.9; % or multiply by 0.9
                    end
                    
                    if chi <= 0
                        chi = 0.1;
                    end
                    oldmit = newmit;
                end
                
                
              
                
                
                
                OldMobileCharges = NewMobileCharges;
 
                %get all hamiltonians
                
                for idx = 1:length(obj.Device)
                  nl = obj.Device{circuit_idx_random(idx)}.NeighborList;
                  if ~isempty(nl)
                        %get Neighbor Objects
                        nl_obj = obj.getCellArray(nl);

                        %get hamiltonian for current cell
                        hamiltonian = obj.Device{circuit_idx_random(idx)}.GetHamiltonian(nl_obj,time);
                        obj.Device{circuit_idx_random(idx)}.Hamiltonian = hamiltonian;
                        
                    end
                       
                end
                
                %get all groundstates
                groundstate = cell(1,16);
                for idx = 1:length(obj.Device)
                    hamiltonian = obj.Device{circuit_idx_random(idx)}.Hamiltonian;
                    wavefunction = obj.Device{circuit_idx_random(idx)}.Wavefunction;
                    %get the new groundstate, average and normalize
                    %the current groundstate and the new
                    %groundstate then calculate pol with that psi
                    [V, EE] = eig(hamiltonian);
                    newpsi = V(:,1);
                    
                    
                    
                    normpsi = (1-chi)*wavefunction + chi*newpsi;
                    normpsi = normalize_psi_1D(normpsi');
                    groundstate{circuit_idx_random(idx)} = normpsi;
                end
                    
                %update pols and acts and then get all the charges
                for idx = 1:length(obj.Device)
                    obj.Device{idx} = obj.Device{idx}.Calc_Polarization_Activation(groundstate{idx}');
                  
                    
                    if(isa(obj.Device{idx}, 'QCASuperCell'))
                        NewMobileCharges(idx) = [0;0;0;0;0;0];
                    else
                        if(isa(obj.Device{idx},'SixDotCell'))
                            NewMobileCharges(:,idx) = obj.Device{circuit_idx_random(idx)}.getMobileCharge(time);
                        else
                            NewMobileCharges(1:3,idx) = obj.Device{circuit_idx_random(idx)}.getMobileCharge(time);
                        end
                    end
                    
                    
                end
                    
                    
                    
                    
                
                
                deltaMobileCharges = OldMobileCharges - NewMobileCharges;
                
                [converganceTolerance, cellindex] = max(max(abs(deltaMobileCharges)));
                %                 disp(num2str(converganceTolerance));
                
                sub=sub+1;
                it=it+1;
            end
            disp(['-------------it:', num2str(it)]);
        end
        
        
        %%
        function obj = Relax2GroundState_serial(obj, time, varargin)
            
            %Iterate to Self consistency
            inverseflag = 0;
            if length(varargin) == 1
                if varargin{1} == 'inverse'
                    inverseflag = 1;
                    
                    
                end
                disp(num2str(varargin{1}))
            end
            
            NewCircuitPols = ones(1,length(obj.Device));
            converganceTolerance = 1;
            sub = 1;
            chi = 0.4;
            it=1;
            while (converganceTolerance > 0.1)
                OldCircuitPols = NewCircuitPols;
                
                %get all hamiltonians
                for idx = 1:length(obj.Device)
                    nl = obj.Device{idx}.NeighborList;
                    nl_obj = obj.getCellArray(nl);
                    
                    hamiltonian = obj.Device{idx}.GetHamiltonian(nl_obj,time);
                    obj.Device{idx}.Hamiltonian = hamiltonian;
                end
                
                %get all the groundstates
                for idx = 1:length(obj.Device)
                    hamiltonian = obj.Device{idx}.Hamiltonian;
                    wavefunction = obj.Device{idx}.Wavefunction;
                    
                    if inverseflag
                        newpsi = invitr(hamiltonian,0.001,10);
                    else
                        [V, EE] = eig(hamiltonian);
                        newpsi = V(:,1);
                    end
                    
                    
                    normpsi = (1-chi)*wavefunction + chi*newpsi;
                    normpsi = normalize_psi_1D(normpsi');
                    groundstate{idx} = normpsi;
                end
                
                %update pols and acts
                for idx = 1:length(obj.Device)
                    obj.Device{idx} = obj.Device{idx}.Calc_Polarization_Activation(groundstate{idx}');
                    NewCircuitPols(idx) = obj.Device{idx}.getPolarization(time);
                end
                
                
                deltaCircuitPols = abs(OldCircuitPols) - abs(NewCircuitPols);
                [converganceTolerance maxid] = max(abs(deltaCircuitPols));
                
                sub=sub+1;
                it=it+1;
                
                disp(['---- Iteration: ', num2str(it), ' - MaxID: ', num2str(maxid), ' - converganceTolerance: ', num2str(converganceTolerance), ' ----']);
                if (it == 500)
                    break
                end
            end
            
        end
        %%
        function obj = pipeline(obj, clockSignalsList, varargin)
            
            
            
            home = pwd;
           
            %default values
            file = 'simResults.mat';
            nt=315;
            inputSignalsList = {};
            numOfPeriods = 1;
            parallelFlag = 0;
            
            
            %optional changes
            args = varargin(1:end);
            while length(args) >= 2
                prop = args{1};
                val = args{2};
                args = args(3:end);
                switch prop
                    case 'Filename'
                        file = val;
                        
                    case 'TimeSteps'
                        if ischar(val)
                            nt = str2num(val);
                        else
                            nt = val;
                        end
                        
                    case 'inputSignalsList'
                        inputSignalsList = val;
                        
                    case 'numOfPeriods'
                        numOfPeriods = val;
                        
                    case 'randomizedRelaxation'
                        randomizedFlag = val;
                        if randomizedFlag == 1
                            
                            disp('USING RANDOMIZED RELAXATION ORDER')
                            
                        end
                    case 'mobileCharge'
                        mobileChargeFlag = val;
                        
                    case 'Parallel'
                        parallelFlag = val;
                        
                        if parallelFlag == 1
                            %disp('parpool')
                            maxThreads = min([feature('NumCores'),4 ]);
                            maxNumCompThreads(maxThreads);
                            delete(gcp('nocreate'));
                            parpool('local',maxThreads);
                            %parallel.pool.Constant
                            
                        end
                        
                        
                    otherwise
                        error(['QCACircuit.pipeline ', prop, ' is an invalid property specifier.']);
                end
            end
            
            
            obj.Simulating = 'on';
            
            
            
            % find the longest period, create time steps
            
            maxPeriod = clockSignalsList{1}.Period;
            for signalidx = 1:length(clockSignalsList)
                if(clockSignalsList{signalidx}.Period > maxPeriod )
                    maxPeriod = clockSignalsList{signalidx}.Period;
                end
            end
            
            tperiod = maxPeriod*numOfPeriods; %numOfPeriods;
            time_array = linspace(0,tperiod,nt);
            tc = mod(time_array, tperiod);
            
            
            
            m = matfile(file, 'Writable', true);
            
            
            save(file, 'clockSignalsList', '-v7.3');
            save(file, 'inputSignalsList', '-append');
            save(file, 'numOfPeriods', '-append');
            save(file, 'obj', '-append');
            
            m.pols = [];%zeros(nt,length(obj.Device));
            m.acts = [];%zeros(nt,length(obj.Device));
            m.efields = {};%zeros(nt,length(obj.Device));
            m.nt = nt;
            
            pols = [];
            acts = [];
            efields = {};
            
          
            
            for t = 1:nt %time step
                percentage = t/nt;
                %waitbar(percentage); annoying right now...
                disp(['t: ', num2str(t)]);
                
                obj = obj.UpdateClockFields(tc(t), clockSignalsList, inputSignalsList);
                                
                
                
                %relax2Groundstate
                if parallelFlag == 0 && mobileChargeFlag == 0
                    obj = obj.Relax2GroundState(tc(t)); %tp(t)
                elseif parallelFlag == 0 && mobileChargeFlag == 1
                    %obj = obj.Relax2GroundState_randomized(tc(t)); %tp(t)
                    if randomizedFlag == 1 && t ~= 1
                        obj = obj.Relax2GroundState_mobilecharge_serial(tc(t), 'randomizedRelaxation', 1); %tp(t)
                    else
                        obj = obj.Relax2GroundState_mobilecharge_serial(tc(t), 'randomizedRelaxation', 0); %tp(t)
                        %obj = obj.Relax2GroundState_mobilecharge(tc(t)); %tp(t)
                    end
                elseif parallelFlag == 1
                    obj = Relax2GroundState_parallel(obj, tc(t)); %tp(t)
                elseif parallelFlag == 2
                    obj = obj.Relax2GroundState_serial(tc(t)); %, 'inverse' tp(t)
                end
                
                %data output
                it = 1;
                for idx=1:length(obj.Device)
                    
                    if isa(obj.Device{idx},'QCASuperCell')
                        
                        for sub=1:length(obj.Device{idx}.Device)
                            
                            
                            pols(t,it) = obj.Device{idx}.Device{sub}.getPolarization(tc(t));
                            acts(t,it) = obj.Device{idx}.Device{sub}.Activation;
                            efields{t,it} = obj.Device{idx}.Device{sub}.ElectricField;
                            
                            it = it + 1;
                        end
                        
                        
                    else
                        
                        
                        pols(t,it) = obj.Device{idx}.getPolarization(tc(t));
                        acts(t,it) = obj.Device{idx}.Activation;
                        efields{t,it} = obj.Device{idx}.ElectricField;
                        it = it + 1;
                    end
                end
                
                
                
                
                
            end %time step loop
            %delete(wb);
            
            
            m.pols = pols;
            m.acts = acts;
            m.efields = efields;
            
            
            disp('Complete!')
            
            obj.Simulating = 'off';
            
            
            delete(gcp('nocreate')); % only delete parallel pool if one was created.
            
            
            cd(home);
        end
        %%
        function obj = UpdateClockFields(obj, time, clockSignalList, inputSignalList)
            
            if( iscell(clockSignalList) && isa(clockSignalList{1}, 'Signal') && iscell(inputSignalList) && isa(inputSignalList{1}, 'Signal') ) %still need to check if all clock signals are a Signal()
                
                % then assign clock fields
                CircuitIdx = 1;
                while CircuitIdx <= length(obj.Device)
                    if( isa(obj.Device{CircuitIdx}, 'QCASuperCell') )
                        for subnode = 1:length(obj.Device{CircuitIdx}.Device)
                            efield = obj.Device{CircuitIdx}.Device{subnode}.ElectricField; % for this node, set the z-efield to zero
                            %efield(3) = 0;
                            efield = [efield(1), 0, 0];
                            
                            for signalidx = 1:length(clockSignalList)
                                %step through each signal and accumulate
                                %the efield
                                efield = efield + clockSignalList{signalidx}.getClockField(obj.Device{CircuitIdx}.Device{subnode}.CenterPosition, mod(time, clockSignalList{signalidx}.Period )); %changes E Field.
                                efield = efield + inputSignalList{signalidx}.getInputField(obj.Device{CircuitIdx}.Device{subnode}.CenterPosition, mod(time, clockSignalList{signalidx}.Period )); %changes E Field.
                                obj.Device{CircuitIdx}.Device{subnode}.ElectricField = efield;
                                
                            end %signalList
                            
                        end
                        CircuitIdx = CircuitIdx+1;
                    else
                        
                        efield = obj.Device{CircuitIdx}.ElectricField; % for this node, set the z-efield to zero
                        %efield(3) = 0;
                        efield = [efield(1), 0, 0];
                        
                        for signalidx = 1:length(clockSignalList)
                            %step through each signal and accumulate
                            %the efield
                            efield = efield + clockSignalList{signalidx}.getClockField(obj.Device{CircuitIdx}.CenterPosition, mod(time, clockSignalList{signalidx}.Period )); %changes E Field.
                            
                            %if (CircuitIdx < 11)
                            %efield = efield + inputSignalList{signalidx}.getInputField(obj.Device{CircuitIdx}.CenterPosition, mod(time, clockSignalList{signalidx}.Period )); %changes E Field.
                            %end
                            
                            obj.Device{CircuitIdx}.ElectricField = efield;
                            
                        end% signalList
                        
                        CircuitIdx = CircuitIdx+1;
                    end
                    
                end
                
                
                
                
            else
                error('Input must be Cell Array of Signals')
            end % if is a cell array of signals (kinda works as a check)
            
        end

        %%
        function cell_obj = getCellArray(obj, CellIDArray)
            %this function returns an array of QCACell objects given a list
            %of IDs
            
            cell_obj = {};
            
            for i=1:length(obj.Device)
                if isa(obj.Device{i},'QCASuperCell')
                    for j=1:length(obj.Device{i}.Device)
                        for k=1:length(CellIDArray)
                            if CellIDArray(k) == obj.Device{i}.Device{j}.CellID
                                cell_obj{end+1} = obj.Device{i}.Device{j};
                            end
                        end
                    end
                    
                else
                    
                    for k=1:length(CellIDArray)
                        if CellIDArray(k) == obj.Device{i}.CellID
                            cell_obj{end+1} = obj.Device{i};
                        end
                    end
                    
                end
            end
            
        end
        %%
        function CellIds = GetCellIDs(obj,cells)
            %returns just the CellIDs given a list of objects.
            
            CellIds=[];
            
            idx = 1;
            
            while idx <= length(cells)
                if isa(cells{idx}, 'QCASuperCell')
                    
                    for sub = 1:length(cells{idx}.Device)
                        CellIds(end+1) = cells{idx}.Device{sub}.CellID;
                        
                    end
                    
                    idx = idx + 1;
                else
                    CellIds(end+1) = cells{idx}.CellID;
                    idx = idx + 1;
                end
                
            end
            
        end
        %%
        function obj = Snap2Grid(obj)
            coord = {};
            
            for i=1:length(obj.Device)  %fill cell with all center positions
                if isa(obj.Device{i},'QCASuperCell')
                    
                    
                    for j=1:length(obj.Device{i}.Device)
                        coord{end+1} = obj.Device{i}.Device{j}.CenterPosition;
                        
                    end
                    
                    
                else
                    coord{end+1} = obj.Device{i}.CenterPosition;
                end
                
            end
            
            
            for i=1:length(coord)
                
                
                diffx=coord{i}(1)-floor(coord{i}(1)); %range of 0 to 1 for rounding to 0, .5, or 1 relatively speaking
                diffy=coord{i}(2)-floor(coord{i}(2)); %this is priming the snap to grid functionality
                
                %determining how each x,y will be rounded to floor, .5 or
                %up to the next integer
                if diffx<.25
                    coord{i}(1)=floor(coord{i}(1));
                end
                if diffx>=.25 && diffx<=.75
                    coord{i}(1)=floor(coord{i}(1))+.5;
                end
                if diffx>.75
                    coord{i}(1)=floor(coord{i}(1))+1;
                end
                
                
                if diffy<.25
                    coord{i}(2)=floor(coord{i}(2));
                end
                if diffy>=.25 && diffy<=.75
                    coord{i}(2)=floor(coord{i}(2))+.5;
                end
                if diffy>.75
                    coord{i}(2)=floor(coord{i}(2))+1;
                end
            end
            
            
            it=1;
            for i=1:length(obj.Device) %replace the cell center positions with the new snapped center positions
                if isa(obj.Device{i},'QCASuperCell')
                    for j=1:length(obj.Device{i}.Device)
                        
                        obj.Device{i}.Device{j}.CenterPosition = coord{it};
                        it=it+1;
                    end
                else
                    obj.Device{i}.CenterPosition = coord{it};
                    it = it+1;
                end
                
            end
        end
        
        
    end
    
end




% format for iterating through circuit
% for i=1:length(obj.Device)
%     if isa(obj.Device{i},'QCASuperCell')
%         Sel=0;
%         for j=1:length(obj.Device{i}.Device)
%             nl = obj.GenerateNeighborList();
%
%             %do a thing
%
%
%         end
%         if Sel
%
%         end
%
%     else
%         %do a thing
%
%     end
% end