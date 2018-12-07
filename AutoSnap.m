function AutoSnap(handles)
% This function allows the opportunity for the user to alternate snap to
% grid functionality on and off.  The value attained from handles.autoSnap
% switches the circuit's SnapToGrid property on or off depending on its
% current state.

    myCircuit = getappdata(gcf,'myCircuit');
    
snap = get(handles.autoSnap,'Value');%use this for the switch


switch snap
    case  1 %clear, draw, set app data
        
        myCircuit.SnapToGrid='on';
        myCircuit = myCircuit.CircuitDraw(0,gca);
        set(handles.autoSnap,'BackgroundColor',[.8 .8 .8],...
            'ForegroundColor',[.1 .8 0]);
        
        
        
        
    case  0 %switch to sim mode, clear, draw, set app data
        myCircuit.SnapToGrid='off';
        set(handles.autoSnap,'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0]);
        
end


setappdata(gcf,'myCircuit',myCircuit);
end