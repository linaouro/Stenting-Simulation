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
        type;
        perc;
        vertices_real;
        faces_real;
        
    end
    
    methods
            
        function  stentObj = Stent(params, centerline, radii, idx)
            global n_circ;
            if nargin ~= 0
                % read in stent
               for i =1:length(idx)
                               
                    if size(radii,1) == 1
                        radii_stent = ones(idx(i),1).*radii(i)';
                    else
                        radii_stent = radii;
                    end
                    % set foreshortening parameters
                    stentObj(i).params = params(3:end,:);
                    stentObj(i).type = params(1:2,2);
 
                    % initialize centerline
                    stentObj(i).centerline = Centerline(centerline(i).coords(1:idx(i),:), centerline(i).tangents(1:idx(i),:));
                    stentObj(i).centerline.index_artery_to_center = centerline(i).index_artery_to_center(1:idx(i),:);

                    [stentObj(i).radius, stentObj(i).vertices, stentObj(i).faces] = get_cylinder_mesh(stentObj(i).centerline, idx(i), radii_stent);                
                     stentObj(i).centerline.index_stent_to_center = reshape(1:size(stentObj(i).vertices,1), n_circ,stentObj(i).centerline.len)';

                    stentObj(i).radius_avg = mean(radii_stent);
                    
                    [stentObj(i).vertices_real,stentObj(i).faces_real] = get_sorted_stent('stent.obj');
                end
            end
        end
        

	function  stentObj = edit_Stent(stentObj, helperObj, radii, idx,i)
            global n_circ;
            if nargin ~= 0

                               
                    if size(radii,1) == 1
                        radii_stent = ones(idx,1).*radii';
                    else
                        radii_stent = radii;
                    end
 
                    % initialize centerline
                    stentObj(i).centerline = Centerline(helperObj.centerline(i).coords(1:idx,:), helperObj.centerline(i).tangents(1:idx,:));
                    stentObj(i).centerline.index_artery_to_center = helperObj.centerline(i).index_artery_to_center(1:idx,:);

                    [stentObj(i).radius, stentObj(i).vertices, stentObj(i).faces] = get_cylinder_mesh(stentObj(i).centerline, idx, radii_stent);                
                    stentObj(i).centerline.index_stent_to_center = reshape(1:size(stentObj(i).vertices,1), n_circ,stentObj(i).centerline.len)';

                    stentObj(i).radius_avg = mean(radii_stent);

            end
        end
 
    end
    
end