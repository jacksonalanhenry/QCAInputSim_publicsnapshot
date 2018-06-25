function DragDropPatch(f,p,a)
dragging = [];
orPos = [];
myOrPos=[];
% FOR THE GUI::: This function will allow drag and drop capability during
% layout mode

myCircuit = getappdata(f,'myCircuit');

%assigning callbacks for each of the script functions the button functions
f.WindowButtonUpFcn=@dropObject;

f.WindowButtonMotionFcn=@moveObject;

%when dragging multiple cells, we want to keep a list of those cells along
%with their positions
selectedcells=[];
selectedPos=[];
        for i=1:length(myCircuit.Device)
            if isa(myCircuit.Device{i},'QCASuperCell')
                for j=1:length(myCircuit.Device{i}.Device)
                    if strcmp(myCircuit.Device{i}.Device{j}.LayoutBox.Selected,'on')
                        selectedcells(end+1)=myCircuit.Device{i}.Device{j}.CellID;
                        
                        myCircuit.Device{i}.Device{j}.LayoutBox.ButtonDownFcn = @dragObject;
                        
                        selectedPos(:,end+1)=myCircuit.Device{i}.Device{j}.CenterPosition;
                    end
                    
                end
                
            else
                if strcmp(myCircuit.Device{i}.LayoutBox.Selected,'on')
                    
                    selectedcells(end+1)=myCircuit.Device{i}.CellID;
                    selectedPos(:,end+1)=myCircuit.Device{i}.CenterPosition;
                    
                    myCircuit.Device{i}.LayoutBox.ButtonDownFcn = @dragObject; %every cell is draggable even in a group
                end
            end
        end
        selectedcells;
        selectedPos;



% The job of the first function is to initiate the dragging process
% by getting the current point of the mouse upon clicking
    function dragObject(hObject,eventdata)
        dragging = hObject;
        orPos = get(gca,'CurrentPoint') ; %will help use dictate how much the position changes
        myOrPos = orPos; %will be used later to determine which cell was clicked to be dragged
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
            
            
            %finding which of the selected cells was the indivdual cell
            %dragged
            myOrPos=myOrPos(1,:);
            myOrPos(3)=0;
            selectedPos(3,:)=0;
            orPosDiffs = selectedPos - myOrPos';
            
            orPosDiffs = orPosDiffs.^2;
            orPosDiffs = sum(orPosDiffs,1).^(.5);
            
            [val indx] = min(orPosDiffs);
            
            ID = selectedcells(indx);%used in the next if loop
            
            
%             ID=p.UserData; 
            
            %if you refer to the threedotcell class, you'll recall that the userdata is the same as the Cell ID
            %for a layoutbox's parent cell
            
%             MainID = floor(p.UserData);
            
                          
            
            
            if ID-floor(ID)==0    %is a normal cell, not a supercell
                
                
                
                for i=1:length(myCircuit.Device)%find the right cell with the integer version
