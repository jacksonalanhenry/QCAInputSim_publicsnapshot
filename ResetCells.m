function ResetCells()
%All cells except for drivers will be reset to an activation of 1 and a
%polarization of 0.

    myCircuit = getappdata(gcf,'myCircuit');
    
        for i=1:length(myCircuit.Device)
            if isa (myCircuit.Device{i},'QCASuperCell') %if any of the cells in a supercell are selected, the whole thing will be deleted
                for j=1:length(myCircuit.Device{i}.Device)
                    if strcmp( myCircuit.Device{i}.Device{j}.Type,'Node')
                    
                        myCircuit.Device{i}.Device{j}.Polarization = 0;
                        myCircuit.Device{i}.Device{j}.Activation = 1;
                        myCircuit.Device{i}.Device{j}.NeighborList=[];
                    end
                end
                
            else %any cell can be deleted also
                if strcmp( myCircuit.Device{i}.Type,'Node')
                    myCircuit.Device{i}.Polarization = 0;
                    myCircuit.Device{i}.Activation = 1;
                    myCircuit.Device{i}.NeighborList=[];
                end
            end
            
        end
        myCircuit = myCircuit.CircuitDraw(gca);
          
        
        setappdata(gcf,'myCircuit',myCircuit);

end

