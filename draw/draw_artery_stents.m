function draw_artery_stents(arteryObj, stentObj)
view([230 60])
draw_artery(arteryObj); hold on;
drawMesh(stentObj(1).vertices, stentObj(1).faces, 'FaceColor', 'w','facealpha',.0);
drawMesh(stentObj(3).vertices, stentObj(3).faces, 'FaceColor', 'w','facealpha',.0);
drawMesh(stentObj(2).vertices, stentObj(2).faces, 'FaceColor', 'w','facealpha',.0);