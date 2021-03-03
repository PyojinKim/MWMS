function [CM1_RMSE, CM1] = computeConsistencyMeasure1(R_cM_aligned, vpInfo_aligned, cam)

% assign current parameters
M = length(R_cM_aligned);
K = cam.K;
Kinv = inv(K);

CM1 = zeros(1,M);


% compute Consistency Measure 1 (CM1)
for k = 2:M
    
    % aligned R_cM & vpInfo
    R_cM_align = R_cM_aligned{k};
    vpInfo_align = vpInfo_aligned{k};
    
    
    % consistency measure 1 (CM1)
    CM1_error_total = [];
    for m = 1:3
        
        % current line information
        numLines = vpInfo_align(m).n;
        lines = vpInfo_align(m).line;
        greatcircleNormals = zeros(numLines,3);
        for n = 1:numLines
            
            % line information
            linedata = lines(n).data;
            
            % normalized, undistorted image plane
            pt1_p_d = [linedata(1:2), 1].';
            pt2_p_d = [linedata(3:4), 1].';
            pt1_n_d = Kinv * pt1_p_d;
            pt2_n_d = Kinv * pt2_p_d;
            pt1_n_u = [undistortPts_normal(pt1_n_d(1:2), cam); 1];
            pt2_n_u = [undistortPts_normal(pt2_n_d(1:2), cam); 1];
            
            % normal vector of great circle
            circleNormal = cross(pt1_n_u.', pt2_n_u.');
            circleNormal = circleNormal / norm(circleNormal);
            greatcircleNormals(n,:) = circleNormal;
        end
        
        
        % compute consistency measure 1 (CM1)
        vp_true = R_cM_align(:,m);
        CM1_error = vp_true.' * greatcircleNormals.';
        CM1_error_total = [CM1_error_total, CM1_error];
    end
    
    
    % check the number of clustered lines
    totalLineNum = (vpInfo_align(1).n + vpInfo_align(2).n + vpInfo_align(3).n);
    if (totalLineNum ~= size(CM1_error_total,2))
        error('Something is wrong in CM1_error_total!');
    end
    
    
    % compute the mean CM1
    CM1(k) = mean(abs(CM1_error_total));                                % L_1 norm
    % CM1(k) = sqrt(sum(CM1_error_total.^2) / totalLineNum);     % L_2 norm
end


% compute the deviation from 90 degree using CM1
CM1(1) = [];
CM1 = abs(rad2deg(acos(CM1)) - 90);


% compute the root mean squared error (RMSE) of CM1
CM1_RMSE = sqrt(sum(CM1.^2) / M);


end

