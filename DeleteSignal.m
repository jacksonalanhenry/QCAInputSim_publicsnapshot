function DeleteSignal(handles)
%This function will delete the current signal selected in the signal list
%on the GUI.  

contents = cellstr(get(handles.signalList,'String'));

clockSignalsList = getappdata(gcf,'clockSignalsList');

if ~isempty(contents) %locating the selected signal to delete
    
    handles.signalEditor.String = '';
    handles.signalEditType.String = '';
    
    sigName = contents{get(handles.signalList,'Value')};
    
    newSigs = {};
    contents = {};
    
    delete = handles.signalList.Value; %this tells us which signal is selected
    
    clockSignalsList{delete} = {}; %erase that signal within the signal list
    
    
    
    for i=1:length(clockSignalsList) %replacing the old signals list with the nonempty signals for both the gui and the appdata list
        if ~isempty(clockSignalsList{i})
            
            newSigs{end+1} = clockSignalsList{i};
            contents{end+1,1} = clockSignalsList{i}.Name;
        end
    end
    
    handles.signalList.String = contents;
    
    clockSignalsList = newSigs;
    handles.signalList.Value = 1;
    
    plot(handles.plotAxes,0,0); %clear the plotting axis
    
    
    handles.signalName.String = 'Input Name';
    
    setappdata(gcf,'clockSignalsList',clockSignalsList);
    
end
end

