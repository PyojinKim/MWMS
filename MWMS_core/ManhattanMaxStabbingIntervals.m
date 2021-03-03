function [R_cM, optimalProbe, ManhattanThetaIntervals] = ManhattanMaxStabbingIntervals(ManhattanDirection_Z, lineNormals)

% parametrize 1-D theta angle with vertical dominant direction
beta = asin(ManhattanDirection_Z(3));
alpha = atan(ManhattanDirection_Z(2)/ManhattanDirection_Z(1));
vDDParams = parametrizeHorizontalDD([cos(alpha), sin(alpha), cos(beta), sin(beta)]);


% compute theta intervals from each line normal
thetaIntervals = [];
for k = 1:size(lineNormals,2)
    
    % find each theta interval for line
    [singleInterval, ~] = computeThetaInterval(vDDParams(1), vDDParams(2), vDDParams(3), vDDParams(4), vDDParams(5), vDDParams(6), lineNormals(:,k));
    
    
    % post-process for single theta interval
    if (size(singleInterval,1) == 1)             % [a,b] in [-pi/2,pi/2]
        singleInterval = [singleInterval, k];
    elseif (size(singleInterval,1) == 2)        % [-pi/2,a] & [b,pi/2]
        singleInterval = [singleInterval, k*ones(2,1)];
    end
    
    
    % save the theta interval results
    thetaIntervals = [thetaIntervals; singleInterval];
end


% utilize Manhattan world periodicity
ManhattanThetaIntervals = convertManhattanThetaInterval(thetaIntervals);


% do max stabbing
sortedManhattanThetaIntervals = sortEndPts(ManhattanThetaIntervals);  % [start, end, lineID]
candidateProbes = maxStabbing(sortedManhattanThetaIntervals);


% find optimal single probe (for MW only)
[~,maxIndex] = max(candidateProbes(3,:));
optimalProbe = mean(candidateProbes(1:2,maxIndex));


% compute Manhattan world directions from optimal probe
ManhattanDirection_X = computeHorizontalDDfromTheta(vDDParams, optimalProbe);
ManhattanDirection_Y = cross(ManhattanDirection_X, ManhattanDirection_Z);
ManhattanDirection_Y = ManhattanDirection_Y / norm(ManhattanDirection_Y);
R_cM = [ManhattanDirection_X, ManhattanDirection_Y, ManhattanDirection_Z];
if (det(R_cM) < 0)
    R_cM = [ManhattanDirection_X, -ManhattanDirection_Y, ManhattanDirection_Z];
end


end

