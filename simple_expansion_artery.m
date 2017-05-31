function [arteryObj, stentObj] =  simple_expansion_artery( arteryObj, stentObj, radius_final) 
global n_circ;

% Step size
steps = 10;


%% Initialization of scaling parameters
% go through stent vertices
for i = 1:3
    radius_curr = mean(stentObj(i).radius_avg);
    d = (radius_final(i)-mean(radius_curr))/steps;
    % artery vertices in vicinity of stentObj i
    relevant_vertices = arteryObj.vertices(stentObj(i).centerline.index_artery_to_center(stentObj(i).centerline.index_artery_to_center~=0),:);
        
    for s=1:steps+5 %TODO change this condition
        for ii = 1:stentObj(i).centerline.len
            idx = (ii-1)*n_circ+1:(ii)*n_circ;
            radius_avg_curr = mean(stentObj(i).radius(idx));
            if radius_avg_curr < radius_final(i)
                    nn = double(stentObj(i).radius(idx) < stentObj(i).radius_artery(idx));
                    nn(nn==0)=0.3;
                    stentObj(i).vertices(idx,:)= stentObj(i).vertices(idx,:)+d*nn.*normr(stentObj(i).vertices(idx,:)-stentObj(i).centerline.coords(ii,:));
                    stentObj(i).radius(idx,:)= stentObj(i).radius(idx,:)+d*nn;   
            end                
        end
        %     hold on; draw_stent(stentObj(i), 'r');
        relevant_distances = arteryObj.dist_to_center(stentObj(i).centerline.index_artery_to_center(stentObj(i).centerline.index_artery_to_center~=0),4);
        % scatter3(relevant_vertices(:,1), relevant_vertices(:,2),relevant_vertices(:,3));
        % index of stent points belongig to each artery point
        [~, index_stent_to_artery] = pdist2( stentObj(i).vertices, relevant_vertices,'euclidean','SMALLEST',1);
        % set artery vertices that are closer to the centerline than its
        % closest stent point to their closest stent point
        relevant_vertices(relevant_distances<stentObj(i).radius(index_stent_to_artery),:)= stentObj(i).vertices(index_stent_to_artery(relevant_distances<stentObj(i).radius(index_stent_to_artery)),:);
        % distance and index to closest centerline point for each artery point
        [dist_art,~] = pdist2(arteryObj.centerline(i).coords,relevant_vertices,'euclidean','SMALLEST',1);
        % average
        arteryObj.dist_to_center(stentObj(i).centerline.index_artery_to_center(stentObj(i).centerline.index_artery_to_center~=0),4) = dist_art';

    end
    % update artery vertices
    arteryObj.vertices(stentObj(i).centerline.index_artery_to_center(stentObj(i).centerline.index_artery_to_center~=0),:) = relevant_vertices;
        
end
hold on; draw_stent(stentObj, 'r');

%TODO add that artery expands also in direction radial

