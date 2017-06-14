classdef Artery
    %   Class for the patient specific 3D model of the pulmonary artery
    
    properties
        centerline;
        centerline_lengths;
        radii_avg;
        radii_min;
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
            arteryObj = calc_radii_dists(arteryObj);
            
            % set stenoses
            arteryObj = set_stenosis(arteryObj);
            
            % set openings
            arteryObj = set_opening(arteryObj);
        end

        function arteryObj = calc_radii_dists(arteryObj)
            center_length = arteryObj.centerline(4).len;
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
                arteryObj.radii_min(i,4) = min(dists);
            end;

            % set values for the single branches 

            for i = 1:3
                arteryObj.radii_avg(1:arteryObj.centerline_lengths(i+1),i) = arteryObj.radii_avg(centerline_lengths1(i)+1:centerline_lengths1(i+1),4);            
                arteryObj.radii_min(1:arteryObj.centerline_lengths(i+1),i) = arteryObj.radii_min(centerline_lengths1(i)+1:centerline_lengths1(i+1),4);            
                
                arteryObj.centerline(i).index_artery_to_center = arteryObj.centerline(4).index_artery_to_center(centerline_lengths1(i)+1:centerline_lengths1(i+1),:);            
                arteryObj.dist_to_center(1:arteryObj.centerline_lengths(i+1),i) = arteryObj.dist_to_center(centerline_lengths1(i)+1:centerline_lengths1(i+1),4);            
            end
        end
        
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
            arteryObj.opening = [ArteryPoint(),ArteryPoint()];
            for i = 1:2
                threshold = 0.4*(max(arteryObj.radii_avg(:,i))+min(arteryObj.radii_avg(nnz(arteryObj.radii_avg(:,i)),i)));
                idx = find(arteryObj.radii_avg(:,i)<threshold,1);
                arteryObj.opening(i) = ArteryPoint(arteryObj.radii_avg(idx,i), idx, arteryObj.centerline(i).coords(idx,:));
            end
        end

        function arteryObj = update_centerline(arteryObj, stent_radii)
            global n_circ;
            %update centerline
            % parametrisation on x
            nx = n_circ+1;
            nz = 2;
            t = linspace(0, 2*pi, nx);
            x = zeros(nz,nx);
            y = zeros(nz,nx);
            z = zeros(nz,nx);
            for i=1:nz 
                lx = stent_radii(i) * cos(t);
                sintheta = sin(t); sintheta(end) = 0;
                ly = stent_radii(i) * sintheta;
                % rotation of circle
                [theta, phi, ~] = cart2sph2d(arteryObj.centerline(i).tangents(1,:));
                lz = zeros(size(lx));
                trans   = localToGlobal3d(arteryObj.centerline(i).coords(1,:), theta, phi, 0);
                [x(i,:), y(i,:), z(i,:)] = transformPoint3d(lx', ly', lz', trans);
            end
            [D,I] = pdist2([x(1,:)', y(1,:)',z(1,:)'],[x(2,:)', y(2,:)',z(2,:)'], 'Euclidean','Largest',1);
            [~,idx2] = max(D);
            idx1 = I(idx2);



            coords = [mean([x(1,idx1)', y(1,idx1)',z(1,idx1)';x(2,idx2)', y(2,idx2)',z(2,idx2)']); arteryObj.centerline(3).coords ];
            tangents = [mean([arteryObj.centerline(1).tangents(1,:);arteryObj.centerline(2).tangents(1,:)]); arteryObj.centerline(3).tangents ];
            arteryObj.centerline(3) = Centerline(coords, tangents);
            arteryObj.centerline(4) = Centerline([arteryObj.centerline(1).coords; arteryObj.centerline(2).coords; arteryObj.centerline(3).coords],[arteryObj.centerline(1).tangents; arteryObj.centerline(2).tangents; arteryObj.centerline(3).tangents]);
            arteryObj.centerline_lengths = [0,size(arteryObj.centerline(1).coords,1),size(arteryObj.centerline(2).coords,1),size(arteryObj.centerline(3).coords,1)];
            arteryObj = calc_radii_dists(arteryObj); 
         end

        
    end
    
end