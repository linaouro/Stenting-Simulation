function vertices = set_artery_to_stent(vertices, dist_to_center, stentObj)

    for i=1:3
        % artery vertices in vicinity of stentObj i
        relevant_vertices = vertices(stentObj(i).centerline.index_artery_to_center(stentObj(i).centerline.index_artery_to_center~=0),:);
        relevant_distances = dist_to_center(stentObj(i).centerline.index_artery_to_center(stentObj(i).centerline.index_artery_to_center~=0),:);
        % scatter3(relevant_vertices(:,1), relevant_vertices(:,2),relevant_vertices(:,3));
        % index of stent points belongig to each artery point
        [~, index_stent_to_artery] = pdist2( stentObj(i).vertices, relevant_vertices,'euclidean','SMALLEST',1);
        % set artery vertices that are close to the centerline than its
        % closest stent point to their closest stent point
        relevant_vertices(relevant_distances<stentObj(i).radius(index_stent_to_artery),:)= stentObj(i).vertices(index_stent_to_artery(relevant_distances<stentObj(i).radius(index_stent_to_artery)),:);
        % update artery vertices
        vertices(stentObj(i).centerline.index_artery_to_center(stentObj(i).centerline.index_artery_to_center~=0),:) = relevant_vertices;
    end
end