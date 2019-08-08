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
        Overlapping='off';
        
        radiusOfEffect = 2.5
        
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
            if ( (isnumeric(value) && value >= -1 && value <= 1) || isa(value, 'Signal')) %value must be numeric in between -1 and 1 or a signal class             
                
                obj.Polarization = value;

            else
                error('Invalid Polarization. Must be a number inbetween -1 and 1')
                
            end
        end
        
        function pol = getPolarization(obj, time)
            if isnumeric(obj.Polarization)
                pol = obj.Polarization;
                %disp([num2str(obj.CellID), ': ', num2str(obj.Polarization)])
            else
                temppol = obj.Polarization.getClockField([0,0,0], time);
                pol = temppol(2);
                %disp([ num2str(obj.CellID), ' has a signal obj'])
                
                
            end
        end
        
        
        function mobileCharge = getMobileCharge(obj, time)
            import QCALayoutPack.*
            qe = QCA_Constants.qe;
            
            mobileCharge = [qe*obj.Activation*(1/2)*(1-obj.getPolarization(time));1-obj.Activation;qe*obj.Activation*(1/2)*(obj.getPolarization(time)+1)];

        end
        
        function pot = Potential(obj, obsvPoint, time )
            import QCALayoutPack.*
            qe = QCA_Constants.qe;
            epsilon_0 = QCA_Constants.epsilon_0;
            qeC2e = QCA_Constants.qeC2e;
            
            selfDotPos = getDotPosition(obj);
            numberofDots = size(selfDotPos, 1);
            
            %charge = qe*obj.Activation*[(1/2)*(1-obj.getPolarization(time));-1;(1/2)*(obj.getPolarization(time)+1)]; %[eV];
            
            charge = [qe*obj.Activation*(1/2)*(1-obj.getPolarization(time));1-obj.Activation;qe*obj.Activation*(1/2)*(obj.getPolarization(time)+1)];
            
            displacementVector = ones(numberofDots,1)*obsvPoint - selfDotPos;
            distance = sqrt( sum(displacementVector.^2, 2) );
            
            if distance < obj.radiusOfEffect
                pot = (1/(4*pi*epsilon_0)*qeC2e)*sum(charge./(distance*1E-9));
            else
                pot = 0;
            end
            
            %disp(['potential of ' num2str(obj.CellID) ' is ' num2str(pot)])
        end
        
        function V_neighbors = neighborPotential(obj, obj2, time) %obj2 should have a potential function(ie, a QCACell or QCASuperCell. Each will call potential at spots)
            %returns the potential of a neighborCell
            
            %find out who the neighbors are. (Neighbor List)
            
            %find the potential at each dot then. self1 + self2 + self3.
            
            objDotPosition = obj.getDotPosition();
            V_neighbors = zeros(size(objDotPosition,1),1);
            
            for x = 1:length(objDotPosition)
                V_neighbors(x,:) = obj2.Potential( objDotPosition(x,:), time );
            end
            
            
            
        end
        
        function hamiltonian = GetHamiltonian(obj, neighborList, time)
            
            objDotpotential = zeros(size(obj.DotPosition,1),1);
            
            
            for x = 1:length(neighborList)
                
%                 disp([num2str(obj.CellID) '---' num2str(neighborList{x}.CellID)])
                objDotpotential = objDotpotential + obj.neighborPotential(neighborList{x}, time);
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
        
        function obj = ColorDraw(obj, varargin)
            targetAxes = [];
            a= obj.CharacteristicLength;
            
            r= obj.CenterPosition;
            x=a*.25*[-1,1,1,-1] + r(1);
            y=a*.75*[1,1,-1,-1] + r(2);
            %r(3) would be in the z direction
            
            
            cell_patch = patch(x,y,'r');
            faceColor = getFaceColor(obj);
            cell_patch.FaceColor = faceColor;
            
