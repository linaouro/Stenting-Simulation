function draw_centerline(centerlineObj)
plot3(centerlineObj.coords1(:,1),centerlineObj.coords1(:,2),centerlineObj.coords1(:,3), 'Color', 'k');
plot3(centerlineObj.coords2(:,1),centerlineObj.coords2(:,2),centerlineObj.coords2(:,3), 'Color', 'k');
