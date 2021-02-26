clc;
close all;
clear variables; %clear classes;
rand('state',0); % rand('state',sum(100*clock));
dbstop if error;

addpath('addon/lsd_1.6');
addpath('addon/lsd_1.6/Matlab');
addpath(genpath(pwd));


%% basic setup for MWMS

% choose the experiment case
% ICL NUIM dataset (1~8)
expCase = 1;

% are figures drawn?
% 1 : yes, draw figures to see current status
% 0 : no, just run MWMS
toVisualize = 1;

% are data results saved?
% 1 : yes, save the variables and results
% 0 : no, just run MWMS
toSave = 1;


setupParams_ICL_NUIM;


% load ICL NUIM dataset data
rawICLNUIMdataset = rawICLNUIMdataset_load(datasetPath);


% MWMS / camera calibration parameters
[ICLNUIMdataset] = getSyncTUMRGBDdataset(rawICLNUIMdataset, imInit, M);
optsMWMS = load_param_MWMS;
cam = initialize_cam_TUM_RGBD(ICLNUIMdataset, optsMWMS.imagePyramidLevel);


%% load ground truth data

% ground truth trajectory in ICL NUIM dataset
R_gc_true = zeros(3,3,M);
p_gc_true = zeros(3,M);
T_gc_true = cell(1,M);
for k = 1:M
    % camera body frame
    R_gc_true(:,:,k) = q2r(ICLNUIMdataset.vicon.q_gc_Sync(:,k));
    p_gc_true(:,k) = ICLNUIMdataset.vicon.p_gc_Sync(:,k);
    T_gc_true{k} = [ R_gc_true(:,:,k), p_gc_true(:,k);
        zeros(1,3),           1; ];
end
if (toVisualize)
    figure; hold on; axis equal;
    L = 0.1; % coordinate axis length
    A = [0 0 0 1; L 0 0 1; 0 0 0 1; 0 L 0 1; 0 0 0 1; 0 0 L 1]';
    
    for k = 1:10:M
        T = T_gc_true{k};
        B = T * A;
        plot3(B(1,1:2),B(2,1:2),B(3,1:2),'-r','LineWidth',1); % x: red
        plot3(B(1,3:4),B(2,3:4),B(3,3:4),'-g','LineWidth',1); % y: green
        plot3(B(1,5:6),B(2,5:6),B(3,5:6),'-b','LineWidth',1); % z: blue
    end
    plot3(p_gc_true(1,:),p_gc_true(2,:),p_gc_true(3,:),'k','LineWidth',2);
    
    title('ground truth trajectory of cam0 frame')
    xlabel('x'); ylabel('y'); zlabel('z');
end


% generate ground truth trajectory in vector form
stateTrue = zeros(6,M);
stateTrue(1:3,:) = p_gc_true;
for k = 1:size(p_gc_true,2)
    [yaw, pitch, roll] = dcm2angle(R_gc_true(:,:,k));
    stateTrue(4:6,k) = [roll; pitch; yaw];
end


%% main MWMS part

% 1. Manhattan frame tracking for MWMS
systemInited_MWMS = false;

R_gc1 = R_gc_true(:,:,1);
R_gc_MWMS = zeros(3,3,M);
R_gc_MWMS(:,:,1) = R_gc1;


% 2. make figures to visualize current status
if (toVisualize)
    % create figure
    h = figure(10);
    set(h,'Color',[1 1 1]);
    set(h,'Units','pixels','Position',[200 5 1600 1000]);
    ha1 = axes('Position',[0.03,0.53 , 0.45,0.45]);
    axis off;
    ha2 = axes('Position',[0.53,0.53 , 0.45,0.45]);
    axis off;
    ha3 = axes('Position',[0.07,0.05 , 0.35,0.45]);
    grid on; hold on;
    ha4 = axes('Position',[0.53,0.03 , 0.45,0.45]);
    grid on; hold on;
end


% 3. record some variables
R_cM_MWMS = cell(1,M);
vpInfo_MWMS = cell(1,M);
pNV_MWMS = cell(1,M);


% do Manhattan world max stabbing (MWMS)
for imgIdx = 1:M
    
    % read RGB, gray, and depth images
    imageCurForLine = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'gray');
    imageCurForMW = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'rgb');
    depthCurForMW = getImgInTUMRGBDdataset(datasetPath, ICLNUIMdataset, cam, imgIdx, 'depth');
    [imageCurForMW, depthCurForMW] = getImgPyramid(imageCurForMW, depthCurForMW, optsMWMS.imagePyramidLevel);
    
    
    % for the first time in this loop
    if (~systemInited_MWMS)
        
        % initialize and seek the dominant MF (vertical dominant direction (2-DoF) and MW direction (1-DoF))
        [R_cM, vpInfo, pNV, sNV, sPP, optimalProbe, thetaIntervals] = seekManhattanWorld(imageCurForLine, imageCurForMW, depthCurForMW, cam, optsMWMS);
        R_c1M = R_cM;
        R_gM = R_gc1 * R_c1M;
        systemInited_MWMS = true;
        
    elseif (systemInited_MWMS)
        
        % track Manhattan frame
        [R_cM, vpInfo, pNV, sNV, sPP, optimalProbe, thetaIntervals] = trackManhattanWorld(R_cM, pNV, imageCurForLine, imageCurForMW, depthCurForMW, cam, optsMWMS);
        R_cM_MWMS{imgIdx} = R_cM;
        vpInfo_MWMS{imgIdx} = vpInfo;
        pNV_MWMS{imgIdx} = pNV;
        
        
        % update current 3-DoF camera orientation
        R_gc_current = R_gM * inv(R_cM);
        R_gc_MWMS(:,:,imgIdx) = R_gc_current;
    end
    
    
    % visualize current status
    if (imgIdx >= 2)
        plots_status_with_true;
    end
end


%% plot error evaluation metric (CM1, CM2, RMD)

% compute R_cM_true (true VPs) for error metric
R_cM_true = cell(1,M);
for k = 1:M
    R_cM_true{k} = inv(R_gc_true(:,:,k)) * R_gM;
end


% 1) Consistency Measure 1 (CM1) with ground truth VPs
[CM1_RMSE_MWMS, CM1_MWMS] = computeConsistencyMeasure1(R_cM_true, vpInfo_MWMS, cam);


% 2) Consistency Measure 2 (CM2) with ground truth VPs
[CM2_RMSE_MWMS, CM2_MWMS] = computeConsistencyMeasure2(R_cM_true, vpInfo_MWMS, cam);


% 3) Rotation Matrix Difference (RMD)
[RMD_MEAN_MWMS, RMD_MWMS] = computeRotationMatrixDifference(R_gc_true, R_gc_MWMS);


% plot three error evaluation metrics together
figure;
subplot(3,1,1);
plot(CM1_MWMS); grid on; axis tight;
title('CM1 [deg]');
subplot(3,1,2);
plot(CM2_MWMS); grid on; axis tight;
title('CM2 [pixel]');
subplot(3,1,3);
plot(RMD_MWMS); grid on; axis tight;
title('RMD [deg]');


%% save the experiment data for IROS 2021

if (toSave)
    save([SaveDir '/MWMS.mat']);
end

