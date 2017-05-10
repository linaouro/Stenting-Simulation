function [left_coords, right_coords, trunk_coords, left_tangents, right_tangents, trunk_tangents] = get_centerlines(filename1, filename2)
    [coords1, tangents1]= read_path( filename1 );
    [coords2, tangents2]= read_path( filename2 );
    
    [~,bif1,bif2] = intersect(coords1,coords2,'rows');
    
    if bif1 == 1
       left_coords = coords1(2:end,:); 
       left_tangents = tangents1(2:end,:);
       right_coords = coords2(bif2+1:end,:);
       right_tangents = tangents2(bif2+1:end,:);
       trunk_coords = coords2(1:bif2,:);
       trunk_tangents = coords2(1:bif2,:);
    else
       left_coords = coords2(2:end,:); 
       left_tangents = tangents2(2:end,:);
       right_coords = coords1(bif1+1:end,:);
       right_tangents = tangents1(bif1+1:end,:);
       trunk_coords = coords1(1:bif1,:);
       trunk_tangents = coords1(1:bif1,:);
        
    end