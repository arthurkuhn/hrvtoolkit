function fig_mod (h, varargin)

%function fig_mod  (h, 'option' ,'value' );
% modify  plots
%
% figmod(1,'?') for help
% 28 Apr 94 REK added title color parameter
% 22 feb 99 REK Rework to use arg_parse.
%               'layout' option changed to 'page_layout' to void conflict with
%			       matlab layout function.
%					Axes are now number in the order in which they are created;

% {{{ Define options values
if nargin ==1,
   varargin = { 'axis_line_width' 1.5 ...
         'label_size' 18 ...
         'line_width' 1 ...
         'marker_size' 6  ...
         'tick_label_size' 14 };
end

%



options = { {'axis_line_width' 1.5 'Width of axes lines'} ...
      {'axis_box' NaN 'Turn axis box on/off [on]'}...
      {'axis_height' NaN 'Height of axes' }...
      {'axis_num' NaN 'Axes to operate on [All]'} ...
      {'axis_title' NaN 'STRING - title of axes'}...
      {'axis_width' NaN 'Width of axes' }...
      {'axis_xpos' NaN 'x position of axes'}...
      {'axis_xlim' NaN ' x limit for axes'}...
      {'axis_ypos' NaN 'y pos of axes'}...
      {'axis_ylim' NaN 'y limit for axes'}...
      {'figure_type' NaN 'set defaults for figure [slide/journal]' } ...
      {'label_size' NaN 'font size for label'}...
      {'page_layout' NaN 'page layout {portrait/landscape'}...
      {'line_width' NaN 'width of lines'}...
      {'line_color' NaN 'line  color'}...
      {'marker_size' NaN 'marker size'}...
      {'position' NaN 'posiiton of plot [ul/bl/ur/br]' }...
      {'tick_label_size' NaN 'font size for tick labels'}...
      {'ticklength' NaN 'length of ticks'} ...
      {'title_size' NaN 'INT font size for title'}...
      {'title_font' NaN 'STRING - font name for title'}...
      {'title_xpos' NaN 'title x position '}...
      {'title_ypos' NaN 'title y position'}...
      {'title_offset' NaN 'title offset'}...
      {'title_color' NaN 'title color'}...
      {'xlabel_offset' NaN 'offset for x labels'}...
      {'xlabel_pos' NaN 'position for x label'}...
      {'xtick_label_flag' NaN 'x ticks on/off'}...
      {'xtick_label' [] 'labels for x ticks'}...
      {'x_label' [] 'labels for x axis'}...
      {'y_label' [] 'labels for y axis'}...
      {'ytick_label' [] 'labels for x ticks'}...
      {'ytick_label_flag' NaN 'y ticks on/off'}...
      {'xtick' NaN 'location of xticks'}...
      {'ylabel_offset' NaN 'offset for y labels'}...
      {'ylabel_pos' NaN ' position for y label'}...
      {'ytick' NaN 'location of yticks'}...
   };

if isstr(h),
   arg_help('fig_mod',options);
   return
end

arg_parse (options, varargin);

% }}}

% set defaults
if ~isnan(figure_type),
   axis_line_width =1.5;
   label_size= 18;
   line_width= 2 ;
   markersize= 6 ;
   tick_label_size=14;
   switch figure_type
   case 'slide'
      
   case 'journal'
      line_color='black';
   otherwise
      error (['figure type not defined: ' figure_type]);
   end
end


type=get(h,'type');
if ~(strcmp(type,'figure'))
   error ('First parameter must be a pointer to a figure');
end

% {{{  Set figure position

if (~ isnan (position)),
   ssize=get (0,'screensize');
   pold=get (h,'position');  
   pnew=pold;
   xoff=25;
   yoff=75;
   if (strcmp(position,'ur')),
      pnew(1)=ssize(3) -xoff -pold(3);
      pnew(2)=ssize(4) - yoff -pold(4);
   elseif strcmp(position,'ul'),
      pnew(1)=xoff;
      pnew(2)=ssize(4)-pold(4) - yoff;
      
   elseif strcmp(position,'bl'),
      pnew(1)=xoff;
      pnew(2)=xoff;
   elseif strcmp(position,'br'),
      pnew(1)=ssize(3)-pold(3) -xoff;
      pnew(2)= xoff;;
      ;
   else 
      error (['fig_mod: bad position option' position])
   end
   set (gcf,  'position', pnew )
end

% }}}

% {{{ Set figure size and layout

if (~isnan(page_layout)),
   set (h,'units', 'pixels');
   pold=get (h,'position');
   page_orient=page_layout;
   if (strcmp(page_layout,'portrait')),
      width=533;
      height=800; 
      paperpos=[.9 .5 6.7 10];
   elseif strcmp(page_layout,'landscape'),
      width=800;
      height=533;
      paperpos=[.9 .5 10.1 7.2];
   elseif strcmp(page_layout,'slide'),
      width=800;
      height=600;
      paperpos=[.9 .5 10 7.5];
      page_orient='landscape';    
   else 
      error (['fig_mod: bad layout option:' page_layout])
   end
   pnew(1)=max( 100);
   pnew(2)=max(100);
   pnew(3)=width;
   pnew(4)=height;
   set (gcf,  'windowstyle','normal', 'position', pnew, ...
      'PaperOrientation',page_orient,'paperposition',paperpos)
end

% }}}

