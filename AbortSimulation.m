function AbortSimulation()
%This aborts the simulation and restores the gui back to its previous state
f=gcf;
clc;
clear all;
f.Pointer = 'arrow';
error('Program terminated for a specific reason')

end

