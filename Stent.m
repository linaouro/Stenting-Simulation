classdef Stent
    %   Class for the patient specific 3D model of the pulmonary artery
    
    properties
        centerline;
        radii;
        vertices;
        faces; 
        params;
    end
    
    methods
        function  stentObj = Stent(filename_stent, filename_params, left_center, right_center, trunk_center)
            % read in stent
            [stentObj.faces, stentObj.vertices] = read_vertices_and_faces_from_obj_file(filename_stent, false);
            
            % initialize centerline
            stentObj.centerline = Centerline(left_center, right_center, trunk_center);
           
            % set foreshortening parameters
            stentObj.params = csvread(filename_params);
        end
 
        
    end
    
end