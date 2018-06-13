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
            ids=[];
            if length(obj.Device)
                ids = GetCellIDs(obj,obj);
            end
            
            obj.Device{n_old+1} = newcell;
            obj.Device{n_old+1}.CellID = length(obj.Device);
            
            
            
            if length(ids)
                for i=1:n_old  %ensuring that CellIDs cannot be repeated
                    
                    
                    compare = (obj.Device{n_old+1}.CellID==ids);
                    maxID = max(ids);
                    if sum(compare)>0
                        obj.Device{n_old+1}.CellID = maxID +1;
                    end
                    
                end
            end
            compare = (obj.Device{n_old+1}.CellID==ids);
            ids = GetCellIDs(obj,obj);
            
            newIDs = GetCellIDs(obj,obj);
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
            
            hold on
            CellIndex = length(obj.Device);
            for CellIndex = 1:length(obj.Device)
                
                if( isa(obj.Device{CellIndex}, 'QCASuperCell') )
                    
                    %check to see if there is a color for the SC
                    if strcmp(obj.Device{CellIndex}.BoxColor,'')                        
                        
                        %We make a cell array of all colors that have been
                        %used
                        colors={};
                        for j=1:length(obj.Device)
                            if isa(obj.Device{j},'QCASuperCell') && ~isempty(obj.Device{j}.BoxColor) && j~= CellIndex
                                colors{end+1} = obj.Device{j}.BoxColor;                                
                            end
                            
                        end
                        
                        %compare each color to a randomly generated color
                        %we want to make sure that the new color is not too
                        %similar to the used colors.  Therefore, we will
                        %use vector geometry to ensure the "angle" between
                        %each color, represented as a 3d vector, is
                        %sufficiently large
                        if length(colors)>0 %there is a colors list
                            theta=0;
                            angles=[];
                            colorcomp=zeros(1,length(colors));%want all elements to be ones
                            
                            while sum(colorcomp)<length(colors)
                                
                                color=[rand rand rand];
                                for i=1:length(colors)
                                    color1=color;
                                    color2=colors{i};
                                    theta = acos(dot(color,colors{i})/(norm(color)*norm(colors{i})))*180/pi; %computing angle b/t colors
                                    angles(i)=theta;
                                    colorcomp(i)=(theta>15); %as long as the angle is >20 degrees, the color is permissible
                                    
                                end
                                
                                
                            end
                            min(angles);
                            obj.Device{CellIndex}.BoxColor=color;
                        else
                            obj.Device{CellIndex}.BoxColor=[rand rand rand]; %the color will remain the same for the same super cell
                        end
                            
                    else
                        %don't make a new color
                    end
                    
                    for subnode = 1:length(obj.Device{CellIndex}.Device)
                        
                        obj.Device{CellIndex}.Device{subnode} = obj.Device{CellIndex}.Device{subnode}.ThreeDotElectronDraw();
                        obj.Device{CellIndex}.Device{subnode} = obj.Device{CellIndex}.Device{subnode}.BoxDraw();
                        obj.Device{CellIndex}.Device{subnode}.SelectBox.Selected = 'off';
                        obj.Device{CellIndex}.Device{subnode}.SelectBox.FaceAlpha = .01;
                        obj.Device{CellIndex}.Device{subnode}.SelectBox.EdgeColor = obj.Device{CellIndex}.BoxColor;
                        obj.Device{CellIndex}.Device{subnode}.SelectBox.LineWidth = 3;
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
                if isa(obj.Device{CellIndex},'QCASuperCell')
                    
                    
                    %check to see if there is a color for the SC
                    if strcmp(obj.Device{CellIndex}.BoxColor,'')
                        
                        %We make a cell array of all colors that have been
                        %used
                        colors={};
                        for j=1:length(obj.Device)
                            if isa(obj.Device{j},'QCASuperCell') && ~isempty(obj.Device{j}.BoxColor) && j~= CellIndex
                                colors{end+1} = obj.Device{j}.BoxColor;
                            end
                            
                        end
                        
                        %compare each color to a randomly generated color
                        %we want to make sure that the new color is not too
                        %similar to the used colors.  Therefore, we will
                        %use vector geometry to ensure the "angle" between
                        %each color, represented as a 3d vector, is
                        %sufficiently large
                        if length(colors)>0 %there is a colors list
                            theta=0;
                            angles=[];
                            colorcomp=zeros(1,length(colors));%want all elements to be ones
                            
                            while sum(colorcomp)<length(colors)
                                
                                color=[rand rand rand];
                                for i=1:length(colors)
                                    color1=color;
                                    color2=colors{i};
                                    theta = acos(dot(color,colors{i})/(norm(color)*norm(colors{i})))*180/pi; %computing angle b/t colors
                                    angles(i)=theta;
                                    colorcomp(i)=(theta>15); %as long as the angle is >20 degrees, the color is permissible
                                    
                                end
                                
                                
                            end
                            min(angles);
                            obj.Device{CellIndex}.BoxColor=color;
                        else
                            obj.Device{CellIndex}.BoxColor=[rand rand rand]; %the color will remain the same for the same super cell
                        end
                        
                    else
                        %don't make a new color
                    end
                    
                    
                    for i=1:length(obj.Device{CellIndex}.Device)
                    obj.Device{CellIndex}.Device{i}=obj.Device{CellIndex}.Device{i}.LayoutModeDraw(obj.Device{CellIndex}.BoxColor);
                    Select(obj.Device{CellIndex}.Device{i}.LayoutBox);
                    end
                    
                else
                    obj.Device{CellIndex} = obj.Device{CellIndex}.LayoutModeDraw();
                    Select(obj.Device{CellIndex}.LayoutBox);
                end
                
                
                
                
                
                hold off
            end
        
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
            sub = 1;
            while (converganceTolerance > 0.001)
                OldCircuitPols = NewCircuitPols;
                
                idx = 1;
                %randomize order
                %                 randarray = linspace(1,length(obj.Device),length(obj.Device));
                %                 randarray = randarray(randperm(length(randarray)))
                
                while idx <= length(obj.Device)
                    
                    if( isa(obj.Device{idx}, 'QCASuperCell') )
                        
                        
                        NewPols = ones(1,length(obj.Device{idx}.Device));
                        subnodeTolerance = 1;
                        super = 1;
                        
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
                            super = super + 1;
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
                
                sub=sub+1;
            end
            
        end
        
        function obj = pipeline(obj,signal,currentaxes)
            %give this function a signal(or field) obj
            
            nt=315;
            time_array = linspace(0,2,nt); %right now this will do 2 periods
            
            %draw gradient before cells
            nx = 125; % number of x points
            
            t_Tc = linspace(-5, 5, nt); % for gradient ploting purposes
            x_lambda = linspace(-2, 12, nx); % for gradient plotting purposes
            
            Ezt = zeros(nx, nt);
            
            for tidx = 1:nt
                Ezt(:, tidx) = (+0.5* cos( 2*pi*(x_lambda/signal.Wavelength - time_array(tidx)/signal.Period ) ) -0.5)*signal.Amplitude;
            end
            
            
            
            
            Frame(nt) = struct('cdata',[],'colormap',[]);
            v = VideoWriter('sinusoidEField.mp4','MPEG-4');
            open(v);
            
            for t = 1:nt %time step
                
                %edit Efield for all cells in circuit
                idx=1;
                while idx <= length(obj.Device)
                    if( isa(obj.Device{idx}, 'QCASuperCell') )
                        
                        for subnode = 1:length(obj.Device{idx}.Device)
                            obj.Device{idx}.Device{subnode}.ElectricField = signal.getEField(obj.Device{idx}.Device{subnode}.CenterPosition, time_array(t)); %changes E Field.
                        end
                        idx = idx+1;
                    else
                        obj.Device{idx}.ElectricField = signal.getEField(obj.Device{idx}.CenterPosition, time_array(t)); %changes E Field.
                        
                        idx = idx+1;
                    end
                    
                end
                
                
                %relax2Groundstate
                
                obj = obj.Relax2GroundState();
                three = obj.Device{3}.ElectricField;
                twelve = obj.Device{12}.ElectricField;
                diff = abs(twelve-three);
                disp(['t: ', num2str(t), ' diff: ', num2str(diff)])
                
                %visualize
                
                
                Eplot = repmat(Ezt(:,t),[1,nt]);
                
                
                pcolor(x_lambda' * ones(1, nt), ones(nx, 1)* t_Tc, Eplot)
                colormap cool;
                shading interp;
                colorbar;
                
                
                
                
                
                obj = obj.CircuitDraw(currentaxes);
                drawnow
                %save it
                Frame(t) = getframe(gcf);
                writeVideo(v,Frame(t));
                
            end %time step loop
            
            
            fig = figure;
            movie(fig,Frame,1)
            close(v);
            
            disp("Complete!")
            
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
        
        function CellIds = GetCellIDs(obj,cells)
            %returns just the CellIDs given a list of objects.
            ids=[];
            for i=1:length(cells.Device)
                if isa(cells,'QCASuperCell')
                    
                    for j=1:length(cells.Device)
                        ids(end+1)=cells.Device{i}.Device{j}.CellID;
                    end
                else
                    
                    ids(end+1)=cells.Device{i}.CellID;
                end
            end
            
            CellIds = ids;
        end
        
        
        
        %Gradient attempt
        function obj = CircuitDrawWithEField(obj, signal, targetAxes)
            cla;
            hold on
            
            
            

            
            
            CellIndex = length(obj.Device);
            for CellIndex = 1:length(obj.Device)
                
                if( isa(obj.Device{CellIndex}, 'QCASuperCell') )
                    
                    %check to see if there is a color for the SC
                    if strcmp(obj.Device{CellIndex}.BoxColor,'')                        
                        
                        %We make a cell array of all colors that have been
                        %used
                        colors={};
                        for j=1:length(obj.Device)
                            if isa(obj.Device{j},'QCASuperCell') && ~isempty(obj.Device{j}.BoxColor) && j~= CellIndex
                                colors{end+1} = obj.Device{j}.BoxColor;                                
                            end
                            
                        end
                        
                        %compare each color to a randomly generated color
                        %we want to make sure that the new color is not too
                        %similar to the used colors.  Therefore, we will
                        %use vector geometry to ensure the "angle" between
                        %each color, represented as a 3d vector, is
                        %sufficiently large
                        if length(colors)>0 %there is a colors list
                            theta=0;
                            angles=[];
                            colorcomp=zeros(1,length(colors));%want all elements to be ones
                            
                            while sum(colorcomp)<length(colors)
                                
                                color=[rand rand rand];
                                for i=1:length(colors)
                                    color1=color;
                                    color2=colors{i};
                                    theta = acos(dot(color,colors{i})/(norm(color)*norm(colors{i})))*180/pi; %computing angle b/t colors
                                    angles(i)=theta;
                                    colorcomp(i)=(theta>15); %as long as the angle is >20 degrees, the color is permissible
                                    
                                end
                                
                                
                            end
                            min(angles);
                            obj.Device{CellIndex}.BoxColor=color;
                        else
                            obj.Device{CellIndex}.BoxColor=[rand rand rand]; %the color will remain the same for the same super cell
                        end
                            
                    else
                        %don't make a new color
                    end
                    
                    for subnode = 1:length(obj.Device{CellIndex}.Device)
                        
                        obj.Device{CellIndex}.Device{subnode} = obj.Device{CellIndex}.Device{subnode}.ThreeDotElectronDraw();
                        obj.Device{CellIndex}.Device{subnode} = obj.Device{CellIndex}.Device{subnode}.BoxDraw();
                        obj.Device{CellIndex}.Device{subnode}.SelectBox.Selected = 'off';
                        obj.Device{CellIndex}.Device{subnode}.SelectBox.FaceAlpha = .01;
                        obj.Device{CellIndex}.Device{subnode}.SelectBox.EdgeColor = obj.Device{CellIndex}.BoxColor;
                        obj.Device{CellIndex}.Device{subnode}.SelectBox.LineWidth = 3;
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
        
        
        
    end
    
    
end