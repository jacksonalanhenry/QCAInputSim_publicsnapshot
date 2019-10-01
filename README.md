# QCAInputSim

QCAInputSim is a Simulator for Molecular Quantum-dot Cellular Automata Circuits.
This simulator is able to simulate the operation of 3-dot or 6-dot QCA Cells in electric fields. With the ultimate goal of exploring the possibilities of molecular QCA for classical computing.

## Usage

In the main directory there are 3 main types of MATLAB files: Class Definitions, GUI Helper functions, and Simulation Helper functions.

Along with these files there is a Front-end GUI that has been built with MATLAB's GUIDE that helps with the construction circuits and placement of nodes. There are some simple simulation capabilities built in the front-end as well, but the more powerful simulation settings can be accessed by writing your own MATLAB script.


### Example Scripts
There is a simple test script called 'simple_wire_test_script.m' that shows a simple wire with a driver node. This script highlights how to add nodes to a circuit, create clock signals, and run the pipeline simulation function. 

A second script called 'inverter_test_script.m' shows a more powerful version of this project. This script shows an inverter driven by a electric field instead of a driver.


Each Script will simulate then create a video of the output. These can be found in the main directory as well.



### Installation
To run either of these scripts an installation of MATLAB 2016 or higher is required.




## Authors
Under the guidance of Dr. Enrique Blair, this project is primary written by Jackson Henry(BSECE, Baylor University) with the help of other students. 

