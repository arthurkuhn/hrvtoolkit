% Step 1:
% Set the correct path and file names here
%files = {'a5c37ce1d999','a2f1ba57e8af','a02b15a1254c'};

d = uigetdir(pwd, 'Select a folder');
files = dir(fullfile(d, '*.mat'));
% Display the names
cell = struct2cell(files);
files = cell(1,:);

% Step 2:
% Update the test values here
testValuesEnsemble = 0.1:0.1:0.5;
testValuesMAD = 5:5:25;

for i = 1:length(files)
    for e = 1:length(testValuesEnsemble)
        parfor m = 1:length(testValuesMAD)
            options = getOptionsForTest(e, m, testValuesEnsemble, testValuesMAD);
            [ result ] = hrvDetect(char(files(i)), options );
            fileName = strcat(files(i),'-MAD-', num2str(testValuesMAD(m)),'-ENSEMBLE-',num2str(testValuesEnsemble(e)),'.ibi');
            ibi = result.ibi;
            csvwrite(char(fileName),ibi);
        end
     end
end


% Step 3:
% Simply change the value of the option you want to vary to
% testValues(testNum).
% Eg: options = [options, 'ensemble_filter_threshold', testValues(testNum)];
function options = getOptionsForTest(e, m, testValuesEnsemble, testValuesMAD)
    options = {};
    options = [options, 'ensemble_filter_threshold', testValuesEnsemble(e)];
    options = [options, 'mad_filter_threshold', testValuesMAD(m)];
    options = [options, 'missed_beats_tolerance_percent', 25];
    options = [options, 'median_filter_window', 3];
    options = [options, 'interpolation_method', 'linear'];
    options = [options, 'smoothing_spline_coef', 0.5]; % used if interpolation method is spline
    options = [options, 'eval_type', 'full']; % required for plotting
    %options = [options, 'webrooturl', 'https://storage.googleapis.com/hrvtoolkit-test-data/apex'];
end