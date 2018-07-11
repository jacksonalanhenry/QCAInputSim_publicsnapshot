function f = PeriodicFermi( x, period, sharpness )
%PeriodicFermi constructs a periodic function using Fermi Transitions. 
%   Detailed explanation goes here

t1 = period/4;
t2 = 3*period/4;
f = FermiTransition(x, t1, sharpness) - FermiTransition(x, t2, sharpness);


end

