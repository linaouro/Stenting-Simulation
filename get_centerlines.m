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
        %tangents = tangents1;
        %tangents1 = tangents2;
        %tangents2 = tangents;
    end

    
    [coords,tangents,~] = interparc(size(coords1,1)-1,coords1(2:end,1),coords1(2:end,2),coords1(2:end,3));
    centerline(1) = Centerline(coords(1:end,:),tangents(1:end,:)); % right
    [coords,tangents,~]= interparc(size(coords2(bif+1:end,:),1),coords2(bif+1:end,1),coords2(bif+1:end,2),coords2(bif+1:end,3));
    centerline(2) = Centerline(coords,tangents); % left
    [coords,tangents,~]= interparc(bif-1,coords2(bif-1:-1:1,1),coords2(bif-1:-1:1,2),coords2(bif-1:-1:1,3));
    centerline(3) = Centerline(coords,tangents); % trunk    
    %centerline(3).tangents(1,:) = mean([ -centerline(1).tangents(1,:); -centerline(2).tangents(1,:)]);
    
    %TODO check what happens if you add the center point of the two first
    %branch points
 
    centerline(4) = Centerline([centerline(1).coords; centerline(2).coords; centerline(3).coords],[centerline(1).tangents; centerline(2).tangents; centerline(3).tangents]);
   