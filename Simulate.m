function Simulate(handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
ax=gca;

ResetCells();

myCircuit = getappdata(gcf,'myCircuit');

%     handles.layoutchange.Value=0;

mySignal = getappdata(gcf,handles.signalEditor.String);


inputfield = str2num(get(handles.changeInputField,'String'));

x=[];
y=[];

%regenerate neighbor list once we hit the simulate button
myCircuit=myCircuit.GenerateNeighborList();


eps0 = 8.854E-12;%set constants
a=1e-9;
q=1;
E0 = q^2 * (1.602e-19) / (4*pi*eps0*a)* (1-1/sqrt(2));
clk= str2num(get(handles.chngClock,'String'));




for i=1:length(myCircuit.Device)%set clock field for all cells
    if isa(myCircuit.Device{i},'QCASuperCell')
        for j=1:length(myCircuit.Device{i}.Device)
            %
            
            if (myCircuit.Device{i}.Device{j}.ElectricField(2)==0)
                myCircuit.Device{i}.Device{j}.ElectricField=[0 0 clk]*E0;
            end
            
            if strcmp(myCircuit.Device{i}.Device{j}.SelectBox.Selected,'on')
                x(end+1)=myCircuit.Device{i}.Device{j}.CenterPosition(1);
                y(end+1)=myCircuit.Device{i}.Device{j}.CenterPosition(2);
                
            end
        end
        
        
    else
        
        if (myCircuit.Device{i}.ElectricField(2)==0)
            myCircuit.Device{i}.ElectricField=[0 0 clk]*E0;
        end
        
        if strcmp(myCircuit.Device{i}.SelectBox.Selected,'on')
            x(end+1)=myCircuit.Device{i}.CenterPosition(1);
            y(end+1)=myCircuit.Device{i}.CenterPosition(2);
            
        end
        
    end
    myCircuit.Device{i};
end

x;
y;

%relax and redraw
myCircuit=myCircuit.Relax2GroundState();

xdiff=0;
ydiff=0;

% must draw the circuit before we can draw the arrows denoting the electric
% field lines
myCircuit=myCircuit.CircuitDraw(gca);

if ~isempty(mySignal)
    if (length(x) > 1)
        xdiff = (max(x)-min(x));
        ydiff = (max(y)-min(y));
        
        midy = (max(y)+min(y))/2;
        midx = (max(x)+min(x))/2;
        
        mySignal = mySignal.drawElectrode([midx, midy, 0], ydiff, xdiff,inputfield);
        
        
    elseif length(x) == 1
        xdiff = 0;
        ydiff = (max(y)-min(y));
        mySignal = mySignal.drawElectrode([x(1), y(1), 0], ydiff,xdiff,inputfield);
    end
end

setappdata(gcf,'myCircuit',myCircuit);
end