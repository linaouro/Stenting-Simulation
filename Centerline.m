classdef Centerline 
    %   Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        coords;
        tangents;
        index_artery_to_center;
        seglen;
    end
    
    methods
        function centerlineObj = Centerline(coords, tangents) 
            if nargin == 2
                centerlineObj.coords = coords;
                centerlineObj.tangents = tangents;
                centerlineObj.seglen = sqrt(sum(diff(centerlineObj.coords,[],1).^2,2));
            end
         end
        

        
    end
    
end