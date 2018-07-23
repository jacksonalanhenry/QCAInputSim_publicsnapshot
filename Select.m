function Select(p)
% Select functionality, then once that object is selected in the gui,
% it can be dragged and dropped.  Once deselected, it cannot be
% dragged and dropped until it is selected again.


    %assigning the callback function, the deselect function will get its
    %callback in the sel function
    
        p.ButtonDownFcn=@selObject;

    
    function selObject(hObject, eventdata)
    
    if strcmp(p.Selected,'off')%check if it's not selected
        if ~isempty(p.ButtonDownFcn)
            p.Selected='on';%select it
            p.ButtonDownFcn=@deSelObject;
            
            
            DragDrop();
            
        end
        
    end
    end
    
    
    
    function deSelObject(hObject,eventdata)%using callback to deselect
    
    if strcmp(p.Selected,'on')%same logic as before, checking
        if ~isempty(p.ButtonDownFcn)%the button and condition
            p.Selected='off';
            
            p.ButtonDownFcn=@selObject;
            
            
            %                 setappdata(gcf,'myCircuit',myCircuit);
        end
    end
    
    
    end
   
end