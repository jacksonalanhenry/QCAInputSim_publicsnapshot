function parallelPipeline(inputidx)


    %% Load Circuit
    load(fullfile('Circuits folder', 'inputNodesBinaryWire.mat'));
    mycircuit = Circuit;
    
    
    %% Set input node fields and clock field
    epsilon_0 = 8.854E-12;
    a=1e-9;%[m]
    q=1;%[eV]
    Eo = q^2*(1.602e-19)/(4*pi*epsilon_0*a)*(1-1/sqrt(2));
    clk = 5;

    inputandclock = [0,inputidx/10,clk]*Eo;
    
    mysignal = Signal();
    mysignal.Wavelength = 100;
    mysignal.Amplitude = 5;
    mysignal.Period = 1;
    
    
    for i=1:length(mycircuit.Device)
        if isa(mycircuit.Device{i},'QCASuperCell')
            for j=1:length(mycircuit.Device{i}.Device)
                mycircuit.Device{i}.Device{j}.ElectricField = inputandclock;
                %disp('g')
            end
            
        else
            mycircuit.Device{i}.ElectricField = inputandclock;
            
        end
    end
    
    %%
    %clf
    %myaxis = axes;
    
    
    simnamefront = 'inputFieldProblem_w';
    simname = strcat(simnamefront, num2str(mysignal.Wavelength), '_i',num2str(inputidx));
    
    mycircuit = mycircuit.GenerateNeighborList();
    mycircuit = mycircuit.Relax2GroundState();
    
    % mycircuit = mycircuit.pipeline({mysignal}, simname);
    %clockSignalsList{1}.Wavelength = 100;
    mycircuit = mycircuit.pipeline({mysignal}, 'Filename', simname, 'TimeSteps', 50);
    
    
    
    
    WorkerID = getfield(getCurrentTask(), 'ID');
    disp(['Commenced job on worker ', num2str(WorkerID), ' for index ', num2str(inputidx)]);
    


