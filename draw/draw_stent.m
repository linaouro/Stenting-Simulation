function draw_stent(stentObj,c)
global n_circ;
for j = 1:3
    for i = 0:stentObj(j).centerline.len-1
        line(stentObj(j).vertices(i*n_circ+1:i*n_circ+n_circ,1), stentObj(j).vertices(i*n_circ+1:i*n_circ+n_circ,2), stentObj(j).vertices(i*n_circ+1:i*n_circ+n_circ,3),  'LineWidth',1,'Color', c); hold on;
    end;
end