%% 1. Read in artery.stl (and possibly display)
[faces, vertices, ~] = read_stl('test.stl', true);

%% 2. Read in stent
[stent_V,stent_F] = read_vertices_and_faces_from_obj_file('s_stent.obj', false);

%%