function ClickFunctionality(handles,eventdata,Select)
%All the different types of clicks are documented here, along with the
%specific functionalities attributed to each one.


switch Select
    
    case 'normal' %left click
        %we don't want anything else for left click
        
    case 'extend' %shift click or scroll click
        RectangleSelect()
        
    case 'alternate' %right click
        RightClickThings() %but this is redundant
        
        %it is also redundant
        
        
    case 'open' %double click
        %might not need this, still thinking what we could want with a
        %double click
        
end