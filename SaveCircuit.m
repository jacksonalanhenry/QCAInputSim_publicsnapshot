function SaveCircuit(handles)
% Add capability to save other parameters: clocking field-wavelength, and
% period, speed of bit packet (from sinusoid)
    f=gcf;
    
    Path = getappdata(gcf,'Path');
    

    cd(Path.circ); %go to the circuits folder
    
    Circuit=getappdata(f, 'myCircuit' ); %attain the circuit we want to save
    SignalsList = getappdata(f,'SignalsList');
    
    File = uiputfile('*.mat');
    
    
    if File == 0 %if the user cancels the save operation
        cd(Path.home);
        
    else%they don't cancel the save operation
        save(File, 'Circuit','SignalsList');
    end

    cd(Path.home); %go back to the original directory
    setappdata(f,'myCircuit',Circuit);
    setappdata(f,'SignalsList',SignalsList);
    
end

