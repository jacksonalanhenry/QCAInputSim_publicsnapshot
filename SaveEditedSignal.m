function SaveEditedSignal(handles)
%This is different from the main save function.  Saving a signal within the
%signal panel overwrites the new information into the signal that is
%currently selected and under editing.

contents = cellstr(get(handles.signalList,'String')); %get the list of signals from handles


SignalsList = getappdata(gcf,'SignalsList'); %retrieve the signals from appdata
myCircuit = getappdata(gcf,'myCircuit');

%find which signal to save
if ~isempty(contents)
    
    spot = get(handles.signalList,'Value'); 
    sigName = contents{spot}; %this is the signal we selected
    
    
    for i=1:length(SignalsList)
        if strcmp(sigName,SignalsList{i}.Name)
            mySignal = SignalsList{i};  %this is the signal with the same name (they are the same)
            pick = i;
        end
    end
    
    if ~isempty(mySignal)
        sigType = mySignal.Type;
        
        handles.signalEditor.String = ''; %clear the gui boxes to indicate editing is over
        handles.signalEditType.String = '';
        
        %edit data based on the signal type
        switch sigType
            
            case 'Sinusoidal'
                
                mySignal.Amplitude = str2num(handles.changeAmp.String);
                mySignal.Wavelength = str2num(handles.changeWave.String);
                mySignal.Period = str2num(handles.changePeriod.String);
                mySignal.Phase = str2num(handles.changePhase.String);
                %mySignal.MeanValue = str2num(handles.changeMV.String);
                
                
                
            case 'Custom'
                
            case 'Fermi'
                mySignal.Amplitude = str2num(handles.changeAmpFermi.String);
                mySignal.Sharpness = str2num(handles.changeSharpnessFermi.String);
                mySignal.Period = str2num(handles.changePeriodFermi.String);
                mySignal.Phase = str2num(handles.changePhaseFermi.String);
                mySignal.MeanValue = str2num(handles.changeMeanValueFermi.String);
                
                
            case 'Electrode'
                mySignal.InputField = str2num(handles.changeInputField.String);
        end
        
        types = cellstr(get(handles.signalType,'String'));
        newSigType = types{get(handles.signalType,'Value')};
        mySignal.Type = newSigType;
        
        
        mySignal.Name = handles.signalName.String;
        
        contents{spot} = mySignal.Name;
        handles.signalList.String = contents;
        
        SignalsList{pick} = mySignal;%replace the signal with the edited one
        
        
        setappdata(gcf,'SignalsList',SignalsList);
        myCircuit = myCircuit.CircuitDraw(gca);
        setappdata(gcf,'myCircuit',myCircuit);
        
        plot(handles.plotAxes,0,0); %clear the plot axis
        
        
        
        handles.signalName.String = 'Input Name';
    end
end

end

