function QCALayoutAddNode()
%This allows the user to add a node.  There is a similar button for adding
%a driver.  See also the Add 5 Nodes button.

myCircuit = getappdata(gcf, 'myCircuit');
nodeType = getappdata(gcf, 'nodeType');

% xloc=[];


if(isempty(myCircuit.Device))
    newXlocation = 0;
    newYlocation = 0;
else
    xs=[];
    ys=[];
    for i=1:length(myCircuit.Device)
        if isa(myCircuit.Device{i},'QCASuperCell')
            for j=1:length(myCircuit.Device{i}.Device)
                
                xs(end+1)=myCircuit.Device{i}.Device{j}.CenterPosition(1);
                ys(end+1)=myCircuit.Device{i}.Device{j}.CenterPosition(2);
            end
        else
            xs(end+1)=myCircuit.Device{i}.CenterPosition(1);
            ys(end+1)=myCircuit.Device{i}.CenterPosition(2);
        end
        
        
    end
    
 
   
    

end

%create node
switch nodeType
     case 'Three Dot Node'
         
        if(isempty(myCircuit.Device))
            newXlocation = 0;
            newYlocation = 0;
        else
            newXlocation = max(xs)+1;
            newYlocation = min(ys); 
        end
        
        node = ThreeDotCell([newXlocation newYlocation 0]);
        node.CenterPosition = [newXlocation newYlocation 0];
        
    case 'Six Dot Node'
        if(isempty(myCircuit.Device))
            newXlocation = 0;
            newYlocation = 0;
        else
            newXlocation = max(xs)+2;
            newYlocation = min(ys); 
        end 
        
        node = SixDotCell([newXlocation newYlocation 0]);
        node.CenterPosition = [newXlocation newYlocation 0];
        
    otherwise
        error('Node Type was set to an Invalid Type');
end

% add node to circuit
myCircuit = myCircuit.addNode(node);





myCircuit = myCircuit.CircuitDraw(0,gca);
%         handles.layoutchange.Value=0;



setappdata(gcf,'myCircuit',myCircuit);


%axis tight
axis equal