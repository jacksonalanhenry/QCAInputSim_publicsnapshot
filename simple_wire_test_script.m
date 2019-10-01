clear

%% Create Nodes for practice

driver = SixDotCell();
driver.Type = 'Driver';
driver.CenterPosition = [0,0,0];

node = SixDotCell();
node.CenterPosition = [2,0,0];

node2 = SixDotCell();
node2.CenterPosition = [4,0,0];



%% Create Circuit and add Nodes

mycircuit = QCACircuit();
mycircuit = mycircuit.addNode(driver);
mycircuit = mycircuit.addNode(node);
mycircuit = mycircuit.addNode(node2);


%lets add some more nodes a bit faster to make the simulation more
%interesting
for idx = 1:10
    tempNode = SixDotCell();
    tempNode.CenterPosition = node2.CenterPosition + [idx*2,0,0];
    
    mycircuit = mycircuit.addNode(tempNode);
end




%% Physics Constants for Nice Signal Units
epsilon_0 = 8.854E-12;
a=1e-9;%[m]
q=1;%[eV]
Eo = q^2*(1.602e-19)/(4*pi*epsilon_0*a)*(1-1/sqrt(2)); %Kink Energy Field Strength



%% Signals
clf
myaxis = axes;

mycircuit = mycircuit.GenerateNeighborList();
mycircuit = mycircuit.Relax2GroundState(0);
mycircuit = mycircuit.CircuitDraw(0,myaxis);


numOfPeriods = 5;
TimeStepsPerPeriod = 400;


%Clock Signal Setup
clocksignal = Signal();
clocksignal.Wavelength = 50;
clocksignal.Amplitude = 15*Eo;
clocksignal.Period=200;

%Input Signal Setup
inputsignal = Signal();
inputsignal.Amplitude = 0; %Set amplitude to zero so there is no interation


inputSignalsList{1} = inputsignal;
clockSignalsList{1} = clocksignal;

%Driver Signal Setup
DriverSignal = Signal();
DriverPol = 1;
DriverSignal.Type = 'Driver';
DriverSignal.Amplitude = 2*DriverPol;
DriverSignal.Period = clockSignalsList{1}.Period*2;
DriverSignal.Phase = DriverSignal.Period/4;
DriverSignal.Sharpness = 3;
DriverSignal.MeanValue = DriverSignal.Amplitude/2;


mycircuit.Device{1}.Polarization = DriverSignal; %set the polarization of the driver equal to signal class



%% Simulation

simnamefront = 'simplewire_simresults';
mycircuit = mycircuit.pipeline(clockSignalsList, 'inputSignalsList', inputSignalsList, ...
                                                  'Filename', simnamefront, 'mobileCharge', 1,  ...
                                                  'numOfPeriods', numOfPeriods, 'TimeSteps', numOfPeriods*TimeStepsPerPeriod, ...
                                                  'randomizedRelaxation', 0);
                                              
                                              
                                              
%% Visualization

PipelineVisualization(simnamefront,myaxis,pwd,'Simplewire_Driver.mp4',10);