%             c1 = circle(obj.CenterPosition(1), obj.CenterPosition(2), a*.125*abs(obj.Polarization), [1 1 1]);
%             c2 = circle(obj.CenterPosition(1), obj.CenterPosition(2)+a*.4, a*.125, [1 1 1]);
%             c3 = circle(obj.CenterPosition(1), obj.CenterPosition(2)-a*.4, a*.125, [1 1 1]);
            

            
            
            if length(varargin)==1
                targetAxes = varargin{1};
                %axes(targetAxes);
                hold off;
            end
            
           
            
        end
        
        function color = getFaceColor(obj)
            pol = obj.Polarization;
            if(pol > 0)
                %color = [abs(pol) 0 0];
                color = [1-abs(pol) 1 1-abs(pol)];
            elseif(pol < 0)
                %color = [0 abs(pol) 0];
                color = [1 1-abs(pol) 1-abs(pol)];
            else
                color = [1 1 1];
            end
        end
        
        function obj = BoxDraw(obj)
            obj.SelectBox=patch;
            obj.SelectBox.XData=[obj.CenterPosition(1)-.25;obj.CenterPosition(1)+.25;obj.CenterPosition(1)+.25;obj.CenterPosition(1)-.25];
            obj.SelectBox.YData=[obj.CenterPosition(2)-.75;obj.CenterPosition(2)-.75;obj.CenterPosition(2)+.75;obj.CenterPosition(2)+.75];
            obj.SelectBox.EdgeColor = 'None';
            
            obj.CellID;
            obj.Overlapping;
            switch obj.Overlapping
                case 'off'
                    obj.SelectBox.FaceColor=[1 1 1];
                    obj.SelectBox.FaceAlpha = .01;
                case 'on'
                    obj.SelectBox.FaceColor=[1 0 0];
                    obj.SelectBox.FaceAlpha = .4;
                    
            end
            
            obj.SelectBox.UserData = obj.CellID;            
        end
        
        
        function obj = ElectronDraw(obj, time, varargin)
            
                targetAxes = [];
                a= obj.CharacteristicLength;
                r= obj.CenterPosition;
                act = obj.Activation;
                pol = obj.getPolarization(time);
                radiusfactor = 0.2;
                
                
                if length(varargin)==1
                    targetAxes = varargin{1};
                    hold off;
                    
                end
                
                
                %Tunnel junctions
                x_dist = [obj.CenterPosition(1), obj.CenterPosition(1)];
                y_dist13 = [obj.CenterPosition(2)+a*.5, obj.CenterPosition(2)-a*.4];
                l13 = line(x_dist, y_dist13, 'LineWidth', 2, 'Color', [0 0 0]);
                
                %Print CellID
                text(obj.CenterPosition(1), obj.CenterPosition(2)+.8*a, num2str(obj.CellID), 'HorizontalAlignment', 'center','FontSize',12);
                
                %extra circle
                %c123 = circle(obj.CenterPosition(1), obj.CenterPosition(2), obj.radiusOfEffect, [1 1 1], 'EdgeColor', [0 0 0], 'Points',25);
                %c123.FaceColor = 'None';
                
                
                
                %Electron Sites
                c1 = circle(obj.CenterPosition(1), obj.CenterPosition(2), a*radiusfactor, [1 1 1],'Points',25, 'TargetAxes', targetAxes);
                c2 = circle(obj.CenterPosition(1), obj.CenterPosition(2)+a*.5, a*radiusfactor, [1 1 1],'Points',25, 'TargetAxes', targetAxes);
                c3 = circle(obj.CenterPosition(1), obj.CenterPosition(2)-a*.5, a*radiusfactor, [1 1 1],'Points',25, 'TargetAxes', targetAxes);
                
                
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
                e0 = circle(obj.CenterPosition(1), obj.CenterPosition(2)+a*.5, q0*a*radiusfactor*scalefactor, electronColor,'EdgeColor', 'None','Points',25, 'TargetAxes', targetAxes);
                eN = circle(obj.CenterPosition(1), obj.CenterPosition(2),      qN*a*radiusfactor*scalefactor, electronColor,'EdgeColor', 'None','Points',25, 'TargetAxes', targetAxes);
                e1 = circle(obj.CenterPosition(1), obj.CenterPosition(2)-a*.5, q1*a*radiusfactor*scalefactor, electronColor,'EdgeColor', 'None','Points',25, 'TargetAxes', targetAxes);
                
                
                
                
            
            
            
        end
    end
end

% make a neighbor list.
%QCACiruit: assign neighbors (based on center-center distance)
%testing just assign neightbors
% QCACell
%NeighborList [unique cell ID's]



