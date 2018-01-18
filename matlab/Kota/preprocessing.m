function sig = preprocessing(ecg, fs)

%% bandpass filter for Noise cancelation of other sampling frequencies(Filtering)
f1=16; %cuttoff low frequency to get rid of baseline wander
f2=26; %cuttoff frequency to discard high frequency noise
Wn=[f1 f2]*2/fs; % cutt off based on fs
N = 3; % order of 3 less processing
[a,b] = butter(N,Wn); %bandpass filtering
ecg_h = filtfilt(a,b,ecg);
sig = ecg_h/ max( abs(ecg_h));