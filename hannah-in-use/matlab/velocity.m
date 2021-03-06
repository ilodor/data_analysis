function v = velocity(file1);

%computes velocity. input a [#ofpoints, 3] vector, where first column is time, second is x, third is y
% you can import your csv file as such:
% x = load('pos.csv');
% v = velocity(x);
%
% returns velocities in cm/s and time stamp vector
% doesn't smooth or transform-- do that later when you assign velocities

file = file1';

t = file(1, :);
xpos = file(2, :);
ypos = file(3, :);

velvector = [];
timevector = [];

s = size(t,2);

for i = 2:s-1
	%find distance travelled
	if t(i)~=t(i-1)
		hypo = hypot((xpos(i-1)-xpos(i+1)), (ypos(i-1)-ypos(i+1)));
		vel = hypo./((t(i+1)-t(i-1)));
		velvector(end+1) = vel;
		timevector(end+1) = t(i);
	end
end





v = smooth(velvector);
v = [v'/3.5; timevector];