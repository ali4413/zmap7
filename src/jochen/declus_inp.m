% declus_inp.m
% ---------------------------------------------------------------
% This script asks for input parameters that need to be setup
% at the beginning of declustering a catalog using the windowing
% technique by Gardner & Knopoff.
%
% J. Woessner, woessner@seismo.ifg.ethz.ch
% Last update: 02.09.02

report_this_filefun(mfilename('fullpath'));

global mCatalog

storedcat=a; % Keep original catalog for resetting in Seismicity map

mCatalog=a; % Script works on mCatalog
if isempty(mCatalog)
    mCatalog=a;
end

% Check if catalog has hour and minute saved
%
m = mCatalog.Count;
if n < 9 
    errdisp = ...
        ['The catalog does not   '
        'contain hour and minute'
        'data. Please reload the'
        'catalog                '];
    zmap_message_center.set_message('Error!  Alert!',errdisp)
    warndlg(errdisp)
    done;return
end

% Make the interface
%
bas_fig=figure_w_normalized_uicontrolunits(...
    'Units','pixel','pos',[ZG.welcome_pos 400 300 ],...
    'Name','Declustering - Windowing approach',...
    'NumberTitle','off',...
    'MenuBar','none',...
    'NextPlot','new');
axis off


%%%%% Documentation for Matlab window
titlestr1 = 'Help on declustering using Gardner and Knopoff approach';

infostr1 = [' The declustering method by Gardner & Knopoff (1974) uses predefined'...
        ' windows in space and time to identify dependent and independent seismicity.'...
        ' For comparison, three window suggestions in space and time from different'...
        ' authors (Gardner & Knopoff (1974), Gruenthal (pers. comm.), Uhrhammer (1986))'...
        ' are implemented. Use the PLOT button to have a glance on the window sizes. Choose the window'...
        ' using the popup menu. Use the GO button to start the declustering. As a result,'...
        ' the clusters and mainshocks are plotted in the seismicity map, a message box'...
        ' including information on the clusters pops up. Moreover, a comparison of the cluster length'...
        ' to the predefined windos and a histogram showing'...
        ' the magnitude distribution of all events in the clusters is plotted. After declustering, use the '...
        ' CREATE button to plot a seperate map of declustering. Choose appropriate values, depending on either'...
        ' the radius or the max. number of events to determine the degree. Additional help is found in the '...
        ' MATLAB help window.'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Input
inp1=uicontrol('Style','popup','Position',[.20 .6 .5 .1],...
    'Units','normalized','String','Gardner & Knopoff (1974)| Gruenthal (pers. comm.)| Uhrhammer (1986)',...
    'Callback','nMethod=get(inp1,''Value'')');

% Buttons
plot_button=uicontrol('Style','Pushbutton',...
    'Position',[.3 .35 .2 .1 ],...
    'Units','normalized','Callback','plot_cluster_win','String','Plot');
decl_button = uicontrol('Style','Pushbutton',...
    'Position',[.3 .14 .2 .1 ],...
    'Units','normalized','Callback','clusterdeg','String','Create');

close_button=uicontrol('Style','Pushbutton',...
    'Position',[.65 .02 .20 .08 ],...
    'Units','normalized',...
    'Callback','close(findobj(''tag'',''fig_win''));close(findobj(''tag'',''fig_clus''));close(findobj(''tag'',''fig_declus_wintec''));close,done',...
    'String','Exit');

go_button=uicontrol('Style','Pushbutton',...
    'Position',[.8 .6 .20 .095],...
    'Units','normalized',...
    'Callback','close(findobj(''tag'',''fig_win''));declus_wintec',...
    'String','Go');
info_button=uicontrol('Style','Pushbutton',...
        'Position',[.10 .02 .20 .08 ],...
        'Units','normalized',...
        'Callback','zmaphelp(titlestr1,infostr1); web([''file:'' hodi ''/zmapwww/declus_win/index.html''])',...
        'String','Info');

%% Text
txt1 = text(...
    'Color',[1 0 0 ],...
    'EraseMode','normal',...
    'Position',[0.2 1.00 0 ],...
    'Rotation',0 ,...
    'FontWeight','bold' ,...
    'FontSize',ZmapGlobal.Data.fontsz.m ,...
    'String','Declustering menu ');
txt2 = text(...
    'Color',[0 0 0 ],...
    'EraseMode','normal',...
    'Position',[0.02 0.8 0 ],...
    'Rotation',0 ,...
    'FontWeight','bold' ,...
    'FontSize',ZmapGlobal.Data.fontsz.m ,...
    'String','Choose window size:');
txt3 = text(...
    'Color',[0 0 0 ],...
    'EraseMode','normal',...
    'Position',[0.02 0.5 0 ],...
    'Rotation',0 ,...
    'FontWeight','bold' ,...
    'FontSize',ZmapGlobal.Data.fontsz.m ,...
    'String','Show space and time windows:');
txt4 = text(...
    'Color',[0 0 0 ],...
    'EraseMode','normal',...
    'Position',[0.02 0.22 0 ],...
    'Rotation',0 ,...
    'FontWeight','bold' ,...
    'FontSize',ZmapGlobal.Data.fontsz.m ,...
    'String','Create degree of clustering map:');

