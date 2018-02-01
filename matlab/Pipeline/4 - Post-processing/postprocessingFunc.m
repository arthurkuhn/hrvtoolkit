function [ cleanTachogram, validLocs ] = postprocessingFunc( sig, fs )
%POSTPROCESSINGFUNC Median Filters and Detects noise
%   Inputs:
%       - Sig: The location of the r-peaks on the ECG
%       - Fs: The sampling frequency
%
%   Outputs:
%       - cleanTachogram: The filtered BPM signal 
%       - validLocs: An array with the beats that are marked as noisy
%           AFTER the signal has been filtered. (Therefore beats that are
%           flagged by the std filter).
time = 0:(1/fs):((length(sig)-1)/fs);
interval = diff(sig);
interval(length(interval)+1) = interval(length(interval));

BPM = 60*fs./(interval);
%get noise of original bpm 
[array_kt,noisy_sig_kt,skt] = std_dev(BPM, 5, 8);
%filter BPM
[mfilt_sig,d]=median_fct(sig,interval, time, fs);
%get noise of filtered bpm
[array_post,noisy_sig_post,post] = std_dev(mfilt_sig, 5, 8);

cleanTachogram = mfilt_sig;
noisyBeats = noisy_sig_post;

%plot BPM
bx1 = subplot(4,1,1);
plot(1:length(BPM), BPM);
title('Kota BPM');
xlabel('Time (s)');
ylabel('BPM');
axis([0 (1.05*length(BPM)) 0 400]);

%noise
bx2 = subplot(4,1,2);
plot(1:length(BPM), BPM);
hold on
scatter(array_kt, noisy_sig_kt,15, 'r');
title('Noise detection on Kota BPM');
xlabel('Time (s)');
ylabel('BPM');
axis([0 (1.05*length(BPM)) 0 400]);

%median filtered
bx3 = subplot(4,1,3);
plot(1:length(mfilt_sig), mfilt_sig);
title('BPM after 5 sample median filter');
xlabel('Time (s)');
ylabel('BPM');
axis([0 (1.05*length(BPM)) 0 400]);

%noise
bx4 = subplot(4,1,4);
plot(1:length(mfilt_sig), mfilt_sig);
hold on
%plot(array_pt, noisy_sig_pt, 'rv');
scatter(array_post, noisy_sig_post,15, 'r');
title('Noise detection on median filtered BPM');
xlabel('Time (s)');
ylabel('BPM');
axis([0 (1.05*length(BPM)) 0 400]);

linkaxes([bx1,bx2, bx3, bx4],'x');

%[mfilt_sig,d]=median_fct(R_loc,interval, time, fs);



end

