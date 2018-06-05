function MakeSuperCellGUI(handles)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    myCircuit = getappdata(gcf,'myCircuit');
    
    button = get(handles.makeSC,'Value');
    
    SCParts=[];
    
    if button
       for i=1:length(myCircuit.Device)
           if strcmp(myCircuit.Device{i}.SelectBox.Selected,'on')
           SCParts(end+1)=i;%need to call the cells to become a super cell
           end
       end
       
       
       
       
       
       
    end    
end

