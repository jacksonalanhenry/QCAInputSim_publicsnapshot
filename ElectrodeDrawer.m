function ElectrodeDrawer(handles)
%This function will draw the selected signal on the circuit axis as long as
%the selected signal is an electrode.  

SignalsList = getappdata(gcf,'SignalsList');

contents = cellstr(get(handles.signalList,'String'));

if ~isempty(contents)
    sigName = contents{get(handles.signalList,'Value')};
    
    for i=1:length(SignalsList)
        SignalsList{i}.Name;
        SignalsList{i}.Type;
        if strcmp(SignalsList{i}.Name,sigName) && strcmp(SignalsList{i}.Type,'Electrode')
            
            SignalsList{i}.IsDrawn = 'on';
            mySignal = SignalsList{i};
            
            if ~isempty(mySignal.Height)
                mySignal = mySignal.drawElectrode(); %the signal has all of the required traits for drawing an electrode
                
            else
                [center height width field] = GetBoxTraits(handles); %we need to attain the center position, height, width, and Efield
                mySignal = mySignal.drawElectrode(center ,height ,width ,field); 
                
                
                SignalsList{i} = mySignal;
            end
            
        end
        
    end
    
end


setappdata(gcf,'SignalsList',SignalsList); %must set app data for SignalsList


myCircuit = getappdata(gcf,'myCircuit');
myCircuit = myCircuit.CircuitDraw(gca);



setappdata(gcf,'myCircuit',myCircuit);


% ChangeInputField(handlesButton);


end

