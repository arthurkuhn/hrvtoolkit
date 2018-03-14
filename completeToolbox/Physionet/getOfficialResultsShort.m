function [R_locs, ecg_sig] = getOfficialResultsShort( recordName, proportion )
%GETOFFICIALRESULTS Returns the valided results for the Physionet data

load(recordName + ".mat");
data = eval(recordName);

if(isfield(data, 'R_locs'))
    R_locs = data.R_locs;
else
    R_locs =[];
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