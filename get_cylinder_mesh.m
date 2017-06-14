function [rr, vertices, faces] = get_cylinder_mesh(centerline, nz, radii )
% modified CYLINDERMESH function from geom3d
% Create a 3D mesh representing a cylinder curved along centerline
%
%   [V F] = cylinderMesh(CYL)
%   Computes vertex coordinates and face vertex indices of a mesh

global n_circ;
% compute length and orientation
coords = centerline.coords;
tangents = centerline.tangents;
% parametrisation on x
nx = n_circ+1;
t = linspace(0, 2*pi, nx);
x = zeros(nz,nx);
y = zeros(nz,nx);
z = zeros(nz,nx);
% radii per stent vertex
rr = zeros((nx-1)*nz,1);

for i=1:nz 
    lx = radii(i) * cos(t);
    sintheta = sin(t); sintheta(end) = 0;
    ly = radii(i) * sintheta;
    rr(1+(i-1)*(nx-1):(nx-1)*i,:) = radii(i) * ones(nx-1,1);
    % rotation of circle
    [theta, phi, ~] = cart2sph2d(tangents(i,:));
    lz = zeros(size(lx));%ones(size(lx))*seglen(i);
    trans   = localToGlobal3d(coords(i,:), theta, phi, 0);
    [x(i,:), y(i,:), z(i,:)] = transformPoint3d(lx', ly', lz', trans);
end

% convert to FV mesh
[vertices, faces] = surfToMesh1(x, y, z, 'xPeriodic', true);

