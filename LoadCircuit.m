function LoadCircuit(f,handles)

%   Extremely detailed explanation goes here

Path = getappdata(gcf,'Path');
myCircuit = getappdata(gcf,'myCircuit');
circpath = Path.circ;
home = Path.home;
cd(circpath)
newFile = uigetfile('*.mat');


if ~newFile
    cd(home)
else
    copyfile(newFile,home);
    cd(home);
    
    
    loader=load(newFile);
    cla;
    
    setappdata(f,'myCircuit',loader.Circuit);
    
    loader.Circuit.CircuitDraw(handles.LayoutWindow);
    axis equal
    delete(newFile);
    
    
    myCircuit=getappdata(gcf,'myCircuit');
    setappdata(gcf,'myCircuit',myCircuit);
    

    
end




end