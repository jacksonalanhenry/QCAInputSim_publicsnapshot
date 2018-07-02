function Simulate(handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    ResetCells(); 
    myCircuit = getappdata(gcf,'myCircuit');
   
%     handles.layoutchange.Value=0;

    
    %regenerate neighbor list once we hit the simulate button
    myCircuit=myCircuit.GenerateNeighborList();
    

eps0 = 8.854E-12;%set constants
a=1e-9;
q=1;
E0 = q^2 * (1.602e-19) / (4*pi*eps0*a)* (1-1/sqrt(2));
clk= str2num(get(handles.chngClock,'String'));
clockfield=[0 clk 0]*E0;    
    


    for i=1:length(myCircuit.Device)%set clock field for all cells
        if isa(myCircuit.Device{i},'QCASuperCell')
            for j=1:length(myCircuit.Device{i}.Device)
                myCircuit.Device{i}.Device{j}.ElectricField=clockfield;
            end
        else
            myCircuit.Device{i}.ElectricField=clockfield;
        end
        myCircuit.Device{i};
    end

   
    
    %relax and redraw
    myCircuit=myCircuit.Relax2GroundState();   
    
    myCircuit=myCircuit.CircuitDraw(gca);


 
    setappdata(gcf,'myCircuit',myCircuit);
end