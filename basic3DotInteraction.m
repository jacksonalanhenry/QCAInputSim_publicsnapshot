%%%
% Author: Jackson Henry
% 6 Dot QCA Cells

%% Constants

qe = 1.602E-19; % C

%% Parameters


%%

%Start with a Driver
Driver = ThreeDotCell(); %Spelled out super hard for now
Driver.Type = 'Driver';  %make it type driver
Driver.Polarization = 1; %make polarization 1
Driver.Activation = 0;   %make activation 0

%Now make a Node
node1 = ThreeDotCell(); %defaults are good for the most part
node1.CenterPosition = [1, 0, 0];


