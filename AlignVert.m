function AlignVert()
%aligning selected cells vertically


myCircuit = getappdata(gcf,'myCircuit');

%list of all xvals and yvals
yvals=[];
xvals=[];


%fill the vectors with all the selected cells
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

ymin = min(yvals);  %lowest point of the column that will be created
xavg = mean(xvals); %the xvalue where the column is located

y=0;
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
                myCircuit.Device{i}.Device{j}.CenterPosition(1) = xavg;
                myCircuit.Device{i}.Device{j}.CenterPosition(2) = ymin+y;%shift selected cells by 2 upwards
                
                y=y+2;
            end
        end
        
    else
        
        if strcmp(myCircuit.Device{i}.SelectBox.Selected,'on')
            myCircuit.Device{i}.CenterPosition(1) = xavg;
            myCircuit.Device{i}.CenterPosition(2) = ymin+y;
            
            y=y+2;
        end
    end
end

myCircuit = myCircuit.CircuitDraw(gca);

setappdata(gcf,'myCircuit',myCircuit);



end

