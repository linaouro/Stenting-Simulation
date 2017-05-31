addpath('draw/')
addpath('geom3d/')
global n_circ ;
n_circ =50;
%% 1. Artery setup
arteryObj = Artery('test_artery.stl','test_path1.pth', 'test_path2.pth');

% display artery, centerline and stenoses
figure;
draw_artery(arteryObj);
hold on;
draw_centerline(arteryObj.centerline)
draw_stenoses(arteryObj.stenosis);
draw_stenoses(arteryObj.opening);

% for debugging: check if closest points are realistic
%draw_closest_points(arteryObj.centerline(1).coords,arteryObj.vertices, arteryObj.centerline(1).index_artery_to_center,1);

%% 2. Stent setup 
% set stent lenghts automatically
stent_idx_trunk = min(arteryObj.centerline(3).len,max(round(0.5*arteryObj.centerline(3).len),round(1.3*arteryObj.stenosis(3).index)));
stent_idx_left = min(arteryObj.centerline(2).len,round(1.5*arteryObj.stenosis(2).index));
stent_idx_right = min(arteryObj.centerline(1).len,round(1.5*arteryObj.stenosis(1).index));

% create final stent
stentFinal(3) = Stent('stent_foreshortening_branches1.csv', arteryObj.centerline(3),  ones(stent_idx_trunk,1)*0.65,stent_idx_trunk);
stentFinal(2) = Stent('stent_foreshortening_branches2.csv', arteryObj.centerline(2), ones(stent_idx_left,1)*0.3,stent_idx_left);
stentFinal(1) = Stent('stent_foreshortening_branches2.csv', arteryObj.centerline(1), ones(stent_idx_right,1)*0.3, stent_idx_right);

stentY = Stent();
stentY.vertices = [stentFinal(3).vertices; stentFinal(2).vertices; stentFinal(1).vertices];
stentY.faces = [stentFinal(3).faces; stentFinal(2).faces+size(stentFinal(3).vertices,1); stentFinal(1).faces+size(stentFinal(3).vertices,1)+size(stentFinal(2).vertices,1)];
% OR: average radii; TODO give maximum radius
% stentFinal(3) = Stent('stent_foreshortening_branches1.csv', arteryObj.centerline(3),  arteryObj.radii_avg(:,3),stent_idx_trunk);
% stentFinal(2) = Stent('stent_foreshortening_branches2.csv', arteryObj.centerline(2), arteryObj.radii_avg(:,2),stent_idx_left);
% stentFinal(1) = Stent('stent_foreshortening_branches2.csv', arteryObj.centerline(1), arteryObj.radii_avg(:,1), stent_idx_right);


% create initial stent
[stentInitial] = initial_stent_from_final(arteryObj, stentFinal);
stentInitial = set_stent_artery_radii(arteryObj, stentInitial);


% draw artery and inital stent
draw_artery(arteryObj);
hold on;
drawMesh(stentInitial(1).vertices, stentInitial(1).faces, 'FaceColor', 'w','facealpha',.1);
drawMesh(stentInitial(3).vertices, stentInitial(3).faces, 'FaceColor', 'w','facealpha',.1);
drawMesh(stentInitial(2).vertices, stentInitial(2).faces, 'FaceColor', 'w','facealpha',.1);

% draw artery and final stent
figure;
draw_artery(arteryObj); hold on;
drawMesh(stentFinal(1).vertices, stentFinal(1).faces, 'FaceColor', 'w','facealpha',.1);
drawMesh(stentFinal(3).vertices, stentFinal(3).faces, 'FaceColor', 'w','facealpha',.1);
drawMesh(stentFinal(2).vertices, stentFinal(2).faces, 'FaceColor', 'w','facealpha',.1);

%% 3. Intervention
% create expanded artery
[arteryObj_new, stentExp] =  expansion_artery( arteryObj,stentInitial, [0.3, 0.3, 0.65]);
%arteryObj_new.vertices = set_artery_to_stent(arteryObj_new.vertices, arteryObj_new.dist_to_center(:,4), stentExp);

%draw expanded artery
figure
draw_artery(arteryObj_new)
hold on

figure;
draw_artery(arteryObj_new); hold on;
drawMesh(stentExp(1).vertices, stentExp(1).faces, 'FaceColor', 'w','facealpha',.0);
drawMesh(stentExp(3).vertices, stentExp(3).faces, 'FaceColor', 'w','facealpha',.0);
drawMesh(stentExp(2).vertices, stentExp(2).faces, 'FaceColor', 'w','facealpha',.0);


% possibly smoothing with smooth3