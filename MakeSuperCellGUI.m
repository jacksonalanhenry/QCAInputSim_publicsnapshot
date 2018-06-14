function MakeSuperCellGUI(handles)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
myCircuit = getappdata(gcf,'myCircuit');


% myCircuit.Mode = 'Simulation';

%     handles.layoutchange.Value=0;
%     SwitchMode(handles);

button = get(handles.makeSC,'Value');

SCParts=[];


mode = myCircuit.Mode;



if button
    
    switch mode
        case 'Simulation'
            for i=1:length(myCircuit.Device)
                if  ~isa(myCircuit.Device{i},'QCASuperCell') && strcmp(myCircuit.Device{i}.SelectBox.Selected,'on')
                    SCParts(end+1)=i; %need to call the cells to become part of the super cell
                end
            end
            
        case 'Layout'
            for i=1:length(myCircuit.Device)
                if  ~isa(myCircuit.Device{i},'QCASuperCell') && strcmp(myCircuit.Device{i}.LayoutBox.Selected,'on')
                    SCParts(end+1)=i; %need to call the cells to become part of the super cell
                end
            end
            
    end
    
    
    if length(SCParts)>1
        SuperCell = QCASuperCell();
        
        for i=1:length(SCParts)
            
            SuperCell = SuperCell.addCell(myCircuit.Device{SCParts(i)});
            myCircuit.Device{SCParts(i)}={};
            
        end
        
        
        newCircuit={};
        for i=1:length(myCircuit.Device)
            if ~isempty(myCircuit.Device{i})
                newCircuit{end+1} = myCircuit.Device{i};
            end
        end
        
        
        %         myCircuit.Device = newCircuit;
        
        
        
        %         myCircuit.Device = setdiff(myCircuit.Device,SuperCell.Device);
        
        %         a=myCircuit.GetCellIDs(myCircuit)
        %         b=myCircuit.GetCellIDs(SuperCell)
        
        %         ids = setdiff(a,100*b);
        %         newCircuit={};
        %         for i=1:length(ids)
        %             newCircuit{end+1} = myCircuit.Device{i};
        %         end
        %
        myCircuit.Device = newCircuit;
       
        myCircuit=myCircuit.addNode(SuperCell);
        
%         myCircuit.GetCellIDs(myCircuit)
        myCircuit.Device
%        myCircuit.Device{4}
        
%         setappdata(gcf,'myCircuit',myCircuit);
%         myCircuit=myCircuit.CircuitDraw(gca);
    end
end
    handles.makeSC.Value=0;
    switch mode
        case 'Simulation'
            myCircuit=myCircuit.CircuitDraw(gca);
        case 'Layout'
            myCircuit=myCircuit.LayoutDraw(gca);
    end
    
    myCircuit.GetCellIDs(myCircuit)
    
    setappdata(gcf,'myCircuit',myCircuit);
    

    
    
end