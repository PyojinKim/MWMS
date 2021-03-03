function [candidateProbes] = maxStabbing(sortedIntervals)

% define default variables
candidateProbes = [];
numStabbedInterval = 0;
tempStartPoint = [];


% do max stabbing algorithm
for k = 1:size(sortedIntervals,2)
    
    % check start or end point of theta interval
    if (sortedIntervals(2,k) == 0)
        add_flag = true;
        
        % increase # of stabbed intervals
        tempStartPoint = sortedIntervals(1,k);
        numStabbedInterval = numStabbedInterval + 1;
    else
        
        % save the last start point
        if (add_flag == true)
            candidateProbes = [candidateProbes, [tempStartPoint; sortedIntervals(1,k); numStabbedInterval]];
            add_flag = false;
        end
        
        % decrease # of stabbed intervals
        numStabbedInterval = numStabbedInterval - 1;
    end
end

end