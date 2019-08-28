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
        downsamplerate = 2;

        
    case 4
        vfilename = varargin{1};
        downsamplerate = 2;
        
    case 5
        downsamplerate = varargin{2};
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
tperiod = clockSignal.Period*numOfPeriods;
time_array = linspace(1,tperiod,nt);

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

sizePol = size(pols,1);



% epsilon_0 = 8.854E-12;
% a=1e-9;%[m]
% q=1;%[eV]
% Eo = q^2*(1.602e-19)/(4*pi*epsilon_0*a)*(1-1/sqrt(2));
% 
% inputfield = 0.85*Eo;
% 
% centerpos = [0,0,0];
% amp = 2*inputfield;
% period = 400;
% phase = period/4;
% sharpness = 3;
% mv = amp/2;
%time_array = linspace(1, period, nt);
%tp = mod(time_array, period);



for t = downsample(1:sizePol,downsamplerate);


    
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
    

    clockSignal.drawSignal([xmin-1,xmax+1], [ymin-2.5, ymax+2.5], tp(t));
    
    myCircuit = myCircuit.CircuitDraw(t, targetaxis, [pols(t,:); acts(t,:)]);
    

    
    %%%%%%%%arrowmod = amp * PeriodicFermi(mod(centerpos(1) - tp(t) - phase , period), period, sharpness) + mv;
    
    %arrowtext = strcat('E_y=',num2str(arrowmod/Eo),'E_o');
    %%%%%%%%textborder(xmin-3, 0, '$E_{y}$', [0,0,0],[1,1,1], 'FontSize', 28, 'Interpreter', 'latex')
    %rectangle('Position',[xmin-3.1 -0.5 1.3 1],'Curvature',0.2,'FaceColor',[1,1,1]);
    %text(xmin-3, 0, '$E_{in}$', 'Color', [0,0,0], 'FontSize', 28, ...
    %    'Interpreter', 'latex')
    
    
    %%%%%%%arrow([xmin-1 -10*arrowmod], [xmin-1 10*arrowmod],'Width',2,'EdgeColor',[1,1,1],'FaceColor',[0,0,0]);
    
    drawnow
    axis equal
    axis off
    %save it
    %gcf
    %gca
    %r = getrect(gcf)
    %Frame(t) = getframe(gcf,[0 0 maxwidth*.65 maxheight*.5]);
    %Frame(t) = getframe(gca);
    Frame(t) = getframe(gcf);
    
    
    writeVideo(v,Frame(t));
    disp(['t: ' num2str(t)])
    
    
end





myCircuit.Simulating = 'off';
caxis('auto');

a=gca;

a.Box = 'off';
a.YLimMode = 'auto';

colorbar('delete');
close(v);
disp('Complete!')

end