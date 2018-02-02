## Documentation
### Generation
Generated using [M2HTML](https://www.artefact.tk/software/matlab/m2html).
To generate documentation for the Pipeline, run from the root of the repo:
```Matlab
rmdir doc s
m2html('mfiles','matlab/Pipeline', 'htmldir','doc', 'recursive','on', 'global','on');
```
All the doc can then be found in the doc folder
### In the code
To enable auto-generation simply comment functions as follows:
```Matlab
% M2HTML Toolbox - A Documentation Generator for Matlab in HTML
% Version 1.5 01-May-2005
% 
% M2HTML main functions.
%   m2html   - Documentation System for Matlab M-files in HTML.
%   mdot     - Wrapper to GraphViz's <mdot> for dependency graphs.
%   mwizard  - Graphical user interface for m2html.
%   private  - Internal functions.
%
% Template toolbox.
%   @template  - HTML template class
%
% Templates files.
%   templates/blue   - Default HTML template.
%   templates/frame  - Identical to <blue> but using frames.
%   templates/brain  - Another frames-enabled template
%
% Others.
%   Changelog, GPL, INSTALL, LICENSE, README, TODO.

%   Copyright (C) 2003-2005 Guillaume Flandin <Guillaume@artefact.tk>
%   $Revision: 1.5 $Date: 2005/05/01 16:15:30 $
```