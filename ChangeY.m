function myCircuit=ChangeY(handles)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
myCircuit=getappdata(gcf,'myCircuit');

for i=1:length(myCircuit.Device)
    
    if (strcmp(myCircuit.Device{i}.SelectBox.Selected,'on')) %is it selected?
        myCircuit.Device{i}.CenterPosition(2)=myCircuit.Device{i}.CenterPosition(2)+str2num(get(handles.changey,'String'));
            %change the Y coordinates by how much the user inputs
    end
   
            
end


cla;%clear and draw
myCircuit = myCircuit.CircuitDraw(handles.LayoutWindow);

setappdata(gcf,'myCircuit',myCircuit);

end

