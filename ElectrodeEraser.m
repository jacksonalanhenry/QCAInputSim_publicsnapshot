function ElectrodeEraser(handles)
%This function will erase the selected electrode(s). The signal will still be stored still,
%not deleted even though it is not drawn

SignalsList = getappdata(gcf,'SignalsList');
myCircuit = getappdata(gcf,'myCircuit');


for i=1:length(SignalsList)
    
    if strcmp(SignalsList{i}.TopPatch.Selected,'on') || strcmp(SignalsList{i}.BottomPatch.Selected,'on')
        SignalsList{i}.IsDrawn = 'off';
    end
    
end

setappdata(gcf,'SignalsList',SignalsList);

myCircuit = myCircuit.CircuitDraw(gca);

  

setappdata(gcf,'myCircuit',myCircuit);

end

