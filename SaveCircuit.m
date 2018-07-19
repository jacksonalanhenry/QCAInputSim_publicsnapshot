function SaveCircuit()
% Add capability to save other parameters: clocking field-wavelength, and
% period, speed of bit packet (from sinusoid)


Path = getappdata(gcf,'Path');


Circuit=getappdata(gcf, 'myCircuit'); %attain the circuit we want to save
SignalsList = getappdata(gcf,'SignalsList');

[File , pathname] = uiputfile('*.mat');


if File == 0 %if the user cancels the save operation
    cd(Path.home);
    
else%they don't cancel the save operation
    cd(pathname)
    
    
    save(File,'Circuit','SignalsList');
    
    cd(Path.home);
end


setappdata(gcf,'myCircuit',Circuit);
setappdata(gcf,'SignalsList',SignalsList);

end