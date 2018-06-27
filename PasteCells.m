function PasteCells()
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here


    %get both the circuit and the copied cells from the current fig
    myCircuit = getappdata(gcf,'myCircuit');
    
    copies = getappdata(gcf,'Copies');
    
  

    
xvals=[];
%collect all the x values
for i=1:length(myCircuit.Device)
    if isa(myCircuit.Device{i},'QCASuperCell')
        for j=1:length(myCircuit.Device{i}.Device)
            xvals(end+1) = myCircuit.Device{i}.Device{j}.CenterPosition(1);
            
        end
    else
        
        xvals(end+1) = myCircuit.Device{i}.CenterPosition(1);
    end
    
    
end


%find the max x val so we know where to draw the copied cells
xmax = max(xvals);

% if xmax == 0
%     xmax = 1;
% end

%shift all the copied cells by the same amount
for i=1:length(copies)
    if isa(copies{i},'QCASuperCell')
        for j=1:length(copies{i}.Device)
            copies{i}.Device{j}.CenterPosition(1) = copies{i}.Device{j}.CenterPosition(1)+xmax+1;
            
            
        end
    else
        
        copies{i}.CenterPosition(1) = copies{i}.CenterPosition(1)+xmax+1;
        
        
        
    end
    
    
end
    
    
    %add the copied cells to the circuit
    
    for i=1:length(copies)
        
       myCircuit = myCircuit.addNode(copies{i}); %put them all in the circuit
       
    end
    
    
    %draw
    myCircuit = myCircuit.CircuitDraw(gca);
     
    
    %reset the center position of the copied cells so the next time we
    %paste it doesn't add too much to the center position of the cells
for i=1:length(copies)
    if isa(copies{i},'QCASuperCell')
        for j=1:length(copies{i}.Device)
            copies{i}.Device{j}.CenterPosition(1) = copies{i}.Device{j}.CenterPosition(1)-xmax-1;
            
            
        end
    else
        
        copies{i}.CenterPosition(1) = copies{i}.CenterPosition(1)-xmax-1;
        
        
        
    end
    
    
end    
    
    %set it all back into the figure
    setappdata(gcf,'myCircuit',myCircuit);
    
    setappdata(gcf,'Copies',copies);
    
end

