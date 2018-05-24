function h = circle(varargin)
%
% H = CIRCLE(x0, y0, R, C) creates a circular patch at position (x0,y0),
% with radius R, and color C.  Returns handle to circle.
%
%
% H = CIRCLE(x0, y0, R, C, prop1, val1, ...)
%
% PROPERTIES
%
%    'Points' is used to specify the number of points specifying a polygon
%             which approximates a circle. Specify this as an integer. The
%             default value is 15.
%
%    'EdgeColor' is used to specify the color of the line defining the
%                circle. Specify this as a RGB triple [R G B], with each
%                element in the color value on the interval [0, 1].
%
%    'FillColor' is used to specify the color of the interior of the
%                circle. Specify this as a RGB triple [R G B], with each
%                element in the color value on the interval [0, 1].
%
%    'LineWidth' is used to specify the width of the line defining the
%                circle. Specify this as a one-by-one number.
%
%    'LineStyle' is used to specify the style of the line defining the
%                circle. Specify this as a character string. Some options:
%
%                '-'     Solid line
%
%                '--'    Dashed line
%
%                ':'     Dotted line
%
nth=15;

x0 = varargin{1};
y0 = varargin{2};
R = varargin{3};
C = varargin{4};

EdgeColor = [0 0 0];
LineWidth = 2;
LineStyle = '-';


args = varargin(5:end);
while length(args) >= 2
    prop = args{1};
    val = args{2};
    args = args(3:end);
    switch prop
        case 'Points'
            if ischar(val)
                nth = str2num(val);
            else
                nth = val;
            end
            
        case 'FillColor'
            FillColor = val;
            
        case 'EdgeColor'
            EdgeColor = val;
            
        case 'LineWidth'
            LineWidth = val;
            
        case 'LineStyle'
            LineStyle = val;
            
        otherwise
            error(['CIRCLE.M: ', prop, ' is an invalid property specifier.']);
    end
end

thetas=[0:nth]*2*pi/nth;
dx=R*cos(thetas);
dy=R*sin(thetas);
x=x0+dx;
y=y0+dy;
h=patch(x,y,C, 'EdgeColor', EdgeColor, 'LineWidth', LineWidth, ...
    'LineStyle', LineStyle);

%end function circle
