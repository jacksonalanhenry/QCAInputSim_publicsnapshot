function ChangePol(handles, varargin)
%Change the position of any single driver or node.
myCircuit = getappdata(gcf,'myCircuit');


pol = str2num(get(handles.chngPol,'String'));
act = str2num(get(handles.chngAct,'String'));


if isempty(pol)
    pol = -1;
else 
    if pol<-1
        pol=-1;
    elseif pol>1
        pol=1;
    end
    set(handles.chngPol, 'String', num2str(pol));
end


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
                    myCircuit.Device{i}.Device{j}.Activation=act;
                    
                    %if it's on, change polarization to whatever the user inputs
                    
                end
            end
        else
            if strcmp(myCircuit.Device{i}.Type,'Driver') && (strcmp(myCircuit.Device{i}.SelectBox.Selected,'on'))%check for device being on
                myCircuit.Device{i}.Polarization=pol;
                myCircuit.Device{i}.Activation=act;

            end
        end
    end
    
    
    
    myCircuit = myCircuit.CircuitDraw(0, gca);
    
    
    setappdata(gcf,'myCircuit',myCircuit);

end