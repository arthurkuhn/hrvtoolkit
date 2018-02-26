function [ sig, fs ] = loadFromFile( filePath )
%LOADFROMFILE Loads the ECG signal from the full APEX recording file
%   Input:
%       filePath can be absolute or relative to working directory
%   Outputs:
%       sig is the raw ECG signal
%       fs is the sampling 
%
%   Example:
%       [sig, fs] = loadFromFile('a2ecg.mat');
%
%   Process:
%   1. The signal is first formatted in a row vector.
%   2. The first minute of the signal is processed using our full 
%      pipeline. If necessary, the signal is reversed (see invertIfNeeded).


end

