function [ detrended, R_loc, validLocs ] = guiRunner( sigNum )
%GUIRUNNER Summary of this function goes here
%   Detailed explanation goes here

[ sig, fs ] = loadSig( sigNum );

% Pre-processing
[ sig, detrended ] = preprocessingNew(sig, fs);

% Kota
[ R_loc ] = kota(sig, detrended, fs);

validLocs = ones(1,length(R_loc));

windowSize = 100;
[ validLocs ] = ensembleMethods(detrended, R_loc, validLocs, windowSize);

%plotResult( detrended, R_loc, validLocs, fs );

end

