function LoadCircuit()

%   A circuit/signal file can be selected from the dialog box upon calling
%   this function.  Once the circuit is loaded, the user can interact with
%   and change that circuit and the signals with it as well.

Path = getappdata(gcf,'Path');

myCircuit = getappdata(gcf,'myCircuit'); %going to replace this current circuit

circpath = Path.circ;

home = Path.home;

cd(circpath);
newFile = uigetfile('*.mat');


if ~newFile
    cd(home);
else
    copyfile(newFile,home);
    cd(home);
    
    
    loader=load(newFile);
    
    
    myCircuit = loader.Circuit;
    
    myCircuit = myCircuit.CircuitDraw(gca);
    
    delete(newFile);
    
    
    
    setappdata(gcf,'myCircuit',myCircuit);
    
end


end