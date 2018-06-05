function DragDropPatch(f,p,a)
dragging = [];
orPos = [];
% FOR THE GUI::: This function will allow drag and drop capability during
% layout mode

myCircuit = getappdata(f,'myCircuit');

%assigning callbacks for each of the script functions the button functions
f.WindowButtonUpFcn=@dropObject;

f.WindowButtonMotionFcn=@moveObject;

p.ButtonDownFcn=@dragObject;




% The job of the first function is to initiate the dragging process
% by getting the current point of the mouse upon clicking
    function dragObject(hObject,eventdata)
        dragging = hObject;
        orPos = get(gca,'CurrentPoint');  %will help use dictate how much the position changes

    end

        

% This function will "drop" the object by using the difference of the
% final and intial point will be added to the x and y data of the
% patch's original position.  Note that in get() we use gca instead
% of gcf since the units of the patch's x data and y data are in coordinates
% instead of pixels (much better)
    function dropObject(hObject,eventdata)
        if ~isempty(dragging)
            newPos = get(gca,'CurrentPoint');
            posDiff = newPos - orPos; %change in position
            
            set(dragging,'XData',get(dragging,'XData') + posDiff(1,1));%the patch will be at this position now
            set(dragging,'YData',get(dragging,'YData') + posDiff(1,2));
            dragging = [];
            

            ID=p.UserData; %if you refer to the threedotcell class, you'll recall that the userdata is the same as the Cell ID
                           %for a layoutbox's parent cell

            
            %somewhat redundant logic, but the new center position is
            %becoming the new location of the layout box patch
            
                myCircuit.Device{ID}.LayoutCenterPosition = [p.XData(1)+.25 p.YData(1)+.75 0];
                
                myCircuit.Device{ID}.CenterPosition=myCircuit.Device{ID}.LayoutCenterPosition;
            
            setappdata(gcf,'myCircuit',myCircuit);
%             end
            
            p.ButtonDownFcn=@callSel; %assigning button to call selectfunction
            
        end
        
        
    end




% This is using the change in position to make the drag and drop look
% seamless, instead of jumping from place to place
function moveObject(hObject,eventdata)
if ~isempty(dragging)
    
    newPos = get(gca,'CurrentPoint');%getting the coordinates
    posDiff = newPos - orPos;
    orPos = newPos;
    
    
    set(dragging,'XData',get(dragging,'XData') + posDiff(1,1));
    set(dragging,'YData',get(dragging,'YData') + posDiff(1,2));
   

    
end
end


%This calls the select function 
function callSel(hObject,eventdata)
if ~isempty(p.ButtonDownFcn)%call select function once we select after
                            %dragging and dropping
    p.Selected='off';
    Select(p);
end

end

end