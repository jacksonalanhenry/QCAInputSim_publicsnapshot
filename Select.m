function Select(p)
%   GUI SELECT
% Select functionality, then once that object is selected in the gui,
% it can be dragged and dropped.  Once deselected, it cannot be
% dragged and dropped until it is selected again.

%     p.Selected = 'off';


p.ButtonDownFcn=@selObject;


    function selObject(hObject, eventdata)
        
        
        if strcmp(p.Selected,'off')
            if ~isempty(p.ButtonDownFcn)
                
                p.Selected='on';
                
                p.ButtonDownFcn=@deSelObject;
%                                     DragDropPatch(f,p,a);
            end
        end
                myCircuit=getappdata(gcf,'myCircuit');
                
                if strcmp(myCircuit.Mode,'Layout')
                    DragDropPatch(gcf,p,gca);
                end
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


