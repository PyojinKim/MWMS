if (toVisualize)
    %% update lines & plane on RGB image
    
    axes(ha1); cla;
    plot_tracked_single_plane(imageCurForMW, R_cM, pNV, sNV, sPP, optsMWMS); hold on;
    plot_extended_lines(R_cM, vpInfo, imageCurForLine, cam, optsMWMS);
    plot_display_text(R_cM, sNV, vpInfo, optsMWMS); hold off;
    title('Tracked Single Plane and MW Lines on the Image');
    
    %% update all lines on gray image
    
    axes(ha2); cla;
    plot_image_lines(imageCurForLine, cam, optsMWMS); hold off;
    title('All Detected Lines on the Image');
    
    %% update optimal probe & Manhattan theta intervals
    
    axes(ha3); cla;
    plot_MW_theta_interval_aligned(vpInfo, optimalProbe, thetaIntervals); grid on; xlim([0 90]);
    xlabel('Theta [deg]'); ylabel('Line Index');
    title('Optimal Probe and MW Theta Intervals');
    
    %% update 3-DoF camera orientation
    
    axes(ha4); cla;
    hold on; grid on; axis equal; view(130,30);
    plot_Manhattan_camera_frame(R_cM, R_gc_MWMS(:,:,imgIdx));
    plot_true_camera_frame(R_gc_true(:,:,imgIdx)); hold off;
    title('3-DoF Camera Orientation');
    refresh; pause(0.01);
    
    %% save current figure
    
    if (toSave)
        % save directory for MAT data
        SaveDir = [datasetPath '/ICRA2022'];
        if (~exist( SaveDir, 'dir' ))
            mkdir(SaveDir);
        end
        
        % save directory for images
        SaveImDir = [SaveDir '/MWMS'];
        if (~exist( SaveImDir, 'dir' ))
            mkdir(SaveImDir);
        end
        
        pause(0.01); refresh;
        saveImg = getframe(h);
        imwrite(saveImg.cdata , [SaveImDir sprintf('/%06d.png', imgIdx)]);
    end
end
