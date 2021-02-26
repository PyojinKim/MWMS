function [optsMWMS] = load_param_MWMS
% Project:   Manhattan World Estimation with Max Stabbing (MWMS)
% Function: load_param_MWMS
%
% Description:
%   get the initial parameters with respect to the MWMS algorithm
%
% Example:
%   OUTPUT:
%   optsMWMS: options for MWMS process like below
%
%   INPUT:
%
%
% NOTE:
%     The parameters below are initialized as the CVPR paper
%
% Author: Pyojin Kim
% Email: pjinkim1215@gmail.com
% Website:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% log:
% 2020-03-13: Complete
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%


% line detection parameters
optsMWMS.lineDetector = 'lsd';     % 'gpa'
optsMWMS.lineDescriptor = 'lbd';
optsMWMS.lineLength = 70;


% plane detection and tracking parameters
optsMWMS.imagePyramidLevel = 2;
optsMWMS.minimumDepth = 0.4;
optsMWMS.maximumDepth = 8;
optsMWMS.planeInlierThreshold = 0.02;
optsMWMS.cellsize = 10;
optsMWMS.minSampleRatio = 0.15;

optsMWMS.numInitialization = 200;
optsMWMS.iterNum = 200;
optsMWMS.convergeAngle = deg2rad(0.001);
optsMWMS.halfApexAngle = deg2rad(10);
optsMWMS.c = 20;
optsMWMS.ratio = 0.1;


% horizontal direction detection parameters
optsMWMS.verticalLineNormalAngleThreshold = 3.0;     % degree
optsMWMS.verticalPolarRegionAngleThreshold = 6.0;    % degree


% Kalman filter parameters
optsMWMS.initialVPAngleNoise = deg2rad(1);
optsMWMS.processNoise = deg2rad(0.5);
optsMWMS.measurementNoise = deg2rad(0.5);


end






