function ResetCells(handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    myCircuit = getappdata(gcf,'myCircuit');
    
        for i=1:length(myCircuit.Device)
            if isa (myCircuit.Device{i},'QCASuperCell') %if any of the cells in a supercell are selected, the whole thing will be deleted
                for j=1:length(myCircuit.Device{i}.Device)
                    if strcmp( myCircuit.Device{i}.Device{j}.Type,'Node')
                    
                        myCircuit.Device{i}.Device{j}.Polarization = 0;
                        myCircuit.Device{i}.Device{j}.Activation = 1;
                
                    end
                end
                
            else %any cell can be deleted also
                if strcmp( myCircuit.Device{i}.Type,'Node')
                    myCircuit.Device{i}.Polarization = 0;
                    myCircuit.Device{i}.Activation = 1;
                end
            end
            
        end
        myCircuit = myCircuit.CircuitDraw(handles.LayoutWindow);
        
        setappdata(gcf,'myCircuit',myCircuit);

end

