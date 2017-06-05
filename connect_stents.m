function stentObj = connect_stents(stentObj)
global n_circ;
    for i =1:2
        stentObj(i).vertices = [stentObj(3).vertices(1:n_circ,:); stentObj(i).vertices];
        stentObj(i).centerline = Centerline([stentObj(3).centerline.coords(1,:); stentObj(i).centerline.coords], [stentObj(3).centerline.tangents(1,:); stentObj(i).centerline.tangents]);
        stentObj(i).radius = [stentObj(3).radius(1:n_circ); stentObj(i).radius];
        [~,~, stentObj(i).faces] = get_cylinder_mesh(stentObj(i).centerline, n_circ, size(stentObj(i).centerline.coords,1), stentObj(i).radius);
    end