function [ManhattanThetaIntervals] = convertManhattanThetaInterval(AtlantaThetaIntervals)

% Atlanta World Theta Interval: [-pi/2,pi/2]
% Manhattan World Theta Interval: [0,pi/2]

ManhattanThetaIntervals = [];
numIntervals = size(AtlantaThetaIntervals,1);
for k = 1:numIntervals
    
    % theta interval from "computeThetaInterval"
    startPoint = AtlantaThetaIntervals(k,1);
    endPoint = AtlantaThetaIntervals(k,2);
    lineIndex = AtlantaThetaIntervals(k,3);
    
    
    % convert theta interval range for Manhattan world (if range is shifted, last column is 1)
    if ((startPoint < 0) && (endPoint < 0))
        singleInterval = [startPoint+(pi/2), endPoint+(pi/2), lineIndex, 1];
    elseif ((startPoint < 0) && (0 < endPoint))
        singleInterval = [startPoint+(pi/2), 0+(pi/2), lineIndex, 1;
            0, endPoint, lineIndex, 0];
    else
        singleInterval = [startPoint, endPoint, lineIndex, 0];
    end
    
    
    % save the theta interval results
    ManhattanThetaIntervals = [ManhattanThetaIntervals; singleInterval];
end


end

