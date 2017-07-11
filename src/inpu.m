%  This scriptfile ask for several input parameters that can be setup
%  at the beginning of each session. The default values are the
%  extrema in the catalog
%
%a = org;        % resets the main catalogue "a" to initial state

% TODO remove this file, it has been replaced by catalog_overview.m
report_this_filefun(mfilename('fullpath'));

%  default values
t0b = min(ZG.a.Date);
teb = max(ZG.a.Date);
tdiff = (teb - t0b)*365;

if ~exist('par1', 'var')
    %  if tdiff>10                 %select bin length respective to time in catalog
    %     par1 = ceil(tdiff/100);
    %  elseif tdiff<=10 & tdiff>1
    %     par1 = 0.1;
    %  elseif tdiff<=1
    %     par1 = 0.01;
    %  end
    par1 = 30;
end

minmag = max(ZG.a.Magnitude) -0.2;
dep1 = 0.3*max(ZG.a.Depth);
dep2 = 0.6*max(ZG.a.Depth);
dep3 = max(ZG.a.Depth);
minti = min(ZG.a.Date);
maxti  = max(ZG.a.Date);
minma = min(ZG.a.Magnitude);
maxma = max(ZG.a.Magnitude);
mindep = min(ZG.a.Depth);
maxdep = max(ZG.a.Depth);

%
% make the interface
%
figure_w_normalized_uicontrolunits(...
    'Units','pixel','pos',[300 100 300 400 ],...
    'Name','General Parameters!',...
    'visible','off',...
    'NumberTitle','off',...
    'MenuBar','none',...
    'Color',color_fbg,...
    'NextPlot','new');
axis off

inp1B=uicontrol('Style','edit','Position',[.70 .90 .22 .05],...
    'Units','normalized','String',num2str(length(a)),...
    'Callback','nueq=str2double(get(inp1B,''String'')); set(inp1B,''String'',num2str(length(a)));');

inp1=uicontrol('Style','edit','Position',[.70 .80 .22 .05],...
    'Units','normalized','String',num2str(minmag),...
    'Callback','minmag=str2double(get(inp1,''String'')); set(inp1,''String'',num2str(minmag))');

inp2=uicontrol('Style','edit','Position',[.70 .70 .22 .05],...
    'Units','normalized','String',num2str(par1),...
    'Callback','par1=str2double(get(inp2,''String'')); set(inp2,''String'',num2str(par1));');

inp3=uicontrol('Style','edit','Position',[.70 .60 .22 .05],...
    'Units','normalized','String',num2str(minti),...
    'Callback','minti=str2double(get(inp3,''String'')); set(inp3,''String'',num2str(minti));');


inp4=uicontrol('Style','edit','Position',[.70 .50 .22 .05],...
    'Units','normalized','String',num2str(maxti),...
    'Callback','maxti=str2double(get(inp4,''String'')); set(inp4,''String'',num2str(maxti));');

inp5=uicontrol('Style','edit','Position',[.70 .40 .22 .05],...
    'Units','normalized','String',num2str(minma),...
    'Callback','minma=str2double(get(inp5,''String'')); set(inp5,''String'',num2str(minma));');

inp6=uicontrol('Style','edit','Position',[.70 .30 .22 .05],...
    'Units','normalized','String',num2str(maxma),...
    'Callback','maxma=str2double(get(inp6,''String'')); set(inp6,''String'',num2str(maxma));');

inp7=uicontrol('Style','edit','Position',[.30 .15 .15 .05],...
    'Units','normalized','String',num2str(mindep),...
    'Callback','mindep=str2double(get(inp7,''String'')); set(inp7,''String'',num2str(mindep));');

inp8=uicontrol('Style','edit','Position',[.50 .15 .15 .05],...
    'Units','normalized','String',num2str(maxdep),...
    'Callback','maxdep=str2double(get(inp8,''String'')); set(inp8,''String'',num2str(maxdep));');



