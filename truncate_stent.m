function stentObj = truncate_stent(stentObj,index)
%% Remove vertices and corresponding faces from list. 
% This function will take in a stentObj and truncate the stent at idnex.
% It removes centerline points >= index, the corresponding stent vertices 
% and will also remove any faces that reference the removed vertices. 
%
% Input: stentObj - stentObj including the vertices, faces, radii,
%                   centerline etc
%        index - first centerline index to be removed
%
% Output: stentObj - same as input, with modified vertices, faces, radii,
%                   centerline etc
%
% parts of the code taken from removeVerticesPatch by Lane Foulks
global n_circ;

removeVerticeList = (index*n_circ+1:length(stentObj.vertices));
fnew = stentObj.faces;

%% find the position (rows) of the vertices to be deleted
logicalRemoveVertices = false(1,length(stentObj.vertices));
logicalRemoveVertices(removeVerticeList) = 1;
%%  Create new vertice reference tags
tagsOld = 1:length(stentObj.vertices);

tagsNew = tagsOld; % copy original tags
newCount = cumsum(~logicalRemoveVertices); % counts the vertices that are to remain
tagsNew(~logicalRemoveVertices) = newCount(~logicalRemoveVertices); % the newCount are the new reference tags
tagsNew(logicalRemoveVertices) = nan; % place nans at loctions that shouldn't be used

%% Delete vertices, radii, centerline points with coords etc
stentObj.vertices(logicalRemoveVertices,:) = []; 
stentObj.radius(logicalRemoveVertices,:) = []; 
stentObj.radius_artery(logicalRemoveVertices,:) = []; 
stentObj.centerline.index_stent_to_center(index:end,:)=[];
stentObj.centerline.coords(index:end,:)=[];
stentObj.centerline.tangents(index:end,:)=[];
stentObj.centerline.index_artery_to_center(index:end,:)=[];
stentObj.centerline.seglen(index-1:end,:) = 0;
stentObj.centerline.len = index-1;
%% Delete faces
[IndexFacesRowDelete,~] = find(ismember(fnew,removeVerticeList)); % find the position (rows) of the faces to delete
fnew(IndexFacesRowDelete,:) = []; % deletes faces that reference any vertice removed

%% Renumber faces
stentObj.faces = tagsNew(fnew);
