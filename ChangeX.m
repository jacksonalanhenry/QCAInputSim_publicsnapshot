function ChangeX(handles)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    myCircuit=getappdata(gcf,'myCircuit');
    
    myCircuit.Device{1}.CenterPosition(1)=str2num(get(handles.changex,'String'));
    
    setappdata(gcf,'myCircuit',myCircuit);
    
end

