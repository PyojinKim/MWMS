function [alpha, beta, ManhattanDirection_Z] = parametrizeVerticalDD(ManhattanDirection_Z)

% convert from vertical dominant direction to alpha, beta
beta = asin(ManhattanDirection_Z(3));
alpha = atan(ManhattanDirection_Z(2)/ManhattanDirection_Z(1));


% check Manhattan Z direction vector is on the hemisphere
vDD = [cos(alpha) * cos(beta); sin(alpha) * cos(beta); sin(beta)];
if (norm(vDD - ManhattanDirection_Z) > 0.001)
    
    % choose the opposite direction
    ManhattanDirection_Z = -ManhattanDirection_Z;
    beta = asin(ManhattanDirection_Z(3));
    alpha = atan(ManhattanDirection_Z(2)/ManhattanDirection_Z(1));
end


end

