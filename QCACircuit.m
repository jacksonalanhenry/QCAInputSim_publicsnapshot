classdef QCACircuit
    % make a class "qca circuit" that contains cells and knows which ones are
    % neighbors. Should be able to individually save file without corrupting
    % the original program.
    
    properties
        Device = {}; % QCA CELL ARRAY
        RefinedDevice = {};
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
            
        end
        
        
        
        function NeighborCheck( obj ) %Checks for each cell
            
            obj.RefinedDevice = obj.Device;
            if nargin > 0
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
                    obj.RefinedDevice{n} = obj.Device{SmallestNorm};
                    
                end
                
            end
        end
        
        
        
        
        
        
        
        
        
        
    end
    
end

