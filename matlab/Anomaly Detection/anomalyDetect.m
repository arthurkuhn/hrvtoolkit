%% Noise Anomaly Detection %%

close all;
clear all;
load("G002ecg.mat")
fs = 1000;

orig_sig = G002ecg;
% RMS signals
sig1 = orig_sig;
sig2 = orig_sig;
% STD signals
sig3 = orig_sig;
sig4 = orig_sig;
% SKEWNESS
sig5 = orig_sig;
sig6 = orig_sig;

time = 0:(1/fs):((length(orig_sig)-1)/fs);
window = 2*fs; % # of secs
numwindows = floor(length(orig_sig-1)/window);


%RMS
for i = 0:numwindows-1 %0 to # windows
   r = rms(orig_sig(i*window+1:(i+1)*window));

   if (r > 0.0013)
       sig1(i*window+1:(i+1)*window) = mean(orig_sig(1:length(orig_sig)-1));
   end
   if (r > 0.00126)
       sig2(i*window+1:(i+1)*window) = mean(orig_sig(1:length(orig_sig)-1));       
  % else
       %not noisy
   end
end

figure;

subplot(3,1,1);
plot(time, orig_sig);
axis([0 300 -3e-3 1.5e-3]);
title('Original signal');
xlabel('Time (s)');

subplot(3,1,2);
plot(time, sig1);
axis([0 300 -3e-3 1.5e-3]);
title('max RMS = 0.0013');
xlabel('Time (s)');

subplot(3,1,3);
plot(time, sig2);
axis([0 300 -3e-3 1.5e-3]);
title('max RMS = 0.00126');
xlabel('Time (s)');

%STD DEV : WINDOW = 0.5s;
for i = 0:numwindows-1 %0 to # windows
   s = std(orig_sig(i*window+1:(i+1)*window));

   if (s > 1.35e-04)
       sig3(i*window+1:(i+1)*window) = mean(orig_sig(1:length(orig_sig)-1)); % put to mean 
   end
   if (s > 1.3e-04)
       sig4(i*window+1:(i+1)*window) = mean(orig_sig(1:length(orig_sig)-1)); % put to mean  

       
  % elseif (r > 0.00125)
  %     sig2(i*window+1:(i+1)*window) = 0;       
  % else
       %not noisy
   end
end


figure;
subplot(3,1,1);
plot(time, orig_sig);
axis([0 300 -3e-3 1e-3]);
title('Original signal');
xlabel('Time (s)');

subplot(3,1,2);
plot(time, sig3);
axis([0 300 -3e-3 1e-3]);
title('Max standard deviation = 1.35e-04');
xlabel('Time (s)');

subplot(3,1,3);
plot(time, sig4);
axis([0 300 -3e-3 1e-3]);
title('Max standard deviation = 1.3e-04');
xlabel('Time (s)');


%SKEW
for i = 0:numwindows-1 %0 to # windows
   sk = skewness(orig_sig(i*window+1:(i+1)*window));
   if (sk > 3.95)
       sig5(i*window+1:(i+1)*window) = mean(orig_sig(1:length(orig_sig)-1));
   end
   if (sk > 3.85)
       sig6(i*window+1:(i+1)*window) = mean(orig_sig(1:length(orig_sig)-1));       
   else
       %not noisy
   end
end

figure;
subplot(3,1,1);
plot(time, orig_sig);
axis([0 300 -3e-3 1e-3]);
title('Original signal');
xlabel('Time (s)');

subplot(3,1,2);
plot(time, sig5);
axis([0 300 -3e-3 1e-3]);
title('Max skewness = 3.95');
xlabel('Time (s)');

subplot(3,1,3);
plot(time, sig6);
axis([0 300 -3e-3 1e-3]);
title('Max skewness = 3.85');
xlabel('Time (s)');
