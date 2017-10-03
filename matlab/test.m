close all;
load("G002ecg.mat")

qrsEx = a2f1ecg(250:750000);
fs = 1000;

qrsEx = qrsEx;

qrsEx = qrsEx*2500;

t = 1:length(qrsEx);

[~,locs_Rwave] = findpeaks(qrsEx,'MinPeakHeight',0.5,...
                                    'MinPeakDistance',200);
                                
ECG_inverted = -qrsEx;
[~,locs_Swave] = findpeaks(ECG_inverted,'MinPeakHeight',1,...
                                        'MinPeakDistance',200);
figure
hold on 
plot(t,qrsEx)
plot(locs_Rwave,qrsEx(locs_Rwave),'rv','MarkerFaceColor','r')
plot(locs_Swave,qrsEx(locs_Swave),'bs','MarkerFaceColor','b')

interval = diff(locs_Rwave);
figure;
plot(1:length(interval),interval);

sigPeaks = qrsEx(locs);



newmatrix = sigPeaks;
newmatrix(sigPeaks < 4) = 0;

% figure
% plot(1:length(qrsEx),qrsEx)
% hold on
% plot(1:length(newmatrix),newmatrix,'ro')
% xlabel('Seconds'); ylabel('Amplitude')
% title('Subject - MIT-BIH 200')


% [mpdict,~,~,longs] = wmpdictionary(numel(qrsEx),'lstcpt',{{'sym4',3}});
% figure
% scaled = qrsEx * 1200;
% plot(scaled)
% hold on
% plot(2*circshift(mpdict(:,11),[-2 0]),'r')
% axis tight
% legend('QRS Complex','Sym4 Wavelet')
% title('Comparison of Sym4 Wavelet and QRS Complex')