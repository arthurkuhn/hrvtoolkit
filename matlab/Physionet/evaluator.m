
% The record of interest
record = 'picsdb/infant1_ecg';

% Read the signal data
[signal,Fs,tm]=rdsamp(record);

% Read the annotations
[ann]=rdann(record,'qrsc');

% Plot
plot(tm,signal(:,1));hold on;grid on
plot(tm(ann),signal(ann,1),'ro','MarkerSize',4);