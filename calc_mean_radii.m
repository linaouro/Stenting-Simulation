function [average, st_dev] = calc_mean_radii(centers, artery,limit)
[dist_artery, index_closestArtery] = pdist2(centers,artery,'euclidean','SMALLEST',1);
index_closestArtery_small = index_closestArtery'; 
index_closestArtery_small(dist_artery > limit) = [];% hier noch entscheiden was man fuer 5 nimmt
dist_artery_small = dist_artery(dist_artery<=limit);
index_artery_small = get_index(index_closestArtery_small,size(centers,1));


% average after expansion
average = zeros(size(centers,1),1);
st_dev = zeros(size(centers,1),1);
dist_artery_small = dist_artery_small';
for i=1:size(centers,1)
    average(i) = 2*sum(dist_artery_small(index_artery_small(i,1:sum(index_artery_small(i,:)~=0)),1))/sum(index_artery_small(i,:)~=0);
    st_dev(i) = std(dist_artery_small(index_artery_small(i,1:sum(index_artery_small(i,:)~=0)),1));
end;
for i=2:size(centers,1)-1
    if isnan(average(i))
        average(i) = mean(average(find(~(isnan(average(1:i))),1,'last')), find(~(isnan(average(i:size(average,1)))),1,'first'));
    end;
end;
% average1 = zeros(size(centerspline,1),1);
% average1(1) = (average(1)+average(2))/2;
% average1(size(average,1)) = (average(size(average,1))+average(size(average,1)-1))/2;
% for i=2:size(centerspline,1)-1
%     average1(i) = (average(i-1)+average(i+1))/2;
% end;
% average = average1;