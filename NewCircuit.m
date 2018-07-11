function NewCircuit(handles)
%The axes are cleared for a new circuit to be made.
f=gcf;

a=gca;
myCircuit = getappdata(f,'myCircuit');
SignalsList = getappdata(f,'SignalsList');
cla;%clear the axes

copies = getappdata(f,'Copies');

copies={};

SignalsList = {}; %reset all the visual aspects of the gui
handles.signalList.String = '';
handles.signalList.Value = 1;
handles.signalEditor.String = '' ;
handles.signalEditType.String = '';

handles.signalType.Value = 1;
        handles.sinusoidPanel.Visible = 'on';
        handles.customSignal.Visible = 'off';
        handles.electrodePanel.Visible = 'off';


setappdata(f,'SignalsList',SignalsList); %must set app data before CircuitDraw() happens


myCircuit.Device{1}={};%empty first node

myCircuit.Device=myCircuit.Device{1};%the empty first device

myCircuit.Mode = 'Simulation';
myCircuit = myCircuit.CircuitDraw(gca);


setappdata(f,'myCircuit',myCircuit);
setappdata(f,'Copies',copies);

end