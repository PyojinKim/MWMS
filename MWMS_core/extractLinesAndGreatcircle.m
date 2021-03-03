function [lines, greatcirclePoints, greatcircleNormals] = extractLinesAndGreatcircle(imageCurForLine, cam, optsMWMS)

% assign current parameters
lineDetector = optsMWMS.lineDetector;
lineLength = optsMWMS.lineLength;
K = cam.K;
Kinv = inv(K);


% line detection
dimageCurForLine = double(imageCurForLine);
if (strcmp(lineDetector,'lsd'))
    [lines, ~] = lsdf(dimageCurForLine, (lineLength^2));
elseif (strcmp(lineDetector,'gpa'))
    [lines, ~] = gpa(imageCurForLine, lineLength);
end
lines = extractUniqueLines(imageCurForLine, lines, cam);


% great circle normal vector
numLines = size(lines,1);
greatcirclePoints = zeros(numLines,6);
greatcircleNormals = zeros(numLines,3);
for k = 1:numLines
    
    % line information
    linedata = lines(k,1:4);
    
    % normalized, undistorted image plane
    pt1_p_d = [linedata(1:2), 1].';
    pt2_p_d = [linedata(3:4), 1].';
    pt1_n_d = Kinv * pt1_p_d;
    pt2_n_d = Kinv * pt2_p_d;
    pt1_n_u = [undistortPts_normal(pt1_n_d(1:2), cam); 1];
    pt2_n_u = [undistortPts_normal(pt2_n_d(1:2), cam); 1];
    
    % two points (r=1) on the great circle
    pt1_sphere = pt1_n_u / norm(pt1_n_u);
    pt2_sphere = pt2_n_u / norm(pt2_n_u);
    greatcirclePoints(k,:) = [pt1_sphere.', pt2_sphere.'];
    
    % normal vector of great circle
    circleNormal = cross(pt1_n_u.', pt2_n_u.');
    circleNormal = circleNormal / norm(circleNormal);
    greatcircleNormals(k,:) = circleNormal;
end


end