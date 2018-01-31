%% Noise Anomaly Detection %%
function [array_post, noisy_sig_post] = post_test(R_loc, fs)
 
%median filter
mfilt_size = 5;
%std dev
window = 10;
threshold = 4;
%1 for plot
plot_graph = 1;

interval = diff(R_loc);
%get BPM Kota
BPM = 60*fs./(interval);
%median filter
mfilt_sig = medfilt1(BPM,mfilt_size);
%std dev filter
[array_post,noisy_sig_post,std_post] = std_dev(mfilt_sig, window, threshold);

if (plot_graph == 1)
    
    figure;
    %plot BPM
    bx1 = subplot(3,1,1);
    plot(1:length(BPM), BPM);
    title("Kota BPM");
    xlabel("Time (s)");
    ylabel("BPM");
    axis([0 (1.05*length(BPM)) 0 300]);

    %median filtered
    bx2 = subplot(3,1,2);
    plot(1:length(mfilt_sig), mfilt_sig);
    title("BPM after 5 sample median filter");
    xlabel("Time (s)");
    ylabel("BPM");
    axis([0 (1.05*length(BPM)) 0 200]);
    axis([0 (1.05*length(BPM)) 0 300]);

    %noise
    bx3 = subplot(3,1,3);
    plot(1:length(mfilt_sig), mfilt_sig);
    hold on
    %plot(array_pt, noisy_sig_pt, 'rv');
    scatter(array_post, noisy_sig_post,15, 'r');
    title("Std Dev Noise detection with threshold = "+ threshold);
    xlabel("Time (s)");
    ylabel("BPM");
    axis([0 (1.05*length(BPM)) 0 200]);
    axis([0 (1.05*length(BPM)) 0 300]);

    linkaxes([bx1,bx2, bx3],'x');

end