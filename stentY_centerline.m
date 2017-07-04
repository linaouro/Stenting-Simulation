function arteryObj = stentY_centerline(arteryObj, radii)
    for i = 1:2
        tangent = (arteryObj.opening(i).coords-arteryObj.opening(3).coords);
        point = arteryObj.opening(3).coords+(radii(i)/arteryObj.final_radii(i))*tangent;
        size1 = max(1,round(norm(point - arteryObj.centerline(i).coords(arteryObj.opening(i).index,:))/arteryObj.centerline(i).seglen(1)));
        if size1>0 && (1-radii(i)/arteryObj.final_radii(i)>0.0001)
            coords = [point; arteryObj.centerline(i).coords(arteryObj.opening(i).index,:) ];
            [coords,tangents,~]= interparc(size1,coords(:,1),coords(:,2),coords(:,3));
            arteryObj.centerline(i) = Centerline([coords; arteryObj.centerline(i).coords(arteryObj.opening(i).index+1:end,:)], [tangents; arteryObj.centerline(i).tangents(arteryObj.opening(i).index+1:end,:)]);
            arteryObj.endpoint(i).index = arteryObj.endpoint(i).index - arteryObj.opening(i).index + size1;
            arteryObj.opening(i).index = 1;
        else
            %arteryObj.centerline(i).tangents(arteryObj.opening(i).index,:) = tangent;
            arteryObj.centerline(i) = Centerline(arteryObj.centerline(i).coords(arteryObj.opening(i).index:end,:), arteryObj.centerline(i).tangents(arteryObj.opening(i).index:end,:));
            arteryObj.endpoint(i).index = arteryObj.endpoint(i).index - arteryObj.opening(i).index;
            arteryObj.opening(i).index = 1;
        end;

    end    
    arteryObj.centerline(4) = Centerline([arteryObj.centerline(1).coords; arteryObj.centerline(2).coords; arteryObj.centerline(3).coords],[arteryObj.centerline(1).tangents; arteryObj.centerline(2).tangents; arteryObj.centerline(3).tangents]);
    arteryObj.centerline_lengths = [0,size(arteryObj.centerline(1).coords,1),size(arteryObj.centerline(2).coords,1),size(arteryObj.centerline(3).coords,1)];
    arteryObj = calc_radii_dists2(arteryObj); 

 end