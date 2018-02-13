classdef ThreeDotCell < QCACell
    %ThreeDotCell Defines ThreeDotCell subclass of QCACell
    %   Detailed explanation goes here
    
    properties
        Polarization = 0;
        Activation = 1;
        
        
        
    end
    
    methods
        function obj = ThreeDotCell( varargin )
            
            DotPosition = 0.5*[1,0,1; ...
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
        
        
        function pot = getPotential( self, neighbor )
            %get the polarization due to driver. 
            
           
            epsilon_0 = 8.854E-12; % [C/(V*m)]
            qe = 1; % [eV]

            
            neighborDotPos = getDotPosition(neighbor);
            selfDotPos = getDotPosition(self);
            
            %r is now a 3x3 matrix holding q1->q1;q2->q2;q3->q3 which is
            %not exactly correct.
            r = selfDotPos - neighborDotPos;
            
            neighbor_q1 = (qe/2)*(neighbor.Polarization+1)*neighbor.Activation;
            neighbor_q2 = 1 - neighbor.Activation;
            neighbor_q3 = (qe/2)*(1-neighbor.Polarization)*neighbor.Activation;
            
            %SELFDOT1
            %r from selfdot1 to neighbor dot1
            r11=sqrt(sum((selfDotPos(1,:)-neighborDotPos(1,:)).^2));
            %r from selfdot1 to neighbor dot2
            r12=sqrt(sum((selfDotPos(1,:)-neighborDotPos(2,:)).^2));
            %r from selfdot1 to neighbor dot3
            r13=sqrt(sum((selfDotPos(1,:)-neighborDotPos(3,:)).^2));
            
            %SELFDOT2
            r21=sqrt(sum((selfDotPos(2,:)-neighborDotPos(1,:)).^2));
            %r from selfdot1 to neighbor dot2
            r22=sqrt(sum((selfDotPos(2,:)-neighborDotPos(2,:)).^2));
            %r from selfdot1 to neighbor dot3
            r23=sqrt(sum((selfDotPos(2,:)-neighborDotPos(3,:)).^2));
            
            %SELFDOT3
            %r from selfdot1 to neighbor dot1
            r31=sqrt(sum((selfDotPos(3,:)-neighborDotPos(1,:)).^2));
            %r from selfdot1 to neighbor dot2
            r32=sqrt(sum((selfDotPos(3,:)-neighborDotPos(2,:)).^2));
            %r from selfdot1 to neighbor dot3
            r33=sqrt(sum((selfDotPos(3,:)-neighborDotPos(3,:)).^2));
            
            Potential_on_dot1 = (1/4*pi*epsilon_0)*( neighbor_q1*r11 + neighbor_q1*r12 + neighbor_q1*r13 );
            Potential_on_dot2 = (1/4*pi*epsilon_0)*( neighbor_q2*r21 + neighbor_q2*r22 + neighbor_q2*r23 );
            Potential_on_dot3 = (1/4*pi*epsilon_0)*( neighbor_q3*r31 + neighbor_q3*r32 + neighbor_q3*r33 );

            pot = [Potential_on_dot1; Potential_on_dot2; Potential_on_dot3;];
            
        end
        
    end
    
end

