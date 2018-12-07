

maxThreads = min([feature('NumCores'),2]);
maxNumCompThreads(maxThreads);
delete(gcp('nocreate'));
parpool('local',maxThreads);


x = 1:200;
y = zeros(1,length(x));

% Load Circuit
 load(fullfile('Circuits folder', 'inputNodesBinaryWire.mat'));
 mycircuit = Circuit;
 % Set input node fields and clock field
 epsilon_0 = 8.854E-12;
 a=1e-9;%[m]
 q=1;%[eV]
 Eo = q^2*(1.602e-19)/(4*pi*epsilon_0*a)*(1-1/sqrt(2));


 

parfor inputidx = 1:10
    %y(inputidx) = x(inputidx).^2;
    
    
    parallelPipeline(inputidx)
    
    
    
end

delete(gcp('nocreate'));
