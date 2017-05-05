function [distances, radii] = calc_artery_radii(vertices, centers, tangents)

% normal
normals = -1./tangents;
normals = normc(normals')';

% get d=-ax-by-cz of hessian normal form
d = -normals(:,1).*centers(:,1)-normals(:,2).*centers(:,2)-normals(:,3).*centers(:,3);

distances = abs(normals*vertices'+d);
radii=zeros(size(centers,1),1);

for i=1:size(centers,1)
    plane = (vertices(distances(i,:)<0.001,:));
    radii(i) = mean(norm(plane - centers(i,:)));
end

