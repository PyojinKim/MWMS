function [RMD_MEAN, RMD] = computeRotationMatrixDifference(R_gc_true, R_gc_esti)

% assign current parameters
M = length(R_gc_true);

RMD = zeros(1,M);


% compute Rotation Matrix Difference (RMD)
for k = 1:M
    
    % true & estimated R_gc
    Rgc_True = R_gc_true(:,:,k);
    Rgc_Esti = R_gc_esti(:,:,k);
    
    
    % compute the RMD
    RMD(k) = acos((trace(Rgc_True.' * Rgc_Esti)-1)/2) * (180/pi);
end


% compute the mean of RMD
RMD = real(RMD);
RMD_MEAN = mean(RMD);


end

