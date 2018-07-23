function choosedialog(handles)
%This opens a dialog box where it double checks to make sure that the user
%wants to clear the entire figure of all signals and devices.  If the user
%selects 'Yes,' then the function ClearAll() is called after the box is deleted,
%otherwise, the box is only deleted.

    d = dialog('Position',[300 300 250 150],'Name','Clear All');
    txt = uicontrol('Parent',d,...
           'Style','text',...
           'Position',[20 80 210 40],...
           'String','Clear all? (nothing will be saved)');
       
       
       btn1 = uicontrol('Parent',d,...
           'Position',[49 40 70 25],...
           'String','Yes',...
           'Callback',@Yes);
       
       btn2 = uicontrol('Parent',d,...
           'Position',[139 40 70 25],...
           'String','Close',...
           'Callback',@No);
        
    function Yes(source,callbackdata)
        
        delete(d);
        ClearAll(handles);
        
    end

    function No(source,callbackdata)
        
        delete(d);
    end



end
