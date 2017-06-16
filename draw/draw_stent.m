function draw_stent(stentObj)

for i = 1:3
        p = patch('faces', stentObj(i).faces, 'vertices' ,stentObj(i).vertices);
        set(p, 'facec', 'w');              % Set the face color (force it)
        set(p, 'facealpha',.5)             % Use for transparency
        set(p, 'EdgeColor','black');         % Set the edge color
        %set(p, 'EdgeColor',[1 0 0 ]);      % Use to see triangles, if needed.
        light('Position',[-1.0,-1.0,100.0],'Style','infinite');
        lighting gouraud;
        axis equal;
        daspect([1 1 1])                    % Setting the aspect ratio
        view([60 130])                      
        xlabel('X'),ylabel('Y'),zlabel('Z')
        drawnow                             %, axis manual
end