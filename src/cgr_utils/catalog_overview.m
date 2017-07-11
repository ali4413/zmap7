function mycat = catalog_overview(mycat)
    % catalog_overview presents a window where catalog summary statistics show and can be edited
    
    %  This scriptfile ask for several input parameters that can be setup
    %  at the beginning of each session. The default values are the
    %  extrema in the catalog
    if ~isa(mycat,'ZmapCatalog')
        mycat = ZmapCatalog(mycat);
    end
    
    report_this_filefun(mfilename('fullpath'));
    %global file1 tim1 tim2 minma2 maxma2 minde maxde maepi
    %global maxdep maxma mindep minti maxti minmag
    
    %  default values
    t0b = min(mycat.Date);
    teb = max(mycat.Date);
    tdiff = (teb - t0b);
    
    if ~exist('par1', 'var')   %select bin length respective to time in catalog
        par1 = 30;
    end
    big_evt_minmag = ZmapGlobal.Data.big_eq_minmag;
    %{
    %% these shouldn't be set here, they should be set at plot time, or in plot menu
    big_evt_minmag = max(mycat.Magnitude) -0.2;
    dep1 = 0.3*max(mycat.Depth);
    dep2 = 0.6*max(mycat.Depth);
    dep3 = max(mycat.Depth);
    %}
    minti = min(mycat.Date);
    maxti  = max(mycat.Date);
    minma = min(mycat.Magnitude);
    maxma = max(mycat.Magnitude);
    mindep = min(mycat.Depth);
    maxdep = max(mycat.Depth);
    
    fignum = create_dialog();
    
    watchoff
    str = 'Please Select a subset of earthquakes and press "Go"';
    zmap_message_center.set_message('Message',str);
    figure(fignum);
    
    %uiwait(fignum)
    
    function fignum = create_dialog()
        % create_dialog - creates the dialog box
        
        %
        % make the interface
        %
        fignum = figure_w_normalized_uicontrolunits(...
            'Units', 'pixels', ...
            'pos',[300 100 300 400 ],...
            'Name',['Catalog "', mycat.Name,'"'],...
            'visible','off',...
            'NumberTitle','off',...
            'MenuBar','none',...
            'Tag', main_dialog_figure('tag'),...
            'NextPlot','new');
        axis off
        
        % control display parameters
        label_x = 0.08;
        all_h = 0.17;
        
        
        % EQ's in catalog
        uicontrol('Style','text',...
            'Position',[.1 .94 .8 .05],...
            'Units', 'pixels',...
            'FontSize',ZmapGlobal.Data.fontsz.m ,...
            'FontWeight','bold' ,...
            'HorizontalAlignment','center',...
            'String',['Catalog "', mycat.Name, '"']);
        
        uicontrol('Style','text',...
            'Position',[.1 .88 .7 .05],...
            'Units', 'pixels',...
            'FontSize',ZmapGlobal.Data.fontsz.m ,...
            'FontWeight','bold' ,...
            'HorizontalAlignment','left',...
            'String',' EQs in catalog: ');
        
        uicontrol('Style','text',...
            'Position',[.1 .88 .7 .05],...
            'Units', 'pixels',...
            'FontSize',ZmapGlobal.Data.fontsz.m ,...
            'FontWeight','bold' ,...
            'HorizontalAlignment','left',...
            'String',' EQs in catalog: ');
        
        uicontrol('Style','text',...
            'Position',[.70 .88 .22 .05],...
            'Units', 'pixels', ...
            'String',num2str(mycat.Count),...
            'Value',mycat.Count,...
            'FontWeight','bold',...
            'FontSize', ZmapGlobal.Data.fontsz.m,...
            'Tag','mapview_nquakes_field',...
            'Callback',@upate_numeric);
        
        filter_panel = uipanel('Parent',fignum,'Title','Catalog Parameters',...
            'Position',[.02 .4 .96 .45], 'Units', 'pixels');
        option_panel = uipanel('Parent',fignum,'Title','Additional Parameters',...
            'Position',[.02, .15, .96, .25], 'Units', 'pixels');
        
        % plot big events with M gt
        uicontrol('Parent',option_panel,...
            'Style','text',...
            'Position',[label_x 0.6 .7 .3 ],...
            'Units', 'pixels', ...
            'FontSize',ZmapGlobal.Data.fontsz.m ,...
            'FontWeight','bold' ,...
            'HorizontalAlignment','left',...
            'String','Plot "Big" Events:    M >');
        
        uicontrol('Parent',option_panel,...
            'Style','edit','Position',[.75 .6 .22 .3],...
            'Units', 'pixels', ...
            'String',num2str(big_evt_minmag),...
            'Value',big_evt_minmag,...
            'Tag','mapview_big_evt_field',...
            'Callback',@update_numeric);
        
        % TODO: add reset button (would be nice...)
        
        %  beginning year
        uicontrol('Parent',filter_panel,...
            'Style','edit','Position',[.45 0.75 .52 all_h],...
            'Units','pixels',...
            'String',char(minti,'yyyy-MM-dd HH:mm:ss'),...
            'Value', datenum(minti),...
            'HorizontalAlignment','center',...
            'Callback',@update_dates,...
            'Tag','mapview_start_field',...
            'tooltipstring', 'as decimal year or yyyy-mm-dd hh:mm:ss');
        
        uicontrol('Parent',filter_panel,...
            'Style','text',...
            'Position',[label_x 0.75 .4 all_h],...
            'Units', 'pixels', ...
            'FontSize',ZmapGlobal.Data.fontsz.m ,...
            'FontWeight','bold' ,...
            'HorizontalAlignment','left',...
            'String','Beginning date: ');
        
        % ending year
        uicontrol('Parent',filter_panel,...
            'Style','edit','Position',[.45 0.55 .52 all_h],...
            'Units', 'pixels', ...
            'String',char(maxti,'yyyy-MM-dd HH:mm:ss'),...
            'Value', datenum(maxti),...
            'Callback',@update_dates,...
            'Tag','mapview_end_field',...
            'tooltipstring', 'as decimal year or yyyy-mm-dd hh:mm:ss');
        
        
        uicontrol('Parent',filter_panel,...
            'Style','text',...
            'Position',[label_x 0.55 0.4 all_h],...
            'Units', 'pixels', ...
            'FontSize',ZmapGlobal.Data.fontsz.m ,...
            'FontWeight','bold' ,...
            'HorizontalAlignment','left',...
            'String','Ending date: ');
        
        
        % Magnitude
        
        uicontrol('Parent',filter_panel,...
            'Style','text',...
            'Position',[label_x 0.29 0.5 all_h],...
            'Units', 'pixels', ...
            'FontSize',ZmapGlobal.Data.fontsz.m,...
            'FontWeight','bold',...
            'HorizontalAlignment','left',...
            'String','Magnitude:');
        
        
        uicontrol('Parent',filter_panel,...
            'Style','text',...
            'Position',[0.63 0.29 0.4 all_h],...
            'Units', 'pixels', ...
            'FontSize',ZmapGlobal.Data.fontsz.m,...
            'FontWeight','bold',...
            'HorizontalAlignment','left',...
            'String','≤ M ≤');
        
        uicontrol('Parent',filter_panel,...
            'Style','edit',...
            'Position',[.43 .3 .17 all_h],...
            'Units', 'pixels', ...
            'String',num2str(minma),...
            'Value', minma,...
            'Tag','mapview_minmag_field',...
            'Callback',@update_numeric);
        
        uicontrol('Parent',filter_panel,...
            'Style','edit','Position',[.80 .3 .17 all_h],...
            'Units', 'pixels', ...
            'String',num2str(maxma),...
            'Value', maxma,...
            'Tag','mapview_maxmag_field',...
            'Callback',@update_numeric);
        
        
        % Depth control
        uicontrol('Parent',filter_panel,...
            'Style','text',...
            'Position',[label_x 0.04 0.4 all_h],...
            'Units', 'pixels', ...
            'FontSize',ZmapGlobal.Data.fontsz.m,...
            'FontWeight','bold',...
            'HorizontalAlignment','left',...
            'String','Depth:');
        
        
        uicontrol('Parent',filter_panel,...
            'Style','text',...
            'Position',[0.5 0.04 0.4 all_h],...
            'Units', 'pixels', ...
            'FontSize',ZmapGlobal.Data.fontsz.m,...
            'FontWeight','bold',...
            'HorizontalAlignment','left',...
            'String','≤ Z (km) ≤');
        
        uicontrol('Parent',filter_panel,...
            'Style','edit','Position',[.29 .05 .2 all_h],...
            'Units', 'pixels', ...
            'String',num2str(mindep),...
            'Value', mindep,...
            'Tag','mapview_mindepth_field',...
            'Callback',@update_numeric);
        
        uicontrol('Parent',filter_panel,...
            'Style','edit','Position',[.77 .05 .2 all_h],...
            'Units', 'pixels', ...
            'String',num2str(maxdep),...
            'Value', maxdep,...
            'Tag','mapview_maxdepth_field',...
            'Callback',@update_numeric);
        
        % buttons
        uicontrol('Style','Pushbutton',...
            'Position',[.79 .02 .20 .10 ],...
            'Units', 'pixels', ...
            'Callback',@cancel_callback,'String','cancel');
        
        uicontrol('Style','Pushbutton',...
            'Position',[.58 .02 .20 .10 ],...
            'Units','pixels',...
            'Callback',@go_callback,...
            'String','Apply');
        
        uicontrol('Style','Pushbutton',...
            'Position',[.05 .02 .35 .10 ],...
            'Units', 'pixels', ...
            'Callback',{@distro_callback, mycat}, ...
            'String','see distributions');
        
        set(gcf,'visible','on')
    end
    
    function update_numeric(src, ~)
        % update the value from the string
        src.Value = str2double(src.String);
    end
    
    function update_dates(src, ~)
        % interpret as decimal year or full date
        isTextdate = contains(src.String,{':',' ','/','-'});
        
        if isTextdate
            src.Value = datenum(datetime(src.String)); %provides extra parsing
        else
            try
                src.Value=str2double(src.String);
            catch ME
            end
        end
    end
    
    function go_callback(src, ~)
        %TODO remove all the side-effects.  store relevent data somewhere specific
        %filter the catalog, then return
        myparent=get(src,'Parent');
        
        h = findall(myparent,'Tag','mapview_maxdepth_field');
        maxdep = h.Value;
        h = findall(myparent,'Tag','mapview_minmag_field');
        minma = h.Value;
        h = findall(myparent,'Tag','mapview_maxmag_field');
        maxma = h.Value;
        h = findall(myparent,'Tag','mapview_mindepth_field');
        mindep = h.Value;
        h = findall(myparent,'Tag','mapview_start_field');
        minti = datetime(datevec(h.Value));
        h = findall(myparent,'Tag','mapview_end_field');
        maxti = datetime(datevec(h.Value));
        h = findall(myparent,'Tag','mapview_big_evt_field');
        minmag = h.Value;
        %h = findall(myparent,'Tag','mapview_binlen_field');
        %par1 = h.Value;
        if ~isa(mycat,'ZmapCatalog')
            mycat = ZmapCatalog(mycat);
        end
        
        % following code originally from sele_sub.m
        %    Create  reduced (in time and magnitude) catalogues "a" and "ZG.newcat"
        %
        mycat.addFilter('Magnitude','>=', minma);
        mycat.addFilter('Magnitude','<=', maxma);
        mycat.addFilter('Date','>=',minti);
        mycat.addFilter('Date','<=',maxti);
        mycat.addFilter('Depth','>=',mindep);
        mycat.addFilter('Depth','<=',maxdep);
        mycat.cropToFilter();
        % not changed unless a new set of general parameters is entered
        % TOFIX: ZG.newcat and new2 used to be set HERE, they need to be set elsewhere. maybe a replaceMainCatalog function?
        % ZG.newcat = ZmapCatalog;     % ZG.newcat is created to store the last subset data
        % ZG.newt2 = ZmapCatalog;      %  ZG.newt2 is a subset to be changed during analysis
        
        tim1 = minti;
        tim2 = maxti;
        minma2 = minma;
        maxma2 = maxma;
        minde = min(mycat.Depth);
        maxde = max(mycat.Depth);
        
        % OTHER VARIABLES existsed here too, but didn't seem relevant
        
        %create catalog of "big events" if not merged with the original one:
        %
        mycat.clearFilter();
        maepi = mycat.subset(mycat.Magnitude > minmag);
        
        mycat.sort('Date');
       
        zmap_message_center.update_catalog();
        update(mainmap())
        
        close(main_dialog_figure('handle'));
        % changes in bin length go to global par1
    end
    
    
    