%                                                of the selected ID so we know which coordinate differece to use
                    
                    if myCircuit.Device{i}.CellID == ID
                        pick = i;
                    end
                    
                end
                
                
                centerPosList=cell(1,length(myCircuit.Device));
                centerPosList{pick} = myCircuit.Device{pick}.LayoutCenterPosition;
                
                totalDiff = [];
                
                xcoor=centerPosList{pick}(1);
                
                
                ycoor=centerPosList{pick}(2);
                
                newPos=newPos(1,:); %the final position of the dragged object
                totalDiff = newPos - [xcoor ycoor 0];%how much each cell will change
                
                
                
                
                diffx=totalDiff(1)-floor(totalDiff(1)); %range of 0 to 1 for rounding to 0, .5, or 1 relatively speaking
                diffy=totalDiff(2)-floor(totalDiff(2)); %this is priming the snap to grid functionality
                
                
                %determining how each x,y will be rounded to floor, .5 or
                %up to the next integer
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
                
                
                
                for j = 1:length(myCircuit.Device) %assign all the center positions to a cell array
                    
                    
                    
                    if ~isa(myCircuit.Device{j},'QCASuperCell') &&  strcmp(myCircuit.Device{j}.LayoutBox.Selected,'on')  %find which other cells are selected
                        
                        centerPosList{j} = myCircuit.Device{j}.LayoutCenterPosition;%list all their coordinates
                        
                        
                        
                        totalDiff;
                        centerPosList{j};
                        
                        k = centerPosList{j} + totalDiff;
                        
                        k(3)=0;
                        centerPosList{j} = k;
                        
                        
                        
                        
                        
                        
                        
                        myCircuit.Device{j}.CenterPosition = centerPosList{j}; %reassigning center positions for redrawing
                    end
                    
                    
                    
                    if isa(myCircuit.Device{j},'QCASuperCell') %dragging a whole SuperCell regardless of how many are selected (>1)
                        sel=[];
                        for k=1:length(myCircuit.Device{j}.Device)
                            if strcmp(myCircuit.Device{j}.Device{k}.LayoutBox.Selected,'on')
                                sel(end+1)=1;
                            else
                                sel(end+1)=0; %none selected
                            end
                        end
                        
                        if sum(sel) %if any cells are selected
                            for q=1:length(myCircuit.Device{j}.Device)
                                centerPosList{j} = myCircuit.Device{j}.Device{q}.LayoutCenterPosition;%list all their coordinates
                                
                                totalDiff;
                                centerPosList{j};
                                
                                k = centerPosList{j} + totalDiff;
                                
                                k(3)=0;
                                centerPosList{j} = k;
                                
                                myCircuit.Device{j}.Device{q}.CenterPosition = centerPosList{j};
                            end
                        end
                    end
                end
                
                
                p.ButtonDownFcn=@callSel; %assigning button to call select function
                myCircuit = myCircuit.LayoutDraw(gca); 
                
                setappdata(gcf,'myCircuit',myCircuit);
                %                 Select(p);
                
                
            else    %is a supercell.  We will move the entire cell if one of them is moved
                
                
                realPick = ID;
                realPick= floor((realPick-floor(realPick))*100+.1);
                
                newID = floor(ID);
                pick=1;
                
                for i=1:length(myCircuit.Device)%find the right cell with the integer version of the selected ID
                    if isa(myCircuit.Device{i},'QCASuperCell')
                        
                        for j=1:length(myCircuit.Device{i}.Device)
                            
                            if myCircuit.Device{i}.Device{j}.CellID == ID
                                pick = i;
                                
                            end
                        end
                    end
                end
                
                
                
                centerPosList=cell(length(myCircuit.Device{pick}));
                totalDiff = [];
                
                
                
                
                for j = 1:length(myCircuit.Device{pick}.Device) %assign all the center positions to a cell array
                    
                    centerPosList{j} = myCircuit.Device{pick}.Device{j}.LayoutCenterPosition;
                    
                    if strcmp(myCircuit.Device{pick}.Device{j}.LayoutBox.Selected,'on') && j==realPick %the selected cell will determine how the others change
                        xcoor=centerPosList{j}(1);
                        
                        
                        ycoor=centerPosList{j}(2);
                        
                        newPos=newPos(1,:);
                        totalDiff = newPos - [xcoor ycoor 0]; %same logic as before, creating snap to grid functionality
                        
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
                        
                        totalDiff;
                        centerPosList{j};
                        
                        k = centerPosList{j} + totalDiff;
                        k(3)=0;
                        centerPosList{j} = k;
                        k;
                        myCircuit.Device{pick}.Device{j}.CenterPosition = centerPosList{j}; %assigning each center position again
                        
                        
                    end
                    
                    
                    
                end %found the selected cell
                
                
                
                for j = 1:length(myCircuit.Device) %assign ALL the center positions to a cell array
                    
                    
                    
                    if ~isa(myCircuit.Device{j},'QCASuperCell') &&  strcmp(myCircuit.Device{j}.LayoutBox.Selected,'on')  %find which other cells are selected
                        
                        centerPosList{j} = myCircuit.Device{j}.LayoutCenterPosition;%list all their coordinates into the array
                        
                        totalDiff;
                        centerPosList{j};
                        
                        k = centerPosList{j} + totalDiff;
                        
                        k(3)=0;
                        centerPosList{j} = k;
                        
                        myCircuit.Device{j}.CenterPosition = centerPosList{j};
                    end
                    
                    if isa(myCircuit.Device{j},'QCASuperCell') %if any of the cells in the supercell are selected
                        sel=[];
                        for k=1:length(myCircuit.Device{j}.Device)
                            if strcmp(myCircuit.Device{j}.Device{k}.LayoutBox.Selected,'on')
                                sel(end+1)=1;
                            else
                                sel(end+1)=0;
                            end
                        end
                        
                        if sum(sel)
                            for q=1:length(myCircuit.Device{j}.Device)
                                centerPosList{j} = myCircuit.Device{j}.Device{q}.LayoutCenterPosition;%list all their coordinates
                                
                                totalDiff;
                                centerPosList{j};
                                
                                k = centerPosList{j} + totalDiff;
                                
                                k(3)=0;
                                centerPosList{j} = k;
                                
                                myCircuit.Device{j}.Device{q}.CenterPosition = centerPosList{j};
                            end
                        end
                    end
                end
                
                
                p.ButtonDownFcn=@callSel;
                
                myCircuit = myCircuit.LayoutDraw(gca); %redraw
                
                
                setappdata(gcf,'myCircuit',myCircuit);
                
            end  %end drag super cell
            
        end
    end



% This is using the change in position to make the drag and drop look
% seamless, instead of jumping from place to place
    function moveObject(hObject,eventdata)
        if ~isempty(dragging)
            
            newPos = get(gca,'CurrentPoint'); %getting the coordinates
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