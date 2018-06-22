function ChangeCellPos(handles)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
myCircuit = getappdata(gcf,'myCircuit');

newPos = str2num(get(handles.chngPos,'String'));



selCells=0; %which cells are selected.  We want it to be 1

%these two will only become useful if selCells == 1
pick=0; 
SCpick=0;


mode = myCircuit.Mode; %for layout or sim modes



if length(newPos) == 2 %we only want to move one cell by position
    
    switch mode
        case 'Simulation'
            for i=1:length(myCircuit.Device)
                
                if isa(myCircuit.Device{i},'QCASuperCell') %check for device being selected
                    
                    for j=1:length(myCircuit.Device{i}.Device)
                        if strcmp(myCircuit.Device{i}.Device{j}.SelectBox.Selected,'on')
                            
                            selCells=selCells+1; 
                            pick = i; 
                            SCpick = j;
                        end
                    end
                else
                    if strcmp(myCircuit.Device{i}.SelectBox.Selected,'on')
                        selCells=selCells+1;
                        pick = i;
                    end
                end
            end
            
            if selCells == 1  %there is only 1 cell selected, now we know which one to change its position
                if isa(myCircuit.Device{pick},'QCASuperCell')
                    myCircuit.Device{pick}.Device{SCpick}.CenterPosition(1:2) = newPos;
                    
                    
                else
                    myCircuit.Device{pick}.CenterPosition(1:2) = newPos;
                end
            end
            
            myCircuit = myCircuit.CircuitDraw(gca);
            
        case 'Layout'
            
            for i=1:length(myCircuit.Device)
                
                if isa(myCircuit.Device{i},'QCASuperCell') %(strcmp(myCircuit.Device{i}.SelectBox.Selected,'on'))%check for device being on
                    
                    for j=1:length(myCircuit.Device{i}.Device)
                        if strcmp(myCircuit.Device{i}.Device{j}.LayoutBox.Selected,'on')
                            
                            selCells=selCells+1;
                            pick = i;
                            SCpick = j;
                        end
                    end
                else
                    if strcmp(myCircuit.Device{i}.LayoutBox.Selected,'on')
                        selCells=selCells+1;
                        pick = i;
                    end
                end
            end
            
            if selCells == 1
                if isa(myCircuit.Device{pick},'QCASuperCell')
                    myCircuit.Device{pick}.Device{SCpick}.CenterPosition(1:2) = newPos;
                    
                    
                else
                    myCircuit.Device{pick}.CenterPosition(1:2) = newPos;
                end
            end
            
            myCircuit = myCircuit.LayoutDraw(gca);
     
            
    end
    
    setappdata(gcf,'myCircuit',myCircuit);
end

