function LoadCircuit(f,handles)
    
%   Extremely detailed explanation goes here
%     cd('C:\Users\jprev\Desktop\QCA\QCA Research\QCAInputSim\Circuits folder');
%         cd('Circuits folder');
    Path = getappdata(gcf,'Path');
    
    circpath = Path.circ;
    home = Path.home;
    cd(circpath)
    [newFile, newFilePath] = uigetfile('*.mat');
    
    
    copyfile(newFile,home);
    cd(home);
%     home='C:\Users\jprev\Desktop\QCA\QCA Research\QCAInputSim';
%     cd(home);
    
    
    loader=load(newFile);
    cla;

    setappdata(f,'myCircuit',loader.Circuit);
    
   loader.Circuit.CircuitDraw(handles.LayoutWindow);
    axis equal
    delete(newFile);
end