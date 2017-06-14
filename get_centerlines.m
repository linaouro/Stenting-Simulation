function [centerline] = get_centerlines(filename1, filename2)
    [coords1, tangents1]= read_path( filename1 );
    [coords2, tangents2]= read_path( filename2 );
    
    [~,bif,bif2] = intersect(coords1,coords2,'rows');

    if bif == 1 
        bif = bif2;
    else
        coords = coords1;
        coords1 = coords2;
        coords2 = coords;
        tangents = tangents1;
        tangents1 = tangents2;
        tangents2 = tangents;
    end
%% simple centerline splitting
%     centerline(1) = Centerline(coords1(2:end,:),tangents1(2:end,:)); % right
%     centerline(2) = Centerline(coords2(bif+1:end,:),tangents2(bif+1:end,:)); % left
%     centerline(3) = Centerline(coords2(bif-1:-1:1,:),tangents2(bif:-1:1,:)); % trunk
    
%     [coords,tangents,~] = interparc(size(coords1,1)-1,coords1(2:end,1),coords1(2:end,2),coords1(2:end,3));
%     centerline(1) = Centerline(coords(2:end,:),tangents(2:end,:)); % right
%     [coords,tangents,~]= interparc(size(coords2(bif+1:end,:),1),coords2(bif+1:end,1),coords2(bif+1:end,2),coords2(bif+1:end,3));
%     centerline(2) = Centerline(coords(2:end,:),tangents(2:end,:)); % left
%     [coords,tangents,~]= interparc(bif+1,coords2(1:bif,1),coords2(1:bif,2),coords2(1:bif,3));
%     centerline(3) = Centerline(coords(end:-1:1,:),tangents(end:-1:1,:)); % trunk    
%     centerline(3).tangents(1,:) = tangents2(end,:);
    
    [coords,tangents,~] = interparc(size(coords1,1)-1,coords1(2:end,1),coords1(2:end,2),coords1(2:end,3));
    centerline(1) = Centerline(coords(1:end,:),tangents(1:end,:)); % right
    [coords,tangents,~]= interparc(size(coords2(bif+1:end,:),1),coords2(bif+1:end,1),coords2(bif+1:end,2),coords2(bif+1:end,3));
    centerline(2) = Centerline(coords(1:end,:),tangents(1:end,:)); % left
    [coords,tangents,~]= interparc(bif+1,coords2(1:bif,1),coords2(1:bif,2),coords2(1:bif,3));
    centerline(3) = Centerline(coords(end:-1:1,:),tangents(end:-1:1,:)); % trunk    
    centerline(3).tangents(1,:) = mean([centerline(3).tangents(1,:); centerline(1).tangents(1,:); centerline(2).tangents(1,:)]);
    
%% each centerline single up to bifurcation only trunk including bifurcation
%     [coords,tangents,~] = interparc(round(size(coords1,1)),coords1(:,1),coords1(:,2),coords1(:,3));
%     centerline(1) = Centerline(coords(2:end,:),tangents(2:end,:)); % right
%     [coords,tangents,~]= interparc(round(size(coords2(bif:end,:),1)),coords2(bif:end,1),coords2(bif:end,2),coords2(bif:end,3));
%     centerline(2) = Centerline(coords(2:end,:),tangents(2:end,:)); % left
%     [coords,tangents,~]= interparc(round(size(coords2(1:bif,:),1)),coords2(1:bif,1),coords2(1:bif,2),coords2(1:bif,3));
%     centerline(3) = Centerline(coords(end:-1:1,:),tangents(end:-1:1,:)); % trunk
%     [coords,tangents,~] = interparc(round(size(coords1,1)),coords1(:,1),coords1(:,2),coords1(:,3));
%     centerline(1) = Centerline(coords(1:end,:),tangents(1:end,:)); % right
%     [coords,tangents,~]= interparc(round(size(coords2(bif:end,:),1)),coords2(bif:end,1),coords2(bif:end,2),coords2(bif:end,3));
%     centerline(2) = Centerline(coords(1:end,:),tangents(1:end,:)); % left
%     [coords,tangents,~]= interparc(round(size(coords2(1:bif,:),1)),coords2(1:bif,1),coords2(1:bif,2),coords2(1:bif,3));
%     centerline(3) = Centerline(coords(end:-1:1,:),tangents(end:-1:1,:)); % trunk

%% each centerline interpolated completely, then split at;
    
%     [coords,tangents,~] = interparc(round(size(coords1,1))+bif-1,[coords2(1:bif-1,1); coords1(:,1)],[coords2(1:bif-1,2); coords1(:,2)],[coords2(1:bif-1,3); coords1(:,3)]);
%     centerline(1) = Centerline(coords(bif-2:end,:),tangents(bif-2:end,:)); % right
%     [coords,tangents,~]= interparc(round(size(coords2,1)),coords2(:,1),coords2(:,2),coords2(:,3));
%     centerline(2) = Centerline(coords(bif-1:end,:),tangents(bif-1:end,:)); % left
%     [coords,tangents,~]= interparc(round(size(coords2(1:bif,:),1)),coords2(1:bif,1),coords2(1:bif,2),coords2(1:bif,3));
%     centerline(3) = Centerline(coords(end:-1:1,:),tangents(end:-1:1,:)); % trunk

    
    

%centerline(4) = Centerline([centerline(1).coords(2:end,:); centerline(2).coords(2:end,:); centerline(3).coords],[centerline(1).tangents(2:end,:); centerline(2).tangents(2:end,:); centerline(3).tangents]);
   
    centerline(4) = Centerline([centerline(1).coords; centerline(2).coords; centerline(3).coords],[centerline(1).tangents; centerline(2).tangents; centerline(3).tangents]);
    %centerline(4) = Centerline([centerline(1).coords(end:-1:1,:); centerline(2).coords(end:-1:1,:); centerline(3)],[centerline(1).tangents(end:-1:1,:); centerline(2).tangents(end:-1:1,:); centerline(3).tangents]);
