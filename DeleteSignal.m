function DeleteSignal(handles)
%This function will delete the current signal selected in the signal list
%on the GUI.  

contents = cellstr(get(handles.signalList,'String'));

SignalsList = getappdata(gcf,'SignalsList');

if ~isempty(contents) %locating the selected signal to delete
    
    handles.signalEditor.String = '';
    handles.signalEditType.String = '';
    
    sigName = contents{get(handles.signalList,'Value')};
    
    newSigs = {};
    contents = {};
    
    delete = handles.signalList.Value; %this tells us which signal is selected
    
    SignalsList{delete} = {}; %erase that signal within the signal list
    
    
    
    for i=1:length(SignalsList) %replacing the old signals list with the nonempty signals for both the gui and the appdata list
        if ~isempty(SignalsList{i})
            
            newSigs{end+1} = SignalsList{i};
            contents{end+1,1} = SignalsList{i}.Name;
        end
    end
    
    handles.signalList.String = contents;
    
    SignalsList = newSigs;
    handles.signalList.Value = 1;
    
    plot(handles.plotAxes,0,0); %clear the plotting axis
    
    
    handles.signalName.String = 'Input Name';
    
    setappdata(gcf,'SignalsList',SignalsList);
    
end
end

