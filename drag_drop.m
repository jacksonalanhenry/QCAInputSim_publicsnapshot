
function drag_drop(f);

f.WindowButtonUpFcn=@dropObject;
f.WindowButtonMotionFcn=@moveObject;
f.Units='normalized';




MHB = uix.HBox('parent',f)

ax=axes('parent',MHB);

an1 = annotation('textbox','position',[1 1 1 1],'String',...
             'Hello','ButtonDownFcn',@dragObject);
an1.Parent(1)=ax;

a = annotation('textbox','position',[0.2 0.2 0.2 0.2],...
    'String','Hello','ButtonDownFcn',@dragObject);
a.Parent(1)=ax;

MVB=uix.VBox('parent',MHB);
drivebuttongroup = uicontrol('Style', 'popup','parent',MVB,'string','Driver Cells');
targetbuttongroup = uicontrol('Style', 'popup','parent',MVB,'string','Target Cells');


MHB.Widths(1)=-6; %two button groups and spacing changed


a=-4;
b=4;
ax.YLim=[a b];
ax.XLim=[a b];
grid on;

dragging = [];
orPos = [];
    function dragObject(hObject,eventdata)
        dragging = hObject;
        orPos = get(gcf,'CurrentPoint');
    end
    function dropObject(hObject,eventdata)
        if ~isempty(dragging)
            newPos = get(gcf,'CurrentPoint');
            
            
            posDiff = newPos - orPos;

            
            set(dragging,'Position',get(dragging,'Position') + [posDiff(1:2) 0 0]);
            
            dragging = [];
        end
    end
    function moveObject(hObject,eventdata)
        if ~isempty(dragging)
            newPos = get(gcf,'CurrentPoint');
            
          
            
            posDiff = newPos - orPos
            
            
            orPos = newPos

            
            set(dragging,'Position',get(dragging,'Position') + [posDiff(1:2) 0 0]);
            
        end

    end





end