function NewCircuit(f,handles)
%UNTITLED2 Summary of this function goes here
a=gca;
myCircuit = getappdata(f,'myCircuit');
cla;%clear the axes

copies = getappdata(f,'Copies');

copies={};


myCircuit.Device{1}={};%empty first node

myCircuit.Device=myCircuit.Device{1};%the empty first device

myCircuit.Mode = 'Simulation';
myCircuit = myCircuit.CircuitDraw(handles.LayoutWindow);
handles.layoutchange.Value=0;

setappdata(f,'myCircuit',myCircuit);
setappdata(f,'Copies',copies);

end