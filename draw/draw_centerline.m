function draw_centerline(centerlineObj)
%stars
% for i = 1:3
%     plot3(centerlineObj(i).coords(:,1),centerlineObj(i).coords(:,2),centerlineObj(i).coords(:,3),'*-', 'LineWidth', 1); hold on;
% end
%simple
for i = 1:3
    plot3(centerlineObj(i).coords(:,1),centerlineObj(i).coords(:,2),centerlineObj(i).coords(:,3),'LineWidth', 1, 'Color', 'b'); hold on;
end