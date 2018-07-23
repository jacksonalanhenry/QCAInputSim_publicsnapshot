function QCAHelp()
% Circuit
% The user may add/remove node (red) and driver(green) cells, along with selecting multiple 
% nodes to create a super cell, identified by the outline of a common unique color.  Driver 
% cells cannot be in super cells.  Cells can be selected in groups or alone, along with
% being dragged and dropped to any position. When dragging and dropping, the user can elect
% to have snap to to grid functionality on or off.  The user may also use the arrow keys 
% to 'nudge' cell(s) in any direction.  
% 
% 
% Signal
% The user may create a signal which is one of four types: sinusoidal, custom,
% fermi, and electrode.  The former 3 will be plotted on the signal axes in the signal panel if 
% a signal of one of those 3 types is selected in the signal list box at the far left of the panel.
% Editing a signal consists of selecting it from the list, thus opening up the signal
% and putting all the relevant information into the boxes for the
% corresponding signal type.  The signal's properties can be changed,
% including but not limited to (if applicable) its type, wavelength,
% amplitude, etc.
% 
% 
% Hot Keys
% Ctrl+h = align selected cells horizontally
% Ctrl+u = align selected cells vertically
% Ctrl+m = make super cell
% Ctrl+l = disband supercell (click any member of the super cell then ctrl+l)
% Ctrl+f = add a node cell (red)
% Ctrl+d = add a driver cell (green)
% Ctrl+b = rectangle select (see mouse functionality)
% Ctrl+back/del = delete selected cell(s)
% Ctrl+g = snap to grid
% Ctrl+e = reset cells to P=0,A=1
% Ctrl+t = refresh (redraw)
% Ctrl+a = select all cells
% Ctrl+q = deselect all cells (or simply use the Shift button alone)
% Ctrl+n = New circuit (clears the axes and signals list)
% Ctrl+o = Open a previously saved circuit
% Ctrl+s = Save circuit
% Ctrl+. = make selected driver(s) P=1
% Ctrl+, = make selected driver(s) P=-1
% 
% 
% Click Functionality
% Left click allows the user to select any button or cell
% Right click opens a context menu with known functionality
% Scroll (middle) click allows the user to use rectangle select (the arrow will become a cross)
% 
% 
% Simulations
% In order to Simulate, the user must first create a circuit and a signal.
% Once both are created, the user can select the Simulation button in the Simulation
% panel.  There is an option to name the simulation below that button, but if no
% name is entered, the simulation will automatically be named 'simResults'.  Upon
% completion of that simulation, the user can elect to visualize that simulation by
% pressing the Visualize Simulation button.  Then a .mp4 file will be created that the user 
% can view upon completion of the visualization function. 

Circuit = 'The user may add/remove node (red) and driver(green) cells, along with selecting multiple nodes to create a super cell, identified by the outline of a common unique color.  Driver cells cannot be in super cells.  Cells can be selected in groups or alone, along with being dragged and dropped to any position. When dragging and dropping, the user can electto have snap to to grid functionality on or off.  The user may also use the arrow keys to ''nudge'' cell(s) in any direction.';

Signal  = 'The user may create a signal which is one of four types: sinusoidal, custom, fermi, and electrode.  The former 3 will be plotted on the signal axes in the signal panel if a signal of one of those 3 types is selected in the signal list box at the far left of the panel. Editing a signal consists of selecting it from the list, thus opening up the signal and putting all the relevant information into the boxes for the corresponding signal type.  The signal''s properties can be changed, including but not limited to (if applicable) its type, wavelength, amplitude, etc.';

h='Ctrl+h = align selected cells horizontally';
u='Ctrl+u = align selected cells vertically';
m='Ctrl+m = make super cell';
l='Ctrl+l = disband supercell (click any member of the super cell then ctrl+l)';
f='Ctrl+f = add a node cell (red)';
d='Ctrl+d = add a driver cell (green)';
b='Ctrl+b = rectangle select (see mouse functionality)';
back='Ctrl+back/del = delete selected cell(s)';
g='Ctrl+g = snap to grid';
e='Ctrl+e = reset cells to P=0,A=1';
t='Ctrl+t = refresh (redraw)';
a='Ctrl+a = select all cells';
q='Ctrl+q = deselect all cells (or simply use the Shift button alone)';
n='Ctrl+n = New circuit (clears the axes and signals list)';
o='Ctrl+o = Open a previously saved circuit';
s='Ctrl+s = Save circuit';
pd='Ctrl+. = make selected driver(s) P=1';
com='Ctrl+, = make selected driver(s) P=-1';

Click   = 'Left click allows the user to select any button or cell\nRight click opens a context menu with known functionality\nScroll (middle) click allows the user to use rectangle select (the arrow will become a cross)\n';
Sims    = 'In order to Simulate, the user must first create a circuit and a signal.  Once both are created, the user can select the Simulation button in the Simulation panel.  There is an option to name the simulation below that button, but if no name is entered, the simulation will automatically be named ''simResults''.  Upon completion of that simulation, the user can elect to visualize that simulation by pressing the Visualize Simulation button.  Then a .mp4 file will be created that the user can view upon completion of the visualization function.';

msgbox({'Circuit';Circuit;'Signal';'';
    Signal;'Hot Keys';h;u;m;l;f;d;b;back;g;e;t;a;q;n;o;s;pd;com;'';
    'Click Functionality';Click;'';
    'Simulations';Sims;'';},'Help','helpd');

end