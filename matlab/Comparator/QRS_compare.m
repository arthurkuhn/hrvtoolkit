%% Runs 2 algorithms and keeps only matching detections %%

close all;
clear all;
load("G002ecg.mat")
load("A1ecg.mat")
load("a2f1ecg.mat")
load("a5c3ecg.mat")

fs = 1000;
orig_sig = G002ecg;
orig_sig = orig_sig.*1000; %to see variations

filt = BP(); % Band pass from 16 to 26 Hz
filt_sig = filter(filt, orig_sig); % new signal

time = 0:(1/fs):((length(filt_sig)-1)/fs); %time in seconds
window = 1*fs; % # of secs
%threshold = 0.09;
% 0.09 for G002, 0.11 for a2f1, 0.145 for a5c3
%[array_ecg,noisy_sig_ecg, s] = std_dev(filt_sig, 0.09, window);

[qrs_amp_raw,qrs_i_raw,delay]=pan_tompkin(orig_sig,1000,0);
period = diff(qrs_i_raw);
period(length(period)+1) = 0;
period = period./fs; %period in seconds
[array_pt,noisy_sig_pt,spt] = std_dev(period, 0.04, 8);

[qrs_amp_raw2,qrs_i_raw2]=kotaFunction2(orig_sig,1000,0);
period2 = diff(qrs_i_raw2);
period2(length(period2)+1) = 0;
period2 = period2./fs; %period in seconds
[array_kt,noisy_sig_kt,skt] = std_dev(period2, 0.04, 8);
