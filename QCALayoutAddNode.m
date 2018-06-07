function QCALayoutAddNode( handles )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

myCircuit = getappdata(gcf, 'myCircuit');
% xloc=[];


if(isempty(myCircuit.Device))
    newXlocation = 0;
else
    xs=[];
    for i=1:length(myCircuit.Device)
        xs(end+1)=myCircuit.Device{i}.CenterPosition(1);
        
    end
    
    newXlocation = max(xs)+1;
    
%     newXlocation = length(myCircuit.Device)-.5;
    % %         newXlocation = size(myCircuit.Device,1)*myCircuit.Device{end}.CharacteristicLength
%     newXlocation = newXlocation+1;
    
    %     for i=1:length(myCircuit.Device)
    %         xloc(i)=myCircuit.Device{i}.CenterPosition(1)
    %     end
end

% newXlocation=max(xloc);
% add node to circuit
myCircuit = myCircuit.addNode(ThreeDotCell([newXlocation 0 0]));

myCircuit.Device{length(myCircuit.Device)}.LayoutCenterPosition = [newXlocation 0 0];


% xloc(end+1)=myCircuit.Device{length(myCircuit.Device)}.CenterPosition(1)

% modify appdata circuit
setappdata(gcf, 'myCircuit', myCircuit);

% circuitDraw
myCircuit = myCircuit.CircuitDraw(handles.LayoutWindow);

handles.layoutchange.Value=0;
handles.makeSC.Value=0;

setappdata(gcf,'myCircuit',myCircuit);



%         myCircuit.Device{3}.CenterPosition


%axis tight
axis equal