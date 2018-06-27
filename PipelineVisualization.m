function PipelineVisualization( simresults, targetaxis )
%This function takes in a file and visualizes the simulation.
%This should be used in conjuction with circuit function pipeline()
%   draw the circuit at each time step.
%   things we care about for this: The signal info to construct
%   the gradient, and the cells positions, pol and act at each time step


load(simresults);
mycircuit = obj;



%draw gradient before cells
time_array = linspace(0,2,nt); %right now this will do 2 periods
nx = 125;


t_Tc = linspace(-2,2, nt); % for gradient ploting purposes
x_lambda = linspace(-1, length(mycircuit.Device)+1, nx); % for gradient plotting purposes


Ezt = zeros(nx, nt);

for tidx = 1:nt
    Ezt(:, tidx) = ( cos(( 2*pi*(x_lambda/signal.Wavelength - time_array(tidx)/signal.Period ) ) + (3.1-pi) ) )*signal.Amplitude;
     
end



EztMax = max(Ezt(:));
EztMin = min(Ezt(:));



% mycircuit = mycircuit.CircuitDraw([pols(1,:); acts(1,:)]);

%
Frame(nt) = struct('cdata',[],'colormap',[]);
v = VideoWriter('sinusoidEField.mp4','MPEG-4');
open(v);

for t = 1:size(pols,1)
    
    Eplot = repmat(Ezt(:,t),[1,nt]);
    
    
    pcolor(x_lambda' * ones(1, nt), ones(nx, 1)* t_Tc, Eplot);
    colormap cool;
    shading interp;
    colorbar;
    caxis([EztMin EztMax])
    mycircuit = mycircuit.CircuitDraw(targetaxis, [pols(t,:); acts(t,:)]);

    
    drawnow
    %save it
    Frame(t) = getframe(gcf);
    writeVideo(v,Frame(t));
    disp(['t: ' num2str(t)])
    
end


close(v);
disp('Complete!')

end

