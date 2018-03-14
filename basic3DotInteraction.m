%%%
% Author: Jackson Henry
% 6 Dot QCA Cells

clear all;
close all;

%% Constants

epsilon_0 = 8.854E-12; % [C/(V*m)]     
qeV2J = 1.602E-19; % [J]
qe = 1; %[eV]

%% Parameters
a = 10; %[nm]
gamma = 10;

k = 1/(4*pi* epsilon_0*qeV2J*a);


%%

%Start with a Driver at position 0,0,0
Driver = ThreeDotCell(); %Spelled out super hard for now
Driver.Type = 'Driver';  %make it type driver
Driver.Polarization = -1; %make polarization -1
Driver.Activation = 1; %make activation 1 
Driver.CenterPosition = [0,0,0];


%Now make a Node position 1,0,0
node2 = ThreeDotCell(); %defaults are good for the most part
node2.CenterPosition = [1,0,0];
node2.ElectricField = [0,0,-1];


one = [0;0;1];
null = [0;1;0];
zero = [1;0;0];

Z = one*one' - zero*zero';
Pnn = null*null';



%testing getHamiltonian.
[V, EE] = eig(node2.GetHamiltonian({Driver}));
psi = V(:,1); %ground state

% Polarization is the expectation value of sigma_z
P = psi' * Z * psi
A = 1 - psi' * Pnn * psi 

%modify gamma, pdrv, adrv and see if everything is correct.



