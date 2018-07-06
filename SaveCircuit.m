function SaveCircuit()
% Add capability to save other parameters: clocking field-wavelength, and
% period, speed of bit packet (from sinusoid)
    f=gcf;
    
    Path = getappdata(gcf,'Path');
    

    cd(Path.circ); %go to the circuits folder
    
    Circuit=getappdata(f, 'myCircuit' ); %attain the circuit we want to save
    File = uiputfile('*.mat');
    
    save(File, 'Circuit'); 

    cd(Path.home); %go back to the original directory

end

