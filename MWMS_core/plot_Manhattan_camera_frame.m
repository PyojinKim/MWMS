function plot_Manhattan_camera_frame(R_cM, R_gc)

% convert new global frame only for good view
R_gnew_g = [0 0 -1; 1 0 0; 0 -1 0];


% background grid black lines
bglines = [-2 -2 2 -2 2 2;
    -2 -2 0 -2 2 0;
    -2 -2 -2 -2 2 -2;
    0 -2 -2 0 2 -2;
    2 -2 -2 2 2 -2;
    2 -2 2 -2 -2 2;
    2 -2 0 -2 -2 0;
    2 -2 -2 -2 -2 -2;
    2 -2 2 2 -2 -2;
    0 -2 2 0 -2 -2;
    -2 -2 2 -2 -2 -2;
    -2 0 2 -2 0 -2;
    -2 2 2 -2 2 -2;
    2 0 -2 -2 0 -2;
    2 2 -2 -2 2 -2];
for k = 1:size(bglines,1)
    plot3([bglines(k,1) bglines(k,4)], [bglines(k,2) bglines(k,5)], [bglines(k,3) bglines(k,6)], 'k');
end


% camera orientation
camDir = R_gnew_g * R_gc * [2 0 0 0; 0 2 0 0; 0 0 2 0];
plot3([camDir(1,1) camDir(1,4)], [camDir(2,1) camDir(2,4)], [camDir(3,1) camDir(3,4)], 'r:', 'LineWidth', 4);
plot3([camDir(1,2) camDir(1,4)], [camDir(2,2) camDir(2,4)], [camDir(3,2) camDir(3,4)], 'g:', 'LineWidth', 4);
plot3([camDir(1,3) camDir(1,4)], [camDir(2,3) camDir(2,4)], [camDir(3,3) camDir(3,4)], 'b:', 'LineWidth', 4);


% Manhattan frame (vanishing points)
vpColors = [1 0 0;
    0 1 0;
    0 0 1];
for k = 1:3
    vpVector = R_gc * R_cM(:,k);
    vpDir = R_gnew_g * [-2*vpVector, 2*vpVector];
    plot3(vpDir(1,:), vpDir(2,:), vpDir(3,:), 'Color', vpColors(k,:), 'LineWidth', 3);
    text(vpDir(1,2)*1.1, vpDir(2,2)*1.1, vpDir(3,2)*1.1, ['\bf\fontsize{16}VD ' num2str(k)]);
end


end