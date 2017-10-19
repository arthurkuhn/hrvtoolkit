%% Noise Anomaly Detection %%

close all;
clear all;
load("G002ecg.mat")
load("A1ecg.mat")
load("a2f1ecg.mat")
load("a5c3ecg.mat")

fs = 1000;
orig_sig = A1ecg;
orig_sig = orig_sig.*1000; %to see variations

filt = BP(); % Band pass from 16 to 26 Hz
filt_sig = filter(filt, orig_sig); % new signal

time = 0:(1/fs):((length(filt_sig)-1)/fs); %time in seconds
window = 1*fs; % # of secs
index = 0;
s = zeros(1,length(filt_sig));

for i = floor(1*window)/2+1:length(filt_sig)-window/2 %0 to #samples; one i is 1/fs
   %r(i) = rms(orig_sig(i:i+window));
   s(i) = std(filt_sig(i-floor(window/2):i+(window/2)));
   
   %if (r(i) > 0.1261) %0.11, 0.09
   if (s(i)>0.09)
  % if (s(i) > 0.09)
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
subplot(3,1,1);
plot(time, orig_sig);
title('A1ecg (original signal)');
xlabel('Time (s)');


subplot(3,1,2);
plot(time, filt_sig);
title('filtered signal (BP 16-26Hz)');
xlabel('Time (s)');


subplot(3,1,3);
plot(time, filt_sig);
hold on
scatter(array, noisy_sig,1,'r');
title('noise detection (std dev > 0.145)');
xlabel('Time (s)');



% figure;
% plot(1:length(s),s);
% scatter(array, noisy_sig,1,'c');
% %axis([0 300 -2.5e-3 1.5e-3]);
% title('max RMS = 0.0013');
% xlabel('Time (s)');

% subplot(3,1,3);
% plot(time, sig2);
% axis([0 300 -0.25e-3 0.1e-3]);
% title('max RMS = 0.00126');
% xlabel('Time (s)');

% %STD DEV : WINDOW = 0.5s;
% for i = 0:numwindows-1 %0 to # windows
%    s = std(orig_sig(i*window+1:(i+1)*window));
% 
%    if (s > 1.35e-04)
%        sig3(i*window+1:(i+1)*window) = mean(orig_sig(1:length(orig_sig)-1)); % put to mean 
%    end
%    if (s > 1.3e-04)
%        sig4(i*window+1:(i+1)*window) = mean(orig_sig(1:length(orig_sig)-1)); % put to mean  
% 
%        
%   % elseif (r > 0.00125)
%   %     sig2(i*window+1:(i+1)*window) = 0;       
%   % else
%        %not noisy
%    end
% end
% 
% 
% figure;
% subplot(3,1,1);
% plot(time, orig_sig);
% axis([0 300 -0.25e-3 0.1e-3]);
% title('Original signal');
% xlabel('Time (s)');
% 
% subplot(3,1,2);
% plot(time, sig3);
% axis([0 300 -0.25e-3 0.1e-3]);
% title('Max standard deviation = 1.35e-04');
% xlabel('Time (s)');
% 
% subplot(3,1,3);
% plot(time, sig4);
% axis([0 300 -0.25e-3 0.1e-3]);
% title('Max standard deviation = 1.3e-04');
% xlabel('Time (s)');
% 
% 
% %SKEW
% for i = 0:numwindows-1 %0 to # windows
%    sk = skewness(orig_sig(i*window+1:(i+1)*window));
%    if (sk > 3.95)
%        sig5(i*window+1:(i+1)*window) = mean(orig_sig(1:length(orig_sig)-1));
%    end
%    if (sk > 3.85)
%        sig6(i*window+1:(i+1)*window) = mean(orig_sig(1:length(orig_sig)-1));       
%    else
%        %not noisy
%    end
% end
% 
% figure;
% subplot(3,1,1);
% plot(time, orig_sig);
% axis([0 300 -0.25e-3 0.1e-3]);
% title('Original signal');
% xlabel('Time (s)');
% 
% subplot(3,1,2);
% plot(time, sig5);
% axis([0 300 -0.25e-3 0.1e-3]);
% title('Max skewness = 3.95');
% xlabel('Time (s)');
% 
% subplot(3,1,3);
% plot(time, sig6);
% axis([0 300 -0.25e-3 0.1e-3]);
% title('Max skewness = 3.85');
% xlabel('Time (s)');

% orig_sig1 = filter(filt, orig_sig);
% 
% % RMS signals
% sig1 = orig_sig;
% sig2 = orig_sig;
% % STD signals
% sig3 = orig_sig;
% sig4 = orig_sig;
% % SKEWNESS
% sig5 = orig_sig;
% sig6 = orig_sig;
%numwindows = floor(length(orig_sig-1)/window);

% check if no index @ clean sig:
% index_clean = 0;
% sc = zeros(1,length(orig_sig));
% for i = 50*fs:120*fs; % test on clean sig
%     sc(i) = std(orig_sig(i:i+window));
%     if (sc(i) > 0.145)
%         index_clean = index_clean+1;
%         array_clean(index_clean)= i; 
%     end
% end
