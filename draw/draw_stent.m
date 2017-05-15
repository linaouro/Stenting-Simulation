function draw_stent(stentObj,n, c)
for j = 1:3
    for i = 0:stentObj(j).centerline.len-1
        line(stentObj(j).vertices(i*n+1:i*n+n,1), stentObj(j).vertices(i*n+1:i*n+n,2), stentObj(j).vertices(i*n+1:i*n+n,3),  'LineWidth',1,'Color', c); hold on;
    end;
end