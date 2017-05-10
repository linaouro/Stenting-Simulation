function [average, st_dev, index_artery_to_center] = calc_mean_radii(centers, artery)
center_length = size(centers,1);

% distance and index to closest centerline point for each artery point
[dist_artery, index_center_to_artery] = pdist2(centers,artery,'euclidean','SMALLEST',1);
index_center_to_artery = index_center_to_artery'; 

% index of artery points belonging to each centerline point
index_artery_to_center = get_index(index_center_to_artery,center_length);

% average after expansion
average = zeros(4,center_length);
st_dev = zeros(4,size(centers,1));
dist_artery = dist_artery';
for i=1:center_length
    % number of artery points belonging to center point i
    num = sum(index_artery_to_center(i,:)~=0);
    % distances from point i to artery points
    dists = dist_artery(index_artery_to_center(i,1:num),1);
    average(4,i) = sum(dists)/num;
    st_dev(4,i) = std(dists);
end;



% in case NAN appear
% for i=2:size(centers,1)-1
%     if isnan(average(i))
%         average(i) = mean(average(find(~(isnan(average(1:i))),1,'last')), find(~(isnan(average(i:size(average,1)))),1,'first'));
%     end;
% end;