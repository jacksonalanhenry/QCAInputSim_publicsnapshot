function NewCircuit()
%The axes are cleared for a new circuit to be made.
f=gcf;

a=gca;
myCircuit = getappdata(f,'myCircuit');
cla;%clear the axes

copies = getappdata(f,'Copies');

copies={};


myCircuit.Device{1}={};%empty first node

myCircuit.Device=myCircuit.Device{1};%the empty first device

myCircuit.Mode = 'Simulation';
myCircuit = myCircuit.CircuitDraw(gca);


setappdata(f,'myCircuit',myCircuit);
setappdata(f,'Copies',copies);

end