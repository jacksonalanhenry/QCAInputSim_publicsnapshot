classdef QCACircuit
    % make a class "qca circuit" that contains cells and knows which ones are
    % neighbors. Should be able to individually save file without corrupting
    % the original program.
    
    properties
        Device = {}; % QCA CELL ARRAY
        RefinedDevice = {};
        GroundState = [];
        
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
        
        function obj = CircuitDraw(obj, targetAxes)
            hold on
            for CellIndex = 1:length(obj.Device)
                obj.Device{CellIndex} = obj.Device{CellIndex}.ThreeDotElectronDraw(targetAxes);
                
            end
            
            hold off
        end
        
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
        
    end
    
end

