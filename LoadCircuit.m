function LoadCircuit(handles)
%   A circuit/signal file can be selected from the dialog box upon calling
%   this function.  Once the circuit is loaded, the user can interact with
%   and change that circuit and the signals with it as well.

Path = getappdata(gcf,'Path');

myCircuit = getappdata(gcf,'myCircuit'); %going to replace this current circuit
SignalsList = getappdata(gcf,'SignalsList'); %same with this SignalsList


%We use paths to move between the folders where we use the gui and where we
%place the .mat files.

home = Path.home;

handles.signalList.String='';

[newFile pathname] = uigetfile('*.mat');


%if the user cancels, then nothing goes wrong
if ~newFile
    cd(home);
else
    
    if ~strcmp(pathname(1:end-1),home)
        cd(pathname);
        copyfile(newFile,home);
        cd(home);
        
        
    end
    
    loader=load(newFile);
    
    %replacing the old circuit and signals list with the loaded data
    myCircuit = loader.Circuit;
    SignalsList = loader.SignalsList;
    
    for i=1:length(SignalsList)
        handles.signalList.String{end+1,1} = SignalsList{i}.Name;
    end
    
    setappdata(gcf,'SignalsList',SignalsList);
    myCircuit = myCircuit.CircuitDraw(gca);
    
    
    %the file stays in the folder we put it originally
    if ~strcmp(pathname(1:end-1),home)
        delete(newFile);
    end
    
    
    setappdata(gcf,'myCircuit',myCircuit);
    
end


end