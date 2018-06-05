function NewCircuit(f,handles)
%UNTITLED2 Summary of this function goes here
a=gca;
myCircuit = getappdata(f,'myCircuit');
cla;%clear the axes


myCircuit.Device{1}={};%empty first node

myCircuit.Device=myCircuit.Device{1};%the empty first device


setappdata(f,'myCircuit',myCircuit);


end