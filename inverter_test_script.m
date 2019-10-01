clear

%% Load Saved Circuit from Circuits Folder

load(fullfile('Circuits_folder/inverterCircuits/six/', 'inverter6dotGlobalInput.mat'));

mycircuit = Circuit;
simnamefront = 'inverter6dotGlobalInput_simresults';

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
inputfield = -0.001*Eo;
inputsignal.Type = 'Fermi';
inputsignal.Amplitude = 2*inputfield;
inputsignal.Period = clocksignal.Period*2;
inputsignal.Phase = inputsignal.Period/4;
inputsignal.Sharpness = 3;
inputsignal.MeanValue = inputsignal.Amplitude/2;


inputSignalsList{1} = inputsignal;
clockSignalsList{1} = clocksignal;





%% Simulation


mycircuit = mycircuit.pipeline(clockSignalsList, 'inputSignalsList', inputSignalsList, ...
                                                  'Filename', simnamefront, 'mobileCharge', 1,  ...
                                                  'numOfPeriods', numOfPeriods, 'TimeSteps', numOfPeriods*TimeStepsPerPeriod, ...
                                                  'randomizedRelaxation', 0);
                                              
                                              
                                              
%% Visualization

PipelineVisualization(simnamefront,myaxis,pwd,'Inverter_GlobalInput.mp4',10);




