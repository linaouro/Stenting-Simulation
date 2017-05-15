function [stentObj] = initial_stent_from_final(arteryObj, stentObj)
% initial radius is radius of trunk

for i = 1:3 
    scale = interp1(stentObj(i).params(:,1), stentObj(i).params(:,2), stentObj(i).radius*2,'linear','extrap') ; % initial radius * 2 /2 -> params are lumen
    if isnan(scale) || scale > 1 
        scale = 1;
    elseif scale < 0
            scale = 0.1;
    end
    scale = 1 / scale;
    initial_length = min(arteryObj.centerline(i).len, round(scale*stentObj(i).centerline.len));
    stentObj(i).centerline = Centerline(arteryObj.centerline(i).coords(1:initial_length,:), arteryObj.centerline(i).tangents(1:initial_length,:));
    stentObj(i).vertices = initial_alignment(stentObj(i).centerline, stentObj(i).params(1,1)/2, 50);
    stentObj(i).faces = triangulate_stent(stentObj(i).vertices,50);
end