function ClearAll(handles)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here

f=gcf;

%NEED TO MAKE THIS A GLOBAL FUNCTION OTHERWISE IT CANNOT BE A HOT KEY
%add a dialog box to ask 'r u sure'

a=gca;
myCircuit = getappdata(f,'myCircuit');
SignalsList = getappdata(f,'SignalsList');
cla;%clear the axes

copies = getappdata(f,'Copies');

copies={};

SignalsList = {};
handles.signalList.String = '';
handles.signalList.Value = 1;
handles.signalEditor.String = '' ;
handles.signalEditType.String = '';
handles.signalType.Value = 1;
        handles.sinusoidPanel.Visible = 'on';
        handles.customSignal.Visible = 'off';
        handles.electrodePanel.Visible = 'off';

setappdata(f,'SignalsList',SignalsList);


myCircuit.Device{1}={};%empty first node

myCircuit.Device=myCircuit.Device{1};%the empty first device

myCircuit.Mode = 'Simulation';
myCircuit = myCircuit.CircuitDraw(gca);


setappdata(f,'myCircuit',myCircuit);
setappdata(f,'Copies',copies);



end

