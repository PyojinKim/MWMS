function plot_extended_lines(R_cM, vpInfo, imageCurForLine, cam, optsMWMS)

% assign current parameters
L = optsMWMS.imagePyramidLevel;
imageHeight = size(imageCurForLine,1);
imageWidth = size(imageCurForLine,2);


%% plot extended lines and VPs

% plot clustered lines
for k = 1:vpInfo(1).n
    linePixelPts = vpInfo(1).line(k).data;
    pt1_pixel = linePixelPts(1:2);
    pt2_pixel = linePixelPts(3:4);
    
    % plot extended line to VP
    u_start = 1;
    u_end = imageWidth;
    m = (pt2_pixel(2) - pt1_pixel(2)) / (pt2_pixel(1) - pt1_pixel(1));
    v_start = m * (u_start-pt1_pixel(1)) + pt1_pixel(2);
    v_end = m * (u_end-pt1_pixel(1)) + pt1_pixel(2);
    
    % re-arrange pixel point
    linePixelPts = [u_start, v_start, u_end, v_end] / (2^(L-1));
    plot([linePixelPts(1),linePixelPts(3)],[linePixelPts(2),linePixelPts(4)],'r','LineWidth',2.0);
end
for k = 1:vpInfo(2).n
    linePixelPts = vpInfo(2).line(k).data;
    pt1_pixel = linePixelPts(1:2);
    pt2_pixel = linePixelPts(3:4);
    
    % plot extended line to VP
    u_start = 1;
    u_end = imageWidth;
    m = (pt2_pixel(2) - pt1_pixel(2)) / (pt2_pixel(1) - pt1_pixel(1));
    v_start = m * (u_start-pt1_pixel(1)) + pt1_pixel(2);
    v_end = m * (u_end-pt1_pixel(1)) + pt1_pixel(2);
    
    % re-arrange pixel point
    linePixelPts = [u_start, v_start, u_end, v_end] / (2^(L-1));
    plot([linePixelPts(1),linePixelPts(3)],[linePixelPts(2),linePixelPts(4)],'g','LineWidth',2.0);
end
for k = 1:vpInfo(3).n
    linePixelPts = vpInfo(3).line(k).data;
    pt1_pixel = linePixelPts(1:2);
    pt2_pixel = linePixelPts(3:4);
    
    % plot extended line to VP
    u_start = 1;
    u_end = imageWidth;
    m = (pt2_pixel(2) - pt1_pixel(2)) / (pt2_pixel(1) - pt1_pixel(1));
    v_start = m * (u_start-pt1_pixel(1)) + pt1_pixel(2);
    v_end = m * (u_end-pt1_pixel(1)) + pt1_pixel(2);
    
    % re-arrange pixel point
    linePixelPts = [u_start, v_start, u_end, v_end] / (2^(L-1));
    plot([linePixelPts(1),linePixelPts(3)],[linePixelPts(2),linePixelPts(4)],'b','LineWidth',2.0);
end


% plot all VPs
for k = 1:3
    
    % initial VP point
    VP = R_cM(:,k);
    VP_n = VP ./ VP(3);
    VP_p = cam.K * VP_n;
    
    
    % plot VPs
    VP_p_plot = VP_p / (2^(L-1));
    scatter(VP_p_plot(1),VP_p_plot(2),150,[1 1 0],'o');
    scatter(VP_p_plot(1),VP_p_plot(2),50,[1 1 0],'o');
    scatter(VP_p_plot(1),VP_p_plot(2),10,[1 1 0],'o');
end


end

