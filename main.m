addpath(genpath('draw/'))
addpath(genpath('geom3d/'))
addpath(genpath('stlwrite/'))
addpath(genpath('smoothpatch_version1b/'))

global n_circ;
n_circ = 20;
%% 1. Artery setup
arteryObj = Artery('test_artery.stl','test_path1.pth', 'test_path2.pth');

% display artery, centerline and stenoses
f=draw_artery(arteryObj);
%saveas(f, 'images/01_InitialArt.png')
hold on;
draw_centerline(arteryObj.centerline)
draw_stenoses(arteryObj.opening);


% for debugging: check if closest points are realistic
%draw_closest_points(arteryObj.centerline(1).coords,arteryObj.vertices, arteryObj.centerline(1).index_artery_to_center,1);

%% 2. Stent setup 
% set stent lenghts automatically

% create initial stent
[stentInitial] = initial_stent_from_final(arteryObj);
stentInitial = set_stent_artery_radii(arteryObj, stentInitial);

% draw artery and inital stent
f1=draw_artery_real_stents(arteryObj, (stentInitial));
%saveas(f,'images/03_InitialArtStent.png')

% draw artery and final stent
%f=draw_artery_stents(arteryObj, (stentFinal));
%saveas(f,'images/04_FinalArtStent.png')

%% 3. Intervention
% create expanded artery
%[arteryObj_new, stentExp] =  expansion_artery( arteryObj,stentInitial, arteryObj.final_radii,1,0);%expansion_artery_video( arteryObj,stentInitial, stent_radii,0.6);
[arteryObj_new, stentExp] =  expansion_artery( arteryObj,stentInitial, arteryObj.final_radii,1);%expansion_artery_video( arteryObj,stentInitial, stent_radii,0.6);

%a = arteryObj_new.vertices;
    
%distance = norm(a-arteryObj_new.vertices)

% draw expanded artery and stent
arteryObj_new=smoothpatch(arteryObj_new,1,1,0.5,1);
figure
f1 = draw_artery_real_stents(arteryObj_new, stentExp);
%saveas(f,'images/06_ExpandArtStent.png')

% figure
% hold on
% for i =1:3  
%     scatter3(arteryObj.vertices(arteryObj.centerline(i).index_artery_to_center(arteryObj.centerline(i).index_artery_to_center~=0),1),arteryObj.vertices(arteryObj.centerline(i).index_artery_to_center(arteryObj.centerline(i).index_artery_to_center~=0),2),arteryObj.vertices(arteryObj.centerline(i).index_artery_to_center(arteryObj.centerline(i).index_artery_to_center~=0),3));
% end


%TODO: include if initial stent is longer than centerline -> extrapolate
%centerline 