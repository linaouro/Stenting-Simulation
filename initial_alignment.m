function [stent] = initial_alignment(centerline, lumen_stent)
%length_segments = cumsum(seglen(down:up-1));
%length_stent = length_segments(end);
% [up,down,stent_centerline]=createCenterline_new1(centerspline,round((up+down)/2),length_stent,min(stent_V(:,2))*length_stent/(max(stent_V(:,2))-min(stent_V(:,2))),seglen);
% 
% scaleX = lumen_stent/(max(stent_V(:,1))-min(stent_V(:,1)));
% scaleY = length_stent/(max(stent_V(:,2))-min(stent_V(:,2)));%10/(max(stent_V(:,2))-min(stent_V(:,2))); % AGAIN
% scaleZ = lumen_stent/(max(stent_V(:,3))-min(stent_V(:,3)));
% scaling_matrix=[scaleX,0,0;...   % left right -> x
%     0,scaleY,0;...     % length     -> y
%     0,0,scaleZ ...   % up down    -> z
%     ];
% new_stent_V=stent_V*scaling_matrix;
% s_stent_V = new_stent_V;

n = 50;
angles = linspace(0,2*pi,n) ;
circle = [0.5*lumen_stent*cos(angles); zeros(size(angles)) ;  0.5*lumen_stent*sin(angles); ones(size(angles)) ]';
stent = ones(size(circle,1)*size(centerline.coords,1),4);


for i = 0:size(centerline.coords,1)-1
    stent(i*n+1:i*n+n,:) = (get_rot_trans_matrix([0;1;0],centerline.tangents(i+1,:)', centerline.coords(i+1,:)')* circle')';
    line(stent(i*n+1:i*n+n,1), stent(i*n+1:i*n+n,2), stent(i*n+1:i*n+n,3),  'LineWidth',2,'Color', 'k'); hold on;
end;

% 
% for j =1:size(circle,1)
%     cylinder(j,:) = [circle(j,1) 0 circle(j,2)];
% end;
% 
% figure;
% for i = 1:size(length_segments,2)
%     for j =1:size(circle,1)
%         cylinder(i*size(circle,1)+j,:) = [circle(j,1) length_segments(i) circle(j,2)];
%         length_segments(i)
%     end;
%     line(cylinder(i*size(circle,1)+1:i*size(circle,1)+j,1),cylinder(i*size(circle,1)+1:i*size(circle,1)+j,2), cylinder(i*size(circle,1)+1:i*size(circle,1)+j,3),  'LineWidth',2,'Color', 'k'); hold on;
% end;
% 
% 
% 
% % Calculate distance to stent_centerline points: Store minimum distance and corresponding index of centerline for each point
% % [~, index_center] = pdist2(stent_centerline,new_stent_V,'euclidean','SMALLEST',1);
% % index_center = index_center';
% % index_stentCenter= getIndex(index_center, size(stent_centerline,1));
% 
% [~, index_center_cyl] = pdist2(stent_centerline,cylinder,'euclidean','SMALLEST',1);
% index_center_cyl = index_center_cyl';
% index_stentCenter_cyl= getIndex(index_center_cyl, size(stent_centerline,1));
% % calc all tangents and rotation parameters
% p = [t(:,3) zeros(size(t,1),1) -t(:,1)];
% theta = zeros(size(centerline,1),1);
% differ=zeros(size(centerline,1), 3);
% n_cylinder = cylinder;
% % rotate and translate and flex
% for j=down:up
%       theta(j) = acos(t(j,2)*norm(t(j,:)));
%     p(j,:) = p(j,:)/norm(p(j,:));
%     
%     i=j-down+1;
%     
%     [new_stent_V(index_stentCenter(i,1:sum(index_stentCenter(i,:)~=0)),:),stent_centerline(i,:)]=...
%         rotateBoth(centerline(j,:),...
%         p(j,:),...
%         theta(j),...
%         new_stent_V(index_stentCenter(i,1:sum(index_stentCenter(i,:)~=0)),:),...
%         stent_centerline(i,:));
%     
%         [n_cylinder(index_stentCenter_cyl(i,1:sum(index_stentCenter_cyl(i,:)~=0)),:),~]=...
%         rotateBoth(centerline(j,:),...
%         p(j,:),...
%         theta(j),...
%         n_cylinder(index_stentCenter_cyl(i,1:sum(index_stentCenter_cyl(i,:)~=0)),:),...
%         stent_centerline(i,:));
%     
%     differ(j,:) = (centerline(j,:)-stent_centerline(i,:));
%     new_stent_V(index_stentCenter(i,1:sum(index_stentCenter(i,:)~=0)),1)=new_stent_V(index_stentCenter(i,1:sum(index_stentCenter(i,:)~=0)),1)+differ(j,1);
%     new_stent_V(index_stentCenter(i,1:sum(index_stentCenter(i,:)~=0)),2)=new_stent_V(index_stentCenter(i,1:sum(index_stentCenter(i,:)~=0)),2)+differ(j,2);
%     new_stent_V(index_stentCenter(i,1:sum(index_stentCenter(i,:)~=0)),3)=new_stent_V(index_stentCenter(i,1:sum(index_stentCenter(i,:)~=0)),3)+differ(j,3);
%     n_cylinder(index_stentCenter_cyl(i,1:sum(index_stentCenter_cyl(i,:)~=0)),1)=n_cylinder(index_stentCenter_cyl(i,1:sum(index_stentCenter_cyl(i,:)~=0)),1)+differ(j,1);
%     n_cylinder(index_stentCenter_cyl(i,1:sum(index_stentCenter_cyl(i,:)~=0)),2)=n_cylinder(index_stentCenter_cyl(i,1:sum(index_stentCenter_cyl(i,:)~=0)),2)+differ(j,2);
%     n_cylinder(index_stentCenter_cyl(i,1:sum(index_stentCenter_cyl(i,:)~=0)),3)=n_cylinder(index_stentCenter_cyl(i,1:sum(index_stentCenter_cyl(i,:)~=0)),3)+differ(j,3);
%     stent_centerline(i,:) = stent_centerline(i,:)+differ(j,:);
% end;
% 
% [D,~] = pdist2(n_cylinder,artery_V,'euclidean','SMALLEST',1);%TODO here was new stent V