addpath('draw/')
addpath('geom3d/')
%% 1. Artery setup
%arteryObj = Artery('test_artery.stl','test_path1.pth', 'test_path2.pth');

% display artery, centerline and stenoses
figure;
draw_artery(arteryObj);
hold on;
draw_centerline(arteryObj.centerline)
draw_stenoses(arteryObj.stenosis);

% for debugging: check if closest points are realistic
%draw_closest_points(arteryObj.centerline(1).coords,arteryObj.vertices, arteryObj.centerline(1).index_artery_to_center,1);

%% 2. Stent setup 
% set stent lenghts automatically
stent_idx_trunk = min(arteryObj.centerline(3).len,uint8(1.5*arteryObj.stenosis(3).index));
stent_idx_left = min(arteryObj.centerline(2).len,uint8(1.5*arteryObj.stenosis(2).index));
stent_idx_right = min(arteryObj.centerline(1).len,uint8(1.5*arteryObj.stenosis(1).index));

% create final stent
stentY(3) = Stent('stent_foreshortening_branches1.csv', arteryObj.centerline(3), 0.65,stent_idx_trunk);
stentY(2) = Stent('stent_foreshortening_branches2.csv', arteryObj.centerline(2), 0.3,stent_idx_left);
stentY(1) = Stent('stent_foreshortening_branches2.csv', arteryObj.centerline(1), 0.3, stent_idx_right);

% create initial stent
[stentInitial] = initial_stent_from_final(arteryObj, stentY);

% draw artery and inital stent
draw_artery(arteryObj);
hold on;
drawMesh(stentInitial(1).vertices, stentInitial(1).faces, 'FaceColor', 'w');
drawMesh(stentInitial(3).vertices, stentInitial(3).faces, 'FaceColor', 'w');
drawMesh(stentInitial(2).vertices, stentInitial(2).faces, 'FaceColor', 'w');

% draw artery and final stent
figure;
draw_artery(arteryObj); hold on;
drawMesh(stentY(1).vertices, stentY(1).faces, 'FaceColor', 'w');
drawMesh(stentY(3).vertices, stentY(3).faces, 'FaceColor', 'w');
drawMesh(stentY(2).vertices, stentY(2).faces, 'FaceColor', 'w');

%% 3. Intervention
% create expanded artery
arteryObj_new = arteryObj;
arteryObj_new.vertices = set_artery_to_stent(arteryObj_new.vertices, arteryObj_new.dist_to_center(:,4), stentY);

%draw expanded artery
figure
draw_artery(arteryObj_new)
hold on

% possibly smoothing with smooth3