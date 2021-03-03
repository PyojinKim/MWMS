function [residuals] = orthogonalDistanceResidual(lineEndPixelPoints, centerPixelPoint, lineMFLabel, K, R_cM_initial, planeNormalVector, angle)
% Project:   Manhattan World Estimation with Max Stabbing (MWMS)
% Function: orthogonalDistanceResidual
%
% Description:
%   residual return function for lsqnonlin in MATLAB
%
% Example:
%   OUTPUT:
%   residuals:
%
%
%   INPUT:
%   lineEndPixelPoints: N x 4
%   centerPixelPoint: N x 2
%   lineMFLabel: N x 1
%   K: camera intrinsic parameter
%   planeNormalVector: axis in axis-angle representation
%   angle: angle in axis-angle representation
%
%
% NOTE:
%
% Author: Pyojin Kim
% Email: pjinkim@sookmyung.ac.kr
% Website:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% log:
% 2021-02-25: Complete
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%


% pre-defined variables
numLines = size(lineEndPixelPoints,1);
axisAngle = [planeNormalVector; angle];
R_axisAngle = vrrotvec2mat(axisAngle);


% initial R_cM
VP_x = R_cM_initial(:,1);
VP_y = R_cM_initial(:,2);
VP_z = R_cM_initial(:,3);


% rotated R_cM with axis-angle
VP_x_rotated = R_axisAngle * VP_x;
VP_y_rotated = R_axisAngle * VP_y;
VP_z = VP_z;
VP_x_rotated_n = VP_x_rotated ./ VP_x_rotated(3);
VP_x_rotated_p = K * VP_x_rotated_n;
VP_y_rotated_n = VP_y_rotated ./ VP_y_rotated(3);
VP_y_rotated_p = K * VP_y_rotated_n;

R_cM_rotated_p = [VP_x_rotated_p, VP_y_rotated_p, zeros(3,1)];


% orthogonal distance with end points
residuals = zeros(numLines,2);
for m = 1:numLines
    
    % current VP index
    vpIdx = lineMFLabel(m);
    VP_p = R_cM_rotated_p(:,vpIdx);
    
    
    % general line equation
    centerpt = centerPixelPoint(m,:);
    lineModel = estimateLineModel(VP_p(1:2), centerpt);
    A = lineModel(1);
    B = lineModel(2);
    C = lineModel(3);
    
    
    % orthogonal distance
    linedata = lineEndPixelPoints(m,:);
    denominator = sqrt(A^2 + B^2);
    d_pt1 = (abs(A*linedata(1) + B*linedata(2) + C) / denominator);
    d_pt2 = (abs(A*linedata(3) + B*linedata(4) + C) / denominator);
    residuals(m,1) = d_pt1;
    residuals(m,2) = d_pt2;
end
residuals = residuals(:);


end
