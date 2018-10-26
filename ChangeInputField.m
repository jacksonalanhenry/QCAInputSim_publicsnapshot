function ChangeInputField(handles)
%Aligning all nodes in a column to be the same polarization, they will be
%locked in place following the phyics of the electric field.
myCircuit = getappdata(gcf,'myCircuit');


% strcmp(myCircuit.Device{i}.SelectBox.Selected,'on')


inputfield = str2num(get(handles.changeInputField,'String'));
clockSignalsList = getappdata(gcf,'clockSignalsList');

for k=1:length(clockSignalsList)
    for i=1:length(myCircuit.Device)
        if isa (myCircuit.Device{i},'QCASuperCell') %if any of the cells in a supercell are selected, the whole thing will be deleted
            
            for j=1:length(myCircuit.Device{i}.Device)
                if strcmp(myCircuit.Device{i}.Device{j}.SelectBox.Selected,'on')
                    
                    myCircuit.Device{i}.Device{j}.ElectricField(2) = inputfield;
                    
                end
                
 
            end
        else %any cell can be deleted also
            if strcmp(myCircuit.Device{i}.SelectBox.Selected,'on')
                myCircuit.Device{i}.ElectricField(2) = inputfield;
                myCircuit.Device{i}.ElectricField(2);
            end
        end
        
    end
end
setappdata(gcf,'myCircuit',myCircuit);


Simulate(handles);

end