function DisbandSuperCell( handles )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
myCircuit = getappdata(gcf,'myCircuit');
% myCircuit.Mode = 'Simulation';

mode = myCircuit.Mode;


newCircuit = QCACircuit;

for i=1:length(myCircuit.Device)
    if isa(myCircuit.Device{i},'QCASuperCell')%if it's a supercell
        
        findselect=[];
        
        switch mode
            case 'Simulation'
                for j=1:length(myCircuit.Device{i}.Device)
                    if strcmp(myCircuit.Device{i}.Device{j}.SelectBox.Selected,'on') %supercell that is selected
                        findselect(end+1)=1;%are any of the cells in the SC selected?
                    else
                        findselect(end+1)=0;
                    end
                end
            case 'Layout'
                for j=1:length(myCircuit.Device{i}.Device)
                    if strcmp(myCircuit.Device{i}.Device{j}.LayoutBox.Selected,'on') %supercell that is selected
                        findselect(end+1)=1;%are any of the cells in the SC selected?
                    else
                        findselect(end+1)=0;
                    end
                end
        end
        
        
        if sum(findselect)>0 %if any of them are selected, send each cell out of the supercell
           for j=1:length(myCircuit.Device{i}.Device)
            newCircuit= newCircuit.addNode(myCircuit.Device{i}.Device{j});
           end
           
        else
           newCircuit = newCircuit.addNode(myCircuit.Device{i});
        end
                
        
    else
        newCircuit = newCircuit.addNode(myCircuit.Device{i});%if it's not a supercell
    end
end
newCircuit.Mode = myCircuit.Mode;
myCircuit=newCircuit;
myCircuit.Device


switch mode
    case 'Simulation'
        myCircuit=myCircuit.CircuitDraw(gca);
        setappdata(gcf,'myCircuit',myCircuit);
       

    case 'Layout'
        myCircuit=myCircuit.LayoutDraw(gca);
        setappdata(gcf,'myCircuit',myCircuit);
        
end





end