function LoadSimResults(handles)
%This function will use the simulation .mat files to create a video with
%the help of the PipelineVisualization function

[Sim, path]= uigetfile('*.mat'); %path gets sent into Pipeline in order to change the path, that way we can put the video file anywhere

% f=gcf;


% f.Pointer = 'watch';


if Sim
    disp('Simulation Loaded.')
end


myCircuit = getappdata(gcf,'myCircuit');
myCircuit = myCircuit.CircuitDraw(gca);
setappdata(gcf,'myCircuit',myCircuit);
setappdata(gcf,'SimResults', Sim);
setappdata(gcf,'SimResultsPath', path);


% f.Pointer = 'arrow';
% f.Pointer;
end