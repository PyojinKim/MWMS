function plot_tracked_single_plane(imageShow, R_cM, planeNormalVector, surfaceNormalVector, surfacePixelPoint, optsMWMS)

% assign current parameters
imageHeight = size(imageShow,1);
imageWidth = size(imageShow,2);
halfApexAngle = optsMWMS.halfApexAngle;
ManhattanXYZIndex = find(abs(planeNormalVector.' * R_cM) > cos(deg2rad(5)));
if (ManhattanXYZIndex == 1)
    planeRGBColor = [255;0;0];          % X axis: red
elseif (ManhattanXYZIndex == 2)
    planeRGBColor = [0;255;0];          % Y axis: green
elseif (ManhattanXYZIndex == 3)
    planeRGBColor = [0;0;255];          % Z axis: blue
else
    error('Something is wrong in plot_tracked_single_plane!');
end


%% project normal vectors to plane normal vector

% default parameters
numNormalVector = size(surfaceNormalVector,2);
planeIndex = ones(1,numNormalVector) * -1000;

% projection on plane normal vector axis
R_cM = seekPlaneManhattanWorld(planeNormalVector);
R_Mc = R_cM.';
n_j = R_Mc * surfaceNormalVector;

% check within half apex angle
lambda = sqrt(n_j(1,:).*n_j(1,:) + n_j(2,:).*n_j(2,:));
index = find(lambda <= sin(halfApexAngle));
planeIndex(:,index) = 1;


%% plot tracked single plane segmentation results

% construct plane RGB mask
planeRGBMask = uint8(zeros(imageHeight,imageWidth,3));
for k = 1:numNormalVector
    
    % current pixel position
    tempPixel = surfacePixelPoint(:,k);
    a = planeIndex(k);
    
    % check tracked single plane or not
    if (a == 1)
        % R / G / B
        for m = 1:size(tempPixel,2)
            u = tempPixel(1,m);
            v = tempPixel(2,m);
            planeRGBMask(v,u,1) = planeRGBColor(1);
            planeRGBMask(v,u,2) = planeRGBColor(2);
            planeRGBMask(v,u,3) = planeRGBColor(3);
        end
    else
        % gray
        for m = 1:size(tempPixel,2)
            u = tempPixel(1,m);
            v = tempPixel(2,m);
            planeRGBMask(v,u,1) = 150;
            planeRGBMask(v,u,2) = 150;
            planeRGBMask(v,u,3) = 150;
        end
    end
end


% plot plane segmentation results
imshow(imageShow,[]); hold on;
h_planeRGBMask = imshow(planeRGBMask,[]);
set(h_planeRGBMask, 'AlphaData', 0.5);


end