function AutoSnap(handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    myCircuit = getappdata(gcf,'myCircuit');
    
snap = get(handles.autoSnap,'Value');%use this for the switch



switch snap
    case  1 %Switch to layout mode, clear, draw, set app data
        
        myCircuit.SnapToGrid='on';
        myCircuit = myCircuit.CircuitDraw(gca);
        set(handles.autoSnap,'BackgroundColor',[.8 .8 .8]);
        setappdata(gcf,'myCircuit',myCircuit);
        
        
    case  0 %switch to sim mode, clear, draw, set app data
        myCircuit.SnapToGrid='off';
        set(handles.autoSnap,'BackgroundColor',[1 1 1]);
        setappdata(gcf,'myCircuit',myCircuit);
        
end
end

