stentY.faces = [stentFinal(3).faces; stentFinal(2).faces+size(stentFinal(3).vertices,1); stentFinal(1).faces+size(stentFinal(3).vertices,1)+size(stentFinal(2).vertices,1)];

% TODO CHECK right now we only use the idc=x of one of the branches, not
% the two closest..
[dists,~] = pdist2(stentFinal(1).vertices(1:n_circ,:), stentFinal(2).vertices(1:n_circ,:), 'euclidean','Smallest',1);
[dists_min,idx_min] = min(dists); 

idx_min_21 = mod(idx_min-12:1:idx_min+12,n_circ);
idx_min_21(idx_min_21==0) = n_circ;
idx_min_21 = idx_min_21 + size(stentFinal(3).vertices,1);

idx_min_12 = mod(idx_min_21+25,n_circ);
idx_min_12(idx_min_12==0) = n_circ;
idx_min_12 = idx_min_12 + size(stentFinal(3).vertices,1)+ size(stentFinal(2).vertices,1);

[dists,idx_min1] = min(pdist2(stentFinal(1).vertices(idx_min+25,:), stentFinal(3).vertices(1:n_circ,:), 'euclidean','Smallest',1));
idx_min_31 = mod(idx_min1-12:1:idx_min1+12,n_circ);
idx_min_31(idx_min_31==0) = n_circ;
idx_min_13 = mod(idx_min+12:1:idx_min+36,n_circ);
idx_min_13(idx_min_13==0) = n_circ;
idx_min_13 = idx_min_13 + size(stentFinal(3).vertices,1)+ size(stentFinal(2).vertices,1);



inds = reshape([idx_min_21' idx_min_12' ; idx_min_31' idx_min_13'], [n_circ 2]);

% vertex indices for each face
v1 = inds(1:end-1, 1:end-1);
v2 = inds(1:end-1, 2:end);
v3 = inds(2:end, 2:end);
v4 = inds(2:end, 1:end-1);

% concatenate indices
faces = [v1(:) v2(end:-1:1) v3(end:-1:1) v4(:)];

stentY.faces(end+1:end+49,:) = faces ;
stentY.faces(end-48:end,[1 4]) = stentY.faces(end-48:end,[1 4]) ;


drawMesh(stentY.vertices, stentY.faces, 'FaceColor', 'r','facealpha',.3); hold on;
%drawMesh(vertices, faces, 'FaceColor', 'b','facealpha',.3); hold on;
