function f=draw_artery_stents(arteryObj, stentObj)
view([230 60])
f=draw_artery(arteryObj); hold on;
for i = 1:size(stentObj,2)
    drawMesh(stentObj(i).vertices, stentObj(i).faces, 'FaceColor', 'w','facealpha',.0);
end