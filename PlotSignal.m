function PlotSignal(handles, mySignal)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

type = mySignal.Type;
name = mySignal.Name;

switch type
    
    case 'Sinusoidal'
        
        
        
        A = str2num(handles.changeAmp.String); %plotting
        L = str2num(handles.changeWave.String);
        T = str2num(handles.changePeriod.String);
        b = str2num(handles.changePhase.String);
        x=-5:.01:5;
        
        
        y = ( cos((2*pi*(x/L - 1/T) )+ b) )*A;
        
        plot(handles.plotAxes,x,y);
        handles.signalDisplayBox.String = name;
        
        
    case 'Fermi'
        
        
        Amp = str2num(handles.changeAmpFermi.String);
        T = str2num(handles.changePeriodFermi.String);
        b = str2num(handles.changePhaseFermi.String);
        K = str2num(handles.changeSharpnessFermi.String);
        M = str2num(handles.changeMeanValueFermi.String);
        
        x=-5:.01:5;
        
        
        y = Amp * PeriodicFermi(mod(x  - b , T), T, K) + M;
        
        plot(handles.plotAxes,x,y);
        handles.signalDisplayBox.String = name;
        
    case 'Custom'
        %nothing yet, but it will also get plotted once custom
        %becomes a functionality
        
    case 'Electrode'
        handles.changeInputField.String = num2str(mySignal.InputField);
        
end


end

