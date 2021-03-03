function [normPlaneModel] = estimatePlaneModel(P1, P2, P3)
% Project:   Patch-based Illumination invariant Visual Odometry (PIVO)
% Function: estimatePlaneModel
%
% Description:
%   get the plane model's parameters [a,b,c,d] <= 'a*x + b*y + c*z + d = 0'
%
% Example:
%   OUTPUT :
%   normPlaneModel: normalized plane model Parameters - [a,b,c,d]
%                           of the plane equation with 3 points.
%                          (a,b,c) : the normal vector of the plane
%
%   INPUT :
%   P1 : Point #1 on the plnae [X,Y,Z];
%   P2 : Point #2 on the plnae [X,Y,Z];
%   P3 : Point #3 on the plnae [X,Y,Z];
%
% NOTE:
%     The P1,P2,P3 should be three non-collinear points (three points not on a line!!)
%
% Author: Pyojin Kim
% Email: pjinkim1215@gmail.com
% Website:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% log:
% 2017-01-22 : Complete
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%


% calculate the normal vector of the plane
normalVector = cross(P1-P2, P1-P3);


% calculate the model parameters of the plane eqn
temp_d = -(normalVector(1)*P1(1) + normalVector(2)*P1(2) + normalVector(3)*P1(3));
planeModel = [normalVector, temp_d];
normPlaneModel = planeModel ./ (min(abs(planeModel)));


% check the validity of the plane equation
% a = normPlaneModel(1);
% b = normPlaneModel(2);
% c = normPlaneModel(3);
% d = normPlaneModel(4);
% a*P1(1) + b*P1(2) + c*P1(3) + d
% a*P2(1) + b*P2(2) + c*P2(3) + d
% a*P3(1) + b*P3(2) + c*P3(3) + d


% plot the calculated plane based on P1, P2, P3
% points=[P1' P2' P3']; % using the given data
% fill3(points(1,:), points(2,:), points(3,:),'r'); grid on;


end
