function [clusteredLineIdx] = clusterManhattanMaxStabbingLines(R_cM, optimalProbe, thetaIntervals)

% unpack Manhattan world directions
ManhattanDirection_X = R_cM(:,1);
ManhattanDirection_Y = R_cM(:,2);
ManhattanDirection_Z = R_cM(:,3);


% single theta angle parameterization
beta = asin(ManhattanDirection_Z(3));
alpha = atan(ManhattanDirection_Z(2)/ManhattanDirection_Z(1));
vDDParams = parametrizeHorizontalDD([cos(alpha), sin(alpha), cos(beta), sin(beta)]);
Manhattan_X = computeHorizontalDDfromTheta(vDDParams, optimalProbe);
if (sum(ManhattanDirection_X == Manhattan_X) ~= 3)
    error('Something is wrong in R_cM!');
end


% cluster lines for Manhattan world
clusteredLineIdx = cell(1,3);
numIntervals = size(thetaIntervals,1);
Manhattan_X_index = [];
Manhattan_Y_index = [];
for k = 1:numIntervals
    
    % MW theta interval
    startPoint = thetaIntervals(k,1);
    endPoint = thetaIntervals(k,2);
    lineIndex = thetaIntervals(k,3);
    isShifted = boolean(thetaIntervals(k,4));
    
    
    % check valid theta interval
    if ((startPoint <= optimalProbe) && (optimalProbe <= endPoint))
        if (isShifted == 0)
            Manhattan_X_index = [Manhattan_X_index, lineIndex];
        else
            Manhattan_Y_index = [Manhattan_Y_index, lineIndex];
        end
    end
end
Manhattan_X_index = unique(Manhattan_X_index);
Manhattan_Y_index = unique(Manhattan_Y_index);


% save the results
clusteredLineIdx{1} = Manhattan_X_index;
clusteredLineIdx{2} = Manhattan_Y_index;


end


% % plot lines for Manhattan world
% figure;
% imshow(imageCurForLine, []); hold on;
% for k = Manhattan_X_index
%     plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'color','r','LineWidth',2.5);
% end
% for k = Manhattan_Y_index
%     plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'color','g','LineWidth',2.5);
% end
%
%
% % plot line normals on the Gaussian sphere
% figure;
% plot_unit_sphere(1, 20, 0.5); hold on; grid on; axis equal;
% for k = Manhattan_X_index
%     normal = lineNormals(:,k);
%     plot3(normal(1),normal(2),normal(3),'o','MarkerSize',10,'LineWidth',2.5,'Color','r','MarkerFaceColor','r');
% end
% for k = Manhattan_Y_index
%     normal = lineNormals(:,k);
%     plot3(normal(1),normal(2),normal(3),'o','MarkerSize',10,'LineWidth',2.5,'Color','g','MarkerFaceColor','g');
% end
% plot_vertical_dominant_direction(ManhattanDirection_X, 'r', 0.01);
% plot_vertical_dominant_direction(ManhattanDirection_Y, 'g', 0.01);
% f = FigureRotator(gca());
% %


