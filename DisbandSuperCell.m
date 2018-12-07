function DisbandSuperCell()
%If a member of a a supercell is selected and then this function is called,
%then the supercell will be disbanded and all constituent parts will be
%individual nodes again.
myCircuit = getappdata(gcf,'myCircuit');


newCircuit = QCACircuit;

for i=1:length(myCircuit.Device)
    if isa(myCircuit.Device{i},'QCASuperCell')%if it's a supercell
        
        findselect=[];
        
        
        for j=1:length(myCircuit.Device{i}.Device)
            if strcmp(myCircuit.Device{i}.Device{j}.SelectBox.Selected,'on') %supercell that is selected
                findselect(end+1)=1;%are any of the cells in the SC selected?
            else
                findselect(end+1)=0;
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

snapping = myCircuit.SnapToGrid; %keep the snap to grid trait


myCircuit=newCircuit; %old = new

myCircuit.SnapToGrid = snapping;



myCircuit=myCircuit.CircuitDraw(0,gca);
setappdata(gcf,'myCircuit',myCircuit);


end