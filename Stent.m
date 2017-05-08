classdef Stent
    %   Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        centerline;
        vertices;
        faces; 
        params;
        index_artery_to_center
    end
    
    methods
        function  stentObj = Stent(filename_stent, filename_params)
            % read in stebt
            [stentObj.faces, stentObj.vertices] = read_vertices_and_faces_from_obj_file(filename_stent, false);
            
            % initialize centerline
            
            % set foreshortening parameters
            stentObj.params = csvread(filename_params);
        end
 
        
    end
    
end