
function [ BPM ] = getBpm( R_loc, validLocs )
%GETBPM Summary of this function goes here
%   Detailed explanation goes here

fs = 1000;
interval = diff(R_loc);
interval(length(interval)+1) = interval(length(interval)); % Adding one last index
%get BPM Kota
BPM = 60*fs./(interval);

end

