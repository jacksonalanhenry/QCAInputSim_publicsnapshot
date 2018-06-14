function Simulate(handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    myCircuit = getappdata(gcf,'myCircuit');
   
    
    myCircuit.GetCellIDs(myCircuit);

    myCircuit=myCircuit.GenerateNeighborList();
    
<<<<<<< HEAD
eps0 = 8.854E-12;
a=1e-9;
q=1;
E0 = q^2 * (1.602e-19) / (4*pi*eps0*a)* (1-1/sqrt(2));
clk= -5.5;
clockfield=[0 0 clk]*E0;    
    
    for i=1:length(myCircuit.Device)
        if isa(myCircuit.Device{i},'QCASuperCell')
            for j=1:length(myCircuit.Device{i}.Device)
                myCircuit.Device{i}.Device{j}.ElectricField=clockfield;
            end
        else
            myCircuit.Device{i}.ElectricField=clockfield;
        end
        myCircuit.Device{i}
    end


    myCircuit=myCircuit.Relax2GroundState();
    myCircuit=myCircuit.CircuitDraw(gca);

 
    setappdata(gcf,'myCircuit',myCircuit);
end