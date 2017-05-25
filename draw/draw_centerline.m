function draw_centerline(centerlineObj)
for i = 1:3
    plot3(centerlineObj(i).coords(:,1),centerlineObj(i).coords(:,2),centerlineObj(i).coords(:,3), 'Color', 'y'); hold on;
end
