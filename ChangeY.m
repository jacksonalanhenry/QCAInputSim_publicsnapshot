function myCircuit=ChangeY(handles)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
myCircuit=getappdata(gcf,'myCircuit');

for i=1:length(myCircuit.Device)
    if isa(myCircuit.Device{i},'QCASuperCell')
        for j=1:length(myCircuit.Device{i}.Device)
            if strcmp(myCircuit.Device{i}.Device{j}.SelectBox.Selected,'on')
                
                myCircuit.Device{i}.Device{j}.CenterPosition(2)=myCircuit.Device{i}.Device{j}.CenterPosition(2)+str2num(get(handles.changey,'String'));
            end
        end
    else
        if strcmp(myCircuit.Device{i}.SelectBox.Selected,'on')%is it selected?
            
            myCircuit.Device{i}.CenterPosition(2)=myCircuit.Device{i}.CenterPosition(2)+str2num(get(handles.changey,'String'));
            %change the X coordinate by the user's input value
            
        end
    end
end


cla;%clear and draw
myCircuit = myCircuit.CircuitDraw(handles.LayoutWindow);

setappdata(gcf,'myCircuit',myCircuit);

end

