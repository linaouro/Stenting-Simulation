classdef Artery
    %   Class for the patient specific 3D model of the pulmonary artery
    
    properties
        centerline;
        radii_avg;
        radii_st_dev;
        vertices;
        faces; 
        stenosis_index;
        stenosis_radius;

    end
    
    methods
        function  arteryObj = Artery(filename_artery, filename_centerline1, filename_centerline2)
            % read in artery
            [arteryObj.faces, arteryObj.vertices, ~] = read_stl(filename_artery);
            % initialize centerline
            arteryObj.centerline = Centerline(filename_centerline1, filename_centerline2);
            % calculate radii
            [arteryObj.radii_avg, arteryObj.radii_st_dev, arteryObj.centerline.index_artery_to_center] = calc_mean_radii(arteryObj.centerline.coords, arteryObj.vertices);
            % find stenosis
            [arteryObj.stenosis_radius, arteryObj.stenosis_index] = min(arteryObj.radii_avg);
        end
 
        
    end
    
end