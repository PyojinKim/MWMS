function [pNV_update, isTracked] = trackSinglePlane(planeNormalVector, surfaceNormalVector, optsLAPO)

% pre-defined variables
minSampleRatio = optsLAPO.minSampleRatio;
iterNum = optsLAPO.iterNum;
convergeAngle = optsLAPO.convergeAngle;
halfApexAngle = optsLAPO.halfApexAngle;
c = optsLAPO.c;


%% track single plane (Manhattan world frame)

% initial model parameters
pNV = planeNormalVector;
pNV_update = pNV;
numNormalVector = size(surfaceNormalVector, 2);
minSampleNum = round(numNormalVector * minSampleRatio);


% do mean shift iteration
for iterCount = 1:iterNum
    
    % for next iteration
    pNV = pNV_update;
    
    
    % project to plane normal vector (Manhattan frame axis)
    R_cM = seekPlaneManhattanWorld(pNV);
    R_Mc = R_cM.';
    n_j = R_Mc * surfaceNormalVector;
    
    lambda = sqrt(n_j(1,:).*n_j(1,:) + n_j(2,:).*n_j(2,:));
    conicIdx = find(lambda < sin(halfApexAngle));
    n_j_inlier = n_j(:,conicIdx);
    
    tan_alfa = lambda(conicIdx)./abs(n_j(3,conicIdx));
    alfa = asin(lambda(conicIdx));
    m_j = [alfa./tan_alfa.*n_j_inlier(1,:)./n_j_inlier(3,:);
        alfa./tan_alfa.*n_j_inlier(2,:)./n_j_inlier(3,:)];
    
    select = ~isnan(m_j);
    select2 = select(1,:).*select(2,:);
    select3 = find(select2 == 1);
    m_j = m_j(:,select3);
    
    
    % number of surface normal vector
    if (size(m_j, 2) >= minSampleNum)
        
        % perform mean shift
        [s_j, ~] = MeanShift(m_j, c);
        
        % new plane normal vector
        alfa = norm(s_j);
        ma_p = tan(alfa)/alfa * s_j;
        pNV_update = R_Mc.' * [ma_p; 1];
        pNV_update = pNV_update / norm(pNV_update);
    else
        
        % return invalid result
        pNV_update = [];
        isTracked = 0;
        return;
    end
    
    
    % check convergence
    if (acos(pNV.' * pNV_update) < convergeAngle)
        break;
    end
end

isTracked = 1;


end