close_button=uicontrol('Style','Pushbutton',...
    'Position',[.65 .02 .20 .10 ],...
    'Units','normalized','Callback','close;zmap_message_center.set_info('' '','' '');done','String','cancel');

go_button=uicontrol('Style','Pushbutton',...
    'Position',[.35 .02 .20 .10 ],...
    'Units','normalized',...
    'Callback','close,think, sele_sub',...
    'String','Go');

info_button=uicontrol('Style','Pushbutton',...
    'Position',[.05 .02 .20 .10 ],...
    'Units','normalized',...
    'Callback','zmaphelp(titstr,hlpStr)',...
    'String','Info');
titstr = 'General Parameters';
hlpStr = ...
    ['This window allows you to select earthquakes '
    'from a catalog. You can select a subset in   '
    'time, magnitude and depth.                   '
    '                                             '
    'The top frame displays the number of         '
    'earthquakes in the catalog - no selection is '
    'possible.                                    '
    '                                             '
    'Two more parameters can be adjusted: The Bin '
    'length in days that is used to sample the    '
    'seismicity and the minimum magnitude of      '
    'quakes displayed with a larger symbol in the '
    'map.                                         '];




txt3 = text(...
    'Color',[1 0 0 ],...
    'Position',[0.02 1.00 0 ],...
    'Rotation',0 ,...
    'FontSize',ZmapGlobal.Data.fontsz.m ,...
    'FontWeight','bold' ,...
    'String',' EQs in catalog: ');


txt1 = text(...
    'Color',[0 0 0 ],...
    'Position',[0.02 0.75 0 ],...
    'Rotation',0 ,...
    'FontSize',ZmapGlobal.Data.fontsz.m ,...
    'FontWeight','bold' ,...
    'String','Bin Length in days :');

txt2 = text(...
    'Color',[0 0 0 ],...
    'Position',[0.02 0.87 0 ],...
    'Rotation',0 ,...
    'FontSize',ZmapGlobal.Data.fontsz.m ,...
    'FontWeight','bold' ,...
    'String','Plot Big Events with M > ');

txt4 = text(...
    'Color',[0 0 0 ],...
    'Position',[0.02 0.63 0 ],...
    'Rotation',0 ,...
    'FontSize',ZmapGlobal.Data.fontsz.m ,...
    'FontWeight','bold' ,...
    'String','Beginning year: ');

txt5 = text(...
    'Color',[0 0 0 ],...
    'Position',[0.02 0.51 0 ],...
    'Rotation',0 ,...
    'FontSize',ZmapGlobal.Data.fontsz.m ,...
    'FontWeight','bold' ,...
    'String','Ending year: ');

txt6 = text(...
    'Color',[0 0 0 ],...
    'Position',[0.02 0.38 0 ],...
    'Rotation',0 ,...
    'FontSize',ZmapGlobal.Data.fontsz.m ,...
    'FontWeight','bold' ,...
    'String','Minimum Magnitude: ');

txt6 = text(...
    'Color',[0 0 0 ],...
    'Position',[0.02 0.25 0 ],...
    'Rotation',0 ,...
    'FontSize',ZmapGlobal.Data.fontsz.m ,...
    'FontWeight','bold' ,...
    'String','Maximum Magnitude: ');

txt7 = text(...
    'Color',[0 0 0 ],...
    'Position',[0.02 0.15 0 ],...
    'Rotation',0 ,...
    'FontSize',ZmapGlobal.Data.fontsz.m ,...
    'FontWeight','bold' ,...
    'String','       Min Depth     Max Depth  ');


%clear txt1 txt2 txt3 txt4 txt5 txt6 txt7 inp1 inp1B inp3 inp3 inp4 inp5 inp6 inp7
set(gcf,'visible','on')
watchoff
str = [ 'Please Select a subset of earthquakes'
    ' and press Go                        '];
zmap_message_center.set_message('Message',str);


