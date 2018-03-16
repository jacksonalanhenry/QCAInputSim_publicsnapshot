%%%
% Author: Jackson Henry
% 6 Dot QCA Cells

clear all;
close all;

%% Constants

epsilon_0 = 8.854E-12; % [C/(V*m)]     
qeV2J = 1.602E-19; % [J]
qe = 1; %[eV]


one = [0;0;1];
null = [0;1;0];
zero = [1;0;0];


%% Parameters
a = 10; %[nm]
gamma = 60;

k = 1/(4*pi* epsilon_0*qeV2J*a);


%% Operators
Z = one*one' - zero*zero';
Pnn = null*null';

%% Create Driver and Node

%Start with a Driver at position 0,0,0
Driver = ThreeDotCell(); %Spelled out super hard for now
Driver.Type = 'Driver';  %make it type driver
Driver.Polarization = 1; %make polarization -1
Driver.Activation = 1; %make activation 1 
Driver.CenterPosition = [0,0,0];

Driver2 = ThreeDotCell(); 
Driver2.Type = 'Driver';  
Driver2.Polarization = 1; 
Driver2.Activation = 1;  
Driver2.CenterPosition = [2,0,0];

%Now make a Node position 1,0,0
node2 = ThreeDotCell(); %defaults are good for the most part
node2.CenterPosition = [1,0,0];
node2.ElectricField = [0,0,-1];


%% Test

dt = 501;
Pdrv = linspace(-1,1,dt);
Efield = linspace(-2.5,1,dt);
P = zeros(dt);
A = zeros(dt);


for x=1:dt
    %set Clock field of Target
    node2.ElectricField = [0,0,Efield(x)];
    
    for y=1:dt
        %set polarization of driver
        Driver.Polarization = Pdrv(y);
        
        %calculate hamiltonian
        [V, EE] = eig(node2.GetHamiltonian({Driver}));
        %get the ground state
        psi = V(:,1); 

        %calculate polarization
        P(x,y) = psi' * Z * psi;
        A(x,y) = 1 - psi' * Pnn * psi;

    end %y
end %x


%testing getHamiltonian.
[V, EE] = eig(node2.GetHamiltonian({Driver, Driver2}));
psi = V(:,1); %ground state

% Polarization is the expectation value of sigma_z
P = psi' * Z * psi
A = 1 - psi' * Pnn * psi

%modify gamma, pdrv, adrv and see if everything is correct.


%% Visualization

% figure
% pcolor(Pdrv, Efield, P);
% 
% c = colorbar;
% 
% shading interp
% grid on;
% set(gca, 'FontSize', 18, 'Fontname', 'Times');
% ylabel('$E_z$ [V/nm]', 'Interpreter', 'latex');
% xlabel('$P_{drv}$', 'Interpreter', 'latex');
% zlabel('$P_{tgt}$', 'Interpreter', 'latex');

