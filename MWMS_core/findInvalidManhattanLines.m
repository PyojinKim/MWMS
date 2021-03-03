function [invalidIndex] = findInvalidManhattanLines(vDD, lineNormals, optsMWMS)

% assign current parameters
vDDAngleThreshold = optsMWMS.verticalLineNormalAngleThreshold;        % degree
polarAngleThreshold = optsMWMS.verticalPolarRegionAngleThreshold;      % degree

invalidIndex = [];
numLines = size(lineNormals,2);


% find invalid image lines for vertical dominant direction
for k = 1:numLines
    
    % compute angle distance between line normal and vDD
    lineNormal = lineNormals(:,k);
    angleDistance = abs(90 - rad2deg(acos(vDD.' * lineNormal)));
    if (angleDistance <= vDDAngleThreshold)
        invalidIndex = [invalidIndex, k];
    end
end


% find invalid image lines near the polar region of vertical dominant direction
for k = 1:numLines
    
    % compute angle distance between line normal and vDD
    lineNormal = lineNormals(:,k);
    angleDistance = rad2deg(acos(vDD.' * lineNormal));
    if ((angleDistance <= polarAngleThreshold) || (angleDistance >= 180 - polarAngleThreshold))
        invalidIndex = [invalidIndex, k];
    end
end


% return invalid line index
invalidIndex = unique(invalidIndex);


% lineNormals_invalid = lineNormals(:,invalidIndex);
% lineNormals(:,invalidIndex) = [];
%
% lines_invalid = lines(invalidIndex,:);
% lines(invalidIndex,:) = [];


end


% % plot invalid line normals on the Gaussian sphere
% figure;
% plot_unit_sphere(1, 20, 0.5); hold on; grid on; axis equal;
% for k = 1:size(lineNormals_invalid,2)
%     normal = lineNormals_invalid(:,k);
%     plot3(normal(1),normal(2),normal(3),'o','MarkerSize',10,'LineWidth',1.5,'Color','k','MarkerFaceColor',[0.5,0.5,0.5]);
% end
% plot_vertical_dominant_direction(vDD, 'm', 0.01);
% plot_vertical_dominant_plane(vDD, 1.5, 'm'); hold off;
% f = FigureRotator(gca());
% %



