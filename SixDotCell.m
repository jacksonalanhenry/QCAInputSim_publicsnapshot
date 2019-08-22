classdef SixDotCell < QCACell
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
        
        radiusOfEffect = 3.1;

        
    end
    
    
    methods
        function obj = SixDotCell( varargin )
            
            DotPosition = 0.5*[ 1, 1,1; ...
                                1, 0,0; ...
                                1,-1,1; ... 
                               -1,-1,1; ...
                               -1, 0,0; ...
                               -1, 1,1]; %Dot relative position in Characteristic Lengths
            
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
            if ( (isnumeric(value) && value >= -1 && value <= 1) || isa(value, 'Signal')) %value must be numeric in between -1 and 1
%                 error('Invalid Polarization. Must be a number inbetween -1 and 1')
                
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
            
            mobileCharge = -1*[qe*obj.Activation*(1/2)*(obj.getPolarization(time)+1);1-obj.Activation;qe*obj.Activation*(1/2)*(1-obj.getPolarization(time));qe*obj.Activation*(1/2)*(obj.getPolarization(time)+1);1-obj.Activation;qe*obj.Activation*(1/2)*(1-obj.getPolarization(time))];

        end
        
        function pot_energy = Potential(obj, obsvPoint, time )
            import QCALayoutPack.*
            qe = QCA_Constants.qe;
            epsilon_0 = QCA_Constants.epsilon_0;
            qeC2e = QCA_Constants.qeC2e;
            
            selfDotPos = obj.getDotPosition();
            numberofDots = size(selfDotPos, 1);
            
            
            %charge = qe*obj.Activation*[(1/2)*(obj.Polarization+1);-1;(1/2)*(1-obj.Polarization);(1/2)*(obj.Polarization+1);-1;(1/2)*(1-obj.Polarization)]; %[eV]
            %charge = qe*obj.Activation*[(1/2)*(obj.Polarization+1);
                                         %-1;
                                         %(1/2)*(1-obj.Polarization);
                                         %(1/2)*(obj.Polarization+1);
                                         %-1;
                                         %(1/2)*(1-obj.Polarization)]; %[eV]

            charge = [qe*obj.Activation*(1/2)*(obj.getPolarization(time)+1);1-obj.Activation;qe*obj.Activation*(1/2)*(1-obj.getPolarization(time));qe*obj.Activation*(1/2)*(obj.getPolarization(time)+1);1-obj.Activation;qe*obj.Activation*(1/2)*(1-obj.getPolarization(time))];

            
            displacementVector = ones(numberofDots,1)*obsvPoint - selfDotPos;
            distance = sqrt( sum(displacementVector.^2, 2) );
            
%             if distance < (obj.radiusOfEffect+10)
                pot_energy = (1/(4*pi*epsilon_0)*qeC2e)*sum(charge./(distance*1E-9));
