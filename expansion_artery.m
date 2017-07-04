function [arteryObj, stentObj] =  expansion_artery( arteryObj, stentObj, radius_final, video) 
steps = 10;

if video
    seconds =5;
    fId = figure('units','normalized','position',[1 1 1 1]);
    hold on
    light('Position',[-1.0,-1.0,100.0],'Style','infinite');
    lighting gouraud;
    writerObj = VideoWriter('images/realStentArteryExpanding.mp4', 'MPEG-4'); % Name it.
    writerObj.FrameRate = floor(steps/seconds); % frames per second
    writerObj.Quality=100;
    open(writerObj);
end


for i = 1:3
    d(i) = (radius_final(i)-stentObj(i).radius_avg)/steps;
    initial_length(i) = stentObj(i).centerline.length;
    initial_radius(i) = stentObj(i).radius_avg;
end
                 
for s=1:steps 
    arteryObj_help = stentY_centerline(arteryObj, initial_radius +s*d); 
    % go through stent vertices
    %f1 = draw_artery_real_stents(arteryObj, stentObj);hold on;
    for i = 1:3
        scale = interp1(stentObj(i).params(:,1), stentObj(i).params(:,2), initial_radius(i) +s*d(i),'linear','extrap') ; % initial radius * 2 /2 -> params are lumen
        if isnan(scale) || scale > 1 
            scale = 1;
        elseif scale < 0
                scale = 0.1;
        end
        truncat_idx = find(cumsum(arteryObj_help.centerline(i).seglen)<=initial_length(i)*scale,1,'Last')+1;
        stentObj = edit_Stent(stentObj, arteryObj_help, ones(truncat_idx,1).*(initial_radius(i) +s*d(i)), truncat_idx,i);
        %stentObj1 = arteryObj;

        % closest center point to each artery point 
        [dist_center_to_artery, index_center_to_artery] = pdist2(arteryObj_help.centerline(i).coords,  arteryObj.vertices,  'euclidean','SMALLEST',1);
        plane = createPlane(arteryObj_help.centerline(i).coords(index_center_to_artery,:), arteryObj_help.centerline(i).tangents(index_center_to_artery,:));
        points = projPointOnPlane(arteryObj.vertices, plane);
        alpha = real(anglePoints3d(arteryObj.vertices, arteryObj_help.centerline(i).coords(index_center_to_artery,:), points));
        index_center_to_artery(alpha*180/pi > 20) = 0;
        a = (alpha'*180/pi > 10)&(dist_center_to_artery> stentObj(i).radius_avg./cos(alpha'));
        %scatter3(arteryObj.vertices(a,1),arteryObj.vertices(a,2),arteryObj.vertices(a,3));
        index_center_to_artery(a) = 0;
        index_center_to_artery(dist_center_to_artery> stentObj(i).radius_avg./cos(alpha')) = 0;

        % artery points belonging to each center point and that are closer to
        % centerline then the stent points
        index_artery_to_center = get_index(index_center_to_artery',arteryObj_help.centerline(i).len)  ;
        index_artery_to_center = index_artery_to_center(1:stentObj(i).centerline.len,:);
        relevant_vertices = arteryObj.vertices(index_artery_to_center(index_artery_to_center~=0),:);
        %f1 = draw_artery_real_stents(arteryObj_new1, stentObj);
        %scatter3(relevant_vertices(:,1),relevant_vertices(:,2),relevant_vertices(:,3));
        % closest stent point to each artery point that is closer to center than
         % the stent
        [~, index_stent_to_artery] = pdist2( stentObj(i).vertices, relevant_vertices,'euclidean','SMALLEST',1);

        arteryObj.vertices(index_artery_to_center(index_artery_to_center~=0),:) = stentObj(i).vertices(index_stent_to_artery,:);




        % update artery vertices
        %arteryObj_help.vertices(relevant_idx,:) = relevant_vertices;
        
    end
    if video
        figure(fId); % Makes sure you use your desired frame.
        %draw_artery_stents(arteryObj, connect_stents(stentObj));
        arteryObj1 = smoothpatch(arteryObj,1,1,0.5,1);
        draw_artery_real_stents(arteryObj1, stentObj); 
        frame = getframe(fId); % 'gcf' can handle if you zoom in to take a movie.
        writeVideo(writerObj, frame);   
    end

end
if video
    close(writerObj); % Saves the movie.
end