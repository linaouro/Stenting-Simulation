stentY.faces = [stentFinal(3).faces; stentFinal(2).faces+size(stentFinal(3).vertices,1); stentFinal(1).faces+size(stentFinal(3).vertices,1)+size(stentFinal(2).vertices,1)];

idx1 = 1:stentFinal(1).centerline.len:size(stentFinal(1).vertices,1);
idx2 = 1:stentFinal(2).centerline.len:size(stentFinal(2).vertices,1);
idx3 = 1:stentFinal(3).centerline.len:size(stentFinal(3).vertices,1);

[a13,b13] = pdist2(stentFinal(1).vertices(idx1,:), stentFinal(3).vertices(idx3,:), 'euclidean','Smallest',1);
[amin13,bmin13] = min(a13); 
idxbmin13 = zeros(51,1);
idx_inner = zeros(51,1);
offset = size(stentFinal(3).vertices,1)+size(stentFinal(2).vertices,1);
offset2 = size(stentFinal(3).vertices,1);

%% 1 to 3 and 2 to 3
for i = 1:51
   idxbmin13(i) = mod(bmin13-13+i,50);
   if (idxbmin13(i) == 0)
       idxbmin13(i)=50;
   end

   idx_inner(i) = mod(bmin23-12-i,50);

   if i > 1 && i < 27
       stentY.faces(end+1,:) = [idx1((idxbmin13(i-1)))+offset;idx3(idxbmin13(i-1)); idx3(idxbmin13(i)); idx1((idxbmin13(i)))+offset];
   end
   if i > 26
        stentY.faces(end+1,:) =    [idx2((idxbmin13(i-1)))+offset2;idx3(idxbmin13(i-1)); idx3(idxbmin13(i));idx2((idxbmin13(i)))+offset2];
               
   end
end

%% 1 to 2
idx_inner(idx_inner == 0) = 50;
idx1_inner = idx_inner(end:-1:1);
for i = 1:26
   if i > 1
       stentY.faces(end+1,:) = [idx1(idx1_inner(i-1))+offset1;idx2(idx_inner(i-1))+offset2;  idx2(idx_inner(i))+offset2; idx1((idx1_inner(i)))+offset1];
   end
end

drawMesh(stentY.vertices, stentY.faces, 'FaceColor', 'r','facealpha',.3); hold on;
