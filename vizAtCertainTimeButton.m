function vizAtCertainTimeButton(handles)
%This function will use the simulation .mat files to create a video with
%the help of the PipelineVisualization function


Sim = getappdata(gcf,'SimResults');
path = getappdata(gcf, 'SimResultsPath');
myCircuit = getappdata(gcf,'myCircuit');


if Sim
    load(Sim);
    
    myCircuit = obj.CircuitDraw(gca);
    timestep = str2num( get(handles.vizAtCertainTimeEditBox,'String') );
    showClockField = str2num( get(handles.showClockFieldRadio,'String') )
    
    if timestep < 1
        timestep = 1;
        myCircuit = myCircuit.CircuitDraw(gca, [pols(timestep,:); acts(timestep,:)]);

    elseif timestep > size(pols,1)
        timestep = size(pols,1);
        myCircuit = myCircuit.CircuitDraw(gca, [pols(timestep,:); acts(timestep,:)]);

    else
        
        
        
        
        
        
                
        xit = 1;
        for i=1:length(myCircuit.Device)
            
            if isa(myCircuit.Device{i},'QCASuperCell')
                for j=1:length(obj.Device{i}.Device)
                    center = obj.Device{i}.Device{j}.CenterPosition;
                    xpos(xit) = center(1);
                    ypos(xit) = center(2);
                    xit = xit + 1;
                end
            else
                center = myCircuit.Device{i}.CenterPosition;
                xpos(xit) = center(1);
                ypos(xit) = center(2);
                xit = xit + 1;
            end
        end
        
        xmax = max(xpos);
        xmin = min(xpos);
        ymax = max(ypos);
        ymin = min(ypos);
        
        
        x = xmin:xmax;
        nx = 125;
        xq = linspace(xmin-1, xmax+1, nx);
        yq = linspace(ymin-2, ymax+2, nt);
        
        if (length(clockSignalList) == 1)
            clockSignal = clockSignalList{1};
        else
            error('Too many signals')
        end
        tperiod = clockSignal.Period*2;
        time_array = linspace(0,tperiod,nt);
        
        tp = mod(time_array, tperiod);
        
        clockSignal.drawSignal([xmin-1,xmax+1], [ymin-2, ymax+2], tp(timestep));

        
        
        
        
        
        
        
        
        myCircuit = myCircuit.CircuitDraw(gca, [pols(timestep,:); acts(timestep,:)]);

        
    end
    
else
    
    [Sim, path]= uigetfile('*.mat'); %path gets sent into Pipeline in order to change the path, that way we can put the video file anywhere
    load(Sim);
    
    setappdata(gcf,'myCircuit',myCircuit);
    setappdata(gcf,'SimResults', Sim);
    setappdata(gcf,'SimResultsPath', path);
    
    disp('click it again for now.....')
    
    
    
end


end