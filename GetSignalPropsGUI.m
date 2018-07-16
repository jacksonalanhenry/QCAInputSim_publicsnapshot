function GetSignalPropsGUI(handles)
%This is the precursor to editing a signal and saving it.  When the user
%selects a signal from the signal list in the gui, its name and type will
%be displayed, and the signal if it is Fermi, custom/piecewise, or sinusoidal, will be plotted

contents = cellstr(get(handles.signalList,'String')); %get the signal list from handles


if ~isempty(contents)
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
        
        switch mySignal.Type
            
            case 'Sinusoidal'
                
                handles.changeAmp.String = num2str(mySignal.Amplitude);
                handles.changeWave.String = num2str(mySignal.Wavelength);
                handles.changePeriod.String = num2str(mySignal.Period);
                handles.changePhase.String = num2str(mySignal.Phase);
                
                
                A = str2num(handles.changeAmp.String);
                L = str2num(handles.changeWave.String);
                T = str2num(handles.changePeriod.String);
                b = str2num(handles.changePhase.String);
                x=-5:.01:5;
                
                
                y = ( cos((2*pi*(x/L - 1/T) )+ b) )*A;
                
                plot(handles.plotAxes,x,y);
                handles.signalDisplayBox.String = sigName;
                
                
            case 'Fermi'
                Amp = str2num(handles.changeAmpFermi.String);
                
                T = str2num(handles.changePeriodFermi.String);
                b = str2num(handles.changePhaseFermi.String);
                K = str2num(handles.changeSharpnessFermi.String);
                M = str2num(handles.changeMeanValueFermi.String);
                
                x=-5:.01:5;
                
                
                y = Amp * PeriodicFermi(mod(x  - b , T), T, K) + M;
                
                plot(handles.plotAxes,x,y);
                handles.signalDisplayBox.String = sigName;
                
            case 'Custom'
                %nothing yet, but it will also get plotted
                
            case 'Electrode'
                handles.changeInputField.String = num2str(mySignal.InputField);
                
        end
        SignalsList{pick} = mySignal;
        
        
        setappdata(gcf,'SignalsList',SignalsList);
    end
end

end

