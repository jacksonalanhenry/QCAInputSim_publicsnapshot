classdef TEMPQCACircuitClass
    %QCA circuit class
    %TEMPORARY
    
    properties
        Device = {};
    end
    
    methods
        function obj = tempQCACircuit(varargin)
            
        end
        
        function obj= AddDevice(obj,newDevice)
            k=length(obj.Device);
            obj.Device{k+1}=newDevice;            
        end
        
        function obj = DrawCircuit (obj,varargin)
           % targetAxes=[];
            if length(varargin)==1
               targetAxes = varargin{1};
               axes(targetAxes);  %sets target axes as current axes 
               
            else
                targetAxes=axes;               
            end
            k=length(obj.Device);
            for cellIdx=1:k
               obj.Device{cellIdx} = ...
                   obj.Device{cellIdx}.tempDraw(targetAxes);
                
            end
            
        end
        
    
    end
    
end

