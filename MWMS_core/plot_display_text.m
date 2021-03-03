function plot_display_text(R_cM, sNV, vpInfo, optsMWMS)

% number of sNV
numNV = computeNumInXYZCone(R_cM, sNV, optsMWMS.halfApexAngle);


% number of lines
numLines = zeros(1,3);
numLines(1) = vpInfo(1).n;
numLines(2) = vpInfo(2).n;
numLines(3) = vpInfo(3).n;


% display current status
text(7, 10, sprintf('sNV: %05d, %05d, %05d', numNV(1), numNV(2), numNV(3)), 'Color', 'y', 'FontSize', 11, 'FontWeight', 'bold');
text(7, 22, sprintf('lines: %05d, %05d, %05d', numLines(1), numLines(2), numLines(3)), 'Color', 'y', 'FontSize', 11, 'FontWeight', 'bold');


end

