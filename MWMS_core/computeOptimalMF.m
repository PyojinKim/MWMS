function [R_cM_optimal] = computeOptimalMF(R_cM_initial, planeNormalVector, angle)

% pre-defined variables
axisAngle = [planeNormalVector; angle];
R_axisAngle = vrrotvec2mat(axisAngle);


% initial R_cM
VP_x = R_cM_initial(:,1);
VP_y = R_cM_initial(:,2);
VP_z = R_cM_initial(:,3);


% rotate R_cM with axis-angle
VP_x_rotated = R_axisAngle * VP_x;
VP_y_rotated = R_axisAngle * VP_y;
VP_z = VP_z;


% optimal R_cM
R_cM_optimal = [VP_x_rotated, VP_y_rotated, VP_z];


end

