classdef ThreeDotCell < QCACell
    %ThreeDotCell Defines ThreeDotCell subclass of QCACell
    %   Detailed explanation goes here
    
    
    properties (Constant) %Helpful Constants used in ThreeDotCell
        
        %basis States
        one  = [0;0;1];
        null = [0;1;0];
        zero = [1;0;0];
        
        %helpful operators
        Z = [-1 0 0; 0 0 0; 0 0 1];
        Pnn = [0 0 0; 0 1 0; 0 0 0 ];
        

    end
    
    properties
        Polarization = 0;
        Activation = 1;
        Hamiltonian = zeros(3);
 
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
        
        function obj = set.Polarization(obj,value)
            if (~isnumeric(value) || value < -1 || value > 1) %value must be numeric in between -1 and 1
                error('Invalid Polarization. Must be a number inbetween -1 and 1')
            else
                obj.Polarization = value;
                
            end
        end
        
        function pot = Potential(obj, obsvPoint )
            import QCALayoutPack.*
            qe = QCA_Constants.qe;
            epsilon_0 = QCA_Constants.epsilon_0;
            qeC2e = QCA_Constants.qeC2e;
            
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
            
        function hamiltonian = GetHamiltonian(obj, neighborList) 
            
            objDotpotential = zeros(size(obj.DotPosition,1),1);
            
            for x = 1:size(neighborList,2)
                objDotpotential = objDotpotential + obj.neighborPotential(neighborList{x});
            end

            gammaMatrix = -obj.Gamma*[0,1,0;1,0,1;0,1,0];
            
            
            hamiltonian = -diag(objDotpotential) + gammaMatrix;
            
            h = abs(obj.DotPosition(2,3)-obj.DotPosition(1,3)); %Field over entire height of cell
            
            hamiltonian(2,2) =+ -obj.ElectricField(1,3)*h; %add clock E

        
        end
        
        function obj = Calc_Polarization_Activation(obj)
            if( strcmp(obj.Type , 'Driver' ))
                %don't try to relax this cell
            else
                %relax
                %testing getHamiltonian.
                
                [V, EE] = eig(obj.Hamiltonian);
                psi = V(:,1); %ground state
                
                % Polarization is the expectation value of sigma_z
                obj.Polarization = psi' * obj.Z * psi;
                obj.Activation = 1 - psi' * obj.Pnn * psi;
            end
            
        end
        
        function obj = ThreeDotColorDraw(obj, varargin)
            targetAxes = [];
            a= obj.CharacteristicLength;
            r= obj.CenterPosition;
            x=a*.25*[-1,1,1,-1] + r(1);
            y=a*.625*[1,1,-1,-1] + r(2);
            %r(3) would be in the z direction
            
            
            cell_patch = patch(x,y,'r');
            faceColor = getFaceColor(obj);
            cell_patch.FaceColor = faceColor;
            
            c1 = circle(obj.CenterPosition(1), obj.CenterPosition(2), a*.125, [1 1 1]);
            c2 = circle(obj.CenterPosition(1), obj.CenterPosition(2)+a*.4, a*.125, [1 1 1]);
            c3 = circle(obj.CenterPosition(1), obj.CenterPosition(2)-a*.4, a*.125, [1 1 1]);
            
            
            
            if length(varargin)==1
                targetAxes = varargin{1};
                axes(targetAxes);
            end
            
            if length(varargin)==1
                hold off;
            end
            
        end
        
        function color = getFaceColor(obj)
            pol = obj.Polarization;
            if(pol < 0)
                %color = [abs(pol) 0 0];
                color = [1-abs(pol) 1 1-abs(pol)];
            elseif(pol > 0)
                %color = [0 abs(pol) 0];
                color = [1 1-abs(pol) 1-abs(pol)];
            else
                color = [1 1 1];
            end  
        end
        
        
    end
    
end

% make a neighbor list.
%QCACiruit: assign neighbors (based on center-center distance)
    %testing just assign neightbors
% QCACell
    %NeighborList [unique cell ID's]
    


