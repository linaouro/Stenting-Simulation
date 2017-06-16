function  draw_real_stent(stentObj)
stentObj = get_real_stent(stentObj);
% for i = 1:1%size(stentObj,2)
%     trisurf(stentObj(i).faces_real,stentObj(i).vertices_real(:,1), stentObj(i).vertices_real(:,2),stentObj(i).vertices_real(:,3),...
%     'FaceColor', [0.8784 0.8785 0.8588], ...
%     'FaceAlpha', 1, ...
%     'EdgeColor', 'none', ...
%     'EdgeAlpha', 0);
%  hold on;
% end
for i = 1:3
        p = patch('faces', stentObj(i).faces_real, 'vertices' ,stentObj(i).vertices_real);
        set(p, 'facec', [0.8784 0.8785 0.8588]);              % Set the face color (force it)
        set(p, 'facealpha',1)             % Use for transparency
        set(p, 'EdgeColor','none');         % Set the edge color
        %set(p, 'EdgeColor',[1 0 0 ]);      % Use to see triangles, if needed.
        light('Position',[-1.0,-1.0,100.0],'Style','infinite');
        lighting gouraud;
        axis equal;
        daspect([1 1 1])                    % Setting the aspect ratio
        view([60 130])                      
        xlabel('X'),ylabel('Y'),zlabel('Z')
        drawnow                             %, axis manual
end
% idx = [1,448; 449, 1368; 1369, 2293; 2294, 3221; 3222, 4149; 4150, 5076; 5077, 6004; 6005,6932; 6933, 7380];
% 
% 
% for j = 1:3
%     stent_V_new = stent_V_sort;
%     stent_V_new(:,3) = (stent_V_new(:,3))/0.2750;
%     stent_V_new(:,1) = (stent_V_new(:,1))/0.2750;
%     idx_center = round(idx(:,2)/7380 *stentObj(j).centerline.len);
%     for i =1:9
%         stent_V_new(idx(i,1):idx(i,2),2) = stent_V_new(idx(i,1):idx(i,2),2)-mean(stent_V_new(idx(i,1):idx(i,2),2));
%         lx = stent_V_new(idx(i,1):idx(i,2),1);%*stentObj(j).radius_avg;
%         lz = stent_V_new(idx(i,1):idx(i,2),2);
%         ly = stent_V_new(idx(i,1):idx(i,2),3);%;*stentObj(j).radius_avg;
%         [theta, phi, ~] = cart2sph2d(stentObj(j).centerline.tangents(idx_center(i),:));
%         trans   = localToGlobal3d(stentObj(j).centerline.coords(idx_center(i),:), theta, phi, 0);
%         trans = trans*[stentObj(j).radius_avg 0 0 0; 0 stentObj(j).radius_avg 0 0; 0 0 1 0; 0 0 0 1];
%         [stent_V_new(idx(i,1):idx(i,2),1), stent_V_new(idx(i,1):idx(i,2),2), stent_V_new(idx(i,1):idx(i,2),3)] = transformPoint3d(lx, ly, lz, trans);
% 
%     end
%     drawStent(stent_V_new, stent_F_sort);
%     %scatter3(stent_V_new(:,1),stent_V_new(:,2),stent_V_new(:,3)); hold on;
%     
% end

% idx = [1,448; 449, 1368; 1369, 2293; 2294, 3221; 3222, 4149; 4150, 5076; 5077, 6004; 6005,6932; 6933, 7380];
% 
% draw_artery(arteryObj_new); hold on;
% stent_V_begin =[(stent_V_sort(1:448,1))/0.2750, stent_V_sort(1:448,2)-mean(stent_V_sort(1:448,2)), (stent_V_sort(1:448,3))/0.2750];
% stent_V_center = [(stent_V_sort(449:1368,1))/0.2750, stent_V_sort(449:1368,2)-mean(stent_V_sort(449:1368,2)), (stent_V_sort(449:1368,3))/0.2750];
% stent_V_end =[(stent_V_sort(6933:7380,1))/0.2750, stent_V_sort(6933:7380,2)-mean(stent_V_sort(6933:7380,2)), (stent_V_sort(6933:7380,3))/0.2750];
% 
% n_rows = 9;
% for j = 1:3
%     [theta, phi, ~] = cart2sph2d(arteryObj.centerline(j).tangents(1,:));
%     trans   = localToGlobal3d(stentObj(j).centerline.coords(1,:), theta, phi, 0)*[stentObj(j).radius_avg 0 0 0; 0 stentObj(j).radius_avg 0 0; 0 0 1 0; 0 0 0 1];
%     [stent_V_new(1:448,1), stent_V_new(1:448,2), stent_V_new(1:448,3)] = transformPoint3d(stent_V_begin(:,1), stent_V_begin(:,2), stent_V_begin(:,3), trans);
% 
%     
%     for i =2:n_rows-1
%         [theta, phi, ~] = cart2sph2d(arteryObj.centerline(j).tangents(round((448+920*(i-1))/((448*2+(n_rows-2)*920))*stentObj(j).centerline.len),:));
%         trans   = localToGlobal3d(stentObj(j).centerline.coords(round((448+920*(i-1))/((448*2+(n_rows-2)*920))*stentObj(j).centerline.len),:), theta, phi, 0);
%         trans = trans*[stentObj(j).radius_avg 0 0 0; 0 stentObj(j).radius_avg 0 0; 0 0 1 0; 0 0 0 1];
%         [stent_V_new(end:end+919,1), stent_V_new(end:end+919,2), stent_V_new(end:end+919,3)] = transformPoint3d(stent_V_center(:,1), stent_V_center(:,2), stent_V_center(:,3), trans);
%     end
%     
%     [theta, phi, ~] = cart2sph2d(arteryObj.centerline(j).tangents(end,:));
%     trans   = localToGlobal3d(stentObj(j).centerline.coords(end,:), theta, phi, 0)*[stentObj(j).radius_avg 0 0 0; 0 stentObj(j).radius_avg 0 0; 0 0 1 0; 0 0 0 1];
%     [stent_V_new(end:end+447,1), stent_V_new(end:end+447,2), stent_V_new(end:end+447,3)] = transformPoint3d(stent_V_end(:,1), stent_V_end(:,2), stent_V_end(:,3), trans);
% 
%     drawStent(stent_V_new, stent_F_sort);
%     %scatter3(stent_V_new(:,1),stent_V_new(:,2),stent_V_new(:,3)); hold on;
%     
% end
