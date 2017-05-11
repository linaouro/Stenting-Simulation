function [centerline] = get_centerlines(filename1, filename2)
    [coords1, tangents1]= read_path( filename1 );
    [coords2, tangents2]= read_path( filename2 );
    
    [~,bif1,bif2] = intersect(coords1,coords2,'rows');
   
    %% TODO: Remember that coords2(bif2,:) bzw coords1(bif1) is the bifurcation point
    if bif1 == 1
       centerline(1) = Centerline(coords1(2:end,:), tangents1(2:end,:)); % right
       centerline(2) = Centerline(coords2(bif2+1:end,:),tangents2(bif2+1:end,:)); % left
       centerline(3) = Centerline(coords2(1:bif2-1,:), tangents2(1:bif2-1,:)); % trunk
    else
       centerline(1) = Centerline(coords2(2:end,:), tangents2(2:end,:));
       centerline(2) = Centerline(coords1(bif1+1:end,:),tangents1(bif1+1:end,:));
       centerline(3) = Centerline(coords1(1:bif1-1,:), tangents1(1:bif1-1,:));    
    end
    centerline(4) = Centerline([centerline(1).coords; centerline(2).coords; centerline(3).coords],[centerline(1).tangents; centerline(2).tangents; centerline(3).tangents]);