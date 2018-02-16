%%%
% Author: Jackson Henry
% 6 Dot QCA Cells

%% Constants

qe = 1.602E-19; % C

%% Parameters


%%

%Start with a Driver at position 0,0,0
Driver = ThreeDotCell(); %Spelled out super hard for now
Driver.Type = 'Driver';  %make it type driver
Driver.Polarization = -1; %make polarization -1
Driver.Activation = 1;   %make activation 1
Driver.CenterPosition = [0,0,0];

%Now make a Node position 1,0,0
node1 = ThreeDotCell(); %defaults are good for the most part
node1.CenterPosition = [1,0,0];

PotentialDriver0 = getPotential(node1,Driver);

Driver.Polarization = 1;
PotentialDriver1 = getPotential(node1,Driver);




