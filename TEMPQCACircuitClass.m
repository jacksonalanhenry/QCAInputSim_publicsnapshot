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
        
    
    end
    
end

