%% Noise Anomaly Detection %%

close all;
clear all;
load("G002ecg.mat")
load("A1ecg.mat")
load("a2f1ecg.mat")
load("a5c3ecg.mat")

fs = 1000;
orig_sig = a5c3ecg;
orig_sig = orig_sig.*1000; %to see variations

filt = BP(); % Band pass from 16 to 26 Hz
filt_sig = filter(filt, orig_sig); % new signal

time = 0:(1/fs):((length(filt_sig)-1)/fs); %time in seconds
window = 1*fs; % # of secs

%Kota
[R_loc, interval, time]=kotaFunction3(orig_sig,fs,0);
BPM = 60*fs./(interval);
%0.04 for G002
%5 for a2f1
[array_kt,noisy_sig_kt,skt] = std_dev(BPM, 5, 8);

[mfilt_sig,d]=median_fct(R_loc,interval, time, fs);
[array_post,noisy_sig_post,post] = std_dev(mfilt_sig, 5, 8);

bx1 = subplot(4,1,1);
plot(1:length(BPM), BPM);
title('Kota RR interval (s)');
ylabel('RR interval (s)');
axis([0 (1.05*length(BPM)) 0 400]);

bx2 = subplot(4,1,2);
plot(1:length(BPM), BPM);
hold on
%plot(array_pt, noisy_sig_pt, 'rv');
scatter(array_kt, noisy_sig_kt,15, 'r');
title('Noise detection on Kota');
ylabel('RR interval (s)');
axis([0 (1.05*length(BPM)) 0 400]);

bx3 = subplot(4,1,3);
plot(1:length(mfilt_sig), mfilt_sig);
axis([0 (1.05*length(BPM)) 0 400]);

bx4 = subplot(4,1,4);
plot(1:length(mfilt_sig), mfilt_sig);
hold on
%plot(array_pt, noisy_sig_pt, 'rv');
scatter(array_post, noisy_sig_post,15, 'r');
title('Noise detection on Kota');
ylabel('RR interval (s)');
axis([0 (1.05*length(BPM)) 0 400]);

linkaxes([bx1,bx2, bx3, bx4],'x');

[mfilt_sig,d]=median_fct(R_loc,interval, time, fs);


