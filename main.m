%% 1. Artery setup
arteryObj = Artery('test_artery.stl','test_path1.pth', 'test_path2.pth');
% display artery
draw_artery(arteryObj);
hold on;
% display centerline
draw_centerline(arteryObj.centerline)

% for debugging: check if closest points are realistic
% draw_closest_points(arteryObj.centerline.coords,arteryObj.vertices, arteryObj.centerline.index_artery_to_center,79);

%% 2. Stent setup 
stentObj = Stent('s_stent.obj','stent_foreshortening.csv');

%% 3. Intervention
% stent expansion and foreshortening

% possibly smoothing with smooth3