% Testing Supercell
f=figure;
a=axes;
Ez=[0,0,-2];

node1=ThreeDotCell();
node1.CenterPosition=[0,0,0];
node1.ElectricField=Ez;

node2=ThreeDotCell();
node2.CenterPosition=[1,0,0];
node2.ElectricField=Ez;


node3=ThreeDotCell();
node3.CenterPosition=[2,0,0];
node3.ElectricField=Ez;

node4=ThreeDotCell();
node4.CenterPosition=[2,2,0];
node4.ElectricField=Ez;

node5=ThreeDotCell();
node5.CenterPosition=[2,-2,0];
node5.ElectricField=Ez;

node6=ThreeDotCell();
node6.CenterPosition=[3,0,0];
node6.ElectricField=Ez;

node7=ThreeDotCell();
node7.CenterPosition=[3,2,0];
node7.ElectricField=Ez;

node8=ThreeDotCell();
node8.CenterPosition=[3,-2,0];
node8.ElectricField=Ez;

nodedriver=ThreeDotCell();
nodedriver.Type='Driver';
nodedriver.CenterPosition=[-1,0,0];
nodedriver.Polarization=1;



Circuit = QCACircuit();

Circuit=Circuit.addNode(node1);
Circuit=Circuit.addNode(node2);
Circuit=Circuit.addNode(node3);
Circuit=Circuit.addNode(node4);
Circuit=Circuit.addNode(node5);
Circuit=Circuit.addNode(node6);
Circuit=Circuit.addNode(node7);
Circuit=Circuit.addNode(node8);
Circuit=Circuit.addNode(nodedriver);


Circuit.Device{1}.NeighborList=[2];
Circuit.Device{2}.NeighborList=[1 3 4 5];
Circuit.Device{3}.NeighborList=[2 4 5 6 7 8];
Circuit.Device{4}.NeighborList=[2 3 6 7];
Circuit.Device{5}.NeighborList=[2 3 6 8];
Circuit.Device{6}.NeighborList=[3 4 5 7 8];
Circuit.Device{7}.NeighborList=[3 4 6];
Circuit.Device{8}.NeighborList=[3 5 6];




% Circuit=Circuit.GenerateNeighborList();
Circuit=Circuit.Relax2GroundState();

Circuit.CircuitDraw(a);
%% 
% Super=SuperCell();
% Super= Super.addCell(node1);
% Super= Super.addCell(node2);
% Super= Super.addCell(node3);
% Super= Super.addCell(node4);
% Super= Super.addCell(node5);
% Super= Super.addCell(node6);
% Super= Super.addCell(node7);
% Super= Super.addCell(node8);
% 
% Super
