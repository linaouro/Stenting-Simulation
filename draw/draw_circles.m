function draw_circles

t = linspace(0,2*pi);
x = cos(t);
y = sin(t);
z = 0*t;
pnts = [x;y;z];

n0 = [0;0;1]; 
n0 = n0/norm(n0); 

n1 = tangents(5,:);
% theta is the angle between normals
c = dot(n0,n1) / ( norm(n0)*norm(n1) ); % cos(theta)
s = sqrt(1-c*c);                        % sin(theta)
u = cross(n0,n1) / ( norm(n0)*norm(n1) ); % rotation axis...
u = u/norm(u); % ... as unit vector
C = 1-c;
% the rotation matrix
R = [u(1)^2*C+c, u(1)*u(2)*C-u(3)*s, u(1)*u(3)*C+u(2)*s
    u(2)*u(1)*C+u(3)*s, u(2)^2*C+c, u(2)*u(3)*C-u(1)*s
    u(3)*u(1)*C-u(2)*s, u(3)*u(2)*C+u(1)*s, u(3)^2*C+c];
% Rotated points
newPnts = R*pnts;

plot3(newPnts(1,:),newPnts(2,:),newPnts(3,:),'k')