% {{{ < Do all axes

%
% get handles to all axes
%
ha=findobj(h,'type','axes');
% Reverse order so number corresponds to the order in which axes created
i=length(ha);
ha(i:-1:1)=ha(1:i);
if ~all(isnan(axis_num)),
   haxes=ha(axis_num);
else
   haxes=ha;
end
naxes=length(haxes);
for iaxis=1:naxes,
   h=haxes(iaxis);
   if ~isnan(axis_box),
      set (h,'box',axis_box);
   end
   % {{{ set axis ticks 
   
   % Set axis tick properties
   
   if ~isnan(xtick),
      set (h,'xtick',xtick);
   end  
   if ~isnan(ytick),
      set (h,'ytick',ytick);
   end
   if ~isempty(x_label),
      set(get(h,'xlabel'),'string',x_label);
   end
   if ~isempty(y_label),
      set(get(h,'ylabel'),'string',y_label);
   end
 if ~isempty(xtick_label),
      set(h,'xticklabel',xtick_label);
   end
if ~isempty(ytick_label),
      set(h,'yticklabel',ytick_label);
 end
 if (~isnan(xtick_label_flag)),
               set (h,'xticklabel',[]),

   end
if (~isnan(ytick_label_flag)),
               set (h,'yticklabel',[]),

   end
   
   % }}}
   % {{{ Set axes position and location
   
   pos=get(h,'position');
   if ~all(isnan(axis_width)),
      pos(3)=getval(axis_width,iaxis, pos(3));
   end
   if ~all(isnan(axis_height)),
      pos(4)=getval(axis_height,iaxis, pos(4));
   end
   if ~all(isnan(axis_xpos));
      pos(1)=axis_xpos(iaxis);
   end
   if ~all(isnan(axis_ypos)),
      pos(2)=axis_ypos(iaxis);
   end
   if ~all(isnan(axis_xlim));
      set (h,'xlim',axis_xlim);
   end
   if ~all(isnan(axis_ylim));
      set (h,'ylim',axis_ylim);
   end
   
   set(h,'position',pos);
   
   % }}}
   % {{{ Make changes to axes text
   if (~isnan(axis_line_width)),
      set(h,'LineWidth',axis_line_width)
   end
   if (~isnan(tick_label_size)),
      set(h,'Fontsize',tick_label_size)
   end
   if (~isnan(ticklength)),
      set(h,  'ticklength',ticklength');
   end
   
   % Title properties
   
   if (~isnan(axis_title)),
      set(get(h,'Title'),'String',axis_title);
   end
if (~isnan(title_size)),
      set(get(h,'Title'),'Fontsize',title_size);
   end
   if (~isnan(title_xpos)),
      tpos=get(get(h,'title'),'position');
      tpos(1) = getval(title_xpos,iaxis,tpos(1));
      set(get(h,'Title'),'position',tpos);
   end
   if (~isnan(title_ypos)),
      tpos=get(get(h,'title'),'position');
      tpos(2) = getval(title_ypos,iaxis,tpos(2));
      set(get(h,'Title'),'position',tpos);
   end
   if (~isnan(title_font)),
      set(get(h,'Title'),'Fontname',title_font);
   end  
   if (~isnan(title_color)),
      set(get(h,'Title'),'color',title_color);
   end    
   if (~isnan(label_size)),
      set(get(h,'xlabel'),'Fontsize',label_size,'FontName','times');
      set( get(h,'ylabel'), 'Fontsize',label_size,'fontname','times');
      set( get(h,'zlabel'), 'Fontsize',label_size,'fontname','times')
      
   end  
   %
   % Move x label down
     % offset y label down
   if (~isnan(xlabel_offset));
      hxl =get(h,'xlabel');
      xl_units=get(hxl,'units');
      set (hxl,'units','norm');
      xlabel_pos=get(hxl,'position');
      xlabel_pos=xlabel_pos+xlabel_offset;
      set(get(h,'xlabel'),'position',xlabel_pos);
      set (hxl,'units',xl_units);
   end
if ~isnan(xlabel_pos),
      hxl =get(h,'xlabel');
      xl_units=get(hxl,'units');
      set (hxl,'units','norm');
      set(hxl,'position',xlabel_pos);
      set (hxl,'units',xl_units);
   end
   if ~isnan(ylabel_pos),
      hyl =get(h,'ylabel');
      yl_units=get(hyl,'units');
      set (hyl,'units','norm');
      set(hyl,'position',ylabel_pos);
      set (hyl,'units',yl_units);
   end
   % offset y label down
   if (~isnan(ylabel_offset));
      hyl =get(h,'ylabel');
      yl_units=get(hyl,'units');
      set (hyl,'units','norm');
      ylabel_pos=get(hyl,'position');
      ylabel_pos=ylabel_pos+ylabel_offset;
      set(get(h,'ylabel'),'position',ylabel_pos);
      set (hyl,'units',yl_units);
   end
   % }}}
   % {{{ Make Changes to axes Lines
   ha=get (h,'children');
   hl=length(ha);
   if (hl >0),
      for hi=1:hl,
         if(strcmp(get(ha(hi),'type'),'line'));
            if ~isnan(line_width),
               set(ha(hi),'Linewidth',line_width);
            end
            if ~isnan(marker_size),
               set(ha(hi),'markersize',marker_size);
            end
            if all(get(ha(hl),'color') == [0 0 1]),
               %              set(h,'color',[1 1 1]);
            end
            if ~isnan(line_color),
                   set(ha(hi),'color',line_color)

            end
            
         end
      end
      % }}}
   else
      disp('no option')
   end
end

function z = getval (x,i,y);
% set values according to axis number
% leave unchanged if x(iaxis)=NaN;
if length(x)==1,
   ynew = x;
else
   ynew = x(i);
end
if isnan(ynew),
   z=y;
else
   z=ynew;
end

return

