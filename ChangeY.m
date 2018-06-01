function ChangeY(handles)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    myCircuit=getappdata(gcf,'myCircuit');
    
    y=myCircuit.Device{1}.CenterPosition(2)=str2num(get(handles.changey,'String'));

    setappdata(gcf,'myCircuit',myCircuit);
    
end

