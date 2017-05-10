classdef Artery
    %   Class for the patient specific 3D model of the pulmonary artery
    
    properties
        centerline;
        radii_avg;
        radii_st_dev;
        vertices;
        faces; 
        stenosis;

    end
    
    methods
        function  arteryObj = Artery(filename_artery, filename_centerline1, filename_centerline2)
            % read in artery
            [arteryObj.faces, arteryObj.vertices, ~] = read_stl(filename_artery);
            % initialize centerline
            arteryObj.centerline = get_centerlines(filename_centerline1, filename_centerline2);
            centerline_lengths = [1,size(arteryObj.centerline(1).coords,1),size(arteryObj.centerline(2).coords,1),size(arteryObj.centerline(3).coords,1)];
            centerline_lengths1 = cumsum(centerline_lengths);
            % calculate radii
            [arteryObj.radii_avg, arteryObj.radii_st_dev, arteryObj.centerline(4).index_artery_to_center] = calc_mean_radii(arteryObj.centerline(4).coords, arteryObj.vertices);
            for i = 1:3
                arteryObj.radii_avg(i,1:centerline_lengths(i+1)) = arteryObj.radii_avg(4,centerline_lengths1(i):centerline_lengths1(i+1)-1);
                [radius, index] = min(arteryObj.radii_avg(1:centerline_lengths(i+1)));
                % set Stenosis
                stenosisObj(i) = Stenosis(radius,index);  
            end
            arteryObj.stenosis = stenosisObj;

        end
 
        
    end
    
end