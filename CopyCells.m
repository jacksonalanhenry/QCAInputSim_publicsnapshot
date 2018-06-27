function CopyCells()
% UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
myCircuit = getappdata(gcf,'myCircuit');

%we want to clear the current data
copyParts = getappdata(gcf,'Copies');

copyParts={};




%which ones are to be copied.  Put them into the copyParts cell array
for i=1:length(myCircuit.Device)
    if isa(myCircuit.Device{i},'QCASuperCell')
        Sel=0;
        for j=1:length(myCircuit.Device{i}.Device)
            
            if strcmp(myCircuit.Device{i}.Device{j}.SelectBox.Selected,'on')
                Sel = Sel+1;
            end
            
        end
        if Sel
            copyParts{end+1} = myCircuit.Device{i};
        end
        
    else
            if strcmp(myCircuit.Device{i}.SelectBox.Selected,'on')
                 copyParts{end+1} = myCircuit.Device{i};
            end        
    end
end


%put the copied cells into the current fig for pasting later          
setappdata(gcf,'Copies',copyParts);
setappdata(gcf,'myCircuit',myCircuit);





end

