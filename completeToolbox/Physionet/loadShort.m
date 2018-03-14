function [ sig, fs ] = loadShort( file, proportion )
%LOADSHORT Cuts the desired input signal and leaves the proportion requested
%   Input:
%       filePath can be absolute or relative to working directory
%   Outputs:
%       sig is the raw ECG signal
%       fs is the sampling 
%
%   Example:
%       [sig, fs] = shorten('infant1+ecg', 0.1);
%
load(file + ".mat");
data = eval(file);

if(string(data.channels(1)) ~= 'ECG')
    print "Unexpected data format";
    return;
end
% Get the first channel (ecg)
sig = data.data(:,1);
if(~isrow(sig))
    sig = sig.';
end

totalSize = length(sig);
newSize = floor(length(sig) * proportion);

sig = sig(1:newSize);


fs = data.Fs;
windowInSeconds = 60;
%sig = invertIfNecessary( sig, fs, windowInSeconds);




end

