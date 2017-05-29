classdef Artery
    %   Class for the patient specific 3D model of the pulmonary artery
    
    properties
        centerline;
        centerline_lengths;
        radii_avg;
        radii_st_dev;
        vertices;
        faces; 
        stenosis;
        dist_to_center;
        opening;

    end
    
    methods
        function  arteryObj = Artery(filename_artery, filename_centerline1, filename_centerline2)
            % read in artery
            [arteryObj.faces, arteryObj.vertices, ~] = read_stl(filename_artery);
           
            % initialize centerline
            arteryObj.centerline = get_centerlines(filename_centerline1, filename_centerline2);
            arteryObj.centerline_lengths = [0,size(arteryObj.centerline(1).coords,1),size(arteryObj.centerline(2).coords,1),size(arteryObj.centerline(3).coords,1)];
            
            % calculate radii and distances
            arteryObj = calc_radii_dists(arteryObj);
            
            % set stenoses
            arteryObj = set_stenosis(arteryObj);
            
            % set openings
            arteryObj = set_opening(arteryObj);
        end

        function arteryObj = calc_radii_dists(arteryObj)
            center_length = size(arteryObj.centerline(4).coords,1);
            centerline_lengths1 = cumsum(arteryObj.centerline_lengths);
            
            % distance and index to closest centerline point for each artery point
            [dist_art, index_center_to_artery] = pdist2(arteryObj.centerline(4).coords,arteryObj.vertices,'euclidean','SMALLEST',1);

            % index of artery points belonging to each centerline point
            arteryObj.centerline(4).index_artery_to_center = get_index(index_center_to_artery',center_length);

            % average
            arteryObj.dist_to_center(:,4) = dist_art';
            for i=1:center_length
                % number of artery points belonging to center point i
                num = sum(arteryObj.centerline(4).index_artery_to_center(i,:)~=0);
                
                % distances from point i to artery points
                dists = arteryObj.dist_to_center(arteryObj.centerline(4).index_artery_to_center(i,1:num),4);
                arteryObj.radii_avg(i,4) = sum(dists)/num;
                arteryObj.radii_st_dev(i,4) = std(dists);
            end;

            % set values for the single branches 

            for i = 1:3
                arteryObj.radii_avg(1:arteryObj.centerline_lengths(i+1),i) = arteryObj.radii_avg(centerline_lengths1(i)+1:centerline_lengths1(i+1),4);            
                arteryObj.centerline(i).index_artery_to_center(1:arteryObj.centerline_lengths(i+1),:) = arteryObj.centerline(4).index_artery_to_center(centerline_lengths1(i)+1:centerline_lengths1(i+1),:);            
                arteryObj.dist_to_center(1:arteryObj.centerline_lengths(i+1),i) = arteryObj.dist_to_center(centerline_lengths1(i)+1:centerline_lengths1(i+1),4);            
            end
        end
        
        function arteryObj = set_stenosis(arteryObj)
            arteryObj.stenosis = [arteryPoint(),arteryPoint(),arteryPoint()];
            offset = 10;
            for i = 1:3
                [radius, index] = min(arteryObj.radii_avg(1:arteryObj.centerline_lengths(i+1)-offset,i));
                % set Stenosis
                arteryObj.stenosis(i) = arteryPoint(radius,index, arteryObj.centerline(i).coords(index,:));  
            end
    
        end 
        
        function arteryObj = set_opening(arteryObj)
            arteryObj.opening = [arteryPoint(),arteryPoint()];
            for i = 1:2
                threshold = 0.4*(max(arteryObj.radii_avg(:,i))+min(arteryObj.radii_avg(nnz(arteryObj.radii_avg(:,i)),i)));
                idx = find(arteryObj.radii_avg(:,i)<threshold,1);
                arteryObj.opening(i) = arteryPoint(arteryObj.radii_avg(idx,i), idx, arteryObj.centerline(i).coords(idx,:));
            end
        end

        

        
    end
        
        

        
                  
 

    
end