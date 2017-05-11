classdef Stenosis
    %   The 
    
    properties
        index
        radius
        coords
    end
    
    methods
        function  stenosisObj = Stenosis(radius, index, coords)
            if nargin ==3
                stenosisObj.radius = radius;
                stenosisObj.index = index;
                stenosisObj.coords = coords;
            end
        end
 
        
    end
    
end