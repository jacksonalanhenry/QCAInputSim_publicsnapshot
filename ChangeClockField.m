function ChangeClockField(handles)
%This function will change the clock field of the circuit, namely the
%electric field in the z direction.  Once the clock field is strong enough
%in the negative z direction, this will allow nodes to get relaxed to a
%state of -1 or 1.
%
    myCircuit = getappdata(gcf,'myCircuit');
    
    newclockfield = str2num(get(handles.chngClock,'String'));
    
        for i=1:length(myCircuit.Device)
            if isa (myCircuit.Device{i},'QCASuperCell') %if any of the cells in a supercell are selected, the whole thing will be deleted
                for j=1:length(myCircuit.Device{i}.Device)

                    
                    myCircuit.Device{i}.Device{j}.ElectricField = [0 0 newclockfield];
                

                end
                
            else %any cell can be deleted also
                
                myCircuit.Device{i}.ElectricField = [0  0  newclockfield];
                
            end
            
        end
%         myCircuit = myCircuit.CircuitDraw(handles.LayoutWindow);
        myCircuit.Device;
        
        setappdata(gcf,'myCircuit',myCircuit);  
        Simulate(handles);

end