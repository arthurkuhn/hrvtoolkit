function [R_locs, ecg_sig] = getOfficialResultsShort( recordName, proportion )
%getOfficialResultsShort Cuts the desired input signal and leaves the proportion requested
%   Input:
%       recordName can be absolute or relative to working directory
%       proportion
%   Outputs:
%       R_locs is the array of annotated beats
%       ecg_sig is ecg signal
%
%   Example:
%       [R_locs, ecg_sig] = getOfficialResultsShort('infant1ecg', 0.1);
%

load(recordName + ".mat");
data = eval(recordName);

if(isfield(data, 'R_locs'))
    R_locs = data.R_locs;
else
    msg = 'Error Loading R_locs';
    error(msg);
end

sig = data.data;

newSize = floor(length(sig) * proportion);

ecg_sig = sig(1:newSize);
indexLastRLoc = 1;
while(indexLastRLoc < length(R_locs))
    if(R_locs(indexLastRLoc+1) >= newSize)
        break;
    end
    indexLastRLoc = indexLastRLoc + 1;
end

R_locs = R_locs(1:indexLastRLoc);