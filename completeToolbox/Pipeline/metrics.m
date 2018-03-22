[ sig, fs ] = loadShort(params.ecgFile, 1);

SDNN = std(result.tachogram);

%SDANN
num5min = zeros(1:floor(length(sig)/(fs*60*5))); %floor
for i=1:(length(sig)/(fs*60*5))
    % pas reussi
    num5min(i) = mean(Rlocs(i:i+1) %segment + tacho
    %lower bound = i+1*nombres de samples dans ton segment 
    % rlocs array/tacho 
    
    
RMSSD = rms(diff(result.tachogram));

%SDNN index

SDSD = std(diff(result.tachogram));

% NN50:
NN50 = 0;
for j = 2:length(result.tachogram)-1
    if (abs(result.tachogram(j) - result.tachogram(j+1)) > 50)
        NN50 = NN50+1;
    end
end

pNN50 = NN50/length(result.tachogram);
    

