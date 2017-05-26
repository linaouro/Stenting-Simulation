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
            
        function  stentObj = Stent(filename_params, centerline, radii, idx)
            if nargin ~= 0
                
                % read in stent
                %[stentObj.faces, stentObj.vertices] = read_vertices_and_faces_from_obj_file(filename_stent, false);
                n = 50.0;
                               
                % set foreshortening parameters
                stentObj.params = csvread(filename_params);
                stentObj.filename_params = filename_params;
                
                % initialize centerline
                stentObj.centerline = Centerline(centerline.coords(1:idx,:), centerline.tangents(1:idx,:));
                stentObj.centerline.index_artery_to_center = centerline.index_artery_to_center(1:idx,:);
                
                [stentObj.radius, stentObj.vertices, stentObj.faces] = get_cylinder_mesh(stentObj.centerline, n, idx, radii);                
                %drawMesh(stentObj.vertices, stentObj.faces, 'FaceColor', 'w','facealpha',.1);
                %plot3(stentObj.centerline.coords(:,1),stentObj.centerline.coords(:,2),stentObj.centerline.coords(:,3), 'Color', 'y'); hold on;
                stentObj.centerline.index_stent_to_center = reshape(1:size(stentObj.vertices,1), n,stentObj.centerline.len)';
                
                stentObj.radius_avg = mean(radii);
            end
        end
 
    end
    
end