end

function cancel_callback(~, ~)
    % return without making changes to catalog
    zmap_message_center.update_catalog();
    %h=zmap_message_center();
    %h.update_catalog();
    close(main_dialog_figure('handle'));
end

function info_callback(~,~)
    
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
    zmaphelp(titstr,hlpStr)
end

function distro_callback(src,~,mycat)
    watchon; drawnow;
    dlg = main_dialog_figure('handle');
    if numel(dlg) >1
        warning('multiple dialog windows found')
    end
        
    f = findall(0,'Tag','catoverview_distribution_pane');
    if isempty(f)
        % grow the catalog figure. create plots in the empty portion, change the button behavior
        dlg.Position = dlg.Position + [0 0 450 0];
        src.String = 'hide distributions';
        pp=uipanel('Parent',gcf,'Units','pixels','Position',[310 10 420 370],'Tag','catoverview_distribution_pane','Title','Distributions');
        %f = figure('Name','Catalog time, mag, depth distributions','MenuBar','none','NumberTitle','off','Tag','catoverview_distribution');
        t_p=subplot(3,1,1,'Parent',pp);
        m_p=subplot(3,1,2,'Parent',pp);
        d_p=subplot(3,1,3,'Parent',pp);
        histogram(t_p,mycat.Date);
        xlabel(t_p,'Time');
        histogram(m_p,mycat.Magnitude);
        xlabel(m_p,'Magnitude');
        histogram(d_p,mycat.Depth);
        xlabel(d_p,'Depth');
    else
        delete(findobj(0,'Tag','catoverview_distribution_pane'));
        dlg.Position = dlg.Position - [0 0 450 0];
        
        src.String = 'show distributions';
        % delete the histograms, 
    end
    watchoff; drawnow;
end

%% Tag Name Helpers
function answer = main_dialog_figure(opt)
    % get
    % opt is either 'tag' or 'handle'
    s = 'catalog_overview_dlg';
    switch opt
        case 'tag'
            answer = s;
        case 'handle'
            answer = findobj(0,'Tag', s);
        otherwise
            error('main_dialog_figure:invalid option, must be ''tag'' or ''handle''');
    end
end
    
    
