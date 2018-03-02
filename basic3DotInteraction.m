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
Driver.Activation = 1;   %make activation 1
Driver.CenterPosition = [0,0,0];

%Now make a Node position 1,0,0
node1 = ThreeDotCell(); %defaults are good for the most part
node1.CenterPosition = [1,0,0];

PotentialDriver0 = getPotential(node1,Driver);

Driver.Polarization = 1;
PotentialDriver1 = getPotential(node1,Driver);


%test P=1 and P=-1 and check for opposite equality to verify kink energy
A = 1;
P = 1;
DeltaV = (1-1/sqrt(2))*k*qe*A*P;

testCell = ThreeDotCell();
testCell.Type = 'Driver';
testCell.Polarization = -1;
testCell.Activation = 1;


point = [0,0.3,0.3];
testCell.Potential(point);



node1.Polarization = -1;
%testing getHamiltonian.
[V, EE] = eig(node1.getHamiltonian())
psi = V(1,:) %ground state

% Polarization is the expectation value of sigma_z
P = psi' * kron(sz,IN) * psi;

%modify gamma, pdrv, adrv and see if everything is correct.




