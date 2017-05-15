function faces = triangulate_stent(vertices,n)
%% Triangulation of stacked cylinder
% simple version.. not very good results yet. TODO: closest points
            l = size(vertices,1);
            n_circ = l/n-1;
            faces = zeros(n*2*n_circ,3);

 
            for j = 0:n_circ-1 % number of circles
                for i=1:n-1 %number of points in circle
                    faces(i+j*n,:) = [i+j*n, i+j*n+1, i+j*n+n+1];
                    faces(i+j*n+n_circ*n,:) = [i+j*n, i+j*n+n+1, i+j*n+n ];
                end
                faces(n+j*n,:) =[n+j*n, 1+j*n, 1+j*n+n+1];
                faces(n+j*n+n_circ*n,:) = [n+j*n, 1+j*n+n+1,n+j*n+n];
            end
        end
        
       