%% Noise Anomaly Detection %%

close all;
% clear all;
% load("G002ecg.mat")
% load("A1ecg.mat")
% load("a2f1ecg.mat")
% load("a5c3ecg.mat")

fs = 1000;
time = 1:length(periods);
window = 5;
index = 0;
s = zeros(1,length(periods));

for i = floor(1*window)/2+1:length(periods)-window/2 %0 to #samples; one i is 1/fs
   s(i) = std(periods(i-floor(window/2):i+(window/2)));
   
   % 0.09 for G002, 0.11 for a2f1, 0.145 for a5c3
   if (s(i)>0.09)
       index = index+1;
       array(index)= i; %take middle window value
   end
end

% for i = 1:length(array)
%     noisy_sig(i) = filt_sig(array(i));
% end

%in secs
array = array/fs;
figure;
ax1 = subplot(3,1,1);
plot(time, orig_sig);
title('A1ecg (original signal)');
xlabel('Time (s)');

ax2 = subplot(3,1,2);
plot(time, filt_sig);
title('filtered signal (BP 16-26Hz)');
xlabel('Time (s)');

ax3 = subplot(3,1,3);
plot(time, filt_sig);
hold on
scatter(array, noisy_sig,1,'r');
title('noise detection (std dev > 0.145)');
xlabel('Time (s)');

linkaxes([ax1, ax2, ax3], 'x')




%quantization
%tachogram
%brady cardio: < 100
