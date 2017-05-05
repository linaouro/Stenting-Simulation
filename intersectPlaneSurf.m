function out=intersectPlaneSurf(p0, v, exx, eyy, ezz)
%out=intersectPlaneSurf(p0, v, exx, eyy, ezz)
% Intersection points of an arbitrary surface with an arbitrary plane.
% The plane must be specified with "p0" which is a point that plane includes
% and normal vector of the plane "v". "exx", "eyy" and "ezz" is the surface coordinates.
% Mehmet OZTURK - KTU Electrical and Electronics Engineering, Trabzon/Turkey

% Note: You have to download geom3d toolbox by David Legland from FEX 
% to visualize results correctly

v=v./norm(v); % normalize the normal vector

mx=v(1); my=v(2); mz=v(3);

% elevation and azimuth angels of the normal of the plane
phi  = acos(mz./sqrt(mx.*mx + my.*my + mz.*mz)); % 0 <= phi <= 180
teta = atan2(my,mx);

st=sin(teta); ct=cos(teta);
sp=sin(phi); cp=cos(phi);

T=[st -ct 0; ct*cp st*cp -sp; ct*sp st*sp cp];
invT=[st ct*cp ct*sp; -ct st*cp st*sp; 0 -sp cp];

% transform surface such that the z axis of the surface coincides with
% plane normal
exx=exx-p0(1); eyy=eyy-p0(2); ezz=ezz-p0(3);
nexx = exx*T(1,1) + eyy*T(1,2) + ezz*T(1,3);
neyy = exx*T(2,1) + eyy*T(2,2) + ezz*T(2,3);
nezz = exx*T(3,1) + eyy*T(3,2) + ezz*T(3,3);

% use MATLABs contour3 algorithm to find the intersections
c=contours(nexx,neyy,nezz,[0 0]);

limit = size(c,2);
i = 1;
ncx=[]; ncy=[];
while(i < limit)
  npoints = c(2,i);
  nexti = i+npoints+1;

  ncx = [ncx c(1,i+1:i+npoints)];
  ncy = [ncy c(2,i+1:i+npoints)];
  i = nexti;
end

% inverse transformation of the intersection coordinates 
cx=ncx*invT(1,1) + ncy*invT(1,2) + p0(1);
cy=ncx*invT(2,1) + ncy*invT(2,2) + p0(2);
cz=ncx*invT(3,1) + ncy*invT(3,2) + p0(3);

out=[cx(:) cy(:) cz(:)];