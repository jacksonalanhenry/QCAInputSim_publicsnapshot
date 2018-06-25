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
        Wavefunction = zeros(3,1);
        SelectBox;
        LayoutBox;
        
    end
    
    
    methods
        function obj = ThreeDotCell( varargin )
            
            DotPosition = 0.5*[0,1,1; ...
                0,0,0; ...
                0,-1,1; ]; %Dot relative position in Characteristic Lengths
            
            SelectBox=patch('Visible','off');
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
%             disp(['potential of ' num2str(obj.CellID) ' is ' num2str(pot)])
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
            
            
            for x = 1:length(neighborList)
                
%                 disp([num2str(obj.CellID) '---' num2str(neighborList{x}.CellID)])
                objDotpotential = objDotpotential + obj.neighborPotential(neighborList{x});
            end
            
            gammaMatrix = -obj.Gamma*[0,1,0;1,0,1;0,1,0];
            
            obj.CellID;
            hamiltonian = -diag(objDotpotential) + gammaMatrix;
            
            h = abs(obj.DotPosition(2,3)-obj.DotPosition(1,3)); %Field over entire height of cell
            x = abs(obj.DotPosition(3,1)-obj.DotPosition(1,1));
            y = abs(obj.DotPosition(3,2)-obj.DotPosition(1,2));
            lengthh = [x,y,0];
            
            
            inputFieldBias = -obj.ElectricField*lengthh';
            
            
            hamiltonian(2,2) = hamiltonian(2,2) + -obj.ElectricField(1,3)*h; %add clock E
            hamiltonian(1,1) = hamiltonian(1,1) + (-inputFieldBias)/2;%add input field to 0 dot
            hamiltonian(3,3) = hamiltonian(3,3) + inputFieldBias/2;%add input field to 1 dot
            

%             disp(['neighbor list of ' num2str(obj.CellID) ' is:     ' num2str(obj.NeighborList)]) 
%             disp('and the hamiltonian is ')

