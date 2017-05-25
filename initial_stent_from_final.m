function [stentObj] = initial_stent_from_final(arteryObj, stentObj)
% initial radius is radius of trunk

for i = 1:3 
    scale = interp1(stentObj(i).params(:,1), stentObj(i).params(:,2), stentObj(i).radius_avg*2,'linear','extrap') ; % initial radius * 2 /2 -> params are lumen
    if isnan(scale) || scale > 1 
        scale = 1;
    elseif scale < 0
            scale = 0.1;
    end
    scale = 1 / scale;
    initial_length = min(arteryObj.centerline(i).len, round(scale*stentObj(i).centerline.len));
    stentObj(i) = Stent(stentObj(i).filename_params, arteryObj.centerline(i), stentObj(i).params(1,1)/2, initial_length);
end