addpath('draw/')
%% 1. Artery setup
%arteryObj = Artery('test_artery.stl','test_path1.pth', 'test_path2.pth');
%load('arteryObj_HSJ003.mat');
% display artery
draw_artery(arteryObj);
hold on;
% display centerline
draw_centerline(arteryObj.centerline)

% for debugging: check if closest points are realistic
% draw_closest_points(arteryObj.centerline.coords,arteryObj.vertices, arteryObj.centerline.index_artery_to_center,79);

%% 2. Stent setup 
% set stent lenghts automatically
%stent_idx_trunk = [max(1,arteryObj.stenosis(3).index-1/6*(arteryObj.centerline(3).len-arteryObj.stenosis(3).index)),arteryObj.centerline(3).len];
stent_idx_trunk = [1,min(arteryObj.centerline(3).len,uint8(1.5*arteryObj.stenosis(3).index))];
stent_idx_left = [1,min(arteryObj.centerline(2).len,uint8(1.5*arteryObj.stenosis(2).index))];
stent_idx_right = [1,min(arteryObj.centerline(1).len,uint8(1.5*arteryObj.stenosis(1).index))];

stentY(3) = Stent('s_stent.obj','stent_foreshortening_trunk.csv', arteryObj.centerline(3).coords, arteryObj.centerline(3).tangents, 1.3,stent_idx_trunk);
stentY(2) = Stent('s_stent.obj','stent_foreshortening_branches1.csv', arteryObj.centerline(2).coords, arteryObj.centerline(2).tangents, 0.6,stent_idx_left);
stentY(1) = Stent('s_stent.obj','stent_foreshortening_branches1.csv', arteryObj.centerline(1).coords, arteryObj.centerline(1).tangents, 0.6, stent_idx_right);

[stentInitial] = initial_stent_from_final(arteryObj, stentY);

%% 3. Intervention
% draw stenoses
draw_stenoses(arteryObj.stenosis);
draw_stent(stentY,50, 'k')
draw_stent(stentInitial,50, 'c')
% stent expansion and foreshortening

% final stent
% arteryObj.set_stents();
% possibly smoothing with smooth3