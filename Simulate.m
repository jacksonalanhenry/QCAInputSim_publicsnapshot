function Simulate(handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
ax=gca;



myCircuit = getappdata(gcf,'myCircuit');

%     handles.layoutchange.Value=0;

SignalsList = getappdata(gcf,'SignalsList');


inputfield = str2num(get(handles.changeInputField,'String'));

% x=[];
% y=[];

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
            myCircuit.Device{i}.Device{j};
            %
            
%             if (myCircuit.Device{i}.Device{j}.ElectricField(2)==0)
                myCircuit.Device{i}.Device{j}.ElectricField(3)=clk*E0;
%             end
            
%             if strcmp(myCircuit.Device{i}.Device{j}.SelectBox.Selected,'on')
%                 x(end+1)=myCircuit.Device{i}.Device{j}.CenterPosition(1);
%                 y(end+1)=myCircuit.Device{i}.Device{j}.CenterPosition(2);
%                 
%             end
        end
        
        
    else
        myCircuit.Device{i};
%         if (myCircuit.Device{i}.ElectricField(2)==0)
%             myCircuit.Device{i}.ElectricField(3) = clk*E0;
%         else
             myCircuit.Device{i}.ElectricField(3) =  clk*E0;
%         end
        
%         if strcmp(myCircuit.Device{i}.SelectBox.Selected,'on')
%             x(end+1)=myCircuit.Device{i}.CenterPosition(1);
%             y(end+1)=myCircuit.Device{i}.CenterPosition(2);
%             
%         end
        myCircuit.Device{i};
    end
    
end

% x;
% y;

%relax and redraw
myCircuit=myCircuit.Relax2GroundState();

% xdiff=0;
% ydiff=0;

% must draw the circuit before we can draw the arrows denoting the electric
% field lines
myCircuit=myCircuit.CircuitDraw(gca);


setappdata(gcf,'myCircuit',myCircuit);

end