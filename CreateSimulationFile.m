function CreateSimulationFile(handles)
%The simulation results .mat file will be created here by running numerous
%simulations and storing them into a .mat file witha  default name or one
%assigned by the user in an edit box

myCircuit = getappdata(gcf,'myCircuit');
SignalsList = getappdata(gcf,'SignalsList');
myCircuit = myCircuit.GenerateNeighborList();

name = num2str(handles.nameSim.String);


% f=gcf;
% 
% f.Pointer = 'watch';


if length(SignalsList)==1 %pipeline will run
    if isempty(name)
        myCircuit = myCircuit.pipeline(SignalsList{1});
    else
        myCircuit = myCircuit.pipeline(SignalsList{1},name);    
    end
    
elseif length(SignalsList) > 1
    %no functionality for multiple Signals yet
    
    
end

myCircuit = myCircuit.CircuitDraw(gca);

setappdata(gcf,'myCircuit',myCircuit);
setappdata(gcf,'SignalsList',SignalsList);


% f.Pointer = 'arrow';
end