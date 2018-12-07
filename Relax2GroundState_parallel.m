function mycircuit = Relax2GroundState_parallel(mycircuit, time)

    %Iterate to Self consistency using ParFor. Each thread will get a single node or supernode.






    NewCircuitPols = ones(1,length(mycircuit.Device));
    NewCircuitActs = ones(1,length(mycircuit.Device));

    converganceTolerance = 1;
    sub = 1;
    chi = 0.4;
    it=1;
    
    
    for idx = 1:length(mycircuit.Device)
        
        nl = mycircuit.Device{idx}.NeighborList;
        %get Neighbor Objects
        nl_obj = mycircuit.getCellArray(nl);
        
        
        %get hamiltonian for current cell
        hamiltonian = mycircuit.Device{idx}.GetHamiltonian(nl_obj,time);
        mycircuit.Device{idx}.Hamiltonian = hamiltonian;
        
        %get the new groundstate, average and normalize
        %the current groundstate and the new
        %groundstate then calculate pol with that psi
        [V, EE] = eig(hamiltonian);
        newpsi = V(:,1);
        
        
        
        normpsi = (1-chi)*mycircuit.Device{idx}.Wavefunction + chi*newpsi;
        normpsi = normalize_psi_1D(normpsi');
        
        
        
        %calculate polarization
        mycircuit.Device{idx} = mycircuit.Device{idx}.Calc_Polarization_Activation(normpsi');
        
        
        NewCircuitPols(idx) = mycircuit.Device{idx}.getPolarization(time);
        NewCircuitActs(idx) = mycircuit.Device{idx}.Activation;

        
        
    end
    
    
    starttime=tic;
    while (converganceTolerance > 0.1)
        OldCircuitPols = NewCircuitPols;
        OldCircuitActs = NewCircuitActs;
        
        for idx = 1:length(mycircuit.Device)
            nl = mycircuit.Device{idx}.NeighborList;
            nl_obj = mycircuit.getCellArray(nl);

            hamiltonian = mycircuit.Device{idx}.GetHamiltonian(nl_obj,time);
            mycircuit.Device{idx}.Hamiltonian = hamiltonian;
        end



        parfor idx=1:length(mycircuit.Device)
            %WorkerID = getfield(getCurrentTask(), 'ID');
            groundstate{idx} = Relax2GroundState_parallelGroundStateCalculation(mycircuit.Device{idx}.Hamiltonian, mycircuit.Device{idx}.Wavefunction, chi);
            
            %disp(['Commenced job on worker ', num2str(WorkerID), ' for Cell ', num2str(mycircuit.Device{idx}.CellID)]);
        end

        
        for idx = 1:length(mycircuit.Device)
            mycircuit.Device{idx} = mycircuit.Device{idx}.Calc_Polarization_Activation(groundstate{idx}');
            NewCircuitPols(idx) = mycircuit.Device{idx}.getPolarization(time);
            NewCircuitActs(idx) = mycircuit.Device{idx}.Activation;

        end


        deltaCircuitPols = abs(OldCircuitPols) - abs(NewCircuitPols);
        deltaCircuitActs = abs(OldCircuitActs) - abs(NewCircuitActs);
        [converganceTolerance maxid] = max(abs(deltaCircuitPols));
        [converganceToleranceACT maxidACT] = max(abs(deltaCircuitActs));
        sub=sub+1;
        it=it+1;
        
        
        disp(['---- Iteration: ', num2str(it), ' - MaxID: ', num2str(maxid), ' - converganceTolerance: ', num2str(converganceTolerance), ' ----']);
        %disp(['Hamiltonian at MaxID:' ])
        if (it == 500)
            break
        end
        mycircuit.Device{maxid}.Wavefunction;
    end
    stoptime = toc(starttime);
    disp(['time: ', num2str(stoptime)]);


end