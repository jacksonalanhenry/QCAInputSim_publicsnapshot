function QCALayoutAddNode( handles )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    
    myCircuit = getappdata(gcf, 'myCircuit');
    if(isempty(myCircuit.Device))
        newXlocation = 0;
    else
          newXlocation = length(myCircuit.Device)-.5;
%         newXlocation = size(myCircuit.Device,1)*myCircuit.Device{end}.CharacteristicLength  
          newXlocation = newXlocation+1;
    end

    % add node to circuit
    myCircuit = myCircuit.addNode(ThreeDotCell([newXlocation 0 0]));
    
%     


    % modify appdata circuit
  setappdata(gcf, 'myCircuit', myCircuit);
       
    % circuitDraw
    myCircuit = myCircuit.CircuitDraw(handles.LayoutWindow)
    myCircuit.Device{4}.SelectBox
    
   
%         myCircuit.Device{3}.CenterPosition       
       

    %axis tight
    axis equal
 
%     Select(myCircuit.Device{end}.SelectBox);
    
end

