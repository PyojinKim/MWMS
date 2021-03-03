function [lines_final] = extractUniqueLines(imageCurForLine, lines, cam)

% assign current parameters
K = cam.K_pyramid(:,:,1);
Kinv = inv(K);
imageHeight = size(imageCurForLine,1);
imageWidth = size(imageCurForLine,2);


% line information for 1-line RANSAC
numLines = size(lines,1);
greatcircleNormal = zeros(numLines,3);
lineLength = zeros(numLines,1);
for k = 1:numLines
    
    % line pixel information
    linedata = lines(k,1:4);
    length = sqrt((linedata(1)-linedata(3))^2 + (linedata(2)-linedata(4))^2);
    
    % normalized image plane
    ptEnd1_p_d = [linedata(1:2), 1].';
    ptEnd2_p_d = [linedata(3:4), 1].';
    ptEnd1_n_d = Kinv * ptEnd1_p_d;
    ptEnd2_n_d = Kinv * ptEnd2_p_d;
    ptEnd1_n_u = [undistortPts_normal(ptEnd1_n_d(1:2), cam); 1];
    ptEnd2_n_u = [undistortPts_normal(ptEnd2_n_d(1:2), cam); 1];
    
    % normal vector of great circle
    circleNormal = cross(ptEnd1_n_u.', ptEnd2_n_u.');
    circleNormal = circleNormal / norm(circleNormal);
    
    % save the result
    greatcircleNormal(k,:) = circleNormal;
    lineLength(k) = length;
end


% cluster related (close) line segments
lineIdx = zeros(numLines,1);
numUniqueLine = 0;
lines_unique = [];
greatcircleNormal_unique = [];
lineLength_unique = [];
lineIdx_unique = [];
while (true)
    
    % reset valid line information
    lines = lines((lineIdx==0),:);
    greatcircleNormal = greatcircleNormal((lineIdx==0),:);
    lineLength = lineLength((lineIdx==0),:);
    
    
    % stop if lines is empty
    if (isempty(lines))
        break;
    end
    
    
    % find close line index
    lineCloseIdx = (abs(greatcircleNormal(1,:) * greatcircleNormal.') > cos(deg2rad(2))).';
    
    
    % assign related line information
    numUniqueLine = numUniqueLine + 1;
    lines_unique = [lines_unique; lines(lineCloseIdx,:)];
    greatcircleNormal_unique = [greatcircleNormal_unique; greatcircleNormal(lineCloseIdx,:)];
    lineLength_unique = [lineLength_unique; lineLength(lineCloseIdx,:)];
    lineIdx_unique = [lineIdx_unique; ones(sum(lineCloseIdx),1) * numUniqueLine];
    lineIdx = lineCloseIdx;
end


% find unique line segments
lines_final = [];
for k = 1:numUniqueLine
    
    % current line index
    lineIdx = find(lineIdx_unique == k);
    numCloseLine = size(lineIdx,1);
    
    % save unique line
    if (numCloseLine == 1)
        lines_final = [lines_final; lines_unique(lineIdx,:)];
    elseif (numCloseLine >= 2)
        [~, maxLineIdx] = max(lineLength_unique(lineIdx,:));
        lines_final = [lines_final; lines_unique(lineIdx(maxLineIdx),:)];
    end
end


% remove useless lines
removeLineIdx_u = find(lines_final(:,1) > (imageWidth - 4) & lines_final(:,3) > (imageWidth - 4));
removeLineIdx_v = find(lines_final(:,2) > (imageHeight - 4) & lines_final(:,4) > (imageHeight - 4));
removeLineIdx = [removeLineIdx_u; removeLineIdx_v];
lines_final(removeLineIdx,:) = [];


end

