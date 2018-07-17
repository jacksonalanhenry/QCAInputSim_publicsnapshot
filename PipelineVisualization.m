function PipelineVisualization( simresults, targetaxis, path, varargin )
%This function takes in a file and visualizes the simulation.
%This should be used in conjuction with circuit function pipeline()
%   draw the circuit at each time step.
%   things we care about for this: The signal info to construct
%   the gradient, and the cells positions, pol and act at each time step
home = pwd;
cd(home);
path;


% w8bar = waitbar(0,'Please wait...');
% w8bar.Position = w8bar.Position + 50;

pause(.5);

switch nargin
    
    case 3
        vfilename = 'CircuitVideo.mp4';
        
    case 4
        vfilename = varargin{1};
        
    otherwise 
        disp('other')
    
end

cd(path);
load(simresults);
cd(home);
mycircuit = obj;

%get all of the xpositions
xit = 1;

% waitbar(0, w8bar , 'Processing Simulation');

for i=1:length(obj.Device)
%     waitbar(i/length(obj.Device), w8bar , 'Retrieving Circuit and Signal data...');
    
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

tperiod = signal.Period*2;
time_array = linspace(0,tperiod,nt);

tp = mod(time_array, tperiod);
xp = mod(xq, signal.Period);


%reconstruct signal

% waitbar(0, w8bar , 'Reconstructing Signal...');

for t = 1:size(pols,1)
%     waitbar( t / size(pols,1) , w8bar , 'Reconstructing Signal...');
    
    for idx = 1:nx
        
        
        
        efplots_temp = signal.getClockField([xp(idx),0,0], tp(t));
        efplots(t, idx) = efplots_temp(3);
        
    end
end




%
Frame(nt) = struct('cdata',[],'colormap',[]);
v = VideoWriter(vfilename,'MPEG-4');
open(v);

mycircuit.Simulating = 'on';

% f=gcf;

% f.Pointer = 'watch';


% waitbar(0, w8bar , 'Writing to Video File...');



for t = 1:size(pols,1)
    
%     close(w8bar)
    cla;

    ef = efplots(t,:);
%     interps = interp1(x,ef,xq,'pchip','extrap');
    Eplot = repmat(ef,[nt,1]);
    
    
    
    pcolor(xq' * ones(1, nt), ones(nx, 1)* yq, Eplot');
    colormap cool;
    shading interp;
    colorbar;
    caxis([-signal.Amplitude signal.Amplitude]);
    mycircuit = mycircuit.CircuitDraw(targetaxis, [pols(t,:); acts(t,:)]);

    
    drawnow
    %save it
    Frame(t) = getframe(gca);
    v;
    
    writeVideo(v,Frame(t))
    disp(['t: ' num2str(t)])
    
    
end

% waitbar(1, w8bar , 'Simulation Video Complete');
% pause(.5);
% close(w8bar);

% f.Pointer = 'arrow';

mycircuit.Simulating = 'off';
caxis('auto');

a=gca;

a.Box = 'off';

a.YLimMode = 'auto';


colorbar('delete');
close(v);
disp('Complete!')

end

