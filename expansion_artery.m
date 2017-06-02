function [arteryObj, stentObj] =  expansion_artery( arteryObj, stentObj, radius_final) 
global n_circ;

steps = 10;
resistance= 0.4;
%TODO include foreshortening

% go through stent vertices
for i = 1:1
    radius_curr = mean(stentObj(i).radius_avg);
    d = (radius_final(i)-mean(radius_curr))/steps;
    
    % artery vertices in vicinity of stentObj i
    relevant_vertices = arteryObj.vertices(stentObj(i).centerline.index_artery_to_center(stentObj(i).centerline.index_artery_to_center~=0),:);
    relevant_distances = arteryObj.dist_to_center(stentObj(i).centerline.index_artery_to_center(stentObj(i).centerline.index_artery_to_center~=0),:);
    % closest stent point to each artery point
    [~, index_stent_to_artery] = pdist2( stentObj(i).vertices, relevant_vertices,'euclidean','SMALLEST',1);
    % artery points belonging to each stent points
    index_artery_to_stent = get_index(index_stent_to_artery',size(stentObj(i).vertices,1))  ;
                 
    for s=1:steps+5 %TODO change this condition
        for ii = 1:stentObj(i).centerline.len
            % indices of one circle
            idx = (ii-1)*n_circ+1:(ii)*n_circ;
            radius_avg_curr = mean(stentObj(i).radius(idx));
            if radius_avg_curr < radius_final(i)
                % artery points (closest to circle points) that are 
                % closer to the centerline than the circle point
                nn = double(stentObj(i).radius(idx) < stentObj(i).radius_artery(idx));
                nn(nn==0)=resistance;
                % expand the stent points; those at vessel wall less,
                % depending on resistance variable
                stentObj(i).vertices(idx,:)= stentObj(i).vertices(idx,:)+d*nn.*normr(stentObj(i).vertices(idx,:)-stentObj(i).centerline.coords(ii,:));
                % update stent point radii
                stentObj(i).radius(idx,:)= stentObj(i).radius(idx,:)+d*nn;   
                % artery points belonging to current circle
                index_artery_to_circle = index_artery_to_stent(idx,:);
                index_artery_to_circle = index_artery_to_circle(index_artery_to_circle~=0);
                
                % artery points belonging to stent points (current circle)
                index_artery_to_circle_stent = index_stent_to_artery(index_artery_to_circle);
                % artery points (belonging to circle points) that are
                % closer to the centerline than the expanded circle point
                mm = stentObj(i).radius(index_artery_to_circle_stent) > relevant_distances(index_artery_to_circle,4);
                % TODO check which centerline the artery points belonged to
                % before
                [~, idx_c_t_a] = pdist2( stentObj(i).centerline.coords, relevant_vertices(index_artery_to_circle(mm),:),'euclidean','SMALLEST',1);
                relevant_vertices(index_artery_to_circle(mm),:) = arteryObj.centerline(i).coords(idx_c_t_a,:)+stentObj(i).radius(index_artery_to_circle_stent(mm)).* normr(relevant_vertices(index_artery_to_circle(mm),:) - arteryObj.centerline(i).coords(idx_c_t_a,:));
                %scatter3(relevant_vertices(idx_a_t_s1(mm),1),relevant_vertices(idx_a_t_s1(mm),2),relevant_vertices(idx_a_t_s1(mm),3));
                %[~,idx_closest_artery] = pdist2( relevant_vertices(idx_a_t_s1(mm),:),stentObj(i).vertices, 'euclidean','SMALLEST',1);
                %rel_distances = relevant_distances(idx_a_t_s1(mm),:);
                %stentObj(i).radius_artery(idx_closest_artery(idx_closest_artery~=0)) = rel_distances(idx_closest_artery,4);%mean(relevant_distances(index_artery_to_stent(index_artery_to_stent~=0)));

            end

        end
  
    end
    % update artery vertices
    arteryObj.vertices(stentObj(i).centerline.index_artery_to_center(stentObj(i).centerline.index_artery_to_center~=0),:) = relevant_vertices;
        
end
%hold on; draw_stent(stentObj, 'r');

%TODO add that artery expands also in direction radial

