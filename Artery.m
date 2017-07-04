classdef Artery
    %   Class for the patient specific 3D model of the pulmonary artery
    
    properties
        centerline;
        centerline_lengths;
        radii_avg;
        %radii_min;
        %radii_st_dev;
        vertices;
        faces; 
        stenosis;
        dist_to_center;
        opening;
        endpoint;
        joining;
        final_radii;
    end
    
    methods
        function  arteryObj = Artery(filename_artery, filename_centerline1, filename_centerline2)
            % read in artery
            [arteryObj.faces, arteryObj.vertices, ~] = read_stl(filename_artery);
            % remove duplicate vertices
            [arteryObj.vertices, ~, ic] =  unique(arteryObj.vertices, 'rows');
            arteryObj.faces = ic(arteryObj.faces);
            
            %a = arteryObj.vertices;
            arteryObj=smoothpatch(arteryObj,1,1,1,1);    
           % distance = norm(a-arteryObj.vertices)

            % initialize centerline
            arteryObj.centerline = get_centerlines(filename_centerline1, filename_centerline2);
            arteryObj.centerline_lengths = [0,size(arteryObj.centerline(1).coords,1),size(arteryObj.centerline(2).coords,1),size(arteryObj.centerline(3).coords,1)];
            
            % calculate radii and distances
            arteryObj = calc_radii_dists2(arteryObj);
            
            % set stenoses
            arteryObj = set_stenosis(arteryObj);
            
            % set openings
            arteryObj = set_opening(arteryObj);
            
            % set end points
            arteryObj = set_endpoint(arteryObj);
            
            arteryObj = update_centerline_opening(arteryObj);
            
        end

