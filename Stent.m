classdef Stent
    %   Class for the patient specific 3D model of the pulmonary artery
    
    properties
        centerline;
        radius;
        radius_avg;
        vertices;
        faces; 
        params;
        filename_params;
    end
    
    methods
            
        function  stentObj = Stent(filename_params, centerline, radius, idx)
            if nargin ~= 0
                
                % read in stent
                %[stentObj.faces, stentObj.vertices] = read_vertices_and_faces_from_obj_file(filename_stent, false);
                n = 50;
                               
                % set foreshortening parameters
                stentObj.params = csvread(filename_params);
                stentObj.filename_params = filename_params;
                
                % initialize centerline
                stentObj.centerline = Centerline(centerline.coords(1:idx,:), centerline.tangents(1:idx,:));
                stentObj.centerline.index_artery_to_center = centerline.index_artery_to_center(1:idx,:);
                
                % create straight cylinder
                cyl = [0 0 0 0 1 0 radius];
                [stentObj.vertices, stentObj.faces] = get_cylinder_mesh(cyl, n, idx);
                
                % morph cylinder
                stentObj.vertices(:,2) = zeros(size(stentObj.vertices,1),1);
                stentObj.vertices(:,4) = ones(size(stentObj.vertices,1),1);
                for i = 0:size(stentObj.centerline.coords,1)-1
                    stentObj.vertices(i*n+1:i*n+n,:) = (get_rot_trans_matrix([0;1;0],stentObj.centerline.tangents(i+1,:)', stentObj.centerline.coords(i+1,:)')* stentObj.vertices(i*n+1:i*n+n,:)')';
                    %scatter3(stentObj.vertices(i*n+1:i*n+n,1),stentObj.vertices(i*n+1:i*n+n,2),stentObj.vertices(i*n+1:i*n+n,3), 'r'); hold on;
                end;

                stentObj.vertices(:,4) = [];
                stentObj.faces(end-n+2:end,:)= [];
                stentObj.centerline.index_stent_to_center = reshape(1:size(stentObj.vertices,1), n,stentObj.centerline.len)';

                % set radii
                stentObj.radius = ones(size(stentObj.vertices,1))*radius;
                stentObj.radius_avg = radius;
            end
        end
 
    end
    
end