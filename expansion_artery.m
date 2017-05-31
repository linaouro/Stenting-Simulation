function [arteryObj, stentObj] =  expansion_artery( arteryObj, stentObj, radius_final) 
global n_circ;

% Step size
steps = 10;

%TODO something is very wrong here with the indices, maybe start over!
%% Initialization of scaling parameters
% go through stent vertices
for i = 1:1%3
    radius_curr = mean(stentObj(i).radius_avg);
    d = (radius_final(i)-mean(radius_curr))/steps;
    % artery vertices in vicinity of stentObj i
    %arteryObj.vertices = arteryObj.vertices(stentObj(i).centerline.index_artery_to_center(stentObj(i).centerline.index_artery_to_center~=0),:);
    [~, index_stent_to_artery] = pdist2( stentObj(i).vertices, arteryObj.vertices,'euclidean','SMALLEST',1);
    index_artery_to_stent = get_index(index_stent_to_artery',size(stentObj(i).vertices,1))  ;                 
    for s=1:steps+5 %TODO change this condition
        for ii = 1:stentObj(i).centerline.len
            idx = (ii-1)*n_circ+1:(ii)*n_circ;
            radius_avg_curr = mean(stentObj(i).radius(idx));
            if radius_avg_curr < radius_final(i)
                    nn = double(stentObj(i).radius(idx) < stentObj(i).radius_artery(idx));
                    nn(nn==0)=0.3;
                    stentObj(i).vertices(idx,:)= stentObj(i).vertices(idx,:)+d*nn.*normr(stentObj(i).vertices(idx,:)-stentObj(i).centerline.coords(ii,:));
                    stentObj(i).radius(idx,:)= stentObj(i).radius(idx,:)+d*nn;   
                    idx_a_t_s = index_artery_to_stent(idx,:);
                    mm = stentObj(i).radius(index_stent_to_artery(idx_a_t_s(idx_a_t_s~=0))) > arteryObj.dist_to_center(idx_a_t_s(idx_a_t_s~=0),4);
                    [~, idx_c_t_a] = pdist2( stentObj(i).centerline.coords, arteryObj.vertices(mm,:),'euclidean','SMALLEST',1);
                    %arteryObj.vertices(mm,:) = arteryObj.centerline(i).coords(idx_c_t_a,:)+stentObj(i).radius(idx_c_t_a).* normc(arteryObj.vertices(mm,:) - arteryObj.centerline(i).coords(idx_c_t_a,:));
                    scatter3(arteryObj.vertices(mm,1),arteryObj.vertices(mm,2),arteryObj.vertices(mm,3));
            end                
        end
  
    end
    % update artery vertices
    %arteryObj.vertices(stentObj(i).centerline.index_artery_to_center(stentObj(i).centerline.index_artery_to_center~=0),:) = arteryObj.vertices;
        
end
hold on; draw_stent(stentObj, 'r');

%TODO add that artery expands also in direction radial

