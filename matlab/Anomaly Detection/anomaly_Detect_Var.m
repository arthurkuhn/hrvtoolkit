%% Noise Anomaly Detection %%

close all;
clear all;
load("G002ecg.mat")
load("A1ecg.mat")
load("a2f1ecg.mat")
load("a5c3ecg.mat")
load("G011ecg.mat")
G011ecg = data;
load("G013ecg.mat")
G013ecg = data;
fs = 1000;


[ R_loc, interval, time ] = kotaFunction3(G011ecg, fs, 0 );
window = 10; % # of secs
index = 0;
s = zeros(1,length(interval));

for i = floor(1*window)/2+1:length(interval)-window/2 %0 to #samples; one i is 1/fs
   s(i) = var(interval(i-floor(window/2):i+(window/2)));
   
   % 0.09 for G002, 0.11 for a2f1, 0.145 for a5c3
   if (s(i)>100000)
       index=index+1;
        false(index) = i;
   end
end

for i = 1:length(false)-1
    false_loc(i) = R_loc(false(i));
    noisy_sig(i) = interval(false(i));
end

false_loc = false_loc./fs;
BPM = 60*fs./(interval);

figure;
subplot(2,1,1);
plot(time(R_loc), interval);
%axis([0 R_loc(length(R_loc)) 0 700]);

subplot(2,1,2);
plot(time(R_loc), interval);
hold on
scatter(false_loc, noisy_sig,10,'r');




%quantization
%tachogram
%brady cardio: < 100
