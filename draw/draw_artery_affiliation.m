function draw_artery_affiliation(arteryObj)
hold on;
color = ['c','b','g'];
for i=1:3
   scatter3(arteryObj.vertices(arteryObj.centerline(i).index_artery_to_center(arteryObj.centerline(i).index_artery_to_center~=0),1),arteryObj.vertices(arteryObj.centerline(i).index_artery_to_center(arteryObj.centerline(i).index_artery_to_center~=0),2),arteryObj.vertices(arteryObj.centerline(i).index_artery_to_center(arteryObj.centerline(i).index_artery_to_center~=0),3), '*', 'LineWidth',1)
end