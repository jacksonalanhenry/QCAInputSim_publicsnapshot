function [center height width field] = GetBoxTraits(handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
myCircuit = getappdata(gcf,'myCircuit');

center = [0 0 0];
height = 1.5;
width = .5;

field  = str2num(handles.changeInputField.String);

x=[];
y=[];

for i=1:length(myCircuit.Device)%set clock field for all cells
    if isa(myCircuit.Device{i},'QCASuperCell')
        for j=1:length(myCircuit.Device{i}.Device)
            
            
            if strcmp(myCircuit.Device{i}.Device{j}.SelectBox.Selected,'on')
                x(end+1)=myCircuit.Device{i}.Device{j}.CenterPosition(1);
                y(end+1)=myCircuit.Device{i}.Device{j}.CenterPosition(2);
                myCircuit.Device{i}.Device{j}.ElectricField  = [0 str2num(handles.changeInputField.String) 0 ];
            end
        end
        
        
    else
        
        
        
        if strcmp(myCircuit.Device{i}.SelectBox.Selected,'on')
            x(end+1)=myCircuit.Device{i}.CenterPosition(1);
            y(end+1)=myCircuit.Device{i}.CenterPosition(2);
            myCircuit.Device{i}.ElectricField  = [0 str2num(handles.changeInputField.String) 0 ];
        end
        myCircuit.Device{i}.ElectricField
    end
end


x;
y;

%relax and redraw

xdiff=0;
ydiff=0;

% must draw the circuit before we can draw the arrows denoting the electric
% field lines
% myCircuit=myCircuit.CircuitDraw(gca);

if ~isempty(x)
    if (length(x) > 1)
        xdiff = (max(x)-min(x));
        ydiff = (max(y)-min(y));
        
        midy = (max(y)+min(y))/2;
        midx = (max(x)+min(x))/2;
        
%         mySignal = mySignal.drawElectrode([midx, midy, 0], ydiff, xdiff,inputfield);
        center = [midx midy 0];
        height = ydiff;
        width = xdiff;
        
    elseif length(x) == 1
        xdiff = 0;
        ydiff = (max(y)-min(y));
%         mySignal = mySignal.drawElectrode([x(1), y(1), 0], ydiff,xdiff,inputfield);
        
        center = [x(1) y(1) 0];
        height = ydiff;
        width = xdiff;        
    end
    
%     setappdata(gcf,handles.signalEditor.String,mySignal);
end

setappdata(gcf,'myCircuit',myCircuit);

end

