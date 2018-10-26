function CreateSimulationFile(handles)
%The simulation results .mat file will be created here by running numerous
%simulations and storing them into a .mat file witha  default name or one
%assigned by the user in an edit box


myCircuit = getappdata(gcf,'myCircuit');
clockSignalsList = getappdata(gcf,'clockSignalsList');
inputSignalsList = getappdata(gcf,'inputSignalsList');
myCircuit = myCircuit.GenerateNeighborList();

name = num2str(handles.nameSim.String);
nt = num2str(handles.numberOfTimeSteps.String);
numOfPeriods = num2str(handles.numberOfPeriods.String);


% f=gcf;
% 
% f.Pointer = 'watch';



if length(clockSignalsList)==1 %pipeline will run
    
%     if isempty(name)
%         %myCircuit = myCircuit.pipeline(SignalsList);
%         myCircuit.pipeline(clockSignalsList, 'Filename', name,'inputSignalsList', inputSignalsList, 'TimeSteps', nt);
% 
%     else
%         myCircuit = myCircuit.pipeline(clockSignalsList,name);    
%     end
    
    
    myCircuit.pipeline(clockSignalsList, 'Filename', name,'inputSignalsList', inputSignalsList, 'TimeSteps', nt, 'numOfPeriods', numOfPeriods);
    
elseif length(clockSignalsList) > 1
    
    %no functionality for multiple Signals yet kinda broken rn
    
    if isempty(name)
        myCircuit = myCircuit.pipeline(clockSignalsList);
        
    else
        myCircuit = myCircuit.pipeline(clockSignalsList,name);  
        
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
setappdata(gcf,'clockSignalsList',clockSignalsList);


% f.Pointer = 'arrow';



    function Yes(source,callbackdata)
        
        delete(d);
        ClearAll(handles);
        
    end

    function No(source,callbackdata)
        
        delete(d);
    end



end