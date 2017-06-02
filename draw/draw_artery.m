function draw_artery(arteryObj)
    figure
    clf;
    p = patch('faces', arteryObj.faces, 'vertices' ,arteryObj.vertices);
    set(p, 'facec', 'r');              % Set the face color (force it)
    set(p, 'facealpha',.7)             % Use for transparency
    set(p, 'EdgeColor','none');         % Set the edge color
    %set(p, 'EdgeColor',[1 0 0 ]);      % Use to see triangles, if needed.
    light                               % add a default light
    daspect([1 1 1])                    % Setting the aspect ratio
    view([230 60])                      
    xlabel('X'),ylabel('Y'),zlabel('Z')
    drawnow                             %, axis manual
