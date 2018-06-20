function ChangeClockField(handles)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    myCircuit = getappdata(gcf,'myCircuit');
    
    newclockfield = str2num(get(handles.chngClock,'String'));
    
        for i=1:length(myCircuit.Device)
            if isa (myCircuit.Device{i},'QCASuperCell') %if any of the cells in a supercell are selected, the whole thing will be deleted
                for j=1:length(myCircuit.Device{i}.Device)

                    
                    myCircuit.Device{i}.Device{j}.ElectricField = [0 0 newclockfield];
                

                end
                
            else %any cell can be deleted also
                
                myCircuit.Device{i}.ElectricField = [0 0 newclockfield];
                
            end
            
        end
%         myCircuit = myCircuit.CircuitDraw(handles.LayoutWindow);
        myCircuit.Device;
        
        setappdata(gcf,'myCircuit',myCircuit);  
        Simulate(handles);

end