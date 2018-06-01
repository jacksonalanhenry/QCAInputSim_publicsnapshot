function Select(p)
% Select functionality, then once that object is selected in the gui,
% it can be dragged and dropped.  Once deselected, it cannot be
% dragged and dropped until it is selected again.

% myCircuit=getappdata(gcf,'myCircuit');

% for i=1:length(myCircuit)
%     myCircuit.Device{i}.SelectBox.ButtonDownFcn=@selObject;
% end

a.ButtonDownFcn=@deSelObject;



% Select functionality, then once that object is selected in the gui,
% it can be dragged and dropped.  Once deselected, it cannot be
% dragged and dropped until it is selected again.


p.ButtonDownFcn=@selObject;





    function selObject(hObject, eventdata)
        
        
        if strcmp(p.Selected,'off')
            if ~isempty(p.ButtonDownFcn)
                
                p.Selected='on';
                
            end
        end
    end

    function deSelObject(hObject,eventdata)
        
        if strcmp(p.Selected,'on')
            if ~isempty(a.ButtonDownFcn)
                p.Selected='off';
                p.ButtonDownFcn=@selObject;
                
            end
        end
        
    end

end

















%     function selObject(hObject, eventdata)

% for i=1:length(myCircuit)
%     if strcmp(myCircuit.Device{i}.SelectBox.Selected,'off')
%         if ~isempty(myCircuit.Device{i}.SelectBox.ButtonDownFcn)
%             %                     selectedcells{i}=p(i)
%             myCircuit.Device{i}.SelectBox.Selected='on'
%
%         end
%     end
% end
%         if strcmp(p.Selected,'on')
%             DragDropPatch(f,p,a);
%         end
% end

%
%     function deSelObject(hObject,eventdata)
%         for i=1:length(p)
%             if strcmp(p(i).Selected,'on')
%                 if ~isempty(a.ButtonDownFcn)
%                     p(i).Selected='off';
%                     p(i).ButtonDownFcn=@selObject;
%
%                 end
%             end
%         end
%         selectedcells=cell(1,length(p));
%     end


