function RemoveNode()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
myCircuit = getappdata(gcf,'myCircuit');

newCircuit = QCACircuit;
newCircuit = {};



cells2del=[];%cells we will delete


        for i=1:length(myCircuit.Device)
            if isa (myCircuit.Device{i},'QCASuperCell') %if any of the cells in a supercell are selected, the whole thing will be deleted
                for j=1:length(myCircuit.Device{i}.Device)
                    if strcmp(myCircuit.Device{i}.Device{j}.SelectBox.Selected,'on')
                        cells2del(end+1) = i;
                        
                    end
                end
                
            else %any cell can be deleted also
                if strcmp(myCircuit.Device{i}.SelectBox.Selected,'on')
                    
                    cells2del(end+1) = i;
                end
            end
            
        end
        
        for j=1:length(cells2del) %empty each of the locations in the device list
            myCircuit.Device{cells2del(j)}={};
        end
        
        for i=1:length(myCircuit.Device)
            if ~isempty(myCircuit.Device{i})
                newCircuit{end+1}=myCircuit.Device{i}; %new circuit gets all the remaining cells
            end
        end
        
        myCircuit.Device = newCircuit;
        
        myCircuit = myCircuit.CircuitDraw(gca);
        



setappdata(gcf,'myCircuit',myCircuit);
end