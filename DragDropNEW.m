function DragDropNEW(varargin)
dragging = [];
orPos = [];
myOrPos=[];
ID=0;
% FOR THE GUI::: This function will allow drag and drop capability during

n=nargin;


f=gcf;
a=gca;

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
        Sel=0;
        for j=1:length(myCircuit.Device{i}.Device)
            
            if strcmp(myCircuit.Device{i}.Device{j}.SelectBox.Selected,'on')
                Sel=Sel+1;
            end
        end
        if Sel
            for j=1:length(myCircuit.Device{i}.Device)
                
                selectedcells(end+1)=myCircuit.Device{i}.Device{j}.CellID;
                
%                 myCircuit.Device{i}.Device{j}.SelectBox.ButtonDownFcn = @dragObject;
                
                selectedPos(:,end+1)=myCircuit.Device{i}.Device{j}.CenterPosition;
            end
            
        end
        
    else
        if strcmp(myCircuit.Device{i}.SelectBox.Selected,'on')
            
            selectedcells(end+1)=myCircuit.Device{i}.CellID;
            selectedPos(:,end+1)=myCircuit.Device{i}.CenterPosition;
            
%             myCircuit.Device{i}.SelectBox.ButtonDownFcn = @dragObject; %every cell is draggable even in a group
        end
    end
end
selectedcells;
selectedPos;

for a=1:length(selectedcells)
    patchList{a} = {};
end


cellList = myCircuit.getCellArray(selectedcells);


loopit = length(cellList);

for i=1:loopit
    if (selectedcells(i)-floor(selectedcells(i)))==0
    
        patchList{i} = patch;
        patchList{i}.XData=[cellList{i}.CenterPosition(1)-.25;cellList{i}.CenterPosition(1)+.25;cellList{i}.CenterPosition(1)+.25;cellList{i}.CenterPosition(1)-.25];
        patchList{i}.YData=[cellList{i}.CenterPosition(2)-.75;cellList{i}.CenterPosition(2)-.75;cellList{i}.CenterPosition(2)+.75;cellList{i}.CenterPosition(2)+.75];
        patchList{i}.FaceColor=[1 1 1];
        patchList{i}.FaceAlpha = .02;
        
        patchList{i}.ButtonDownFcn = @dragObject;
    
    else
        
        patchList{i} = patch;
        patchList{i}.XData=[cellList{i}.CenterPosition(1)-.25;cellList{i}.CenterPosition(1)+.25;cellList{i}.CenterPosition(1)+.25;cellList{i}.CenterPosition(1)-.25];
        patchList{i}.YData=[cellList{i}.CenterPosition(2)-.75;cellList{i}.CenterPosition(2)-.75;cellList{i}.CenterPosition(2)+.75;cellList{i}.CenterPosition(2)+.75];
        patchList{i}.EdgeColor=cellList{i}.SelectBox.EdgeColor;
        patchList{i}.FaceAlpha = .02;
        patchList{i}.LineWidth = 3;
        patchList{i}.ButtonDownFcn = @dragObject;
    end
    
end



% The job of the first function is to initiate the dragging process
% by getting the current point of the mouse upon clicking
    function dragObject(hObject,eventdata)
        dragging = hObject;
        orPos = get(gca,'CurrentPoint') ; %will help use dictate how much the position changes
        myOrPos = orPos; %will be used later to determine which cell was clicked to be dragged
        
        
        
        %finding which of the selected cells was the indivdual cell
        %dragged
        myOrPos=myOrPos(1,:);
        myOrPos(3)=0;
        selectedPos(3,:)=0;
        orPosDiffs = selectedPos - myOrPos';
        
        orPosDiffs = orPosDiffs.^2;
        orPosDiffs = sum(orPosDiffs,1).^(.5);
        
        [val indx] = min(orPosDiffs);

    end


% This function will "drop" the object by using the difference of the
% final and intial point will be added to the x and y data of the
% patch's original position.  Note that in get() we use gca instead
% of gcf since the units of the patch's x data and y data are in coordinates
% instead of pixels (much better)
    function dropObject(hObject,eventdata)
        if ~isempty(dragging)
            
            newPos = get(gca,'CurrentPoint');
            posDiff = newPos - orPos;%change in position
            
            
            mainPosDiff = newPos - myOrPos;
            mainPosDiff = mainPosDiff(1,:);
            mainPosDiff(3)=0;
            
            set(dragging,'XData',get(dragging,'XData') + posDiff(1,1));%the patch will be at this position now
            set(dragging,'YData',get(dragging,'YData') + posDiff(1,2));
            dragging = [];
            
            
            
            for i=1:length(myCircuit.Device)
                sel=0;
                if isa(myCircuit.Device{i},'QCASuperCell')
                    
                    for j=1:length(myCircuit.Device{i}.Device)
                        if strcmp(myCircuit.Device{i}.Device{j}.SelectBox.Selected,'on')
                            sel=sel+1;
                        end
                    end

                    if sel
                        
                        for j=1:length(myCircuit.Device{i}.Device)
                            myCircuit.Device{i}.Device{j}.CenterPosition = myCircuit.Device{i}.Device{j}.CenterPosition + mainPosDiff;
                        end
                        
                    end
                    
                else %not a super cell
                    
                    
                    if strcmp(myCircuit.Device{i}.SelectBox.Selected,'on') 
                        myCircuit.Device{i}.CenterPosition = myCircuit.Device{i}.CenterPosition + mainPosDiff;
                        myCircuit.Device{i}.CenterPosition;
                        
                    end
                    
                end
            end            
            
            patchList={}; %empty the patch list since we don't need any of them anymore
            
%             p.ButtonDownFcn=@callSel;
            
            myCircuit = myCircuit.CircuitDraw(gca); %redraw
            
            if n==1
                SnapToGrid(varagin{1});
            end
            
            
            setappdata(gcf,'myCircuit',myCircuit);
            
        end  %end drag super cell
        
    end




% This is using the change in position to make the drag and drop look
% seamless, instead of jumping from place to place
    function moveObject(hObject,eventdata)
        if ~isempty(dragging)
            
            newPos = get(gca,'CurrentPoint'); %getting the coordinates
            posDiff = newPos - orPos;
            orPos = newPos;
            
            
            for i=1:length(patchList)
                        patchList{i}.XData = patchList{i}.XData + posDiff(1,1);
                        patchList{i}.YData = patchList{i}.YData + posDiff(1,2);                
            end
            
 
        end
        
    end
end