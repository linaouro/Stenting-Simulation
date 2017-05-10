classdef Centerline 
    %   Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        coords;
        tangents;
        index_artery_to_center;
    end
    
    methods
        function centerlineObj = Centerline(coords, tangents) 
            if nargin == 2
                centerlineObj.coords = coords;
                centerlineObj.tangents = tangents;
            end
         end
        

        
    end
    
end