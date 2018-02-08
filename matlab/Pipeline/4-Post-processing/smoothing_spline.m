function [f_spline] = post_proc(fs, detrended, R_loc, BPM)
    interval = diff(R_loc);
    interval(length(interval)+1) = 0;
    interval = 60*fs./(interval);
    time = 0:(1/fs):((length(detrended)-1)/fs);
    
    figure;
    subplot(2,1,2);
    %default value is 0.99
    f_spline = fit(transpose(time(R_loc)),transpose(BPM),'smoothingspline','SmoothingParam',0.99);
    plot(f_spline,time(R_loc),interval);
    ylim([100 200]);
    
    subplot(2,1,1); 
    %original for comparison
    f=fit(transpose(time(R_loc)),transpose(BPM),'smoothingspline');
    plot(f,time(R_loc),interval);
    ylim([100 200]);