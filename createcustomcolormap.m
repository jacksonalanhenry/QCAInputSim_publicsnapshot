global GreenBlueRedColorMap
% Red column
temp4(:,1) = [ zeros(1,51) linspace(0, 1, 50)]';
% Green column
temp4(:,2) = [ linspace(1, 0, 50) zeros(1, 51)]';
% Blue column
temp4(:,3) = [ zeros(1,25) linspace(0, 0.5625, 25) 0.5625 ...
        linspace(0.5625, 0, 25) zeros(1, 25)]';
GreenBlueRedColorMap = temp4;
clear temp4

global GreyScale
% Red column
temp5(:,1) = [ linspace(0, 1, 101)]';
% Green column
temp5(:,2) = temp5(:,1);
% Blue column
temp5(:,3) = temp5(:,1);
GreyScale = temp5;
clear temp5

global GreyScale
% Red column
temp8(:,1) = [ zeros(1,50) linspace(0,1,51) ]';
% Green column
temp8(:,2) = [ zeros(1,50) linspace(0,1,51) ]';
% Blue column
temp8(:,3) = [ zeros(1, 50) linspace(0,1,51) ]';
GreyScale = temp8;
clear temp8

global GreyScale8bit
% temp column
OneA = ones(1,7);
OneB = ones(1,8);
tempK = [zeros(1,50), 0*OneA, 42/256*OneA, 85/256*OneA, 127/256*OneA, ...
        170/256*OneA, 213/256*OneA, OneB]';
temp9(:,1) = tempK;
temp9(:,2) = tempK;
temp9(:,3) = tempK;

GreyScale8Bit = temp9;
clear temp9

global GreenWhiteRed
% Red column
temp6(:,1) = [ linspace(0,1,51) ones(1,50)]';
% Green column
temp6(:,2) = [ ones(1,50), linspace(1,0,51)]';
% Blue column
temp6(:,3) = [ linspace(0, 1, 50) 1 linspace(1, 0, 50)]';
GreenWhiteRed = temp6;
clear temp6

global BlueWhite
% Red column
temp7(:,1) = [ zeros(1,50) linspace(0,1,51) ]';
% Green column
temp7(:,2) = [ zeros(1,50) linspace(0,1,51) ]';
% Blue column
temp7(:,3) = [ 0.5625*ones(1, 50) linspace(0.5625, 1, 51) ]';
BlueWhite = temp7;
clear temp7
