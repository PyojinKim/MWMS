function [planeNormalVector, planePixelPoint] = estimatePlaneNormalRANSAC(imageCur, depthCur, cam, optsLAPO)

% assign current image pyramid
L = optsLAPO.imagePyramidLevel;
K = cam.K_pyramid(:,:,L);
Kinv = inv(K);


%% plane normal vector with RANSAC

% assign current camera parameters
imageHeight = size(imageCur, 1);
imageWidth = size(imageCur, 2);


% pixel and depth value
pixelPtsRef = zeros(3, imageHeight*imageWidth);
depthPtsRef = zeros(3, imageHeight*imageWidth);
pixelCnt = 0;
for v = 1:imageHeight
    for u = 1:imageWidth
        if (depthCur(v,u) >= optsLAPO.minimumDepth)
            pixelCnt = pixelCnt + 1;
            
            pixelPtsRef(:,pixelCnt) = [u; v; 1];
            depthPtsRef(:,pixelCnt) = depthCur(v,u) * ones(3,1);
        end
    end
end
pixelPtsRef(:,(pixelCnt+1):end) = [];
depthPtsRef(:,(pixelCnt+1):end) = [];


% 3D point cloud
normPtsRef = Kinv * pixelPtsRef;
pointCloudRef = normPtsRef .* depthPtsRef;


% do plane RANSAC
[planeIdx, ~, planeModel] = detectPlaneRANSAC(pointCloudRef, optsLAPO.planeInlierThreshold);
planePixelPoint = pixelPtsRef(:,planeIdx);
planeNormalVector = planeModel(1:3) / norm(planeModel(1:3));
planeNormalVector = planeNormalVector.';


end

