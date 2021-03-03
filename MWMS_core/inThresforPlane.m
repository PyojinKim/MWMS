function [matchingNum, goodMatchingIdx] = inThresforPlane(pointCloudRef, normPlaneModel, distance)
% Project:   Patch-based Illumination invariant Visual Odometry (PIVO)
% Function: inThresforPlane
%
% Description:
%   get the index of 3D points satisfying [Distance] < [Threshold],
%   'distance' means the length between the 3D points and the plane.
%
% Example:
%   OUTPUT :
%   matchingNum: the number of 3D points satisfying [DIstance] < [Threshold]
%   goodMatchingIdx: index of 3D points satisfying [DIstance] < [Threshold]
%
%   INPUT :
%   pointCloudRef : 3D feature points expressed in camera frame [m] - [x;y;z]
%   normPlaneModel: normalized plane model - [a,b,c,d]
%                           'a*x + b*y + c*z + d = 0'
%   distance: threshold distance [m] between the point and the plane
%
% NOTE:
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


% set parameters
numPoint = size(pointCloudRef, 2);
distanceEachPoint = zeros(1, numPoint);


% assign plane model parameters
a = normPlaneModel(1);
b = normPlaneModel(2);
c = normPlaneModel(3);
d = normPlaneModel(4);


% distance between each point and plane
denominator = sqrt(a^2 + b^2 + c^2);
for k = 1:numPoint
    distanceEachPoint(k) = abs((a*pointCloudRef(1,k) + b*pointCloudRef(2,k) + c*pointCloudRef(3,k) + d) / (denominator));
end


% determine inlier or not
matchingNum = sum(distanceEachPoint <= distance);
goodMatchingIdx = find(distanceEachPoint <= distance);


end
