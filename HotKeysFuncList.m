function HotKeysFuncList(handles,eventdata)
%Access to the handles and eventdata (keypress) allows us to decide which
%function to call based on its hotkey assignment.  

%if keys such as ctrl, alt, or shift are pressed
if ~isempty(eventdata.Modifier)
    
    if strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'h')
        AlignHoriz();
        
    elseif  strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'u')%align vertical
        AlignVert();
        
    elseif  strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'m') %make a supercell
        MakeSuperCellGUI();
        
    elseif  strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'f') %add a node
        QCALayoutAddNode();
        
    elseif  strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'d')%add a driver
        QCALayoutAddDriver();
        
    elseif  strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'b')%drag and expand box to select cells (must go over the middle)
        RectangleSelect();
        
    elseif  strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'l')%disband super cell
        DisbandSuperCell();
        
        
        
    elseif  strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'g')%turn snapt to grid on and off
        snap = get(handles.autoSnap,'Value');
        
        switch snap
            case 0
                handles.autoSnap.Value = 1;
                
            case 1
                handles.autoSnap.Value = 0;
        end
        AutoSnap(handles);
        
    elseif  strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'e') %reset cells
        ResetCells();
        
    elseif  strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'t')%refresh
        myCircuit = getappdata(gcf,'myCircuit');
        
        myCircuit = myCircuit.CircuitDraw(gca);
        
        setappdata(gcf,'myCircuit',myCircuit);
        
    elseif  strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'a')%select all
        myCircuit = getappdata(gcf,'myCircuit');
        
        if ~isempty(myCircuit.Device)
            for i = 1:length(myCircuit.Device)
                if isa(myCircuit.Device{i},'QCASuperCell')
                    
                    for j=1:length(myCircuit.Device{i}.Device)
                        
                        myCircuit.Device{i}.Device{j}.SelectBox.Selected = 'on';
                        
                        
                    end
                    
                    
                else
                    myCircuit.Device{i}.SelectBox.Selected = 'on';
                    
                end
            end
            
            DragDrop();
            setappdata(gcf,'myCircuit',myCircuit);
        end
        
    elseif  strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'q')%deselect cells (but it's really just redrawing)
        myCircuit = getappdata(gcf,'myCircuit');
        myCircuit = myCircuit.CircuitDraw(gca);
        
        setappdata(gcf,'myCircuit',myCircuit);
        
    elseif  strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'c')
        CopyCells();
        
    elseif  strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'v')
        PasteCells();
        
        
    elseif  strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'n')
        NewCircuit(handles);
        
    elseif  strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'o')
        LoadCircuit(handles);
        
    elseif  strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'s')
        SaveCircuit(handles);
    elseif strcmp(eventdata.Modifier,'control') && (strcmp(eventdata.Key,'delete') || strcmp(eventdata.Key,'backspace'))%remove any selected nodes
        RemoveNode();
        
    elseif strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'comma')
        ChangePol(handles, -1);
        
    elseif strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'period')
        ChangePol(handles, 1);
        
    end
    if   strcmp(eventdata.Modifier,'alt') && strcmp(eventdata.Key,'leftbracket')
        web('https://www.youtube.com/watch?v=TzXXHVhGXTQ');%try it
    end
    
end


end

