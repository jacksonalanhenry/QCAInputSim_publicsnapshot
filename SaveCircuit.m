function SaveCircuit(handles)
% Add capability to save other parameters: clocking field-wavelength, and
% period, speed of bit packet (from sinusoid)
    f=gcf;
    
    Path = getappdata(gcf,'Path');
    
    
    
    
    Circuit=getappdata(f, 'myCircuit' ); %attain the circuit we want to save
    SignalsList = getappdata(f,'SignalsList');
    
    [File pathname] = uiputfile('*.mat');
    
    
    if File == 0 %if the user cancels the save operation
        cd(Path.home);
        
    else%they don't cancel the save operation
        cd(pathname)
        save(File, 'Circuit','SignalsList');
        cd(Path.home);
    end

    cd(Path.home); %go back to the original directory
    setappdata(f,'myCircuit',Circuit);
    setappdata(f,'SignalsList',SignalsList);
    
end

