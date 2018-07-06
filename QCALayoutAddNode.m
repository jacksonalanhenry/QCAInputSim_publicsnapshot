function QCALayoutAddNode()
%This allows the user to add a node.  There is a similar button for adding
%a driver.  See also the Add 5 Nodes button.

myCircuit = getappdata(gcf, 'myCircuit');

% xloc=[];


if(isempty(myCircuit.Device))
    newXlocation = 0;
    newYlocation = 0;
else
    xs=[];

    for i=1:length(myCircuit.Device)
        if isa(myCircuit.Device{i},'QCASuperCell')
            for j=1:length(myCircuit.Device{i}.Device)
                
                xs(end+1)=myCircuit.Device{i}.Device{j}.CenterPosition(1);
            end
        else
            xs(end+1)=myCircuit.Device{i}.CenterPosition(1);
        end
        
        
    end
    
    
    ys=[];
    for i=1:length(myCircuit.Device)
        if isa(myCircuit.Device{i},'QCASuperCell')
            for j=1:length(myCircuit.Device{i}.Device)
                
                ys(end+1)=myCircuit.Device{i}.Device{j}.CenterPosition(2);
            end
        else
            ys(end+1)=myCircuit.Device{i}.CenterPosition(2);
        end
        
        
    end    
    
    newXlocation = max(xs)+1;
    newYlocation = min(ys);    
    

end

% add node to circuit
myCircuit = myCircuit.addNode(ThreeDotCell([newXlocation newYlocation 0]));

myCircuit.Device{length(myCircuit.Device)}.CenterPosition = [newXlocation newYlocation 0];




        myCircuit = myCircuit.CircuitDraw(gca);
%         handles.layoutchange.Value=0;



setappdata(gcf,'myCircuit',myCircuit);


%axis tight
axis equal