function CreateSimulationFile(handles)
%The simulation results .mat file will be created here by running numerous
%simulations and storing them into a .mat file witha  default name or one
%assigned by the user in an edit box


myCircuit = getappdata(gcf,'myCircuit');
SignalsList = getappdata(gcf,'SignalsList');
myCircuit = myCircuit.GenerateNeighborList();

name = num2str(handles.nameSim.String);


% f=gcf;
% 
% f.Pointer = 'watch';



if length(SignalsList)==1 %pipeline will run
    
    if isempty(name)
        myCircuit = myCircuit.pipeline(SignalsList);
    else
        myCircuit = myCircuit.pipeline(SignalsList,name);    
    end
    
elseif length(SignalsList) > 1
    
    %no functionality for multiple Signals yet
    
    if isempty(name)
        myCircuit = myCircuit.pipeline(SignalsList);
        
    else
        myCircuit = myCircuit.pipeline(SignalsList,name);  
        
    end
    
    
%     d = dialog('Position',[300 300 250 150],'Name','Clear All');
%     txt = uicontrol('Parent',d,...
%         'Style','text',...
%         'Position',[20 80 210 40],...
%         'String','Clear all? (nothing will be saved)');
%     
%     
%     btn1 = uicontrol('Parent',d,...
%         'Position',[49 40 70 25],...
%         'String','Yes',...
%         'Callback',@Yes);
%     
%     btn2 = uicontrol('Parent',d,...
%         'Position',[139 40 70 25],...
%         'String','Close',...
%         'Callback',@No);
    
    
end

myCircuit = myCircuit.CircuitDraw(gca);

setappdata(gcf,'myCircuit',myCircuit);
setappdata(gcf,'SignalsList',SignalsList);


% f.Pointer = 'arrow';



    function Yes(source,callbackdata)
        
        delete(d);
        ClearAll(handles);
        
    end

    function No(source,callbackdata)
        
        delete(d);
    end



end