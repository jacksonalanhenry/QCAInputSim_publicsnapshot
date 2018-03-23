function QCALayoutAddNode( handles )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    
    myCircuit = getappdata(gcf, 'myCircuit');
    if(isempty(myCircuit.Device))
        newXlocation = 0;
    else
        newXlocation = size(myCircuit.Device,1)*myCircuit.Device{end}.CharacteristicLength;

    end
    
    % add node to circuit
    myCircuit = myCircuit.addNode(ThreeDotCell([newXlocation 0 0]))
    % modify appdata circuit
    setappdata(gcf, 'myCircuit', myCircuit);
    
    % circuitDraw
    myCircuit.CircuitDraw(handles.LayoutWindow);
    
    %axis tight
    axis equal
    
end

