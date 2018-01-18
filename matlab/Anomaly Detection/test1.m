close all;
clear all;
load("G002ecg.mat")
load("A1ecg.mat")
load("a2f1ecg.mat")
load("a5c3ecg.mat")
load("G011ecg.mat")
load("G013ecg.mat")

fs = 1000;
orig_sig = a5c3ecg;
orig_sig = transpose(orig_sig);
filt = BP(); % Band pass from 16 to 26 Hz
filt_sig = filter(filt, orig_sig); % new signal
time = 0:(1/fs):((length(filt_sig)-1)/fs); %time in seconds
%get BPM Kota
[R_loc, interval, time]=kotaFunction3(orig_sig,fs,0);



[array_post, noisy_sig_post] = post_test(R_loc, fs);

%[mfilt_sig, array_post, noisy_sig_post, std_post] = Post_fct(orig_sig, mfilt_size, window, threshold, plot);
%[mfilt_sig, array_post, noisy_sig_post, std_post] = post_test(fs, R_loc, mfilt_size, window, threshold, plot);
