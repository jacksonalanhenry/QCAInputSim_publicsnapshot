function Simulate(handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    myCircuit = getappdata(gcf,'myCircuit');
    
    
    
    myCircuit=myCircuit.GenerateNeighborList();
    myCircuit=myCircuit.Relax2GroundState();
    myCircuit.CircuitDraw(gca);
end