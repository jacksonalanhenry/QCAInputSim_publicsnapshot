function f = FermiTransition( x, XF, Xtemp )
%FermiTransition Returns a fermi transition given a tranision point (XF)
%and a sharpness factor (XTemp)
%   Detailed explanation goes here

    f = 1 ./ (1 + exp( (x-XF)/Xtemp ));


end

