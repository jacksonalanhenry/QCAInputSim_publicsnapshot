function RePlotSignal(handles)
%This function gets called when the user edits one of the edit boxes and hits enter for a
%signal (fermi, sine, or possibly custom).  It will replace the old data
%in the signal with the new input, along with plotting the signal in its
%new form.

SignalsList = getappdata(gcf,'SignalsList');

sigName = handles.signalEditor.String;


if ~isempty(sigName) %check to see if there is a signal being edited
    
    for i=1:length(SignalsList)
        SignalsList{i}.Name;
        if strcmp(sigName,SignalsList{i}.Name)
            mySignal = SignalsList{i}; %find that signal in the list
            pick = i;
        end
    end
    
    sigType = mySignal.Type;
    
    types = cellstr(get(handles.signalType,'String'));
    newSigType = types{get(handles.signalType,'Value')};
    
    if strcmp(sigType,newSigType)
        mySignal.Type = newSigType;
    end
    
    
    switch sigType %old info is going into the signal
        
        case 'Sinusoidal'
            
            mySignal.Amplitude = str2num(handles.changeAmp.String);
            mySignal.Wavelength = str2num(handles.changeWave.String);
            mySignal.Period = str2num(handles.changePeriod.String);
            mySignal.Phase = str2num(handles.changePhase.String);
            mySignal.MeanValue = str2num(handles.changeMeanValue.String);
            
            
            
        case 'Custom'
            %still nothin' so far
            
            
        case 'Fermi'
            mySignal.Amplitude = str2num(handles.changeAmpFermi.String);
            mySignal.Sharpness = str2num(handles.changeSharpnessFermi.String);
            mySignal.Period = str2num(handles.changePeriodFermi.String);
            mySignal.Phase = str2num(handles.changePhaseFermi.String);
            mySignal.MeanValue = str2num(handles.changeMeanValueFermi.String);
            
            
        case 'Electrode'
            mySignal.InputField = str2num(handles.changeInputField.String);
    end
    
    SignalsList{pick} = mySignal;
    
    PlotSignal(handles,mySignal); %replotting
    
    
end

setappdata(gcf,'SignalsList',SignalsList);

end

