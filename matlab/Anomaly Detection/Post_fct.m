%% Noise Anomaly Detection %%
function [mfilt_sig, array_post, noisy_sig_post, std_post] = Post_fct(orig_sig, window, thresh, plt)

close all;
load("G002ecg.mat")
load("A1ecg.mat")
load("a2f1ecg.mat")
load("a5c3ecg.mat")

fs = 1000;
%orig_sig = a5c3ecg;
orig_sig = transpose(orig_sig);
filt = BP(); % Band pass from 16 to 26 Hz
filt_sig = filter(filt, orig_sig); % new signal
time = 0:(1/fs):((length(filt_sig)-1)/fs); %time in seconds
%window = 1*fs; % # of secs

%get BPM Kota
[R_loc, interval, time]=kotaFunction3(orig_sig,fs,0);
BPM = 60*fs./(interval);

%filter BPM
[mfilt_sig,d]=median_fct(R_loc,interval, time, fs);
%get noise of filtered bpm
%10,4
[array_post,noisy_sig_post,std_post] = std_dev(mfilt_sig, window, thresh);

if (plt == 1)
    
    figure;
    %plot BPM
    bx1 = subplot(3,1,1);
    plot(1:length(BPM), BPM);
    title("Kota BPM");
    xlabel("Time (s)");
    ylabel("BPM");
    axis([0 (1.05*length(BPM)) 0 400]);

    %median filtered
    bx2 = subplot(3,1,2);
    plot(1:length(mfilt_sig), mfilt_sig);
    title("BPM after 5 sample median filter");
    xlabel("Time (s)");
    ylabel("BPM");
    axis([0 (1.05*length(BPM)) 0 400]);

    %noise
    bx3 = subplot(3,1,3);
    plot(1:length(mfilt_sig), mfilt_sig);
    hold on
    %plot(array_pt, noisy_sig_pt, 'rv');
    scatter(array_post, noisy_sig_post,15, 'r');
    title("Std Dev Noise detection with threshold = "+ thresh);
    xlabel("Time (s)");
    ylabel("BPM");
    axis([0 (1.05*length(BPM)) 0 400]);

    linkaxes([bx1,bx2, bx3],'x');

end