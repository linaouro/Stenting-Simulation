figure
hold on;
quiver3(arteryObj.centerline(1).coords(:,1),arteryObj.centerline(1).coords(:,2),arteryObj.centerline(1).coords(:,3),arteryObj.centerline(1).tangents(:,1),arteryObj.centerline(1).tangents(:,2),arteryObj.centerline(1).tangents(:,3))
quiver3(arteryObj.centerline(2).coords(:,1),arteryObj.centerline(2).coords(:,2),arteryObj.centerline(2).coords(:,3),arteryObj.centerline(2).tangents(:,1),arteryObj.centerline(2).tangents(:,2),arteryObj.centerline(2).tangents(:,3))
quiver3(arteryObj.centerline(3).coords(:,1),arteryObj.centerline(3).coords(:,2),arteryObj.centerline(3).coords(:,3),arteryObj.centerline(3).tangents(:,1),arteryObj.centerline(3).tangents(:,2),arteryObj.centerline(3).tangents(:,3))
