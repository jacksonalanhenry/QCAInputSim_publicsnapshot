classdef ThreeDotCell < QCACell
    %ThreeDotCell Defines ThreeDotCell subclass of QCACell
    %   Detailed explanation goes here
    
    properties
        Polarization = 0;
        Activation = 1;
        
        
        
    end
    
    methods
        function obj = ThreeDotCell( varargin )
            
            DotPosition = 0.5*[0,1,1; ...
                               0,0,0; ...
                               0,-1,1; ]; %Dot relative position in Characteristic Lengths
            
            
            switch nargin
                case 0
                    Position = [0,0,0];
            
                case 1
                    Position = varargin{1};
                    
                case 2
                    Position = varargin{1};
                    DotPosition = varargin{2};
                    
                otherwise
                    error('Invalid number of inputs for ThreeDotCell().')
            end
            
            obj = obj@QCACell( Position ); 
            obj.DotPosition = DotPosition;
        end
        
        
        function pot = Potential(obj, obsvPoint )
            qe=1;
            epsilon_0 = 8.854E-12; % [C/(V*m)]
            qeC2e = -1.60217662E-19;% J
            
            selfDotPos = getDotPosition(obj);
            numberofDots = size(selfDotPos, 1);
            
            
            charge = qe*obj.Activation*[(1/2)*(1-obj.Polarization);-1;(1/2)*(obj.Polarization+1)]; %[eV]
            
            displacementVector = ones(numberofDots,1)*obsvPoint - selfDotPos;
            distance = sqrt( sum(displacementVector.^2, 2) );
            pot = (1/(4*pi*epsilon_0)*qeC2e)*sum(charge./(distance*1E-9)); 
            
        end

        function V_neighbors = neighborPotential(obj, obj2) %obj2 should have a potential function(ie, a QCACell or QCASuperCell. Each will call potential at spots)
            %returns the potential of a neighborCell
            
            %find out who the neighbors are (decide between giving this func the list of all neighbors or having this func figure that out. for now just 1 neighbor)
            %possible option of asking the QCACircuit obj.
            
            %find the potential at each dot then. self1 + self2 + self3.
            
            objDotPosition = obj.getDotPosition();
            V_neighbors = zeros(size(objDotPosition,1),1);
            
            for x = 1:length(objDotPosition)
                V_neighbors(x,:) = obj2.Potential( objDotPosition(x,:) );
            end

            
            
        end
        
        function delta = cellDetuning(obj, obj2) % get detuning due to 1 neighbor
            driver = obj2;
            driver.Polarization = -1;
            
            E1 = (-1)*obj.neighborPotential(driver);
            
            driver.Polarization = 1;
            
            E0 = (-1)*obj.neighborPotential(driver);
            
            delta = E1-E0;
            
        end
            
        function hamiltonian = GetHamiltonian(obj, neighborList) %add small neighborlist functionality
            
            %step through the neighbor list and accumulate neighbor
            %potentials
            %do V_neighbor through whole neighbor list.
            %to get true delta accululate delta for everything around it.
            
            hamiltonian = eye(size(obj.getDotPosition,1))*cellDetuning(obj);
            
            gammaMatrix = -obj.Gamma*[0,1,0;1,0,1;0,1,0];
            
            hamiltonian = hamiltonian + gammaMatrix;
            
        end
        
        function obj = tempDraw(obj, varargin)
            targetAxes = [];
            a= obj.CharacteristicLength;
            r= obj.CenterPosition;
            x=a*.25*[-1,1,1,-1] + r(1);
            y=a*.625*[1,1,-1,-1] + r(2);
            %r(3) would be in the z direction
            
            patch(x,y,'r');
            
            if length(varargin)==1
                targetAxes = varargin{1};
                axes(targetAxes);
            end
            
            if length(varargin)==1
                hold off;
            end
            
        end
              
    end
    
end

% make a neighbor list.
%QCACiruit: assign neighbors (based on center-center distance)
    %testing just assign neightbors
% QCACell
    %NeighborList [unique cell ID's]
    


