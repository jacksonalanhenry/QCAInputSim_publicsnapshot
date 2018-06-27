function AlignHoriz()
%aligning selected cells horizontally


myCircuit = getappdata(gcf,'myCircuit');

yvals=[];
xvals=[];

i=1;
for i=1:length(myCircuit.Device)
    if isa(myCircuit.Device{i},'QCASuperCell')
        Sel=0;
        for j=1:length(myCircuit.Device{i}.Device)
            if strcmp(myCircuit.Device{i}.Device{j}.SelectBox.Selected,'on')
                Sel=Sel+1;
                
            end
            
        end
        if Sel
            for j=1:length(myCircuit.Device{i}.Device)
                yvals(end+1) = myCircuit.Device{i}.Device{j}.CenterPosition(2);
                xvals(end+1) = myCircuit.Device{i}.Device{j}.CenterPosition(1);
            end
        end
        
    else
        
        if strcmp(myCircuit.Device{i}.SelectBox.Selected,'on')
            yvals(end+1) = myCircuit.Device{i}.CenterPosition(2);
            xvals(end+1) = myCircuit.Device{i}.CenterPosition(1);
        end
    end
end

yavg = mean(yvals);
xmin = min(xvals);

x=0;
for i=1:length(myCircuit.Device)
    if isa(myCircuit.Device{i},'QCASuperCell')
        Sel=0;
        for j=1:length(myCircuit.Device{i}.Device)
            if strcmp(myCircuit.Device{i}.Device{j}.SelectBox.Selected,'on')
                Sel=Sel+1;
                
            end
            
        end
        if Sel
            for j=1:length(myCircuit.Device{i}.Device)
                myCircuit.Device{i}.Device{j}.CenterPosition(2) = yavg;
                myCircuit.Device{i}.Device{j}.CenterPosition(1) = xmin+x;
                
                x=x+1;
            end
        end
        
    else
        
        if strcmp(myCircuit.Device{i}.SelectBox.Selected,'on')
            myCircuit.Device{i}.CenterPosition(2) = yavg;
            myCircuit.Device{i}.CenterPosition(1) = xmin+x;
            
            x=x+1;
        end
    end
end

myCircuit = myCircuit.CircuitDraw(gca);

setappdata(gcf,'myCircuit',myCircuit);



end

