function f = PeriodicFermi( x, xperiod, sharpness )
%PeriodicFermi constructs a periodic function using Fermi Transitions. 
%   Detailed explanation goes here

% t1 = xperiod/4;
% t2 = 3*xperiod/4;
% 
% xl = mod(x-t1, xperiod);
% 
% f = FermiTransition(xl, t1, sharpness) - FermiTransition(xl, t2, sharpness);

import QCALayoutPack.test.*

t1 = xperiod/4;
t2 = 3*xperiod/4;
% xl = mod(x-t1, xperiod);

f = FermiTransition(x, t1, sharpness) - FermiTransition(x, t2, sharpness); 



end

