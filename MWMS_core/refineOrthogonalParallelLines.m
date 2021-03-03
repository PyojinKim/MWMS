function [R_cM_final, clusteredLinesIdx_final] = refineOrthogonalParallelLines(R_cM_initial, clusteredLinesIdx, planeNormalVector, lines, cam)

% line information for multiple lines refinement
numLines = size(lines,1);
lineEndPixelPoints = zeros(numLines,4);
centerPixelPoint = zeros(numLines,2);
for k = 1:numLines
    
    % line pixel information
    linedata = lines(k,1:4);
    centerpt = (linedata(1:2) + linedata(3:4))/2;
    
    
    % save the result
    lineEndPixelPoints(k,:) = linedata;
    centerPixelPoint(k,:) = centerpt;
end


% refine Manhattan MnS results
if (isempty(clusteredLinesIdx{1}) && isempty(clusteredLinesIdx{2}))
    R_cM_final = zeros(3);
    clusteredLinesIdx_final = cell(1,3);
else
    % re-arrange line information for nonlinear optimization
    lineEndPixelPoints_inMF = [];
    centerPixelPoint_inMF = [];
    lineMFLabel_inMF = [];
    for k = 1:2
        
        % current lines in VPs
        linesInVP = lines(clusteredLinesIdx{k},:);
        numLinesInVP = size(linesInVP,1);
        
        % line pixel point information
        lineEndPixelPoints_inMF = [lineEndPixelPoints_inMF; lineEndPixelPoints(clusteredLinesIdx{k},:)];
        centerPixelPoint_inMF = [centerPixelPoint_inMF; centerPixelPoint(clusteredLinesIdx{k},:)];
        lineMFLabel_inMF = [lineMFLabel_inMF; ones(numLinesInVP,1) * k];
    end
    
    
    % run nonlinear optimization using lsqnonlin in Matlab (Levenberg-Marquardt)
    options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt','Display','iter-detailed');
    [vec,resnorm,residuals,exitflag] = lsqnonlin(@(x) orthogonalDistanceResidual(lineEndPixelPoints_inMF,centerPixelPoint_inMF,lineMFLabel_inMF,cam.K,R_cM_initial,planeNormalVector,x),0,[],[],options);
    
    
    % optimal R_cM for multiple lines refinement
    R_cM_final = computeOptimalMF(R_cM_initial, planeNormalVector, vec);
    clusteredLinesIdx_final = clusteredLinesIdx;
end


end

