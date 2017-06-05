addpath(genpath('draw/'))
addpath(genpath('geom3d/'))
global n_circ ;
n_circ =50;
%% 1. Artery setup
%arteryObj = Artery('test_artery.stl','test_path1.pth', 'test_path2.pth');

% display artery, centerline and stenoses
f=draw_artery(arteryObj);
hold on;
draw_centerline(arteryObj.centerline)
draw_stenoses(arteryObj.stenosis);
%saveas(f, 'StenosesArt.png')

% for debugging: check if closest points are realistic
%draw_closest_points(arteryObj.centerline(1).coords,arteryObj.vertices, arteryObj.centerline(1).index_artery_to_center,1);

%% 2. Stent setup 
% set stent lenghts automatically
stent_idx(3) = min(arteryObj.centerline(3).len,max(round(0.5*arteryObj.centerline(3).len),round(1.1*arteryObj.stenosis(3).index)));
stent_idx(2) = min(arteryObj.centerline(2).len,round(1.5*arteryObj.stenosis(2).index));
stent_idx(1) = min(arteryObj.centerline(1).len,round(1.5*arteryObj.stenosis(1).index));
stent_params = [string('stent_foreshortening_branches2.csv');string('stent_foreshortening_branches2.csv');string('stent_foreshortening_branches1.csv')];
stent_radii = [0.3, 0.3, 0.65];

% create final stent
stentFinal = Stent(stent_params, arteryObj.centerline, stent_radii, stent_idx);

% create initial stent
[stentInitial] = initial_stent_from_final(arteryObj, stentFinal);
stentInitial = set_stent_artery_radii(arteryObj, stentInitial);

% draw artery and inital stent
f=draw_artery_stents(arteryObj, stentInitial);
%saveas(f,'InitialArtStent.png')

% draw artery and final stent
f=draw_artery_stents(arteryObj, stentFinal);
%saveas(f,'FinalArtStent.png')

%% 3. Intervention
% create expanded artery
[arteryObj_new, stentExp] =  expansion_artery( arteryObj,stentInitial, [0.4, 0.4, 0.65]);
%a = arteryObj_new.vertices;
arteryObj_new=smoothpatch(arteryObj_new,1,1,1,1);    
%distance = norm(a-arteryObj_new.vertices)

% draw expanded artery
f=draw_artery(arteryObj_new);
%saveas(f,'ExpandArt.png')

% draw expanded artery and stent
stentY= connect_stents(stentExp);
f=draw_artery_stents(arteryObj_new, stentY);
%saveas(f,'ExpandArtStent.png')


% possibly smoothing with smooth3