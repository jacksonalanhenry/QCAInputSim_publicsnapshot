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
                        %shift and find magnitudes
                        shifted = cellpositions - repmat(cellpositions(:,idx+subnode-1),1,length(cellIDArray));
                        shifted = shifted.^2;
                        shifted = sum(shifted,1).^(.5);
                        
                        %give me the cellid's of the node within a certain limit
                        neighbors = cellIDArray(shifted < 2.25 & shifted > 0);
 
                        
                        
%                         disp(['id: ' num2str(c) ' neighbors: ' num2str(neighbors)])
                        obj.Device{idx}.Device{subnode}.NeighborList = neighbors;
                           

                    end
                    
                    
                else
                    %shift and find magnitudes
                   
                    
                    
                    shifted = cellpositions - repmat(cellpositions(:,idx),1,length(cellIDArray));
                    shifted = shifted.^2;
                    shifted = sum(shifted,1);
                    shifted = shifted.^(.5);
                    
                    %give me the cellid's of the node within a certain limit
                    id = obj.Device{idx}.CellID;
                    neighbors = cellIDArray(shifted < 2.25 & shifted > 0);

%                     y=[];
%                     q=obj.getCellArray(neighbors);
%                     for i = 1:length(neighbors)
%                             if abs(obj.Device{cellIDToplevelnodes(idx)}.CenterPosition(1) - q{i}.CenterPosition(1))>1.5
%                                 disp('he')
%                             else
%                                 
%                             end
%                     end
                    
                    
                    
%                     disp(['id: ' num2str(id) ' neighbors: ' num2str(neighbors)])


                    obj.Device{idx}.NeighborList = neighbors;
                    
                    
                end
                
                
                
                
            end
            
            
        end
        
        function obj = CircuitDraw(obj, targetAxes)
%             cla;
            hold on
            CellIndex = length(obj.Device);
            for CellIndex = 1:length(obj.Device)
                
                if( isa(obj.Device{CellIndex}, 'QCASuperCell') )
                    
                    %check to see if there is a color for the SC
                    if strcmp(obj.Device{CellIndex}.BoxColor,'')                        
                        
                        %We make a cell array of all colors that have been
                        %used
                        colors=0;
                        for j=1:length(obj.Device)
                            if isa(obj.Device{j},'QCASuperCell') && ~isempty(obj.Device{j}.BoxColor) && j~= CellIndex
%                                 colors{end+1} = obj.Device{j}.BoxColor;
                                colors =  colors+1;
                            end
                            
                        end
                        
                        if colors>0;
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
                obj.Mode = 'Simulation';
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
                        colors=0;
                        for j=1:length(obj.Device)
                            if isa(obj.Device{j},'QCASuperCell') && ~isempty(obj.Device{j}.BoxColor) && j~= CellIndex
%                                 colors{end+1} = obj.Device{j}.BoxColor;
                                colors =  colors+1;
                            end
                            
                        end
                        if colors>0;
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
            obj.Mode = 'Layout';
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
%             disp('ORDER OF RELAXING')
%             for i=1:length(obj.Device)
%                fprintf('Cell %d  ...   ',obj.Device{i}.CellID); 
%             end
%             fprintf('\n');

            NewCircuitPols = ones(1,length(obj.Device));
            converganceTolerance = 1; 
            sub = 1;
            
            it=1;
            while (converganceTolerance > 0.000001)
                
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
                        
                        while (subnodeTolerance > 0.00001)
                            OldPols = NewPols;
                            
%                             supernode = floor(obj.Device{idx}.Device{1}.CellID)
                            
                            
                            L=length(obj.Device);
                            for subnode = 1:length(obj.Device{idx}.Device)
                                
                                if( strcmp(obj.Device{idx}.Device{subnode}.Type, 'Driver') )
                                    %don't relax
                                else
                                    
                                    id = obj.Device{idx}.Device{subnode}.CellID;
                                    nl = obj.Device{idx}.Device{subnode}.NeighborList;
                                    pol = obj.Device{idx}.Device{subnode}.Polarization;
%                                                                         disp(['id: ', num2str(id),' nl: ', num2str(nl)  ,' pol: ', num2str(pol)])
                                    
                                    if ~isempty(nl)
                                        
                                        %get Neighbor Objects
                                        
                                        nl_obj = obj.getCellArray(nl);
                                        
                                        %get hamiltonian for current cell
                                        hamiltonian = obj.Device{idx}.Device{subnode}.GetHamiltonian(nl_obj);
                                        
                                        obj.Device{idx}.Device{subnode}.Hamiltonian = hamiltonian;
                                        
                                        %calculate polarization
                                        obj.Device{idx}.Device{subnode} = obj.Device{idx}.Device{subnode}.Calc_Polarization_Activation();
                                        
                                        NewPols(subnode) = obj.Device{idx}.Device{subnode}.Polarization;
                                        
                                        
%                                         disp(['id: ', num2str(id), ' pol: ', num2str(pol)]) %, ' nl: ', num2str(nl)
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
                        
                        if ~isempty(nl)
                            
                            %get Neighbor Objects
                            %                         disp('good')
                            nl_obj = obj.getCellArray(nl);

                            %                         disp('job')
                            
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
                            
