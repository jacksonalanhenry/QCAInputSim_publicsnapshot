function SignalTypePanelSwitch(handles)
%The purpose of this function is to switch between the 4 different signals
%panels within the major signal panel.

signalTypes = cellstr(get(handles.signalType,'String')); %get the list of signal types from handles

sigType = signalTypes{get(handles.signalType,'Value')}; %find which one is selected


%switching visibility on or off
switch sigType
    
    case 'Sinusoidal'
        
        handles.sinusoidPanel.Visible = 'on';
        handles.customSignal.Visible = 'off';
        handles.electrodePanel.Visible = 'off';
        handles.fermiPanel.Visible = 'off';
    
    case 'Fermi'
        handles.sinusoidPanel.Visible = 'off';
        handles.customSignal.Visible = 'off';
        handles.electrodePanel.Visible = 'off';
        handles.fermiPanel.Visible = 'on';            
        
    case 'Custom'
        handles.sinusoidPanel.Visible = 'off';
        handles.customSignal.Visible = 'on';
        handles.electrodePanel.Visible = 'off';
        handles.fermiPanel.Visible = 'off';
    
    case 'Electrode'
        handles.sinusoidPanel.Visible = 'off';
        handles.customSignal.Visible = 'off';
        handles.electrodePanel.Visible = 'on';
        handles.fermiPanel.Visible = 'off';
        
    
end


end

