function [stent_V,stent_F] = get_sorted_stent(filename)% filename  = 'stent.obj'
[stent_V,stent_F] = read_vertices_and_faces_from_obj_file(filename, false);
[~, idx_sort] = sort(stent_V(:,2));
stent_V = stent_V(idx_sort,:);
c(idx_sort) = 1:size(stent_V,1);
stent_F = c(stent_F);
stent_V(:,3) = (stent_V(:,3))/0.2750;
stent_V(:,1) = (stent_V(:,1))/0.2750;
