function GetSignalPropsGUI(handles)
%This is the precursor to editing a signal and saving it.  When the user
%selects a signal from the signal list in the gui, its name and type will
%be displayed, and the signal if it is Fermi, custom/piecewise, or sinusoidal, will be plotted

contents = cellstr(get(handles.signalList,'String')); %get the signal list from handles


if contents{1}~=""
    sigName = contents{get(handles.signalList,'Value')};
    
    SignalsList = getappdata(gcf,'SignalsList'); %get the signal list from the app data that already exists
    
    
    
    if ~isempty(SignalsList)
        
        for i=1:length(SignalsList)
            SignalsList{i}.Name;
            if strcmp(sigName,SignalsList{i}.Name)
                mySignal = SignalsList{i};
                pick = i;
            end
        end
        
        handles.signalEditor.String = sigName;
        handles.signalEditType.String = mySignal.Type;
        handles.signalName.String = sigName;
        
        SignalsList{pick} = mySignal;
        
        Type = mySignal.Type;
        
        SignalTypePanelSwitch(handles,Type); %make the right panel pop up
        
        switch Type
            
            case 'Sinusoidal'
                handles.signalType.Value = 1;
                
                
                handles.changeAmp.String = num2str(mySignal.Amplitude); %display the properties in the edit boxes
                handles.changeWave.String = num2str(mySignal.Wavelength);
                handles.changePeriod.String = num2str(mySignal.Period);
                handles.changePhase.String = num2str(mySignal.Phase);
                handles.changeMeanValue.String = num2str(mySignal.MeanValue);
                
                
            case 'Fermi'
                handles.signalType.Value = 2;
                
                handles.changeAmpFermi.String = num2str(mySignal.Amplitude); %display the properties in the edit boxes
                handles.changeWaveFermi.String = num2str(mySignal.Wavelength);
                handles.changePeriodFermi.String = num2str(mySignal.Period);
                handles.changePhaseFermi.String = num2str(mySignal.Phase);
                handles.changeMeanValueFermi.String = num2str(mySignal.MeanValue);
                handles.changeSharpnessFermi.String = num2str(mySignal.Sharpness);
                
                
            case 'Custom'
                handles.signalType.Value = 3;
                %nothing yet, but it will also get plotted once custom
                %becomes a functionality
                
            case 'Electrode'
                handles.signalType.Value = 4;
                
                handles.changeInputField.String = num2str(mySignal.InputField);
                
        end
        
        
        PlotSignal(handles, mySignal);
        
        
        setappdata(gcf,'SignalsList',SignalsList);
    end
else
    disp('No Signals')
end

end

