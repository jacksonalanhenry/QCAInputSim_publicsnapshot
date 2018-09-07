function SignalTypePanelSwitch(handles, sigType)
%The purpose of this function is to switch between the 4 different signals
%panels within the major signal panel.


%switching visibility on or off
switch sigType
    
    case 'Sinusoidal'
        
        handles.sinusoidPanel.Visible = 'on';
        handles.customSignal.Visible = 'on';
        handles.electrodePanel.Visible = 'on';
        handles.fermiPanel.Visible = 'on';
    
    case 'Fermi'
        handles.sinusoidPanel.Visible = 'on';
        handles.customSignal.Visible = 'on';
        handles.electrodePanel.Visible = 'on';
        handles.fermiPanel.Visible = 'on';            
        
    case 'Custom'
        handles.sinusoidPanel.Visible = 'on';
        handles.customSignal.Visible = 'on';
        handles.electrodePanel.Visible = 'on';
        handles.fermiPanel.Visible = 'on';
    
    case 'Electrode'
        handles.sinusoidPanel.Visible = 'on';
        handles.customSignal.Visible = 'on';
        handles.electrodePanel.Visible = 'on';
        handles.fermiPanel.Visible = 'on';
        
    
end


end

