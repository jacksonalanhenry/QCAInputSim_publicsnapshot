function CreateSignal(handles, signalCategory)
%This function creates the signal. It can be sinusoidal, electrode, fermi,
%or custom, and will be saved as such.  The user can decide which of the 4
%they want to have their signal to be, and assign the corresponding values
%before creating


if ~isempty(handles.signalName.String) %the signal must get a name in order to be created
    clockSignalsList = getappdata(gcf,'clockSignalsList');
    inputSignalsList = getappdata(gcf,'inputSignalsList');
    
    
    clockNames = cellstr(get(handles.signalList,'String'));
    inputNames = cellstr(get(handles.inputSignalList,'String'));

    
    contents = cellstr(get(handles.signalType,'String'));
    sigType = contents{get(handles.signalType,'Value')};
    transitions = cellstr(get(handles.transitionType,'String'));
    transType = transitions{get(handles.transitionType,'Value')};
    
    
    
    % sigType = handlesButton.signalType.String;
    mySignal = Signal();
    
    switch sigType %assign the values depending on what signal type is selected
        case 'Sinusoidal'
            mySignal.Amplitude = str2num(handles.changeAmp.String);
            mySignal.Wavelength = str2num(handles.changeWave.String);
            mySignal.Period = str2num(handles.changePeriod.String);
            mySignal.Phase = str2num(handles.changePhase.String);
            mySignal.Type = sigType;
            
            
        case 'Fermi'
            mySignal.Amplitude = str2num(handles.changeAmpFermi.String);
            mySignal.Sharpness = str2num(handles.changeSharpnessFermi.String);
            mySignal.Period = str2num(handles.changePeriodFermi.String);
            mySignal.Phase = str2num(handles.changePhaseFermi.String);
            mySignal.MeanValue = str2num(handles.changeSharpnessFermi.String);
            mySignal.Type = sigType;
            
            
        case 'Custom'
            
            
            mySignal.Type = sigType;
            
            
        case 'Electrode'
            mySignal.Type = sigType;
            mySignal.InputField = str2num(handles.changeInputField.String);
    end
    
    
    copy=0;
    switch signalCategory
        case 'clockSignal'
            for i=1:length(clockNames)
                if strcmp(clockNames{i},handles.signalName.String)
                    copy=copy+1;
                end
            end
            
            if copy~=0
                newName = strcat(handles.signalName.String,'(copy)');
                mySignal.Name = newName;
                handles.signalList.String{end+1,1} = newName;
            else
                mySignal.Name = handles.signalName.String;
                handles.signalList.String{end+1,1} = handles.signalName.String;
            end
            
            clockSignalsList{end+1} = mySignal;
            setappdata(gcf,'clockSignalsList',clockSignalsList);
            
        case 'inputSignal'
            for i=1:length(inputNames)
                if strcmp(inputNames{i},handles.signalName.String)
                    copy=copy+1;
                end
            end
            
            if copy~=0
                newName = strcat(handles.signalName.String,'(copy)');
                mySignal.Name = newName;
                handles.inputSignalList.String{end+1,1} = newName;
            else
                mySignal.Name = handles.signalName.String;
                handles.inputSignalList.String{end+1,1} = handles.signalName.String;
            end
            
            inputSignalsList{end+1} = mySignal;
            setappdata(gcf,'inputSignalsList',inputSignalsList);
           
        otherwise
            disp('Not currently implemented')
    end
    
    
    
    
    
    
    

    handles.signalName.String = 'Input Name';
    handles.signalName.ForegroundColor = 'black';
    handles.signalName.Value = 1;
    
else
    
    handles.signalName.String = 'NAME NEEDED';
    fprintf('INPUT NAME NEEDED\n')
    %         handles.signalName.ForegroundColor = 'red';
    
    
    handles.signalName.String = 'Input Name';
    
    handles.signalName.ForegroundColor = 'red';
end

end