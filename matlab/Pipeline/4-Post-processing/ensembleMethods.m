function [outliers] = ensembleMethods( detrended_sig, R_locs, windowSize )
%GETENSEMBLEAVERAGE Gets the average of all QRS peaks
%   Detailed explanation goes here

outliers = zeros(1,length(R_locs));

avg = zeros(1,(2*windowSize+1));
fs = 1000;
time = 0:(1/fs):((length(detrended_sig)-1)/fs);

shouldPlot = 0;

left = R_locs-windowSize;
right = R_locs+windowSize;

parfor i=1:length(R_locs)
    if(R_locs(i) < windowSize + 1)
        continue;
    end
    complex = detrended_sig(left(i):right(i));
    avg = avg + complex;
end

correlationCoefArray = zeros(1,length(R_locs));
maxCorrelationArray = zeros(1,length(R_locs));

for i=1:length(R_locs)
    if(R_locs(i) < windowSize + 1)
        continue;
    end
    complex2 = detrended_sig(left(i):right(i));
    crossCorr = xcorr(complex2, avg);
    corrCoeff = corrcoef(complex2, avg);
    correlationCoefArray(i) = corrCoeff(1,2);
    maxCorrelationArray(i) = max(crossCorr);
    if(corrCoeff(1,2) > 0.65)
        continue
    else
        outliers(i) = 1;
    end
end



detrended = detrended_sig;
R_loc = R_locs;
validIndices = [];
invalidIndices = [];
validLocs = ones(1,lenght(R_locs));
for i = 1:length(validLocs)
    if(outliers(i) == 0)
        validIndices = [validIndices R_loc(i)];
    else
        invalidIndices = [invalidIndices R_loc(i)];
    end
end

interval = [];
intervalPrev = 0;
currInterval = 0;
for i=2:length(R_loc)
    if(validLocs(i-1) ~= 1 || validLocs(i) ~= 1)
        currInterval = intervalPrev;
    else
        currInterval = R_loc(i) - R_loc(i-1);
    end
    interval(i-1) = currInterval;
    intervalPrev = currInterval;
end
interval(length(interval)+1) = currInterval;

% interval = diff(R_loc);
% interval(length(interval)+1) = interval(length(interval)); % Adding one last index
% %get BPM Kota
BPM = 60*fs./(interval);

if(shouldPlot == 1)
    
    avgValid = zeros(1,(2*windowSize+1));
    avgInvalid = zeros(1,(2*windowSize+1));
    for i=1:length(validLocs)
        if(R_locs(i) < windowSize + 1)
            continue;
        end
        complex = detrended_sig(left(i):right(i));
        if(validLocs(i) == 1)
            avgValid = avgValid + complex;
        else
            avgInvalid = avgInvalid + complex;
        end
    end
    
    figure;
    plot(avgValid);
    title("Valid Ensemble Average");
    
    figure;
    plot(avgInvalid);
    title("Invalid Ensemble Average");
    
    
    figure('NumberTitle', 'off', 'Name', 'G013');
    bx1 = subplot(4,1,1);
    hold on;
    plot (time,detrended);
    plot(time(validIndices),detrended(validIndices),'bv','MarkerFaceColor','b');
    plot(time(invalidIndices),detrended(invalidIndices),'rv','MarkerFaceColor','r');
    legend('ECG','R');
    title('ECG Signal with R points');
    xlabel('Time in seconds');
    ylabel('Amplitude');
    
    %     figure;
    %     %plot BPM
    %     bx1 = subplot(3,1,1);
    %     plot(time(R_loc), BPM);
    %     title("Kota BPM");
    %     xlabel("Time (s)");
    %     ylabel("BPM");
    %     ylim([0 300]);
    %axis([0 (1.05*length(time(R_loc))) 0 300]);
    %median filtered
    
    bx2 = subplot(4,1,2);
    BPM(isinf(BPM)) = mean(BPM);
    f=fit(transpose(time(R_loc)),transpose(BPM),'smoothingspline');
    plot(f,time(R_loc),interval);
    %plot(1:length(mfilt_sig), mfilt_sig);
    title("BPM Arthur");
    %title("BPM after 5 sample median filter");
    xlabel("Time (s)");
    ylabel("BPM");
    %axis([0 (1.05*length(BPM)) 0 200]);
    ylim([50 250]);
    %axis([0 (1.05*length(time(R_loc))) 0 300]);
    
    bx3 = subplot(4,1,3);
    plot(time(R_loc),correlationCoefArray);
    %plot(1:length(mfilt_sig), mfilt_sig);
    title("Correlation with Average Beat:");
    %title("BPM after 5 sample median filter");
    xlabel("Time (s)");
    ylabel("Correlation Coefficient");
    %axis([0 (1.05*length(BPM)) 0 200]);
    ylim([0 1]);
    %axis([0 (1.05*length(time(R_loc))) 0 300]);
    
    bx4 = subplot(4,1,4);
    plot(time(R_loc),maxCorrelationArray);
    %plot(1:length(mfilt_sig), mfilt_sig);
    title("Maximum Cross Correlation with avg beat:");
    %title("BPM after 5 sample median filter");
    xlabel("Time (s)");
    ylabel("Max");
    %axis([0 (1.05*length(BPM)) 0 200]);
    %ylim([0 1]);
    %axis([0 (1.05*length(time(R_loc))) 0 300]);
    
    
    
    
    linkaxes([bx1,bx2, bx3, bx4],'x');
    
end

