function SwitchMode(handles)
myCircuit = getappdata(gcf,'myCircuit');

myCircuit.Device{1}.LayoutBox

mode = get(handles.layoutchange,'Value');

switch mode
    case  1 %Switch to layout mode
        cla;
        myCircuit = myCircuit.LayoutDraw(handles.LayoutWindow);
        myCircuit.Mode='Layout';
        setappdata(gcf,'myCircuit',myCircuit);
        
        
    case  0 %switch to sim mode
        cla;

        myCircuit = myCircuit.CircuitDraw(handles.LayoutWindow);
        myCircuit.Mode='Simulation';
        setappdata(gcf,'myCircuit',myCircuit);
        
end

myCircuit.Device{1}.LayoutBox
end