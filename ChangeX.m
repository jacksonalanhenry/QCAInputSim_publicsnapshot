function myCircuit=ChangeX(handles)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
myCircuit=getappdata(gcf,'myCircuit');



for i=1:length(myCircuit.Device)

    if strcmp(myCircuit.Device{i}.SelectBox.Selected,'on')%is it selected?
        
        myCircuit.Device{i}.CenterPosition(1)=myCircuit.Device{i}.CenterPosition(1)+str2num(get(handles.changex,'String'));
        %change the X coordinate by the user's input value
  
    end
end

cla;
myCircuit = myCircuit.CircuitDraw(handles.LayoutWindow);

setappdata(gcf,'myCircuit',myCircuit);

% it=length(myCircuit.Device);
% for i=1:it
%     Select(myCircuit.Device{i}.SelectBox);
% end
end

