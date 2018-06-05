function Simulate(handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    myCircuit = getappdata(gcf, ' myCircuit');
    
myCircuit=myCircuit.GenerateNeighborList(); %doing all the calculations
myCircuit=myCircuit.Relax2GroundState();


cla;                    %redraw circuit
myCircuit=myCircuit.CircuitDraw(a);
setappdata(gcf,'myCircuit',myCircuit);
end

