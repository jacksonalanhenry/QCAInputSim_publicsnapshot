function myCircuit=ChangeX(handles)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
myCircuit=getappdata(gcf,'myCircuit');

mode = myCircuit.Mode;

switch mode
    
    case 'Simulation'
        
        for i=1:length(myCircuit.Device)
            if isa(myCircuit.Device{i},'QCASuperCell')
                
                for j=1:length(myCircuit.Device{i}.Device)
                    
                    
                    if strcmp(myCircuit.Device{i}.Device{j}.SelectBox.Selected,'on')
                        for k=1:length(myCircuit.Device{i}.Device)
                            
                            
                            myCircuit.Device{i}.Device{k}.CenterPosition(1)=myCircuit.Device{i}.Device{k}.CenterPosition(1)+str2num(get(handles.changex,'String'));
                        end
                        
                    end
                end
                
                
                
                
            else
                if strcmp(myCircuit.Device{i}.SelectBox.Selected,'on')%is it selected?
                    
                    myCircuit.Device{i}.CenterPosition(1)=myCircuit.Device{i}.CenterPosition(1)+str2num(get(handles.changex,'String'));
                    %change the X coordinate by the user's input value
                    
                end
            end
        end
        
        
        myCircuit = myCircuit.CircuitDraw(handles.LayoutWindow);
        
    case 'Layout'
        
        for i=1:length(myCircuit.Device)
            if isa(myCircuit.Device{i},'QCASuperCell')
                
                for j=1:length(myCircuit.Device{i}.Device)
                    
                    
                    if strcmp(myCircuit.Device{i}.Device{j}.Layout.Selected,'on')
                        for k=1:length(myCircuit.Device{i}.Device)
                            
                            
                            myCircuit.Device{i}.Device{k}.CenterPosition(1)=myCircuit.Device{i}.Device{k}.CenterPosition(1)+str2num(get(handles.changex,'String'));
                        end
                        
                    end
                end
                
                
                
                
            else
                if strcmp(myCircuit.Device{i}.LayoutBox.Selected,'on')%is it selected?
                    
                    myCircuit.Device{i}.CenterPosition(1)=myCircuit.Device{i}.CenterPosition(1)+str2num(get(handles.changex,'String'));
                    %change the X coordinate by the user's input value
                    
                end
            end
        end
        
        
        myCircuit = myCircuit.LayoutDraw(handles.LayoutWindow);
        
        
        
end

setappdata(gcf,'myCircuit',myCircuit);
end