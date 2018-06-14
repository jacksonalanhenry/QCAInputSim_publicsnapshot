function SwitchMode(handles)
myCircuit = getappdata(gcf,'myCircuit');



mode = get(handles.layoutchange,'Value');%use this for the switch
handles.makeSC.Value=0;
% we could also use mode=myCircuit.Mode, but the current use allows us to
% take information directly from the GUI's radio button

switch mode
    case  1 %Switch to layout mode, clear, draw, set app data
        cla;
        myCircuit = myCircuit.LayoutDraw(handles.LayoutWindow);
        myCircuit.Mode='Layout';
        setappdata(gcf,'myCircuit',myCircuit);
        
        
    case  0 %switch to sim mode, clear, draw, set app data
        cla;
        
        myCircuit = myCircuit.CircuitDraw(handles.LayoutWindow);
        
        myCircuit.Mode='Simulation';
        setappdata(gcf,'myCircuit',myCircuit);
        
end

end