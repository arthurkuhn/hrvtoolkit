
record = 'picsdb/infant1_ecg';
[signal,Fs,tm]=rdsamp(record);
[ann]=rdann(record,'qrsc');
plot(tm,signal(:,1));hold on;grid on
plot(tm(ann),signal(ann,1),'ro','MarkerSize',4);