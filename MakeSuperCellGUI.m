function MakeSuperCellGUI()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
myCircuit = getappdata(gcf,'myCircuit');


% myCircuit.Mode = 'Simulation';

%     handles.layoutchange.Value=0;
%     SwitchMode(handles);

%which elements of the circuit will be made into a supercell
SCParts=[];


mode = myCircuit.Mode;




    
    switch mode
        case 'Simulation'
            %find out which ones will be put into the new supercell. Cannot
            %add current supercell members to another supercell
            for i=1:length(myCircuit.Device)
                if  ~isa(myCircuit.Device{i},'QCASuperCell') && strcmp(myCircuit.Device{i}.SelectBox.Selected,'on') && strcmp(myCircuit.Device{i}.Type,'Node')
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
    
    %filling supercell with all the devices
    if length(SCParts)>1
        SuperCell = QCASuperCell();
        
        for i=1:length(SCParts)
            
            SuperCell = SuperCell.addCell(myCircuit.Device{SCParts(i)});
            myCircuit.Device{SCParts(i)}={};%emptying the circuit if that part was selected
            
        end
        
        %emptying the old circuit into the new circuit
        newCircuit={};
        for i=1:length(myCircuit.Device)
            if ~isempty(myCircuit.Device{i})
                newCircuit{end+1} = myCircuit.Device{i};
            end
        end
        
        %the new circuit is now the current circuit
        myCircuit.Device = newCircuit;
       
        %add the supercell onto the end of the new circuit
        myCircuit=myCircuit.addNode(SuperCell);
        
%         myCircuit.GetCellIDs(myCircuit.Device)
        myCircuit.Device;

        
%         setappdata(gcf,'myCircuit',myCircuit);
%         myCircuit=myCircuit.CircuitDraw(gca);
    end


myCircuit.Device;

    switch mode
        case 'Simulation'
            myCircuit=myCircuit.CircuitDraw(gca);
        case 'Layout'
            myCircuit=myCircuit.LayoutDraw(gca);
    end
    

    
    setappdata(gcf,'myCircuit',myCircuit);
    

    
    
end