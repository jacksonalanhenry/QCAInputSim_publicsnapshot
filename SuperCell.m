classdef SuperCell
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Device={};
        
        
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
            obj.Device{n_old+1}.CellID = length(obj.Device);
            
        end
        
        function obj = CircuitDraw(obj, targetAxes)
            hold on
            for CellIndex = 1:length(obj.Device)
                obj.Device{CellIndex} = obj.Device{CellIndex}.ThreeDotElectronDraw(); 
            end
            hold off
        end
        
        
        
        
        
        
    end
    
end

