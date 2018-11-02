function PipelineVisualization( simresults, targetaxis, path, varargin )
%This function takes in a file and visualizes the simulation.
%This should be used in conjuction with circuit function pipeline()
%   draw the circuit at each time step.
%   things we care about for this: The signal info to construct
%   the gradient, and the cells positions, pol and act at each time step

home = pwd;
cd(home);
path;

f=gcf;
f.Units = 'pixels';

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
myCircuit = obj;

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

delete(wb);

xmax = max(xpos);
xmin = min(xpos);
ymax = max(ypos);
ymin = min(ypos);


x = xmin:xmax;
nx = 125;
xq = linspace(xmin-1, xmax+1, nx);
yq = linspace(ymin-2, ymax+2, nt);

if (length(clockSignalsList) == 1)
    clockSignal = clockSignalsList{1};
else
    error('Too many signals')
end
tperiod = clockSignal.Period*2;
time_array = linspace(0,tperiod,nt);

tp = mod(time_array, tperiod);
% xp = mod(xq, signal.Period);

% get the clock field
% efields_mat = cell2mat(efields(:,:));
% zfields = efields_mat(:,3:3:end);
% zmax = max(max(zfields));
% zmin = min(min(zfields));


%reconstruct signal

% for t = 1:size(pols,1)
%     waitbar( t / size(pols,1) , w8bar , 'Reconstructing Signal...');
%     
%     for idx = 1:nx
%         
%         efplots_temp = signal.getClockField([xp(idx),0,0], tp(t));
%         efplots(t, idx) = efplots_temp(3);
%         
%     end
% end





%
Frame(nt) = struct('cdata',[],'colormap',[]);
v = VideoWriter(vfilename,'MPEG-4');
open(v);

myCircuit.Simulating = 'on';

% f.Pointer = 'watch';

f=gcf;

% waitbar(0, w8bar , 'Writing to Video File...');

maxheight=f.Position(4);
maxwidth=f.Position(3);

for t = 1:size(pols,1)


    
%     cla;
    
    %ef = efplots(t,:); 
%     efz = zfields(t,:);
%     
%     interps = interp1(x,efz,xq,'pchip','extrap');
%     Eplot = repmat(ef,[nt,1]);
%     pcolor(xq' * ones(1, nx), ones(nx, 1)* yq, Eplot');
%     colormap cool;
%     shading interp;
%     colorbar;
%     caxis([zmin zmax])
    

    clockSignal.drawSignal([xmin-1,xmax+1], [ymin-2, ymax+2], tp(t));
    myCircuit = myCircuit.CircuitDraw(targetaxis, [pols(t,:); acts(t,:)]);
    
    
    drawnow
    %save it
%     gcf
%     gca
%     r = getrect(gcf)
%     Frame(t) = getframe(gcf,[0 0 maxwidth*.65 maxheight*.5]);
Frame(t) = getframe(gca);
% Frame(t) = getframe(gcf);
    
    
    writeVideo(v,Frame(t));
    disp(['t: ' num2str(t)])
    
    
end


% waitbar(1, w8bar , 'Simulation Video Complete');
% pause(.25);
% close(w8bar);



myCircuit.Simulating = 'off';
caxis('auto');

a=gca;

a.Box = 'off';
a.YLimMode = 'auto';

colorbar('delete');
close(v);
disp('Complete!')

end