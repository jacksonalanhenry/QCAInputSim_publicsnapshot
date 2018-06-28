function QCALayoutAddDriver()
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

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
myCircuit.Device{length(myCircuit.Device)}.Type = 'Driver';



% circuitDraw
mode = myCircuit.Mode;


myCircuit = myCircuit.CircuitDraw(gca);







setappdata(gcf,'myCircuit',myCircuit);




%axis tight
axis equal
end