function CalculateEnergyCallback(handles)
%This function will use the simulation .mat files to create a video with
%the help of the PipelineVisualization function

%vizAtCertainTimeButton(handles)

myCircuit = getappdata(gcf,'myCircuit');


%time = 0;
time = get(handles.vizAtCertainTimeEditBox,'String');
myCircuit = myCircuit.GenerateNeighborList();
%myCircuit = myCircuit.Relax2GroundState(time);


myCircuit = myCircuit.CircuitDraw(time, gca);


all_energy = myCircuit.calculateEnergy(time);
circuit_energy = sum(all_energy)

end


