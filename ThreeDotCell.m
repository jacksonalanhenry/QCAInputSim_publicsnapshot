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
        
        
        function pot = getPotential( obj, neighbor )
            %get the polarization due to driver. 
            
           
            epsilon_0 = 8.854E-12; % [C/(V*m)]
            
            qeV2J = 1.60217662E-19;% J
            
            qe = 1; % [eV]

            
            neighborDotPos = getDotPosition(neighbor);
            selfDotPos = getDotPosition(obj);
            
            
            neighbor_q1 = (qe/2)*(1-neighbor.Polarization)*neighbor.Activation;
            neighbor_q2 = 1 - neighbor.Activation;
            neighbor_q3 = (qe/2)*(neighbor.Polarization+1)*neighbor.Activation;
            
            %SELFDOT1
            %r from selfdot1 to neighbor dot1
            r11 = norm(selfDotPos(1,:)-neighborDotPos(1,:),3);
            %r from selfdot1 to neighbor dot2
            r12 = norm(selfDotPos(1,:)-neighborDotPos(2,:),3);
            %r from selfdot1 to neighbor dot3
            r13 = norm(selfDotPos(1,:)-neighborDotPos(3,:),3);
            
            %SELFDOT2
            r21 = norm(selfDotPos(2,:)-neighborDotPos(1,:),3);
            %r from selfdot1 to neighbor dot2
            r22 = norm(selfDotPos(2,:)-neighborDotPos(2,:),3);
            %r from selfdot1 to neighbor dot3
            r23 = norm(selfDotPos(2,:)-neighborDotPos(3,:),3);
            
            %SELFDOT3
            %r from selfdot1 to neighbor dot1
            r31 = norm(selfDotPos(3,:)-neighborDotPos(1,:),3);
            %r from selfdot1 to neighbor dot2
            r32= norm(selfDotPos(3,:)-neighborDotPos(2,:),3);
            %r from selfdot1 to neighbor dot3
            r33 = norm(selfDotPos(3,:)-neighborDotPos(3,:),3);
            
            Potential_on_dot1 = (1/(4*pi*epsilon_0*qeV2J))*( neighbor_q1/r11 + neighbor_q1/r12 + neighbor_q1/r13 );
            Potential_on_dot2 = (1/(4*pi*epsilon_0*qeV2J))*( neighbor_q2/r21 + neighbor_q2/r22 + neighbor_q2/r23 );
            Potential_on_dot3 = (1/(4*pi*epsilon_0*qeV2J))*( neighbor_q3/r31 + neighbor_q3/r32 + neighbor_q3/r33 );

            pot = [Potential_on_dot1; Potential_on_dot2; Potential_on_dot3;];
            
        end
        
        function pot = Potential(obj, obsvPoint )
            %returns the potential at a given observation point.
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
        
        function delta = cellDetuning(obj)
            driver = ThreeDotCell();
            driver.Polarization = -1;
            
            E1 = (-1)*obj.neighborPotential(driver);
            
            driver.Polarization = 1;
            
            E0 = (-1)*obj.neighborPotential(driver);
            
            delta = E1-E0;
            
        end
        
        function hamiltonian = getHamiltonian(obj)
            
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

