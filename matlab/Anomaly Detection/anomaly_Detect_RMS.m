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
index = 0;
r = zeros(1,length(filt_sig));

for i = floor(1*window)/2+1:length(filt_sig)-window/2 %0 to #samples; one i is 1/fs
   r(i) = rms(filt_sig(i-floor(window/2):i+(window/2)));
   
   if (r(i)>0.09)
       index = index+1;
       array(index)= i; %take middle window value
   end
end

%create same length signal 
for i = 1:length(array)
    noisy_sig(i) = filt_sig(array(i));
end

%in secs
array = array/fs;
figure;
ax1 = subplot(3,1,1);
plot(time, orig_sig);
title('G002ecg (original signal)');
xlabel('Time (s)');

ax2 = subplot(3,1,2);
plot(time, filt_sig);
title('filtered signal (BP 16-26Hz)');
xlabel('Time (s)');

ax3 = subplot(3,1,3);
plot(time, filt_sig);
hold on
scatter(array, noisy_sig,1,'r');
title('noise detection (rms > 0.09)');
xlabel('Time (s)');

linkaxes([ax1, ax2, ax3], 'x')