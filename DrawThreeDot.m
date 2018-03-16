function d = DrawThreeDot(CenterPosition)

c1 = circle(CenterPosition(1), CenterPosition(2), 0.5, [1 0 1]);
c2 = circle(CenterPosition(1), CenterPosition(2)+2, 0.5, [1 0 1]);
c3 = circle(CenterPosition(1), CenterPosition(2)+4, 0.5, [1 0 1]);

hold on;

p1 = plot([CenterPosition(1),CenterPosition(1)], [CenterPosition(2)+0.5, CenterPosition(2)+1.5] ,'b');
p2 = plot([CenterPosition(1),CenterPosition(1)],[CenterPosition(2)+2.5, CenterPosition(2)+3.5],'b');

r1 = rectangle('Position',[CenterPosition(1)-1, CenterPosition(2)-1, 2, 6]);

hold off;

%axis([0 4 0 10])

set(gca , 'FontName', 'Times', 'FontSize', 20); % format the current axes
grid on;

xlim ([0 4]); % adjust the x- limits of the axis
ylim ([0 10]); % adjust the y- limits of the axis

% xlabel ('$x$(m)', 'Interpreter', 'latex') % add an x- label
% ylabel ('$y$(m)', 'Interpreter', 'latex') % add a y- label

title('Three-Dot Cell')

axis equal
end

