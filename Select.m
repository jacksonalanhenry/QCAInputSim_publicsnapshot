function Select(p)
%   GUI SELECT
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
                
                
                
                myCircuit=getappdata(gcf,'myCircuit');
                
                   
                   if strcmp(myCircuit.Mode,'Layout')
                        %check mode layout or simulation
                        setappdata(gcf,'myCircuit',myCircuit);
                        DragDropPatch(gcf,p,gca);
                   end
                   
                   
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



%     function deSelAll(hObject,eventdata)
%         myCircuit=getappdata(gcf,'myCircuit');
% 
%         mode = myCircuit.Mode;
% 
%         if ~isempty(f.ButtonDownFcn)
%             for i=1:length(myCircuit.Device)
% 
%                 switch mode
% 
%                     case 'Simulation'
% 
%                         if strcmp(myCircuit.Device{i}.SelectBox.Selected,'on')
%                             myCircuit.Device{i}.SelectBox.Selected='off';
%                             setappdata(gcf,'myCircuit',myCircuit);
%                             myCircuit.CircuitDraw(gca);
%                         end
% 
%                     case 'Layout'
% 
%                         if strcmp(myCircuit.Device{i}.LayoutBox.Selected,'on')
%                             myCircuit.Device{i}.LayoutBox.Selected='off';
%                             myCircuit.LayoutDraw(gca);
%                             setappdata(gcf,'myCircuit',myCircuit);
%                         end
%                 end
% 
%             end
%             
%             Select(p);
% 
%         end
%     end
% 
% 
% end


