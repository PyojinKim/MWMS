function [temp_R_cM] = seekPlaneManhattanWorld(planeNormalVector)

% temporary vector
tempVector = rand(3,1);
tempVector = tempVector / norm(tempVector);


% vanishing point 1
tempVP1 = cross(planeNormalVector,tempVector);
tempVP1 = tempVP1 / norm(tempVP1);


% vanishing point 2
tempVP2 = cross(planeNormalVector,tempVP1);
tempVP2 = tempVP2 / norm(tempVP2);


% temporary Manhattan frame for single plane
temp_R_cM = [tempVP1, tempVP2, planeNormalVector];


end

