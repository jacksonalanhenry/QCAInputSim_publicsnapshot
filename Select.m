function Select(p)
%   GUI SELECT
% Select functionality, then once that object is selected in the gui,
% it can be dragged and dropped.  Once deselected, it cannot be
% dragged and dropped until it is selected again.
if strcmp(p.ButtonDownFcn,'on')
    p.ButtonDownFcn = 'off';
end

p.ButtonDownFcn=@selObject;
% a.ButtonDownFcn=@deSelObject;
myCircuit = getappdata(gcf,'myCircuit');

    function selObject(hObject, eventdata)
        
        
        if strcmp(p.Selected,'off')
            if ~isempty(p.ButtonDownFcn)
                
                p.Selected='on';

                
                
                p.ButtonDownFcn=@deSelObject;
%                                     DragDropPatch(f,p,a);
            end
        end
        
        %         if strcmp(p.Selected,'on')
        %             DragDropPatch(f,p,a);
        %         end
    end


    function deSelObject(hObject,eventdata)
        
        if strcmp(p.Selected,'on')
            if ~isempty(p.ButtonDownFcn)
                p.Selected='off';
                p.ButtonDownFcn=@selObject;
                
            end
        end
    end

end


