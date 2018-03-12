function [R_locs, ecg_sig] = getOfficialResults( recordName )
%GETOFFICIALRESULTS Returns the valided results for the Physionet data

load(recordName + ".mat");
data = eval(recordName);

if(isfield(data, 'R_locs'))
    R_locs = data.R_locs;
else
    R_locs =[];
end

if(isfield(data, 'data'))
    ecg_sig = data.data;
else
    ecg_sig =[];
end


end