%         function arteryObj = calc_radii_dists1(arteryObj)
%                
%             arteryObj.dist_to_center= zeros(size(arteryObj.vertices,1),4);
%             arteryObj.radii_avg= zeros(size(arteryObj.vertices,1),4);
%             % distance and index to closest centerline point for each artery point
%             [dist_art1, index_center_to_artery1] = pdist2(arteryObj.centerline(1).coords,arteryObj.vertices,'euclidean','SMALLEST',1);
%             [dist_art2, index_center_to_artery2] = pdist2(arteryObj.centerline(2).coords,arteryObj.vertices,'euclidean','SMALLEST',1);
%             [dist_art3, index_center_to_artery3] = pdist2(arteryObj.centerline(3).coords,arteryObj.vertices,'euclidean','SMALLEST',1);
%             dist_art1(index_center_to_artery1<arteryObj.opening(1).index) = dist_art3(index_center_to_artery1<arteryObj.opening(1).index);
%             dist_art2(index_center_to_artery2<arteryObj.opening(2).index) = dist_art3(index_center_to_artery2<arteryObj.opening(2).index);
%             arteryObj = set_measurements(arteryObj, index_center_to_artery1, dist_art1, 1, ~((dist_art1<dist_art2)&(dist_art1<dist_art3)));
%             arteryObj = set_measurements(arteryObj, index_center_to_artery2, dist_art2, 2, ~((dist_art2<dist_art1)&(dist_art2<dist_art3)));
%             arteryObj = set_measurements(arteryObj, index_center_to_artery3, dist_art3, 3, ~((dist_art3<=dist_art1)&(dist_art3<=dist_art2)));
% 
%         end
%         
%         function arteryObj = set_measurements(arteryObj, index_center_to_artery,dist_art, i,d)
%             plane = createPlane(arteryObj.centerline(i).coords(index_center_to_artery,:), arteryObj.centerline(i).tangents(index_center_to_artery,:));
%             points = projPointOnPlane(arteryObj.vertices, plane);
%             alpha = anglePoints3d(arteryObj.vertices, arteryObj.centerline(i).coords(index_center_to_artery,:), points);
%             index_center_to_artery(d) = 0;
%             index_center_to_artery(dist_art >3)=0;
%             arteryObj.centerline(i).index_artery_to_center = get_index(index_center_to_artery',arteryObj.centerline(i).len);
%             arteryObj.dist_to_center(1:nnz(dist_art <2.5),i) = dist_art(dist_art <2.5)';
%             arteryObj.radii_avg(1:nnz(dist_art <2.5),i) = sum(arteryObj.dist_to_center(:,i))/nnz(arteryObj.dist_to_center(:,i));
%             arteryObj.radii_st_dev(1:nnz(dist_art <2.5),i) = std(arteryObj.dist_to_center(:,i));
%             arteryObj.radii_min(1:nnz(dist_art <2.5),i) = min([arteryObj.dist_to_center(:,i);10]);
%         end
        
        function arteryObj = calc_radii_dists2(arteryObj)
            thresh = [1, 1, 2];
            for i = 1:3
                [dist_center_to_artery, index_center_to_artery] = pdist2(arteryObj.centerline(i).coords,  arteryObj.vertices,  'euclidean','SMALLEST',1);
                plane = createPlane(arteryObj.centerline(i).coords(index_center_to_artery,:), arteryObj.centerline(i).tangents(index_center_to_artery,:));
                points = projPointOnPlane(arteryObj.vertices, plane);
                alpha = anglePoints3d(arteryObj.vertices, arteryObj.centerline(i).coords(index_center_to_artery,:), points);
                index_center_to_artery(alpha*180/pi > 10) = 0;
                index_center_to_artery(dist_center_to_artery> thresh(i)) = 0;
                arteryObj.dist_to_center(:,i) = dist_center_to_artery';
                
                % artery points belonging to each center point and that are closer to
                % centerline then the stent points
                arteryObj.centerline(i).index_artery_to_center = get_index(index_center_to_artery',arteryObj.centerline(i).len)  ; 
                num = sum(arteryObj.centerline(i).index_artery_to_center'~=0);
                for j = 1:arteryObj.centerline(i).len
                    arteryObj.radii_avg(j,i) = mean(dist_center_to_artery(arteryObj.centerline(i).index_artery_to_center(j,1:num(j))));    
                    %arteryObj.radii_min(j,i) = min(dist_center_to_artery(arteryObj.centerline(i).index_artery_to_center(j,1:num(j))));
                end
            end
            
        end
        
%         function arteryObj = calc_radii_dists(arteryObj)
%             center_length = arteryObj.centerline(4).len;
%             centerline_lengths1 = cumsum(arteryObj.centerline_lengths);
%             
%             % distance and index to closest centerline point for each artery point
%             [dist_art, index_center_to_artery] = pdist2(arteryObj.centerline(4).coords,arteryObj.vertices,'euclidean','SMALLEST',1);
%             
%             % index of artery points belonging to each centerline point
%             arteryObj.centerline(4).index_artery_to_center = get_index(index_center_to_artery',center_length);
% 
%             % average
%             arteryObj.dist_to_center(:,4) = dist_art';
%             for i=1:center_length
%                 % number of artery points belonging to center point i
%                 num = sum(arteryObj.centerline(4).index_artery_to_center(i,:)~=0);
%                 
%                 % distances from point i to artery points
%                 dists = arteryObj.dist_to_center(arteryObj.centerline(4).index_artery_to_center(i,1:num),4);
%                 arteryObj.radii_avg(i,4) = sum(dists)/num;
%                 arteryObj.radii_st_dev(i,4) = std(dists);
%                 arteryObj.radii_min(i,4) = min([dists;10]);
%             end;
% 
%             % set values for the single branches 
% 
%             for i = 1:3
%                 arteryObj.radii_avg(1:arteryObj.centerline_lengths(i+1),i) = arteryObj.radii_avg(centerline_lengths1(i)+1:centerline_lengths1(i+1),4);            
%                 arteryObj.radii_min(1:arteryObj.centerline_lengths(i+1),i) = arteryObj.radii_min(centerline_lengths1(i)+1:centerline_lengths1(i+1),4);            
%                 
%                 arteryObj.centerline(i).index_artery_to_center = arteryObj.centerline(4).index_artery_to_center(centerline_lengths1(i)+1:centerline_lengths1(i+1),:);            
%                 arteryObj.dist_to_center(1:arteryObj.centerline_lengths(i+1),i) = arteryObj.dist_to_center(centerline_lengths1(i)+1:centerline_lengths1(i+1),4);            
%             end
%         end
        
        function arteryObj = set_stenosis(arteryObj)
            arteryObj.stenosis = [ArteryPoint(),ArteryPoint(),ArteryPoint()];
            offset = 10;
            for i = 1:3
                [radius, index] = min(arteryObj.radii_avg(1:arteryObj.centerline_lengths(i+1)-offset,i));
                % set Stenosis
                arteryObj.stenosis(i) = ArteryPoint(radius,index, arteryObj.centerline(i).coords(index,:));  
            end
    
        end 
        
        function arteryObj = set_opening(arteryObj)
            arteryObj.opening = [ArteryPoint(),ArteryPoint(), ArteryPoint()];
            for i = 1:2
                threshold = (max(arteryObj.radii_avg(:,i))+min(arteryObj.radii_avg(1:nnz(arteryObj.radii_avg(:,i)),i)))/2;
                %threshold = mean(arteryObj.radii_avg(1:nnz(arteryObj.radii_avg(:,i)),i));
                
                idx = find(arteryObj.radii_avg(1:arteryObj.stenosis(i).index,i)>threshold,1,'last')+1;
                arteryObj.opening(i) = ArteryPoint(arteryObj.radii_avg(idx,i), idx, arteryObj.centerline(i).coords(idx,:));
            end
            arteryObj.opening(3) = ArteryPoint(arteryObj.radii_avg(1,3), 1, arteryObj.centerline(3).coords(1,:));

        end
        
        function arteryObj = set_endpoint(arteryObj)
            arteryObj.endpoint = [ArteryPoint(),ArteryPoint(),ArteryPoint()];
            idx(3) = min(arteryObj.centerline(3).len,1+find(cumsum(arteryObj.centerline(3).seglen)>4,1), 'omitnan');
            idx(2) = round(0.8*(arteryObj.centerline(2).len-arteryObj.opening(2).index))+arteryObj.opening(2).index-1; %left
            idx(1) = round(2/3*(arteryObj.centerline(1).len-arteryObj.opening(1).index))+arteryObj.opening(1).index-1;
            for i = 1:3
               arteryObj.endpoint(i) = ArteryPoint(arteryObj.radii_avg(idx(i),i), idx(i), arteryObj.centerline(i).coords(idx(i),:));
            end
        end
     
        function arteryObj = update_centerline_opening(arteryObj)
            global n_circ;
            arteryObj.final_radii = [1.1*max(arteryObj.radii_avg(arteryObj.opening(1).index+1:arteryObj.endpoint(1).index,1)), 1.1*max(arteryObj.radii_avg(arteryObj.opening(2).index+1:arteryObj.endpoint(2).index,2)), min(1.35, 1.0*max(arteryObj.radii_avg(1:arteryObj.endpoint(3).index,3)))];

            % take the first two branch stent circles 
            nx = n_circ+1;
            t = linspace(0, 2*pi, nx);
            x = zeros(2,nx);
            y = zeros(2,nx);
            z = zeros(2,nx);

            for i=1:2 
                lx = arteryObj.final_radii(i) * cos(t);
                sintheta = sin(t); sintheta(end) = 0;
                ly = arteryObj.final_radii(i) * sintheta;
                % rotation of circle
                [theta, phi, ~] = cart2sph2d(arteryObj.centerline(i).tangents(arteryObj.opening(i).index,:));
                lz = zeros(size(lx));%ones(size(lx))*seglen(i);
                trans   = localToGlobal3d( arteryObj.opening(i).coords, theta, phi, 0);
                [x(i,:), y(i,:), z(i,:)] = transformPoint3d(lx', ly', lz', trans);
            end

            circ1 = [x(1,:); y(1,:); z(1,:)]';
            circ2 = [x(2,:); y(2,:); z(2,:)]';
            [dist1, idx1] = pdist2(circ1,circ2,'Euclidean','Largest',1);
            [~, idx2] = max(dist1);
            idx1 =idx1(idx2);
            % calculate center and add to trunk centerline       
             coords = [mean([circ1(idx1,:);circ2(idx2,:)]); arteryObj.centerline(3).coords(1:end,:) ];
            [coords,tangents,~]= interparc(size(coords,1),coords(:,1),coords(:,2),coords(:,3));
            % plane normal on line between the two branches joining points
            plane = createPlane(coords(1,:), circ1(idx1,:)-circ2(idx2,:));
            point = projPointOnPlane(coords(1,:)+0.1*mean([-arteryObj.centerline(1).tangents(arteryObj.opening(1).index,:);-arteryObj.centerline(2).tangents(arteryObj.opening(2).index,:)]), plane);
            %point1 = intersectLinePlane([coords(1,:),arteryObj.centerline(2).tangents(arteryObj.opening(2).index,:)], plane);
            tangents(1,:) = normr(point-coords(1,:));%mean([-arteryObj.centerline(1).tangents(arteryObj.opening(1).index,:); -arteryObj.centerline(2).tangents(arteryObj.opening(2).index,:)]);
            arteryObj.centerline(3) = Centerline(coords, tangents);
            arteryObj.centerline(4) = Centerline([arteryObj.centerline(1).coords; arteryObj.centerline(2).coords; arteryObj.centerline(3).coords],[arteryObj.centerline(1).tangents; arteryObj.centerline(2).tangents; arteryObj.centerline(3).tangents]);
            arteryObj.centerline_lengths = [0,size(arteryObj.centerline(1).coords,1),size(arteryObj.centerline(2).coords,1),size(arteryObj.centerline(3).coords,1)];
            arteryObj = calc_radii_dists2(arteryObj); 
            arteryObj.endpoint(3) = ArteryPoint(arteryObj.radii_avg(arteryObj.endpoint(3).index+1,3), arteryObj.endpoint(3).index+1, arteryObj.centerline(3).coords(arteryObj.endpoint(3).index+1,:));
            arteryObj.opening(3) = ArteryPoint(arteryObj.radii_avg(1,3), 1, arteryObj.centerline(3).coords(1,:));
            arteryObj.joining = normr([circ1(idx1,:)-arteryObj.opening(1).coords; circ2(idx2,:)-arteryObj.opening(2).coords; (circ1(idx1,:)-arteryObj.centerline(3).coords(1,:))]);

         end
        
    end
    
end