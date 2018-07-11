function RightClickThings()
%Upon right-clicking, the user will see a uicontext menu where he or she
%can selected multiple options, all of which are functions within the gui
%for the purpose of increased ease of use.



%get the current figure and axis
f = gcf;
ax = gca;

%create uicontrol
c = uicontextmenu;

% Assign the uicontextmenu to the plot line
%if the user right-clicks anywhere, he can open the menu 
ax.UIContextMenu = c;
f.UIContextMenu = c;

% Create child menu items for the uicontextmenu.
%selecting any menu item calls its respective function
m1 = uimenu(c,'Label','Make Super Cell (Ctrl+S)','Callback',@changeThings);
m2 = uimenu(c,'Label','Disband Super Cell (Ctrl+L)','Callback',@changeThings);

m4 = uimenu(c,'Label','Align');
m4_1 = uimenu('Parent',m4,'Label','Horizontal (Ctrl+H)','Callback',@changeThings);
m4_2 = uimenu('Parent',m4,'Label','Vertical (Ctrl+U)','Callback',@changeThings);

m5 = uimenu(c,'Label','Box Select (Ctrl+B)','Callback',@changeThings);
m6 = uimenu(c,'Label','Remove Node (Del)','Callback',@changeThings);

m7 = uimenu(c,'Label','Add');
m7_1 = uimenu(m7,'Label','Driver (Ctrl+D)','Callback',@changeThings);
m7_2 = uimenu(m7,'Label','Node (Ctrl+F)','Callback',@changeThings);

m8 = uimenu(c,'Label','Copy (Ctrl+C)','Callback',@changeThings);
m9 = uimenu(c,'Label','Paste (Ctrl+V)','Callback',@changeThings);




%all the function calls for the callback upon selecting a menu item
    function changeThings(source,callbackdata)
        switch source.Label
            case 'Make Super Cell'
                MakeSuperCellGUI();
            case 'Disband Super Cell'
                DisbandSuperCell();
            case 'Vertical'
                AlignVert();
            case 'Horizontal'
                AlignHoriz();
            case 'Box Select'
                RectangleSelect();
            case 'Remove Node'
                RemoveNode();
            case 'Driver'
                QCALayoutAddDriver();
            case 'Node'
                QCALayoutAddNode();
            case 'Copy'
                CopyCells();
            case 'Paste'
                PasteCells();
        end
    end
end