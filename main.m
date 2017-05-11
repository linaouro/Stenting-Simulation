addpath('draw/')
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
stentTrunk = Stent('s_stent.obj','stent_foreshortening.csv', arteryObj.centerline(3).coords, arteryObj.centerline(3).tangents, 0.5);
stentLeft = Stent('s_stent.obj','stent_foreshortening.csv', arteryObj.centerline(2).coords, arteryObj.centerline(2).tangents, 0.2);
stentRight = Stent('s_stent.obj','stent_foreshortening.csv', arteryObj.centerline(1).coords, arteryObj.centerline(1).tangents, 0.2);

%% 3. Intervention
% draw stenoses
draw_stenoses(arteryObj.stenosis);

% stent expansion and foreshortening

% final stent
%arteryObj.set_stents();
% possibly smoothing with smooth3