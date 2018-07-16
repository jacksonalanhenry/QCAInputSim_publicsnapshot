function MajorPanelSwitch(handles, panel)
%This function is for the three main panels (circuit, signal, simulation).
%Handles dictates which panel will be visible depending on what toggle
%button is selected in the gui.

switch panel
    case 'circuit'        
        handles.circuitPanel.Value = 1;
        handles.circuitButtonGroup.Visible = 'on';
        
        handles.signalPanel.Value = 0;
        handles.signalButtonGroup.Visible = 'off';        
        
        handles.simulatePanel.Value = 0;
        handles.simulateButtonGroup.Visible = 'off';
        
        
    case 'signal'
        handles.circuitPanel.Value = 0;
        handles.circuitButtonGroup.Visible = 'off';
        
        handles.signalPanel.Value = 1;
        handles.signalButtonGroup.Visible = 'on';        
        
        handles.simulatePanel.Value = 0;
        handles.simulateButtonGroup.Visible = 'off';
        
        
    case 'simulate'        
        handles.circuitPanel.Value = 0;
        handles.circuitButtonGroup.Visible = 'off';
        
        handles.signalPanel.Value = 1;
        handles.signalButtonGroup.Visible = 'off';         
        
        handles.simulatePanel.Value = 1;
        handles.simulateButtonGroup.Visible = 'on';
        
end