%             hamiltonian
%             disp('-----------------------------------------------------------------------------')
        end
        
        function obj = Calc_Polarization_Activation(obj, varargin)
            
            if length(varargin) == 1
                
                if( strcmp(obj.Type , 'Driver' ))
                    %don't try to relax this cell
                else
                    normpsi = varargin{1};
                    obj.Polarization = normpsi' * obj.Z * normpsi;
                    obj.Activation = 1 - normpsi' * obj.Pnn * normpsi;
                    
                    obj.Wavefunction = normpsi;
                end
            else
                
            
                if( strcmp(obj.Type , 'Driver' ))
                    %don't try to relax this cell
                else
                    %relax
                    %testing getHamiltonian.
                    
                    [V, EE] = eig(obj.Hamiltonian);
                    psi = V(:,1); %ground state
                    obj.Wavefunction = psi;
                    
                    % Polarization is the expectation value of sigma_z
                    obj.Polarization = psi' * obj.Z * psi;
                    %disp(['P of cell ' num2str(obj.CellID) ' is ' num2str(obj.Polarization)])
                    obj.Activation = 1 - psi' * obj.Pnn * psi;
                    %disp(['A of cell ' num2str(obj.CellID) ' is ' num2str(obj.Activation)])
                end
                
                
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
            
            c1 = circle(obj.CenterPosition(1), obj.CenterPosition(2), a*.125*abs(obj.Polarization), [1 1 1]);
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
        
        
        function obj = LayoutModeDraw(obj,varargin)
            %drawing a patch to replace the three dot model
            obj.LayoutBox=patch;
            obj.LayoutBox.XData=[obj.CenterPosition(1)-.25;obj.CenterPosition(1)+.25;obj.CenterPosition(1)+.25;obj.CenterPosition(1)-.25];
            obj.LayoutBox.YData=[obj.CenterPosition(2)-.75;obj.CenterPosition(2)-.75;obj.CenterPosition(2)+.75;obj.CenterPosition(2)+.75];
            if nargin>1
                if strcmp(obj.Type,'Node')
                obj.LayoutBox.FaceColor = varargin{1};
                obj.LayoutBox.EdgeColor= varargin{1}; 
                else
                obj.LayoutBox.FaceColor = varargin{1};
                obj.LayoutBox.EdgeColor= 'green'; 
                obj.LayoutBox.LineWidth = 2;
                    
                end
            else
                if strcmp(obj.Type,'Node')
                    obj.LayoutBox.FaceColor='red';
                    obj.LayoutBox.EdgeColor='red';
                else
                    obj.LayoutBox.FaceColor='green';
                    obj.LayoutBox.EdgeColor='black';
                    obj.LayoutBox.LineWidth = 2;
                end
            end
            
            obj.LayoutBox.UserData = obj.CellID; %this will allow access for later use
            obj.LayoutCenterPosition = [obj.LayoutBox.XData(1)+.25, obj.LayoutBox.YData(1)+.75, 0];
            
  
        end
        
                
        function obj = BoxDraw(obj)
            obj.SelectBox=patch;
            obj.SelectBox.XData=[obj.CenterPosition(1)-.25;obj.CenterPosition(1)+.25;obj.CenterPosition(1)+.25;obj.CenterPosition(1)-.25];
            obj.SelectBox.YData=[obj.CenterPosition(2)-.75;obj.CenterPosition(2)-.75;obj.CenterPosition(2)+.75;obj.CenterPosition(2)+.75];
            obj.SelectBox.FaceColor=[1 1 1];
            obj.SelectBox.UserData = obj.CellID;            
        end
        
        
        function obj = ThreeDotElectronDraw(obj, varargin)
            targetAxes = [];
            a= obj.CharacteristicLength;
            r= obj.CenterPosition;
            act = obj.Activation;
            pol = obj.Polarization;
            radiusfactor = 0.2;
            

 
            %Tunnel junctions
            x_dist = [obj.CenterPosition(1), obj.CenterPosition(1)];
            y_dist13 = [obj.CenterPosition(2)+a*.5, obj.CenterPosition(2)-a*.4];
            l13 = line(x_dist, y_dist13, 'LineWidth', 2, 'Color', [0 0 0]);
            
            text(obj.CenterPosition(1), obj.CenterPosition(2)-a, num2str(obj.CellID), 'HorizontalAlignment', 'center')
            
            %extra circle
%             c123 = circle(obj.CenterPosition(1), obj.CenterPosition(2), 2.25, [1 1 1],'Points',25);
            
%             if obj.CellID == 6
%             th = 0:pi/50:2*pi;
%             xunit = 2.25 * cos(th) + obj.CenterPosition(1);
%             yunit = 2.25 * sin(th) + obj.CenterPosition(2);
%             h = plot(xunit, yunit);
%             end
            
            
            
            %Electron Sites
            c1 = circle(obj.CenterPosition(1), obj.CenterPosition(2), a*radiusfactor, [1 1 1],'Points',25);
            c2 = circle(obj.CenterPosition(1), obj.CenterPosition(2)+a*.5, a*radiusfactor, [1 1 1],'Points',25);
            c3 = circle(obj.CenterPosition(1), obj.CenterPosition(2)-a*.5, a*radiusfactor, [1 1 1],'Points',25);
            
            
            %electron color for driver/node
            if strcmp(obj.Type,'Node')
                electronColor = [1 0 0];
            elseif strcmp(obj.Type,'Driver')
                electronColor = [0 1 0];
            end
            
            %Electrons Position Probability
            q0 = (act/2)*(1-pol);   
            qN = 1 - act;
            q1 = (act/2)*(1+pol);
            
            scalefactor = 0.90;
            e0 = circle(obj.CenterPosition(1), obj.CenterPosition(2)+a*.5, q0*a*radiusfactor*scalefactor, electronColor,'EdgeColor', [1,1,1],'Points',25);
            eN = circle(obj.CenterPosition(1), obj.CenterPosition(2),      qN*a*radiusfactor*scalefactor, electronColor,'EdgeColor', [1,1,1],'Points',25);
            e1 = circle(obj.CenterPosition(1), obj.CenterPosition(2)-a*.5, q1*a*radiusfactor*scalefactor, electronColor,'EdgeColor', [1,1,1],'Points',25);
            
            
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



