%% Testing Supercell
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

Circuit = QCACircuit();

Circuit=Circuit.addNode(node1);
Circuit=Circuit.addNode(node2);
Circuit=Circuit.addNode(node3);
Circuit=Circuit.addNode(node4);
Circuit=Circuit.addNode(node5);
Circuit=Circuit.addNode(node6);
Circuit=Circuit.addNode(node7);
Circuit=Circuit.addNode(node8);

Circuit=Circuit.GenerateNeighborList()
Circuit.Relax2GroundState();

Circuit.CircuitDraw(a);




