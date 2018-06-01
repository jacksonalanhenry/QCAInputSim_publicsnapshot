function myCircuit=ChangeY(handles)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
myCircuit=getappdata(gcf,'myCircuit');



for i=1:length(myCircuit.Device)
%     myCircuit.Device{i}.SelectBox
    if (strcmp(myCircuit.Device{i}.SelectBox.Selected,'on'))

        myCircuit.Device{i}.CenterPosition(2)=str2num(get(handles.changey,'String'));
        
    end
end

myCircuit.Device

cla;
myCircuit = myCircuit.CircuitDraw(handles.LayoutWindow);

setappdata(gcf,'myCircuit',myCircuit);

it=length(myCircuit.Device);
for i=1:it
    Select(myCircuit.Device{i}.SelectBox);
end
end

