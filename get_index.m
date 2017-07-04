function index = get_index(index_closest,size_spline)
% function that returns an array of indices (of artery points) belonging to each spline point

% occ counts how many points belong to one spline point
occ = zeros(size(index_closest,1),1);
for i=1:size(index_closest,1)
    occ(i)=sum(index_closest(:,1) == index_closest(i,1));
end;

n = max(occ);

index = zeros(size_spline,n);
for i =1:size(index_closest,1)
    if index_closest(i,1) ~=0
        index(index_closest(i,1),1+sum(index(index_closest(i,1),:)~=0))= i;
    end
end;
