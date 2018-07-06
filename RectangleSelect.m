function RectangleSelect()
% This function allows the user to click and drag on the axis to draw a
% rectangle that, if overlapping with any center points of a cell, will
% select them and allow them to be dragged and dropped.
myCircuit = getappdata(gcf,'myCircuit');

r = getrect(gca);


for i=1:length(myCircuit.Device)
    if isa(myCircuit.Device{i},'QCASuperCell')
        Sel=0;
        for j=1:length(myCircuit.Device{i}.Device)
            
            %find out if any of the cells within the SC are selected by the
            %box
            if myCircuit.Device{i}.Device{j}.CenterPosition(1) >= r(1) && myCircuit.Device{i}.Device{j}.CenterPosition(2) >= r(2) && myCircuit.Device{i}.Device{j}.CenterPosition(1) <= (r(1)+r(3))  && myCircuit.Device{i}.Device{j}.CenterPosition(2) <= (r(2)+r(4))
                Sel = Sel +1;
                
            end
            
            
            
        end
        %select all of them
        if Sel
            for j=1:length(myCircuit.Device{i}.Device)
                
                myCircuit.Device{i}.Device{j}.SelectBox.Selected = 'on';                
            end
        end
        
    else
            if myCircuit.Device{i}.CenterPosition(1) >= r(1) && myCircuit.Device{i}.CenterPosition(2) >= r(2) && myCircuit.Device{i}.CenterPosition(1) <= (r(1)+r(3))  && myCircuit.Device{i}.CenterPosition(2) <= (r(2)+r(4))
                myCircuit.Device{i}.SelectBox.Selected = 'on';
                
            end        
        
    end
end

%setappdata then call dragdrop, otherwise clicking will merit nothing
setappdata(gcf,'myCircuit',myCircuit);
DragDropNEW();
end

