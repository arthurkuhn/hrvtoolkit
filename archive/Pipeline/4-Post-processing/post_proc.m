%% Noise Anomaly Detection %%
function [array_post, noisy_sig_post, std_post, diff_sig] = post_proc(detrended, sig, BPM, R_loc, fs, mfilt_size)


% prev out
% [array_post, noisy_sig_post, std_post, diff_sig]
time = 0:(1/fs):((length(sig)-1)/fs);
plot_graph = 1;
%median filter
%mfilt_size = 15;
%std dev
window = 10;
threshold = 4;

%median filter
mfilt_sig = medfilt1(BPM,mfilt_size);
%std dev filter
[array_post,noisy_sig_post,std_post] = std_dev(mfilt_sig, window, threshold);

if (plot_graph == 1)
    figure;
    bx1 = subplot(3,1,1);
    hold on;
    plot (time,detrended);
    plot(time(R_loc),detrended(R_loc),'rv','MarkerFaceColor','r')
    legend('ECG','R');
    title('ECG Signal with R points');
    xlabel('Time in seconds');
    ylabel('Amplitude');
    
    %     figure;
    %     %plot BPM
    %     bx1 = subplot(3,1,1);
    %     plot(time(R_loc), BPM);
    %     title("Kota BPM");
    %     xlabel("Time (s)");
    %     ylabel("BPM");
    %     ylim([0 300]);
    %axis([0 (1.05*length(time(R_loc))) 0 300]);
    %median filtered
    
    bx2 = subplot(3,1,2);
    f=fit(transpose(time(R_loc)),transpose(BPM),'smoothingspline');
    plot(f,time(R_loc),interval);
    %plot(1:length(mfilt_sig), mfilt_sig);
    title("BPM Arthur");
    %title("BPM after 5 sample median filter");
    xlabel("Time (s)");
    ylabel("BPM");
    %axis([0 (1.05*length(BPM)) 0 200]);
    ylim([50 250]);
    %axis([0 (1.05*length(time(R_loc))) 0 300]);
    
    
    
    %noise
    bx3 = subplot(3,1,3);
    plot(time(R_loc),mfilt_sig);
    hold on
    %plot(array_pt, noisy_sig_pt, 'rv');
    scatter(time(R_loc(array_post)), noisy_sig_post,15, 'r');
    title("Std Dev Noise detection with threshold = "+ threshold + " and window size = "+ mfilt_size);
    xlabel("Time (s)");
    ylabel("BPM");
    %axis([0 (1.05*length(BPM)) 0 200]);
    ylim([0 300]);
    %axis([0 (1.05*length(time(R_loc))) 0 300]);
    
    linkaxes([bx1,bx2, bx3],'x');
    
    diff_sig = diff(std_post);
    diff_sig(length(diff_sig)+1)=0;
    figure;
    subplot(3, 1, 1);
    plot(time(R_loc),mfilt_sig);
    hold on
    %plot(array_pt, noisy_sig_pt, 'rv');
    scatter(time(R_loc(array_post)), noisy_sig_post,15, 'r');
    title("Std Dev Noise detection with threshold = "+ threshold + " and window size = "+ mfilt_size);
    xlabel("Time (s)");
    ylabel("BPM");
    %axis([0 (1.05*length(BPM)) 0 200]);
    ylim([0 300]);
    %axis([0 (1.05*length(time(R_loc))) 0 300]);
    
    subplot(3, 1, 2);
    plot(time(R_loc), std_post);
    
    subplot(3, 1, 3);
    plot(time(R_loc), diff_sig);
end