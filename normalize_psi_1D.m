function varargout = normalize_psi_1D( varargin )
%normalize_psi_1D normalizes a 1-D quantum mechanical wave function psi
%   The wave function psi may be specified as a complex vector, or as a
%   real vector and an imaginary component
%
% SYNTAX
%    psi_normalized = normalize_psi_1D( psi_complex )
%
%    psi_normalized = normalize_psi_1D( psi_re, psi_im )
%
%    [psi_norm_re, psi_norm_im] = normalize_psi_1D( psi_re, psi_im )
%
%    [psi_norm_re, psi_norm_im] = normalize_psi_1D( psi_complex )
%

switch nargin
    case 1
        psi = varargin{1};
    case 2
        psi = varargin{1} + 1i * varargin{2};
end


sum_psi_sq = psi * psi';
psi_norm = (1/sqrt(sum_psi_sq))*psi;

NormCheck = psi_norm * psi_norm';

switch nargout
    case 1
        varargout{1} = psi_norm;
    case 2
        varargout{1} = real(psi_norm);
        varargout{2} = imag(psi_norm);
end

end