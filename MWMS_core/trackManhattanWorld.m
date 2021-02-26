function [R_cM_final, vpInfo, planeNormalVector, surfaceNormalVector, surfacePixelPoint, optimalProbe, thetaIntervals] = trackManhattanWorld(R_cM_old, pNV_old, imageCurForLine, imageCur, depthCur, cam, optsMWMS)

% assign current parameters
lineDetector = optsMWMS.lineDetector;
lineDescriptor = optsMWMS.lineDescriptor;
dimageCurForLine = double(imageCurForLine);
K = cam.K_pyramid(:,:,1);
Kinv = inv(K);


%% track (or re-initialize) dominant plane

% track current plane
[sNV, sPP] = estimateSurfaceNormalGradient_mex(imageCur, depthCur, cam, optsMWMS);
[pNV_new, isTracked] = trackSinglePlane(pNV_old, sNV, optsMWMS);
if (isTracked == 0)
    fprintf('Lost tracking! Re-intialize 1-plane normal vector. \n');
    [pNV_new, ~] = estimatePlaneNormalRANSAC(imageCur, depthCur, cam, optsMWMS);
    optsMWMS.minSampleRatio = 0.05;
    [pNV_new, ~] = trackSinglePlane(pNV_new, sNV, optsMWMS);
end
planeNormalVector = pNV_new;
surfaceNormalVector = sNV;
surfacePixelPoint = sPP;


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
[R_cM_new, optimalProbe, thetaIntervals] = ManhattanMaxStabbingIntervals(planeNormalVector, lineNormals);
[clusteredLinesIdx] = clusterManhattanMaxStabbingLines(R_cM_new, optimalProbe, thetaIntervals);
[R_cM_new, clusteredLinesIdx] = refineOrthogonalParallelLines(R_cM_new, clusteredLinesIdx, planeNormalVector, lines, cam);
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


% Manhattan frame matching for VPs
oldMatchingList = zeros(3,1);
for k = 1:3
    
    % old VP
    vp_old = R_cM_old(:,k);
    
    % new VP
    for m = 1:3
        if (abs(vp_old.' * R_cM_new(:,m)) > cos(deg2rad(10)))
            oldMatchingList(k) = m;
            break;
        end
    end
end


% align Manhattan frame directions (VPs)
R_cM_final = zeros(3,3);
for k = 1:3
    id = oldMatchingList(k);
    
    vp_c = R_cM_new(:,id);
    vp_c_old = R_cM_old(:,k);
    if (acos(vp_c.' * vp_c_old) < deg2rad(10))
        R_cM_final(:,k) = vp_c;
    else
        R_cM_final(:,k) = -vp_c;
    end
end


% initialize vpInfo
vpInfo = struct('n',{},'line',{},'index',{});
for k = 1:3
    id = oldMatchingList(k);
    
    % current VP info
    line = linesVP{id};
    numLine = size(line,2);
    vpInfo(k) = struct('n',numLine,'line',line,'index',k);
end


end