classdef Stent
    %   Class for the patient specific 3D model of the pulmonary artery
    
    properties
        centerline;
        radius;
        vertices;
        faces; 
        params;
    end
    
    methods
        function  stentObj = Stent(filename_stent, filename_params, coords, tangents, radius, idx)
            if nargin ~= 0
                
                % read in stent
                %[stentObj.faces, stentObj.vertices] = read_vertices_and_faces_from_obj_file(filename_stent, false);
                
                % set foreshortening parameters
                stentObj.params = csvread(filename_params);
                
                % initialize centerline
                stentObj.centerline = Centerline(coords(idx(1):idx(2),:), tangents(idx(1):idx(2),:));

                stentObj.vertices = initial_alignment(stentObj.centerline, radius, 50);
                stentObj.faces = triangulate_stent(stentObj.vertices,50);
                %TODO find intersection of the cylinders 
                
                stentObj.radius = radius;
            end
        end
             

 
    end
    
end