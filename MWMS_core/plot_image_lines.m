function plot_image_lines(imageCurForLine, cam, optsMWMS)

% assign current parameters
lineDetector = optsMWMS.lineDetector;
lineLength = optsMWMS.lineLength;


% line detection
dimageCurForLine = double(imageCurForLine);
if (strcmp(lineDetector,'lsd'))
    [lines, ~] = lsdf(dimageCurForLine, (lineLength^2));
elseif (strcmp(lineDetector,'gpa'))
    [lines, ~] = gpa(imageCurForLine, lineLength);
end
lines = extractUniqueLines(imageCurForLine, lines, cam);


% plot image and lines
imshow(imageCurForLine,[]); hold on;
for k = 1:size(lines,1)
    plot([lines(k,1),lines(k,3)],[lines(k,2),lines(k,4)],'LineWidth',2.5);
end


end