%             else
%                 pot_energy = 0
%             end
            
            %disp(['potential of ' num2str(obj.CellID) ' is ' num2str(pot)])
        end
        
        

        
        function V_neighbors = neighborPotential(obj, obj2, time) %obj2 should have a potential function(ie, a QCACell or QCASuperCell. Each will call potential at spots)
            %returns the potential of a neighborCell
            
            %find out who the neighbors are (decide between giving this func the list of all neighbors or having this func figure that out. for now just 1 neighbor)
            %possible option of asking the QCACircuit obj.
            
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
                objDotpotential = objDotpotential + obj.neighborPotential(neighborList{x},time);
            end
            
            gammaMatrix = -obj.Gamma*[0,1,0;1,0,1;0,1,0];
            
            
            hamiltonian = -1*[objDotpotential(3)+objDotpotential(6),0,0;...
                           0,objDotpotential(2)+objDotpotential(5),0;...
                           0,0,objDotpotential(1)+objDotpotential(4)]...
                           +gammaMatrix;
            
            
            h = abs(obj.DotPosition(2,3)-obj.DotPosition(1,3)); %Field over entire height of cell
            x = abs(obj.DotPosition(6,1)-obj.DotPosition(1,1));
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
                    disp(['P of cell ' num2str(obj.CellID) ' is ' num2str(obj.Polarization)])
                    obj.Activation = 1 - psi' * obj.Pnn * psi;
                    disp(['A of cell ' num2str(obj.CellID) ' is ' num2str(obj.Activation)])
                end
                
                
            end
        end
        
        function obj = ColorDraw(obj, time, varargin)
            targetAxes = [];
            a= obj.CharacteristicLength;
            
            r= obj.CenterPosition;
            x=a*.75*[-1,1,1,-1] + r(1);
            y=a*.75*[1,1,-1,-1] + r(2);
            %r(3) would be in the z direction
            
            
            cell_patch = patch(x,y,'r');
            faceColor = getFaceColor(obj, time);
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
        
        function color = getFaceColor(obj, time)
            pol = obj.getPolarization(time);
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
        
        function obj = BoxDraw(obj)
            obj.SelectBox=patch;
            obj.SelectBox.XData=[obj.CenterPosition(1)-.75;obj.CenterPosition(1)+.75;obj.CenterPosition(1)+.75;obj.CenterPosition(1)-.75];
            obj.SelectBox.YData=[obj.CenterPosition(2)-.75;obj.CenterPosition(2)-.75;obj.CenterPosition(2)+.75;obj.CenterPosition(2)+.75];
            
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
                centerpos = obj.CenterPosition;
                reldotpos = obj.DotPosition;
                dotpos = obj.getDotPosition();
                act = obj.Activation;
                pol = obj.getPolarization(time);
                radiusfactor = 0.2;
                
                if length(varargin)==1
                    targetAxes = varargin{1};
                    %axes(targetAxes);
                    hold off;
                    
                end
                
                %Tunnel junctions
                x_dist13 = [dotpos(1,1), dotpos(3,1)];
                y_dist13 = [dotpos(1,2), dotpos(3,2)];
                l13 = line(x_dist13, y_dist13, 'LineWidth', 2, 'Color', [0 0 0]);
                
                x_dist64 = [dotpos(6,1), dotpos(4,1)];
                y_dist64 = [dotpos(6,2), dotpos(4,2)];
                l64 = line(x_dist64, y_dist64, 'LineWidth', 2, 'Color', [0 0 0]);
                
                text(obj.CenterPosition(1), obj.CenterPosition(2)+.8*a, num2str(obj.CellID), 'HorizontalAlignment', 'center',...
                    'FontSize',12);
                
                       
                
                %Electron Sites
                c1 = circle(dotpos(1,1), dotpos(1,2), a*radiusfactor, [1 1 1],'Points',25, 'TargetAxes', targetAxes);
                c2 = circle(dotpos(2,1), dotpos(2,2), a*radiusfactor, [1 1 1],'Points',25, 'TargetAxes', targetAxes);
                c3 = circle(dotpos(3,1), dotpos(3,2), a*radiusfactor, [1 1 1],'Points',25, 'TargetAxes', targetAxes);
                c4 = circle(dotpos(4,1), dotpos(4,2), a*radiusfactor, [1 1 1],'Points',25, 'TargetAxes', targetAxes);
                c5 = circle(dotpos(5,1), dotpos(5,2), a*radiusfactor, [1 1 1],'Points',25, 'TargetAxes', targetAxes);
                c6 = circle(dotpos(6,1), dotpos(6,2), a*radiusfactor, [1 1 1],'Points',25, 'TargetAxes', targetAxes);
                
                %extra circle
%                 c123 = circle(obj.CenterPosition(1), obj.CenterPosition(2), obj.radiusOfEffect, [1 1 1], 'EdgeColor', [0 0 0], 'Points',25);
%                 c123.FaceColor = 'None';
                
                %electron color for driver/node
                if strcmp(obj.Type,'Node')
                    electronColor = [1 0 0];
                elseif strcmp(obj.Type,'Driver')
                    electronColor = [0 1 0];
                end
                
                %Electrons Position Probability
                q1 = (act/2)*(1+pol);
                q2 = 1 - act;
                q3 = (act/2)*(1-pol);
                q4 = q1;
                q5 = q2;
                q6 = q3;
                
                
                scalefactor = 0.90;
                e1 = circle(dotpos(1,1), dotpos(1,2), q1*a*radiusfactor*scalefactor, electronColor,'EdgeColor', 'None','Points',25, 'TargetAxes', targetAxes);
                e2 = circle(dotpos(2,1), dotpos(2,2), q2*a*radiusfactor*scalefactor, electronColor,'EdgeColor', 'None','Points',25, 'TargetAxes', targetAxes); 
                e3 = circle(dotpos(3,1), dotpos(3,2), q3*a*radiusfactor*scalefactor, electronColor,'EdgeColor', 'None','Points',25, 'TargetAxes', targetAxes);
                e4 = circle(dotpos(4,1), dotpos(4,2), q4*a*radiusfactor*scalefactor, electronColor,'EdgeColor', 'None','Points',25, 'TargetAxes', targetAxes);
                e5 = circle(dotpos(5,1), dotpos(5,2), q5*a*radiusfactor*scalefactor, electronColor,'EdgeColor', 'None','Points',25, 'TargetAxes', targetAxes);
                e6 = circle(dotpos(6,1), dotpos(6,2), q6*a*radiusfactor*scalefactor, electronColor,'EdgeColor', 'None','Points',25, 'TargetAxes', targetAxes);
                

            
                obj = obj.BoxDraw();
            
        end
    end
end



