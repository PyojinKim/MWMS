function [R_cM, vpInfo, planeNormalVector, surfaceNormalVector, surfacePixelPoint, optimalProbe, thetaIntervals] = seekManhattanWorld(imageCurForLine, imageCur, depthCur, cam, optsMWMS)

% assign current parameters
lineDetector = optsMWMS.lineDetector;
lineDescriptor = optsMWMS.lineDescriptor;
dimageCurForLine = double(imageCurForLine);
K = cam.K_pyramid(:,:,1);
Kinv = inv(K);


%% initialize and seek dominant plane

% detect dominant plane and surface normals
[pNV, ~] = estimatePlaneNormalRANSAC(imageCur, depthCur, cam, optsMWMS);
[sNV, sPP] = estimateSurfaceNormalGradient_mex(imageCur, depthCur, cam, optsMWMS);
surfaceNormalVector = sNV;
surfacePixelPoint = sPP;


% refine plane normal vector
[pNV, isTracked] = trackSinglePlane(pNV, sNV, optsMWMS);
planeNormalVector = pNV;
if (isTracked == 0)
    disp(num2str(imgIdx));
    disp('lost plane tracking!');
    R_cM = [];
    vpInfo = [];
    planeNormalVector = [];
    return;
end


% check plane normal vector is on the hemisphere
[~, ~, planeNormalVector] = parametrizeVerticalDD(planeNormalVector);


%% seek Manhattan world directions (R_cM) with interval max stabbing

% detect lines and related line normals
[lines, ~, lineNormals] = extractLinesAndGreatcircle(imageCurForLine, cam, optsMWMS);
lineNormals = lineNormals.';


% find useless (invalid) lines for Manhattan world
invalidIndex = findInvalidManhattanLines(planeNormalVector, lineNormals, optsMWMS);
lineNormals(:,invalidIndex) = [];
lines(invalidIndex,:) = [];


% estimate Manhattan world directions (R_cM) with max stabbing
[R_cM, optimalProbe, thetaIntervals] = ManhattanMaxStabbingIntervals(planeNormalVector, lineNormals);
[clusteredLinesIdx] = clusterManhattanMaxStabbingLines(R_cM, optimalProbe, thetaIntervals);
[R_cM, clusteredLinesIdx] = refineOrthogonalParallelLines(R_cM, clusteredLinesIdx, planeNormalVector, lines, cam);
linesVP = cell(1,3);
for k = 1:3
    
    % current lines in VPs
    linesInVP = lines(clusteredLinesIdx{k},:);
    numLinesInVP = size(linesInVP,1);
    
    % line clustering for each VP
    line = struct('data',{},'length',{},'centerpt',{},'linenormal',{},'circlenormal',{});
    numLinesCnt = 0;
    for m = 1:numLinesInVP
        [linedata, centerpt, len, ~, linenormal, circlenormal] = roveFeatureGeneration(dimageCurForLine, linesInVP(m,1:4), Kinv, lineDescriptor);
        if (~isempty(linedata))
            numLinesCnt = numLinesCnt+1;
            line(numLinesCnt) = struct('data',linedata,'length',len,'centerpt',centerpt,'linenormal',linenormal,'circlenormal',circlenormal);
        end
    end
    
    % save line clustering results
    linesVP{k} = line;
end


% initialize vpInfo
vpInfo = struct('n',{},'line',{},'index',{});
for k = 1:3
    
    % current VP info
    line = linesVP{k};
    numLine = size(line,2);
    vpInfo(k) = struct('n',numLine,'line',line,'index',k);
end


end

