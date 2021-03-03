function [normLineModel] = estimateLineModel(P1, P2)
% Project:
% Function: estimateLineModel
%
% Description:
%   get the line model parameters [a,b,c] <= 'a*x + b*y + c = 0'
%
% Example:
%   OUTPUT :
%   normLineModel: normalized line model parameters - [a,b,c]
%
%
%   INPUT :
%   P1 : Point #1 on the line [X,Y];
%   P2 : Point #2 on the line [X,Y];
%
% NOTE:
%
%
% Author: Pyojin Kim
% Email: pjinkim1215@gmail.com
% Website:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% log:
% 2017-09-30 : Complete
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%


% calculate the [a, b, c] in the line equation
a = P2(2) - P1(2);
b = P1(1) - P2(1);
c = P2(1) * P1(2) - P1(1) * P2(2);


% calculate the model parameters of the line equation
lineModel = [a, b, c];
normLineModel = lineModel ./ (min(abs(lineModel)));


% check the validity of the line equation
% a * P1(1) + b * P1(2) + c
% a * P2(1) + b * P2(2) + c
% normLineModel(1) * P1(1) + normLineModel(2) * P1(2) + normLineModel(3)
% normLineModel(1) * P2(1) + normLineModel(2) * P2(2) + normLineModel(3)


end
