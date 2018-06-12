function RemoveNode(handles)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
myCircuit = getappdata(gcf,'myCircuit');

newCircuit = QCACircuit;

mode = myCircuit.Mode;


switch mode
    case 'Simulation'
        for i=1:length(myCircuit.Device)
            if isa (myCircuit.Device{i},'QCASuperCell') %if any of the cells in a supercell are selected, the whole thing will be deleted
                for j=1:length(myCircuit.Device{i}.Device)
                    if strcmp(myCircuit.Device{i}.Device{j}.SelectBox.Selected,'on')
                        
                        myCircuit.Device{i}={}
                    end
                end
                
            else %any cell can be deleted also
                if strcmp(myCircuit.Device{i}.SelectBox.Selected,'on')
                    
                    myCircuit.Device{i}={}
                end
            end
            
            if ~isempty(myCircuit.Device{i})
                newCircuit=newCircuit.addNode(myCircuit.Device{i})
            end
            
        end
        myCircuit = newCircuit;
        myCircuit = myCircuit.CircuitDraw(gca);
        
    case 'Layout'
        for i=1:length(myCircuit.Device)
            if isa (myCircuit.Device{i},'QCASuperCell') %if any of the cells in a supercell are selected, the whole thing will be deleted
                for j=1:length(myCircuit.Device{i}.Device)
                    if strcmp(myCircuit.Device{i}.Device{j}.LayoutBox.Selected,'on')
                        
                        myCircuit.Device{i}={};
                    end
                end
                
            else %any cell can be deleted also
                if strcmp(myCircuit.Device{i}.LayoutBox.Selected,'on')
                    
                    myCircuit.Device{i}={};
                end
            end
            
            if ~isempty(myCircuit.Device{i})
                newCircuit=newCircuit.addNode(myCircuit.Device{i});
            end
            
        end
        myCircuit = newCircuit;
        myCircuit = myCircuit.LayoutDraw(gca);        
end

setappdata(gcf,'myCircuit',myCircuit);
end