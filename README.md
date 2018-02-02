# Coding Practices

## Comments
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

## Documentation

### To Generate
Generated using [M2HTML](https://www.artefact.tk/software/matlab/m2html).
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