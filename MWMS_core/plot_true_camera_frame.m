function plot_true_camera_frame(R_gc_true)

% convert new global frame only for good view
R_gnew_g = [0 0 -1; 1 0 0; 0 -1 0];


% camera orientation
camDir = R_gnew_g * R_gc_true * [2 0 0 0; 0 2 0 0; 0 0 2 0];
plot3([camDir(1,1) camDir(1,4)], [camDir(2,1) camDir(2,4)], [camDir(3,1) camDir(3,4)], 'k', 'LineWidth', 1.5);
plot3([camDir(1,2) camDir(1,4)], [camDir(2,2) camDir(2,4)], [camDir(3,2) camDir(3,4)], 'k', 'LineWidth', 1.5);
plot3([camDir(1,3) camDir(1,4)], [camDir(2,3) camDir(2,4)], [camDir(3,3) camDir(3,4)], 'k', 'LineWidth', 1.5);


end