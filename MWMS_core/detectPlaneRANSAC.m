function [maxMatchingIdx, maxMatchingNum, maxPlaneModel] = detectPlaneRANSAC(pointCloudRef, distance)
% Project:   Patch-based Illumination invariant Visual Odometry (PIVO)
% Function: detectPlaneRANSAC
%
% Description:
%   determine the input's 3D points (pointCloudRef) are on the same plane or not
%
% Example:
%   OUTPUT :
%   maxMatchingIdx: the index of 3D points on the same plane at maximum satisfaction.
%   maxMatchingNum: the number of 3D points on the same plane at maximum satisfaction.
%   maxPlaneModel: the plane model (a,b,c,d) at maximum satisfaction.
%
%   INPUT :
%   pointCloudRef: 3D feature points expressed in camera frame [m] - [x;y;z] in a single patch
%   distance: threshold distance between point and the plane [m]
%
% NOTE:
%
% Author: Pyojin Kim
% Email: pjinkim1215@gmail.com
% Website:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% log:
% 2017-07-22 : Complete
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%


% initialize RANSAC model parameters
totalPointNum = size(pointCloudRef, 2);
samplePointNum = 3;
ransacMaxIterNum = 1000;
ransacIterNum = 50;
ransacIterCnt = 0;

maxMatchingNum = 0;
maxMatchingIdx = [];


% do RANSAC with plane model
while (true)
    
    % sample 3 feature points
    [sampleIdx] = randsample(totalPointNum, samplePointNum);
    pointsSample = pointCloudRef(:,sampleIdx);
    P1 = pointsSample(:,1).';
    P2 = pointsSample(:,2).';
    P3 = pointsSample(:,3).';
    
    
    % estimate plane model parameters with 3 feature points
    normPlaneModel = estimatePlaneModel(P1, P2, P3);
    
    
    % check number of inliers
    [matchingNum, goodMatchingIdx] = inThresforPlane(pointCloudRef, normPlaneModel, distance);
    
    
    % save the large consensus set
    if (matchingNum > maxMatchingNum)
        maxMatchingNum = matchingNum;
        maxMatchingIdx = goodMatchingIdx;
        maxPlaneModel = normPlaneModel;
        
        % calculate the number of iterations (http://en.wikipedia.org/wiki/RANSAC)
        matchingRatio = matchingNum / totalPointNum;
        ransacIterNum = ceil(log(0.01)/log(1-(matchingRatio)^samplePointNum));
    end
    
    ransacIterCnt = ransacIterCnt + 1;
    if (ransacIterCnt >= ransacIterNum || ransacIterCnt >= ransacMaxIterNum)
        break;
    end
end


end






