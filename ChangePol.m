function ChangePol(handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
myCircuit = getappdata(gcf,'myCircuit');

for i=1:length(myCircuit.Device)
   
    if isa(myCircuit.Device{i},'QCASuperCell') 
        
        for j=1:length(myCircuit.Device{i}.Device)
            if strcmp(myCircuit.Device{i}.Device{j}.Type,'Driver') && (strcmp(myCircuit.Device{i}.Device{j}.SelectBox.Selected,'on'))%check for device being on
                
                myCircuit.Device{i}.Device{j}.Polarization=str2num(get(handles.chngPol,'String'));
                %if it's on, change polarization to whatever the user inputs
        
            end
        end
    else
        if strcmp(myCircuit.Device{i}.Type,'Driver') && (strcmp(myCircuit.Device{i}.SelectBox.Selected,'on'))%check for device being on
            myCircuit.Device{i}.Polarization=str2num(get(handles.chngPol,'String'));
        end
    end
end



% myCircuit = myCircuit.CircuitDraw(handles.LayoutWindow);


setappdata(gcf,'myCircuit',myCircuit);

Simulate(handles);

end