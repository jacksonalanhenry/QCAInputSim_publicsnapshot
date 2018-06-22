function SnapToGrid(handles)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes

myCircuit = getappdata(gcf,'myCircuit');
coord = {};

for i=1:length(myCircuit.Device)
    if isa(myCircuit.Device{i},'QCASuperCell')
        
        
        for j=1:length(myCircuit.Device{i}.Device)
            coord{end+1} = myCircuit.Device{i}.Device{j}.CenterPosition;
            
        end
        
        
    else
        coord{end+1} = myCircuit.Device{i}.CenterPosition;
    end
    
end




for i=1:length(coord)

    
    diffx=coord{i}(1)-floor(coord{i}(1)); %range of 0 to 1 for rounding to 0, .5, or 1 relatively speaking
    diffy=coord{i}(2)-floor(coord{i}(2)); %this is priming the snap to grid functionality
    
        
        
    
    
    %determining how each x,y will be rounded to floor, .5 or
    %up to the next integer
    if diffx<.25
        coord{i}(1)=floor(coord{i}(1));
    end
    if diffx>=.25 && diffx<=.75
        coord{i}(1)=floor(coord{i}(1))+.5;
    end
    if diffx>.75
        coord{i}(1)=floor(coord{i}(1))+1;
    end
    
    
    if diffy<.25
        coord{i}(2)=floor(coord{i}(2));
    end
    if diffy>=.25 && diffy<=.75
        coord{i}(2)=floor(coord{i}(2))+.5;
    end
    if diffy>.75
        coord{i}(2)=floor(coord{i}(2))+1;
    end
    
    
    
end


it=1;
myCircuit.Device;
L=length(coord);

for i=1:length(myCircuit.Device)
    if isa(myCircuit.Device{i},'QCASuperCell')
        for j=1:length(myCircuit.Device{i}.Device)
            
            myCircuit.Device{i}.Device{j}.CenterPosition = coord{it};
            it=it+1;
        end
        
        
    else
         myCircuit.Device{i}.CenterPosition = coord{it};
         it = it+1;
    end
    
end



mode = myCircuit.Mode;

switch mode
    case 'Simulation'
        myCircuit = myCircuit.CircuitDraw(gca);
    case 'Layout'
        myCircuit = myCircuit.LayoutDraw(gca);
end

setappdata(gcf,'myCircuit',myCircuit);

end