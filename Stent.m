classdef Stent
    %   Class for the patient specific 3D model of the pulmonary artery
    
    properties
        centerline;
        radius;
        radius_artery;
        radius_avg;
        vertices;
        faces; 
        params;
        filename_params;
    end
    
    methods
            
        function  stentObj = Stent(filename_params, centerline, radii, idx)
            if nargin ~= 0
                global n_circ;
                % read in stent
                %[stentObj.faces, stentObj.vertices] = read_vertices_and_faces_from_obj_file(filename_stent, false);
                for i =1:length(idx)
                               
                    if size(radii,1) == 1
                        radii_stent = ones(idx(i),1).*radii(i);
                    else
                        radii_stent = radii(i,:);
                    end
                    % set foreshortening parameters
                    stentObj(i).params = csvread(filename_params(i));
                    stentObj(i).filename_params = filename_params(i);

                    % initialize centerline
                    stentObj(i).centerline = Centerline(centerline(i).coords(1:idx(i),:), centerline(i).tangents(1:idx(i),:));
                    stentObj(i).centerline.index_artery_to_center = centerline(i).index_artery_to_center(1:idx(i),:);

                    [stentObj(i).radius, stentObj(i).vertices, stentObj(i).faces] = get_cylinder_mesh(stentObj(i).centerline, n_circ, idx(i), radii_stent);                
                     stentObj(i).centerline.index_stent_to_center = reshape(1:size(stentObj(i).vertices,1), n_circ,stentObj(i).centerline.len)';

                    stentObj(i).radius_avg = mean(radii_stent);
                end
            end
        end
        
        
 
    end
    
end