function DragDropPatch(f,p,a)
dragging = [];
orPos = [];
% FOR THE GUI:::Assigning the button functions to each of the three functions below using
% callbacks

myCircuit = getappdata(f,'myCircuit');

f.WindowButtonUpFcn=@dropObject;

f.WindowButtonMotionFcn=@moveObject;

p.ButtonDownFcn=@dragObject;


%
% The job of the first function is to initiate the dragging process
% by getting the current point of the mouse upon clicking
    function dragObject(hObject,eventdata)
        dragging = hObject;
        
        orPos = get(gca,'CurrentPoint');
        
    end

%
% This function will "drop" the object by using the difference of the
% final and intial point will be added to the x and y data of the
% patch's original position.  Note that in get() we use gca instead
% of gcf since the units of the patch's x data and y data are in coordinates
% instead of pixels (much better)
    function dropObject(hObject,eventdata)
        if ~isempty(dragging)
            newPos = get(gca,'CurrentPoint');
            posDiff = newPos - orPos;
            
            set(dragging,'XData',get(dragging,'XData') + posDiff(1,1));
            set(dragging,'YData',get(dragging,'YData') + posDiff(1,2));
            dragging = [];
            
            for i=1:length(myCircuit.Device)
                if strcmp(myCircuit.Device{i}.LayoutBox.Selected,'on')
                    myCircuit.Device{i}.LayoutCenterPosition(1)=myCircuit.Device{i}.CenterPosition(1)+posDiff(1,1);
                    myCircuit.Device{i}.LayoutCenterPosition(2)=myCircuit.Device{i}.CenterPosition(2)+posDiff(1,2);
                end
            end
            
            p.ButtonDownFcn=@callSel;
            
        end
        
        
    end


% This is using the change in position to make the drag and drop look
% seamless, instead of jumping from place to place
function moveObject(hObject,eventdata)
if ~isempty(dragging)
    
    newPos = get(gca,'CurrentPoint');
    posDiff = newPos - orPos;
    orPos = newPos;
    
    
    set(dragging,'XData',get(dragging,'XData') + posDiff(1,1));
    set(dragging,'YData',get(dragging,'YData') + posDiff(1,2));
   
            for i=1:length(myCircuit.Device)
                if strcmp(myCircuit.Device{i}.LayoutBox.Selected,'on')
                    myCircuit.Device{i}.LayoutCenterPosition(1)=myCircuit.Device{i}.CenterPosition(1)+posDiff(1,1);
                    myCircuit.Device{i}.LayoutCenterPosition(2)=myCircuit.Device{i}.CenterPosition(2)+posDiff(1,2);
                end
            end    
    
    
    
end
end

function callSel(hObject,eventdata)
if ~isempty(p.ButtonDownFcn)
    p.Selected='off';
    Select(p);
end

end

end