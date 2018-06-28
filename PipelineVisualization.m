function PipelineVisualization( simresults, targetaxis )
%This function takes in a file and visualizes the simulation.
%This should be used in conjuction with circuit function pipeline()
%   draw the circuit at each time step.
%   things we care about for this: The signal info to construct
%   the gradient, and the cells positions, pol and act at each time step


load(simresults);
mycircuit = obj;

%get all of the xpositions
xit = 1;
for i=1:length(obj.Device)
    if isa(obj.Device{i},'QCASuperCell')
        for j=1:length(obj.Device{i}.Device)
            center = obj.Device{i}.Device{j}.CenterPosition;
            xpos(xit) = center(1);
            ypos(xit) = center(2);
            xit = xit + 1;
        end
    else
        center = obj.Device{i}.CenterPosition;
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




%
Frame(nt) = struct('cdata',[],'colormap',[]);
v = VideoWriter('sinusoidEField.mp4','MPEG-4');
open(v);

mycircuit.Simulating = 'on';

for t = 1:size(pols,1)
    
    cla;
    ef = efields(t,:);
    interps = interp1(x,ef,xq,'pchip','extrap');
    Eplot = repmat(interps,[nt,1]);
    
    
    
    pcolor(xq' * ones(1, nt), ones(nx, 1)* yq, Eplot');
    colormap cool;
    shading interp;
    colorbar;
    caxis([-signal.Amplitude signal.Amplitude])
    mycircuit = mycircuit.CircuitDraw(targetaxis, [pols(t,:); acts(t,:)]);

    
    drawnow
    %save it
    Frame(t) = getframe(gcf);
    writeVideo(v,Frame(t));
    disp(['t: ' num2str(t)])
    
end

mycircuit.Simulating = 'off';

close(v);
disp('Complete!')

end

