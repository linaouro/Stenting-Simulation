classdef ArteryPoint
    %   The 
    
    properties
        index
        radius
        coords
    end
    
    methods
        function  arteryPointObj = ArteryPoint(radius, index, coords)
            if nargin ==3
                arteryPointObj.radius = radius;
                arteryPointObj.index = index;
                arteryPointObj.coords = coords;
            end
        end
 
        
    end
    
end