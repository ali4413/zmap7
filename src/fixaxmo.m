%
% make dialog interface for the fixing of colomap
%


%
report_this_filefun(mfilename('fullpath'));
fre = 0;


%initial values
f = figure_w_normalized_uicontrolunits();
clf
set(gca,'visible','off')
set(f,'Units','pixel','NumberTitle','off','Name','Input Parameters');

set(f,'pos',[ ZG.welcome_pos ZG.welx+200 ZG.wely-50])


% creates a dialog box to input some parameters
%

inp2_field  = uicontrol('Style','edit',...
    'Position',[.80 .775 .18 .15],...
    'Units','normalized',...
    'String',num2str(-5),...
    'Value',-5,...
    'Callback','fix1=str2double(inp2_field.String);inp2_field.String=num2str(fix1);');

txt2 = text(...
    'Color',[0 0 0 ],...
    'EraseMode','normal',...
    'Position',[0. 0.9 0 ],...
    'Rotation',0 ,...
    'FontWeight','bold',...
    'FontSize',ZmapGlobal.Data.fontsz.m ,...
    'String','Please input minimum of z-axis:');


txt3 = text(...
    'Color',[0 0 0 ],...
    'EraseMode','normal',...
    'Position',[0. 0.65 0 ],...
    'Rotation',0 ,...
    'FontWeight','bold',...
    'FontSize',ZmapGlobal.Data.fontsz.m ,...
    'String','Please input maximum of z(or b)-values:');

inp3_field=uicontrol('Style','edit',...
    'Position',[.80 .575 .18 .15],...
    'Units','normalized',...
    'String',num2str(5),...
    'Value',5,...
    'Callback','fix2=str2double(inp3_field.String); inp3_field.String=num2str(fix2);');

close_button=uicontrol('Style','Pushbutton',...
    'Position', [.60 .05 .15 .15 ],...
    'Units','normalized','Callback',@(~,~)zmap_Message_center(),'String','Cancel');

go_button=uicontrol('Style','Pushbutton',...
    'Position',[.25 .05 .15 .15 ],...
    'Units','normalized',...
    'Callback','maxc=str2num(inp3_field.String);minc=str2num(inp2_field.String);close;show_mov',...
    'String','Go');


set(f,'visible','on');watchoff