%                             disp(['id: ', num2str(id), ' pol: ', num2str(pol)  ' nl: ', num2str(nl)])

                        end
                        idx = idx+1;
                    end
                    
                    
                end
                fprintf('\n');
                deltaCircuitPols = abs(OldCircuitPols) - abs(NewCircuitPols);
                converganceTolerance = max(abs(deltaCircuitPols));
                
                sub=sub+1;
                it=it+1;
            end
            
        end
        
        function obj = pipeline(obj,signal,currentaxes)
            %give this function a signal(or field) obj
            
            nt=315;
            time_array = linspace(0,2,nt); %right now this will do 2 periods


            %THIS NEEDS TO MOVE
            %draw gradient before cells
            nx = 125; % number of x points
            
            t_Tc = linspace(-2,2, nt); % for gradient ploting purposes
            x_lambda = linspace(-1, length(obj.Device)+1, nx); % for gradient plotting purposes

            
            Ezt = zeros(nx, nt);
            
            for tidx = 1:nt
                Ezt(:, tidx) = (+0.5* cos(( 2*pi*(x_lambda         /signal.Wavelength - time_array(tidx)/signal.Period ) ) + (3.1-pi) ) )*signal.Amplitude;
            end
            
            
            
            fileID = fopen('SimulationResults.txt','w');
            file = 'simResults.mat';
            m = matfile(file, 'Writable', true);
            save(file, 'signal', '-v7.3');
            save(file, 'obj', '-append', '-v7.3');
            m.pols = [];%zeros(nt,length(obj.Device));
            m.acts = [];%zeros(nt,length(obj.Device));
            m.efields = [];%zeros(nt,length(obj.Device));
            
            formatSpec = 'Clock Amplitude: %.2f \tWavelength: %i \tPeriod: %i\n';
            fprintf(fileID,formatSpec,signal.Amplitude,signal.Wavelength,signal.Period);
           
            %iterate through circuit and print neighbor lists
            idx = 1;
            
            while idx <= length(obj.Device) 
                
                if(isa(obj.Device{idx}, 'QCASuperCell'))
                    
                    for sub = 1: length(obj.Device{idx}.Device)
                        formatSpec = 'CellID: %.2f \t Neighbors: %s\n';
                        nl = obj.Device{idx}.Device{sub}.NeighborList;
                        nl = num2str(nl);
                        if isempty(nl)
                            nl = '**';
                        end
                        fprintf(fileID,formatSpec, obj.Device{idx}.Device{sub}.CellID,nl);
                        
                        
                    end
                    
                    idx = idx + 1;
                else
                    formatSpec = 'CellID: %.2f \t Neighbors: %s\n';
                    nl = obj.Device{idx}.NeighborList;
                    nl = num2str(nl);
                    if isempty(nl)
                            nl = '**';
                    end
                    fprintf(fileID,formatSpec, obj.Device{idx}.CellID,nl);
                    idx = idx +1;
                end
                
            end

            
            
            %THESE NEED TO MOVE
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
                
                
                %data output
                disp(['t: ', num2str(t)]);
                
                fprintf(fileID, '%i; ', t);
                
                  

                idx = 1;
                while idx <= length(obj.Device)
                    if(isa(obj.Device{idx}, 'QCASuperCell'))

                        for sub = 1: length(obj.Device{idx}.Device)
                            formatSpec = '%.2f ;%.2f; %.2f; %.4f; ';
                            ef = obj.Device{idx}.Device{sub}.ElectricField;
                            efz = ef(3);
                            
                            
                            m.pols(end+1,t) = obj.Device{idx}.Device{sub}.Polarization;
                            m.acts(t,end+1) = obj.Device{idx}.Device{sub}.Activation;
                            m.efields = efz;
                            
                            fprintf(fileID,formatSpec, obj.Device{idx}.Device{sub}.CellID,obj.Device{idx}.Device{sub}.Polarization,obj.Device{idx}.Device{sub}.Activation, efz);

                        end


                        idx = idx + 1;
                    else
                        formatSpec = '%.2f ;%.2f; %.2f; %.4f; ';
                        ef = obj.Device{idx}.ElectricField;
                        efz = ef(3);
                        
                        
                        m.pols(t,end+1) = obj.Device{idx}.Polarization;
                        m.acts(t,end+1) = obj.Device{idx}.Activation;
                        m.efields(t,end+1) = efz;
                        
                        
                        fprintf(fileID, formatSpec, obj.Device{idx}.CellID, obj.Device{idx}.Polarization, obj.Device{idx}.Activation,efz);
                        
                        

                    end
                    idx = idx + 1;
                end
                
                fprintf(fileID, '\n');

                %THIS NEEDS TO MOVE
                Eplot = repmat(Ezt(:,t),[1,nt]);


                pcolor(x_lambda' * ones(1, nt), ones(nx, 1)* t_Tc, Eplot)
                colormap cool;
                shading interp;
                
%                 caxis([0 signal.Amplitude])
                colorbar;
%                 h = colorbar;
%                 set(h, 'ylim', [0 signal.Amplitude])

                obj = obj.CircuitDraw(currentaxes);
                drawnow
                %save it
                Frame(t) = getframe(gcf);
                writeVideo(v,Frame(t));
               
                
                
            end %time step loop
            
            
            
            %THIS NEEDS TO MOVE
            fig = figure;
            movie(fig,Frame,1)
            close(v);
            fclose(fileID);
            
            disp('Complete!')
            
        end
        
                
        
        
        
        function cell_obj = getCellArray(obj, CellIDArray)
            %this function returns an array of QCACell objects given a list
            %of IDs
            
            cell_obj = {};
            
            for i=1:length(obj.Device)        
                if isa(obj.Device,'QCASuperCell')    
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
        
    end
    
    
end