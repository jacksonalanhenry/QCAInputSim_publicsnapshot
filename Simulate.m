function Simulate(handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    myCircuit = getappdata(gcf,'myCircuit');
    

    myCircuit=myCircuit.GenerateNeighborList();
    
%     for i=1:length(myCircuit.Device)
%         if isa(myCircuit.Device{i},'QCASuperCell')
%             for j=1:length(myCircuit.Device{i}.Device)
%                 myCircuit.Device{i}.Device{j}.NeighborList;
%             end
%         else
%             myCircuit.Device{i}.NeighborList;
%         end
%         
%     end



    myCircuit=myCircuit.Relax2GroundState();
    myCircuit=myCircuit.CircuitDraw(gca);

 
    setappdata(gcf,'myCircuit',myCircuit);
end