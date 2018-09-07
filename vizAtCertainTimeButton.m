function vizAtCertainTimeButton(handles)
%This function will use the simulation .mat files to create a video with
%the help of the PipelineVisualization function


Sim = getappdata(gcf,'SimResults');
handles
if Sim
    disp('loaded-button')
    myCircuit.CircuitDraw()
end


end