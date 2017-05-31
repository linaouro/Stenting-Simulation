function draw_stenoses(stenoses)

for i=1:size(stenoses,2)
    scatter3(stenoses(i).coords(1), stenoses(i).coords(2), stenoses(i).coords(3),5, 'c');
    hold on;
end