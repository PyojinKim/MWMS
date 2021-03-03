function new = sortEndPts(intervals)


endPts = [];
for i = 1:size(intervals, 1)
    
    s = [intervals(i, 1); 0];
    endPts = [endPts, s];
    %    e = [intervals(i, 2); 1; intervals(i, 3)];
    e = [intervals(i, 2); 1];
    endPts = [endPts, e];
end
old = endPts;

new = sortrows(endPts', 1)';
end