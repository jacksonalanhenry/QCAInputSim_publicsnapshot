function DisbandSuperCell( handles )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    myCircuit = getappdata(gcf,'myCircuit');
    myCircuit.Mode = 'Simulation';
    
    
    newCircuit = QCACircuit;
    
    for i=1:length(myCircuit.Device)
        if isa(myCircuit.Device{i},'QCASuperCell')
            for j=1:length(myCircuit.Device{i}.Device)
               newCircuit= newCircuit.addNode(myCircuit.Device{i}.Device{j});
               
                
            end
        else
            newCircuit = newCircuit.addNode(myCircuit.Device{i});
            newCircuit.Device{i}.SelectBox;
        end
    end
    
    myCircuit=newCircuit;
    newCircuit.Device{2}.SelectBox;
    
    myCircuit.Device{2}.SelectBox;
    myCircuit.GetCellIDs(myCircuit);
    
    
    myCircuit=myCircuit.CircuitDraw(handles.LayoutWindow);
    setappdata(gcf,'myCircuit',myCircuit);

end

