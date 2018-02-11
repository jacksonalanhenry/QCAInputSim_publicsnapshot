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
        
        
        function Potential_on_dot1 = getPotential( self, neighbor )
            %get the polarization due to driver. 
            
           
            epsilon_0 = 8.854E-12; % [C/(V*m)]
            qe = 1; % [eV]
            
            neighborDotPos = getDotPosition(neighbor);
            selfDotPos = getDotPosition(self);
            
            r = selfDotPos - neighborDotPos;
            
            neighbor_q1 = (qe/2)*(neighbor.Polarization+1)*neighbor.Activation;
            neighbor_q2 = 1 - neighbor.Activation;
            neighbor_q3 = (qe/2)*(1-neighbor.Polarization)*neighbor.Activation;
            
            Potential_on_dot1 = (1/4*pi*epsilon_0)*( neighbor_q1*r(1,:) + neighbor_q1*r(2,:) + neighbor_q1*r(3,:) );
            Potential_on_dot2 = (1/4*pi*epsilon_0)*( neighbor_q2*r(1,:) + neighbor_q2*r(2,:) + neighbor_q2*r(3,:) );
            Potential_on_dot3 = (1/4*pi*epsilon_0)*( neighbor_q3*r(1,:) + neighbor_q3*r(2,:) + neighbor_q3*r(3,:) );

            
            
        end
        
    end
    
end

