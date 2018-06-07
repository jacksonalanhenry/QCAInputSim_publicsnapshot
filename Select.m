function Select(p)
%   GUI SELECT
% Select functionality, then once that object is selected in the gui,
% it can be dragged and dropped.  Once deselected, it cannot be
% dragged and dropped until it is selected again.
% a=gca;
%
% a.ButtonDownFcn=@deSelAll;
%assigning the callback function, the deselect function will get its
%callback in the sel function
p.ButtonDownFcn=@selObject;



    function selObject(hObject, eventdata)
        
        
        if strcmp(p.Selected,'off')%check if it's not selected
            if ~isempty(p.ButtonDownFcn)
                
                
                
                
                
                p.Selected='on';%select it
                
                %change callback
                
                
                myCircuit = getappdata(gcf,'myCircuit');
                
                switch myCircuit.Mode
                    case 'Simulation'
                        if ~isint(p.UserData)
                            ID = floor(p.UserData);
                            
                            for i=1:length(myCircuit.Device)
                                if myCircuit.Device{i}.CellID == ID
                                    for j=1:length(myCircuit.Device{i}.Device)
                                        myCircuit.Device{i}.Device{j}.SelectBox.Selected = 'on';
                                        myCircuit.Device{i}.Device{j}.SelectBox.ButtonDownFcn = @deSelObject;
                                    end
                                end
                            end
                        end
                        
                    case 'Layout'
                        if ~isint(p.UserData)
                            ID = floor(p.UserData);
                            
                            for i=1:length(myCircuit.Device)
                                if myCircuit.Device{i}.CellID == ID
                                    for j=1:length(myCircuit.Device{i}.Device)
                                        myCircuit.Device{i}.Device{j}.LayoutBox.Selected = 'on';
                                        myCircuit.Device{i}.Device{j}.LayoutBox.ButtonDownFcn = @deSelObject;
                                    end
                                end
                            end
                        end
                        
                end
                p.ButtonDownFcn=@deSelObject;
                setappdata(gcf,'myCircuit',myCircuit);
            end
        end
        
        myCircuit=getappdata(gcf,'myCircuit');
        
        if strcmp(myCircuit.Mode,'Layout')%check mode layout or simulation
            
            DragDropPatch(gcf,p,gca);
            
        end
    end


    function deSelObject(hObject,eventdata)%using callback to deselect
        
        if strcmp(p.Selected,'on')%same logic as before, checking
            if ~isempty(p.ButtonDownFcn)%the button and condition
                p.Selected='off';
                
                
                myCircuit = getappdata(gcf,'myCircuit');
                switch myCircuit.Mode
                    case 'Simulation'
                        if ~isint(p.UserData)
                            ID = floor(p.UserData);
                            
                            for i=1:length(myCircuit.Device)
                                if myCircuit.Device{i}.CellID == ID
                                    for j=1:length(myCircuit.Device{i}.Device)
                                        myCircuit.Device{i}.Device{j}.SelectBox.Selected = 'off';
                                        myCircuit.Device{i}.Device{j}.SelectBox.ButtonDownFcn = @selObject;
                                    end
                                end
                            end
                        end
                        
                    case 'Layout'
                        if ~isint(p.UserData)
                            ID = floor(p.UserData);
                            
                            for i=1:length(myCircuit.Device)
                                if myCircuit.Device{i}.CellID == ID
                                    for j=1:length(myCircuit.Device{i}.Device)
                                        myCircuit.Device{i}.Device{j}.LayoutBox.Selected = 'off';
                                        myCircuit.Device{i}.Device{j}.LayoutBox.ButtonDownFcn = @selObject;
                                    end
                                end
                            end
                        end
                        
                end
                p.ButtonDownFcn=@selObject;
                setappdata(gcf,'myCircuit',myCircuit);
            end
        end
      
        
    end
end


%
%     function deSelAll(hObject,eventdata)
%         myCircuit=getappdata(gcf,'myCircuit');
%
%         mode = myCircuit.Mode;
%
%         if ~isempty(a.ButtonDownFcn)
%             for i=1:length(myCircuit.Device)
%
%                 switch mode
%
%                     case 'Simulation'
%
%                         if strcmp(myCircuit.Device{i}.SelectBox.Selected,'on')
%                             myCircuit.Device{i}.SelectBox.Selected='off';
%                             setappdata(gcf,'myCircuit',myCircuit);
%                         end
%
%                     case 'Layout'
%
%                         if strcmp(myCircuit.Device{i}.LayoutBox.Selected,'on')
%                             myCircuit.Device{i}.LayoutBox.Selected='off';
%                             setappdata(gcf,'myCircuit',myCircuit);
%                         end
%                 end
%
%             end
%             Select(p)
%
%         end
%     end
%
%
% end


