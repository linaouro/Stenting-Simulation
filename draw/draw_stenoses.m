function draw_stenoses(stenoses)

for i=1:3
    scatter3(stenoses(i).coords(1), stenoses(i).coords(2), stenoses(i).coords(3),5, 'c');
    hold on;
end