classdef Centerline
    %   Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        coords;
        coords1;
        coords2;
        tangents;
        tangents1;
        tangents2;
        bif1;
        bif2;
        index_artery_to_center;
    end
    
    methods
        function centerlineObj = Centerline(filename1, filename2)
            [centerlineObj.coords1, centerlineObj.tangents1]= read_path( filename1 );
            [centerlineObj.coords2, centerlineObj.tangents2]= read_path( filename2 );
            % read in centerline
            centerlineObj.coords = [centerlineObj.coords1; centerlineObj.coords2(2:end,:)];
            centerlineObj.tangents = [centerlineObj.tangents1; centerlineObj.tangents2(2:end,:)];
            % find bifurcation point
            [~,centerlineObj.bif1,centerlineObj.bif2] = intersect(centerlineObj.coords1,centerlineObj.coords2,'rows');
 
        end
    end
    
end