function arg_help (name,options)
%
% display help for arguments 
%
disp (['Options for ' name '  are:'])
l=length(options);
for i=1:l,
   opt=options{i};
   if isnumeric(opt{2}),
      def=num2str(opt{2});
   elseif islogical(opt{2}),
       if opt{2},
           def='true';
       else
           def='false';
       end
   else
      def =opt{2};
   end
      disp(['   ' opt{1} ':' opt{3} '[' def ']' ])
end


% Copyright 2000, Robert E Kearney
% This file is part of the nlid toolbox, and is released under the GNU 
% General Public License For details, see copying.txt and gpl.txt 
