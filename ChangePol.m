function ChangePol(handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
myCircuit = getappdata(gcf,'myCircuit');

for i=1:length(myCircuit.Device)
   
    if (strcmp(myCircuit.Device{i}.SelectBox.Selected,'on'))%check for device being on
        
        myCircuit.Device{i}.Polarization=str2num(get(handles.chngPol,'String'));%if it's on, change polarization to whatever the user inputs
        
    end
end
cla;%clear and draw
myCircuit = myCircuit.CircuitDraw(handles.LayoutWindow);

setappdata(gcf,'myCircuit',myCircuit);

end




