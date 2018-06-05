function NewCircuit(f,handles)
%UNTITLED2 Summary of this function goes here
a=gca;
myCircuit = getappdata(f,'myCircuit');
cla;


myCircuit.Device{1}={};

myCircuit.Device=myCircuit.Device{1};


setappdata(f,'myCircuit',myCircuit);

% myCircuit.CircuitDraw(a);

end