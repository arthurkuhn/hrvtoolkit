%downloadFiles Downloads the entire dataset of interest and saves the files
% the current working directory.
% Saves the records in a format very similar to the native APEX format
% to enable compatibility with normal pipeline.

    clear();
    i = 9;
    record = strcat('picsdb/infant', int2str(i), '_ecg');

    % Load the data
    [signal,Fs,tm]=rdsamp(record);
    [ann]=rdann(record,'qrsc');

    result = {};
    result.channels = {"ECG"};
    result.Fs = Fs;
    result.data = signal;
    result.R_locs = ann;

    % Save file in variable with same name:
    filename = char(strcat("infant",int2str(i),"_ecg"));
    eval([ filename '=result']);
    save(filename, filename);

for i = 2:3
    
end

