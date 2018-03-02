% testbedTempDraw.m
%    This is a testbed script for the TEMPQCACircuitClass and the
%    ThreeDotCell/tempDraw() function.
%
% by E.P. Blair
% Baylor University
% 2018.03.01
%


NewCircuit = TEMPQCACircuitClass; % create an empty circuit

% Create ThreeDotCell objects
A = ThreeDotCell; % create a default QCA cell at the origin
B = ThreeDotCell([4, 3, 0]); % create a second cell at [4, 3, 0]

% Add ThreeDotCell objects to NewCircuit
NewCircuit = NewCircuit.AddDevice(A);
NewCircuit = NewCircuit.AddDevice(B);

%% Visualization
VizAxes = axes;
NewCircuit = NewCircuit.DrawCircuit(VizAxes);



