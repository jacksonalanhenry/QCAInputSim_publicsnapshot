function RemoveNode(handles)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
myCircuit = getappdata(gcf,'myCircuit');

newCircuit = QCACircuit;
newCircuit = {};

mode = myCircuit.Mode;

cells2del=[];

switch mode
    case 'Simulation'
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
        
        for j=1:length(cells2del)
            myCircuit.Device{cells2del(j)}={};
        end
        
        for i=1:length(myCircuit.Device)
            if ~isempty(myCircuit.Device{i})
                newCircuit{end+1}=myCircuit.Device{i};
            end
        end
        myCircuit.Device = newCircuit;
        myCircuit = myCircuit.CircuitDraw(gca);
        
    case 'Layout'
        for i=1:length(myCircuit.Device)
            if isa (myCircuit.Device{i},'QCASuperCell') %if any of the cells in a supercell are selected, the whole thing will be deleted
                for j=1:length(myCircuit.Device{i}.Device)
                    if strcmp(myCircuit.Device{i}.Device{j}.LayoutBox.Selected,'on')
                        
                        cells2del(end+1) = i;
                    end
                end
                
            else %any cell can be deleted also
                if strcmp(myCircuit.Device{i}.LayoutBox.Selected,'on')
                    
                    cells2del(end+1) = i;
                end
            end
            
        end
        for j=1:length(cells2del)
            myCircuit.Device{cells2del(j)}={};
        end
        
        for i=1:length(myCircuit.Device)
            if ~isempty(myCircuit.Device{i})
                newCircuit{end+1}=myCircuit.Device{i};
            end
        end
        myCircuit.Device = newCircuit;
        myCircuit = myCircuit.LayoutDraw(gca);      
end


% myCircuit = myCircuit.GenerateNeighborList() STILL NEED TO FIX
% GENERATE NEIGHBOR LIST


setappdata(gcf,'myCircuit',myCircuit);
end