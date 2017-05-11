function rot_trans_mat = get_rot_trans_matrix(v1,v2, c)
% R*v1=v2
% v1, v2: 3x1 vectors

% 1. rotation vector
w=cross(v1,v2);
w=w/norm(w);
w_hat=fcn_GetSkew(w);
% 2. rotation angle
cos_tht=v1'*v2/norm(v1)/norm(v2);
tht=acos(cos_tht);
% 3. rotation matrix, using Rodrigues' formula
rot_mat=eye(size(v1,1))+w_hat*sin(tht)+w_hat^2*(1-cos(tht));

% 4. translation matrix
rot_trans_mat = [rot_mat c; 0 0 0 1];

function x_skew=fcn_GetSkew(x)
x_skew=[0 -x(3) x(2);
 x(3) 0 -x(1);
 -x(2) x(1) 0];