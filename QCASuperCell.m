classdef QCASuperCell
    %SuperCell Holds a list of cells
    %   This is to help with the race condition that happens with the
    %   Hartree Fock approximation
    
    properties
        Device = {}; %what QCACells are in 
        CellID = 0;  %unique ID
        NeighborList = []; %this SuperCell's Neighbors
        BoxColor='';
        
    end
    
    methods
        function obj = SuperCell( varargin ) % constructor class
            
            if nargin > 0
                placeholder = obj.Device;
                obj.Device = {placeholder varargin};
                
            else
                % Nothing happens
                
            end
            
        end
        
        function obj = addCell( obj, newcell )
            n_old = length(obj.Device);
            obj.Device{n_old+1} = newcell;
            
            obj.Device{n_old+1}.CellID = obj.CellID + length(obj.Device)/100;
           
        end
        
        function obj = CircuitDraw(obj, targetAxes)
            hold on
            for CellIndex = 1:length(obj.Device)
                obj.Device{CellIndex} = obj.Device{CellIndex}.ColorDraw(); 
            end
            hold off
        end
        
    end
    
end

