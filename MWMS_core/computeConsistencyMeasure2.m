function [CM2_RMSE, CM2] = computeConsistencyMeasure2(R_cM_aligned, vpInfo_aligned, cam)

% assign current parameters
M = length(R_cM_aligned);
K = cam.K;

CM2 = zeros(1,M);


% compute Consistency Measure 2 (CM2)
for k = 2:M
    
    % aligned R_cM & vpInfo
    R_cM_align = R_cM_aligned{k};
    vpInfo_align = vpInfo_aligned{k};
    
    
    % consistency measure 2 (CM2)
    CM2_error_total = [];
    for m = 1:3
        
        % current VP on image plane
        VP = R_cM_align(:,m);
        VP_n = VP ./ VP(3);
        VP_p = K * VP_n;
        
        
        % current line information
        numLines = vpInfo_align(m).n;
        lines = vpInfo_align(m).line;
        orthogonalDistance = zeros(1,numLines);
        for n = 1:numLines
            
            % general line equation
            centerpt = lines(n).centerpt;
            lineModel = estimateLineModel(VP_p(1:2), centerpt);
            A = lineModel(1);
            B = lineModel(2);
            C = lineModel(3);
            
            
            % orthogonal distance
            linedata = lines(n).data;
            denominator = sqrt(A^2 + B^2);
            d_pt1 = (abs(A*linedata(1) + B*linedata(2) + C) / denominator);
            d_pt2 = (abs(A*linedata(3) + B*linedata(4) + C) / denominator);
            orthogonalDistance(n) = (d_pt1 + d_pt2) / 2;
        end
        
        
        % compute consistency measure 2 (CM2)
        CM2_error = orthogonalDistance;
        CM2_error_total = [CM2_error_total, CM2_error];
    end
    
    
    % check the number of clustered lines
    totalLineNum = (vpInfo_align(1).n + vpInfo_align(2).n + vpInfo_align(3).n);
    if (totalLineNum ~= size(CM2_error_total,2))
        error('Something is wrong in CM2_error_total!');
    end
    
    
    % save the mean CM2
    CM2(k) = mean(abs(CM2_error_total));
end


% compute the root mean squared error (RMSE) of CM2
CM2(1) = [];
CM2_RMSE = sqrt(sum(CM2.^2) / M);


end

