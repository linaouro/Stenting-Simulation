%% Interpolation of the arerty' centerline. Should be repeated until enough centerline points are found. For testing maybe no repetitions for faster computations.
function centerspline = interpolate_centerline(centerline)

centerspline=fnplt(cscvn(centerline'))';
[~,b] = unique(round(centerspline/1e-15),'rows','stable');
centerspline=centerspline(b,:);