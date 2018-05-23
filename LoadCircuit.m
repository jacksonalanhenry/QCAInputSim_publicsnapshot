function LoadCircuit(f,handles)
    
%   Extremely detailed explanation goes here
    
    newFile = uigetfile;%('*.mat');
    cd('C:\Users\jprev\Desktop\QCA\QCA Research\QCAInputSim\Circuits folder');
    
    
    home=('C:\Users\jprev\Desktop\QCA\QCA Research\QCAInputSim');
    cd(home);
    
    
    loader=load(newFile);
    setappdata(f,'myCircuit',loader.Circuit);
    
   loader.Circuit.CircuitDraw(handles.LayoutWindow);
    axis equal
    
end