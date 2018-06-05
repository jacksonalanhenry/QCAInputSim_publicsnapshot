function Simulate(handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    myCircuit = getappdata(gcf, ' myCircuit');
    
myCircuit=myCircuit.GenerateNeighborList();
myCircuit=myCircuit.Relax2GroundState();


cla;
myCircuit=myCircuit.CircuitDraw(a);
setappdata(gcf,'myCircuit',myCircuit);
end

