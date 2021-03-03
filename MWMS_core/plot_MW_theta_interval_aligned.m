function plot_MW_theta_interval_aligned(vpInfo, optimalProbe, thetaIntervals)

% calculate the number of shifted candidate intervals
numIntervals = size(thetaIntervals,1);
ManhattanOriginIndex = [];
ManhattanShiftIndex = [];
for k = 1:numIntervals
    
    % Manhattan world theta interval
    startPoint = thetaIntervals(k,1);
    endPoint = thetaIntervals(k,2);
    lineIndex = thetaIntervals(k,3);
    isShifted = boolean(thetaIntervals(k,4));
    
    
    % check valid theta interval
    if ((startPoint <= optimalProbe) && (optimalProbe <= endPoint))
        if (isShifted == 0)
            ManhattanOriginIndex = [ManhattanOriginIndex, lineIndex];
        else
            ManhattanShiftIndex = [ManhattanShiftIndex, lineIndex];
        end
    end
end
numOriginIndex = numel(unique(ManhattanOriginIndex));
numShiftIndex = numel(unique(ManhattanShiftIndex));


% find RGB color of origin or shift
if (vpInfo(1).n == numOriginIndex)
    originRGBColor = 'r';
elseif (vpInfo(2).n == numOriginIndex)
    originRGBColor = 'g';
elseif (vpInfo(3).n == numOriginIndex)
    originRGBColor = 'b';
else
    error('Something is wrong in plot_MW_theta_interval!');
end
if (vpInfo(1).n == numShiftIndex)
    shiftRGBColor = 'r';
elseif (vpInfo(2).n == numShiftIndex)
    shiftRGBColor = 'g';
elseif (vpInfo(3).n == numShiftIndex)
    shiftRGBColor = 'b';
else
    error('Something is wrong in plot_MW_theta_interval!');
end


% plot each MW theta interval
for k = 1:numIntervals
    
    % Manhattan world theta interval
    startPoint = thetaIntervals(k,1);
    endPoint = thetaIntervals(k,2);
    lineIndex = thetaIntervals(k,3);
    isShifted = boolean(thetaIntervals(k,4));
    
    
    % plot each theta interval
    if ((startPoint <= optimalProbe) && (optimalProbe <= endPoint))
        if (isShifted == 0)
            line([rad2deg(startPoint), rad2deg(endPoint)], [lineIndex, lineIndex],'color',originRGBColor,'LineWidth',3.5);
        elseif (isShifted == 1)
            line([rad2deg(startPoint), rad2deg(endPoint)], [lineIndex, lineIndex],'color',shiftRGBColor,'LineWidth',3.5);
        else
            error('Something is wrong in plot_MW_theta_interval!');
        end
    else
        line([rad2deg(startPoint), rad2deg(endPoint)], [lineIndex, lineIndex],'color','k','LineWidth',3.5);
    end
end
line([rad2deg(optimalProbe), rad2deg(optimalProbe)],[0, (numIntervals+1)],'color','m','LineWidth',2.0);


end


