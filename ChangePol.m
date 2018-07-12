function ChangePol(handles, varargin)
%Change the position of any single driver or node.
myCircuit = getappdata(gcf,'myCircuit');

pol = str2num(get(handles.chngPol,'String'));

if nargin > 1
    polarization = varargin{1};
    
    switch polarization
        case 1
            pol = 1;
        case -1
            pol = -1;
    end
end

for i=1:length(myCircuit.Device)
   
    if isa(myCircuit.Device{i},'QCASuperCell') 
        
        for j=1:length(myCircuit.Device{i}.Device)
            if strcmp(myCircuit.Device{i}.Device{j}.Type,'Driver') && (strcmp(myCircuit.Device{i}.Device{j}.SelectBox.Selected,'on'))%check for device being on
                
                myCircuit.Device{i}.Device{j}.Polarization=pol;
                %if it's on, change polarization to whatever the user inputs
        
            end
        end
    else
        if strcmp(myCircuit.Device{i}.Type,'Driver') && (strcmp(myCircuit.Device{i}.SelectBox.Selected,'on'))%check for device being on
            myCircuit.Device{i}.Polarization=pol;
        end
    end
end



myCircuit = myCircuit.CircuitDraw(gca);


setappdata(gcf,'myCircuit',myCircuit);

end