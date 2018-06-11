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
            
            
            ID=p.UserData %if you refer to the threedotcell class, you'll recall that the userdata is the same as the Cell ID
                            %for a layoutbox's parent cell
            
            
            %This will allow the user to have their movements snap to the
            %grid once layout mode is turned off
            if isint(ID)    %is a normal cell, not a supercell
                xcoor=p.XData(1)+.25;
                diffx=xcoor-floor(xcoor);
                
                ycoor=p.YData(1)+.75;
                diffy=ycoor-floor(ycoor);
                
                if diffx<.25
                    xcoor=floor(xcoor);
                end
                if diffx>=.25 && diffx<=.75
                    xcoor=floor(xcoor)+.5;
                end
                if diffx>.75
                    xcoor=floor(xcoor)+1;
                end
                
                if diffy<.25
                    ycoor=floor(ycoor);
                end
                if diffy>=.25 && diffy<=.75
                    ycoor=floor(ycoor)+.5;
                end
                if diffy>.75
                    ycoor=floor(ycoor)+1;
                end
                
                ID
                for i=1:length(myCircuit.Device)%find the right cell with the integer version of the selected ID
                    if myCircuit.Device{i}.CellID == ID
                       pick = i                       
                    end
                end
                
                
                myCircuit.Device{pick}.LayoutCenterPosition = [xcoor ycoor 0];
                
                myCircuit.Device{pick}.CenterPosition=myCircuit.Device{pick}.LayoutCenterPosition;
                p.ButtonDownFcn=@callSel; %assigning button to call select function
                myCircuit = myCircuit.LayoutDraw(gca);
                
                 setappdata(gcf,'myCircuit',myCircuit);
%                 Select(p);


            else    %is a supercell.  We will move the entire cell if one of them is moved
                newID = floor(ID);
                pick=1;
                for i=1:length(myCircuit.Device)%find the right cell with the integer version of the selected ID
                    if myCircuit.Device{i}.CellID == newID
                       pick = i; 
                       
                    end
                    
                end
                myCircuit.GetCellIDs(myCircuit);
                
                isa(myCircuit.Device{pick},'QCASuperCell');
                
                centerPosList=cell(length(myCircuit.Device{pick}));
                totalDiff = [];
                
                
                
                for j = 1:length(myCircuit.Device{pick}.Device) %assign all the center positions to a cell array
                    
                    centerPosList{j} = myCircuit.Device{pick}.Device{j}.LayoutCenterPosition;
                    
                    if strcmp(myCircuit.Device{pick}.Device{j}.LayoutBox.Selected,'on') %the selected cell will determine how the others change
                        xcoor=centerPosList{j}(1);
                        
                        
                        ycoor=centerPosList{j}(2);
                        
                        newPos=newPos(1,:);
                        totalDiff = newPos - [xcoor ycoor 0]
                        
                        diffx=totalDiff(1)-floor(totalDiff(1));
                        diffy=totalDiff(2)-floor(totalDiff(2));
                        
                        if diffx<.25
                            totalDiff(1)=floor(totalDiff(1));
                        end
                        if diffx>=.25 && diffx<=.75
                            totalDiff(1)=floor(totalDiff(1))+.5;
                        end
                        if diffx>.75
                            totalDiff(1)=floor(totalDiff(1))+1;
                        end
                        
                        if diffy<.25
                            totalDiff(2)=floor(totalDiff(2));
                        end
                        if diffy>=.25 && diffy<=.75
                            totalDiff(2)=floor(totalDiff(2))+.5;
                        end
                        if diffy>.75
                            totalDiff(2)=floor(totalDiff(2))+1;
                        end
                        
                        totalDiff
                        centerPosList{j}
                        
                        k = centerPosList{j} + totalDiff;
                        centerPosList{j} = k;
                        myCircuit.Device{pick}.Device{j}.CenterPosition = centerPosList{j};
                    end
                    
                    
                end %found the selected cell
                
                for i=1:length(myCircuit.Device{pick}.Device)
                    if strcmp(myCircuit.Device{pick}.Device{i}.LayoutBox.Selected,'off')
                        centerPosList{i};
                        totalDiff
                        k = centerPosList{i} + totalDiff
                        centerPosList{i} = k(1,:);
                        centerPosList{i};
                        myCircuit.Device{pick}.Device{i}.CenterPosition = centerPosList{i};
                    end
                end
                p.ButtonDownFcn=@callSel; 
                
                
                myCircuit = myCircuit.LayoutDraw(gca);
                
                setappdata(gcf,'myCircuit',myCircuit);
                               
            end  %end drag super cell
            
            
            
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

% This calls the select function
    function callSel(hObject,eventdata)
        if ~isempty(p.ButtonDownFcn)%call select function once we select after
            %dragging and dropping
            p.Selected='off';
            
            Select(p);
        end
        
    end

end