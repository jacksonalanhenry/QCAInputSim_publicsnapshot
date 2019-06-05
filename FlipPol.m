function FlipPol(handles, varargin)
%Change the position of any single driver or node.
myCircuit = getappdata(gcf,'myCircuit');





idx = 1;


for i=1:length(myCircuit.Device)
    
    if isa(myCircuit.Device{i},'QCASuperCell')
        
        for j=1:length(myCircuit.Device{i}.Device)
            if (strcmp(myCircuit.Device{i}.Device{j}.SelectBox.Selected,'on'))%check for device being on
                myCircuit.Device{i}.Device{j}.Polarization = -1*myCircuit.Device{i}.Device{j}.Polarization;
            end
        end
    else
        if (strcmp(myCircuit.Device{i}.SelectBox.Selected,'on'))%check for device being on
            myCircuit.Device{i}.Polarization = -1*myCircuit.Device{i}.Polarization;
        end
    end
end






myCircuit = myCircuit.CircuitDraw(0, gca);


setappdata(gcf,'myCircuit',myCircuit);



end