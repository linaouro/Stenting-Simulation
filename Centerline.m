classdef Centerline < matlab.mixin.SetGet
    %   Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        coords;
        trunk_coords; % trunk
        left_coords; % left
        right_coords; % right
        tangents;
        trunk_tangents;
        left_tangents;
        right_tangents;
        bif;
        index_artery_to_center;
    end
    
    methods
        function centerlineObj = Centerline(filename1, filename2, trunk_coords, left_coords, right_coords) % trunk_tangents, left_tangents, right_tangents)
            switch nargin 
                case 3 % for stent
                    % set centerlines
                    centerlineObj.left_coords = left_coords;
                    centerlineObj.right_coords = right_coords;
                    centerlineObj.trunk_coords = trunk_coords;
%                     centerlineObj.left_tangents = left_tangents;
%                     centerlineObj.right_tangents = right_tangents;
%                     centerlineObj.trunk_tangents = trunk_tangents;
                case 2 % for artery
                    % read in centerlines
                    [centerlineObj.left_coords, centerlineObj.right_coords, centerlineObj.trunk_coords, centerlineObj.left_tangents, centerlineObj.right_tangents, centerlineObj.trunk_tangents] = get_centerlines(filename1, filename2);
                    centerlineObj.coords = [centerlineObj.trunk_coords; centerlineObj.left_coords; centerlineObj.right_coords];
                    centerlineObj.tangents = [centerlineObj.trunk_tangents; centerlineObj.left_tangents; centerlineObj.right_tangents];
                    % set bifurcation point
                    centerlineObj.bif = size(centerlineObj.trunk_coords, 1);
                otherwise
                    error('Centerline constructor received wrong number of input arguments.')
            end
            

        end
        

        
    end
    
end