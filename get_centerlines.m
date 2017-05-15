function [centerline] = get_centerlines(filename1, filename2)
    [coords1, ~]= read_path( filename1 );
    [coords2, ~]= read_path( filename2 );
    
    [~,bif,bif2] = intersect(coords1,coords2,'rows');

    if bif == 1 
        bif = bif2;
    else
        coords = coords1;
        coords1 = coords2;
        coords2 = coords;
%         tangents = tangents1;
%         tangents1 = tangents2;
%         tangents2 = tangents;
    end
%% each centerline only few points around bifurcation
%     [c,t,~] = interparc(5,coords1(1:3,1),coords1(1:3,2),coords1(1:3,3));
%     centerline(1) = Centerline([c;coords1(4:end,:)], [t;tangents1(4:end,:)]); % right
%     [c,t,~]= interparc(11,coords2(bif-1:bif+1,1),coords2(bif-1:bif+1,2),coords2(bif-1:bif+1,3));
%     centerline(2) = Centerline([c(6:end,:);coords2(bif:end,:)],[t(6:end,:);tangents2(bif:end,:)]); % left
%     centerline(3) = Centerline([coords2(1:bif-5,:);c(1:6,:)], [tangents2(1:bif,:);t(1:6,:)]); % trunk

%% each centerline single up to bifurcation
    [coords,tangents,~] = interparc(size(coords1,1),coords1(:,1),coords1(:,2),coords1(:,3));
    centerline(1) = Centerline(coords,tangents); % right
    [coords,tangents,~]= interparc(size(coords2(bif:end,:),1),coords2(bif:end,1),coords2(bif:end,2),coords2(bif:end,3));
    centerline(2) = Centerline(coords,tangents); % left
    [coords,tangents,~]= interparc(size(coords2(1:bif,:),1),coords2(1:bif,1),coords2(1:bif,2),coords2(1:bif,3));
    centerline(3) = Centerline(coords(end:-1:1,:),tangents(end:-1:1,:)); % trunk

% %% two big centerlines plus trunk
%     [coords,tangents,~] = interparc(size(coords1,1)+size(coords2(1:bif-1,:),1),[coords2(1:bif-1,1);coords1(:,1)],[coords2(1:bif-1,2);coords1(:,2)],[coords2(1:bif-1,3);coords1(:,3)]);
%     centerline(1) = Centerline(coords,tangents); % right
%     [coords,tangents,~]= interparc(size(coords2,1),coords2(:,1),coords2(:,2),coords2(:,3));
%     centerline(2) = Centerline(coords,tangents); % left
%     %[coords,tangents,~]= interparc(size(coords2(1:bif,:),1),coords2(1:bif,1),coords2(1:bif,2),coords2(1:bif,3));
%     centerline(3) = Centerline(coords2(1:bif-1,:),tangents2(1:bif,:)); % trunk    

    %centerline(1).tangents(1,:) = mean([centerline(1).tangents(1,:); centerline(2).tangents(1,:);centerline(3).tangents(end-1,:)],1);
    %centerline(2).tangents(1,:) = centerline(1).tangents(1,:);
    %centerline(3).tangents(end,:) = centerline(1).tangents(1,:);
    centerline(4) = Centerline([centerline(1).coords(2:end,:); centerline(2).coords(2:end,:); centerline(3).coords],[centerline(1).tangents(2:end,:); centerline(2).tangents(2:end,:); centerline(3).tangents]);