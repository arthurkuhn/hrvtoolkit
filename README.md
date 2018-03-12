# The Tacho Toolbox

## Structure

| Pipeline Stage | Function |
| ------ | ------ |
| Loading | Load the raw ECG signal and invert it if necessary |
| Pre-Processing | Detrends and filters the signal |
| Beat Detection | Detects R-Peaks using the Kota algorithm |
| Beat Processing | Analyse detected beats to remove noise |
| Tachogram Generation | Generate the tachogram from the valid beat data |
| Tachogram Processing | Post-process the tachogram to remove any remaining noise |


## TODO List

- Interpolated Flag in Pipeling
- Finish Evaluator function
- GUI update to enable any file selection
- InvertIfNecessary: infant1_ecg suggests bad idea, temporarily removed


## Coding Practices

### Comments
All functions should be commented as follows:

```Matlab
%medFilter Finds the outliers in the signal using a median filter
% Skips beats already marked as invalid (and does not take them into
% account for the other points.
%
% Inputs:
%    signal - The RR-interval data
%    validLocs - Boolean Array, 1 for valid peaks
%    tau - Parameter
%
% Outputs:
%    validLocs - Boolean Array, 1 for valid peaks
%
% Reference:
% Thuraisingham, R. A. (2006). "Preprocessing RR interval time
% series for heart rate variability analysis and estimates of
% standard deviation of RR intervals."
% Comput. Methods Programs Biomed.
```

### Documentation

Generated in /doc using [M2HTML](https://www.artefact.tk/software/matlab/m2html).
To generate documentation for the Pipeline, run from the root of the repo:
```Matlab
rmdir doc s
m2html('mfiles','matlab/Pipeline', 'htmldir','doc', 'recursive','on', 'global','on');
```
All the doc can then be found in the doc folder

To get the doc with the graph (needs dot from graphviz in path):
```Matlab
m2html('mfiles','matlab/Pipeline', 'htmldir','doc', 'recursive','on', 'global','on', 'template','frame', 'index','menu', 'graph','on');
```


### WFDB ToolBox

#### Database Info

Preterm Infant Cardio-Respiratory Signals Database [Info](https://physionet.org/physiobank/database/picsdb/)

### Accessing Records

Important note: This plugin can be slow due to the large datafiles downloaded in the background.

The WFDB Toolbox allows the user to transparently use signals from the entire dataset. Signals are lazily downloaded in the cache folder as required.

### Useful commands

| Command | Function | Example |
| ------ | ------ | ------ |
| tach | Gets a uniformly sampled and smoothed heart signal. [DOC](https://physionet.org/physiotools/matlab/wfdb-app-matlab/html/tach.html) | ```[hr]=tach('picsdb/infant1_ecg','qrsc'); plot(hr);grid on;hold on``` |
| rdsamp | Reads a signal from the database [DOC](https://physionet.org/physiotools/matlab/wfdb-app-matlab/html/rdsamp.html) | ```[signal,Fs,tm]=rdsamp('picsdb/infant1_ecg',[],1000); plot(tm,signal(:,1))``` |
| rdann | Reads an annotation file from the database [DOC](https://physionet.org/physiotools/matlab/wfdb-app-matlab/html/rdann.html)| ```[ann]=rdann('picsdb/infant1_ecg','qrsc');``` |

### Complete Example

```
record = 'picsdb/infant1_ecg';
[signal,Fs,tm]=rdsamp(record);
[ann]=rdann(record,'qrsc');
plot(tm,signal(:,1));hold on;grid on
plot(tm(ann),signal(ann,1),'ro','MarkerSize',4);
```


