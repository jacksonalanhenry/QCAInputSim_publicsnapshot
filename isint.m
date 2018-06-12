function out = isint(num)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    if num-floor(num)>0
        out=0;
    else
        out=1;
    end

end

