function [average, st_dev, index_artery_to_center,dist_artery] = calc_mean_radii(centers, artery, centerline_lengths)
center_length = size(centers,1);
centerline_lengths1 = cumsum(centerline_lengths);
% distance and index to closest centerline point for each artery point
[dist_artery(4,:), index_center_to_artery] = pdist2(centers,artery,'euclidean','SMALLEST',1);
index_center_to_artery = index_center_to_artery'; 

% index of artery points belonging to each centerline point
index_artery_to_center = get_index(index_center_to_artery,center_length);

% average after expansion
average = zeros(center_length,4);
st_dev = zeros(size(centers,1),4);
dist_artery = dist_artery';
for i=1:center_length
    % number of artery points belonging to center point i
    num = sum(index_artery_to_center(i,:)~=0);
    % distances from point i to artery points
    dists = dist_artery(index_artery_to_center(i,1:num),4);
    average(i,4) = sum(dists)/num;
    st_dev(i,4) = std(dists);
end;

for i = 1:3
	average(1:centerline_lengths(i+1),i) = average(centerline_lengths1(i):centerline_lengths1(i+1)-1,4);            
    index_artery_to_center(1:centerline_lengths(i+1),:) = index_artery_to_center(centerline_lengths1(i):centerline_lengths1(i+1)-1,:);            
    dist_artery(1:centerline_lengths(i+1),i) = dist_artery(centerline_lengths1(i):centerline_lengths1(i+1)-1,4);            
end

% in case NAN appear
% for i=2:size(centers,1)-1
%     if isnan(average(i))
%         average(i) = mean(average(find(~(isnan(average(1:i))),1,'last')), find(~(isnan(average(i:size(average,1)))),1,'first'));
%     end;
% end;