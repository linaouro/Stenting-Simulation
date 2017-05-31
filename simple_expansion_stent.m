function stentObj =  simple_expansion_stent( stentObj, radius_final) 
global n_circ;

% Step size
steps = 5;


%% Initialization of scaling parameters
% go through stent vertices
for i = 1:3
    radius_curr = mean(stentObj(i).radius_avg);
    d = (radius_final(i)-mean(radius_curr))/steps;
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
    end
end
hold on; draw_stent(stentObj, 'r');

%TODO add that artery expands also in direction radial

