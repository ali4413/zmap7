function incias() % autogenerated function wrapper
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    report_this_filefun(mfilename('fullpath'));
    %
    %
    % make another dialog interface and
    %
    figure(mess);
    clf
    %initial values
    iwl3 = 1;
    nustep = 10;
    
    
    
    
    set(gca,'visible','off');
    set(gcf,'pos',[ZG.welcome_pos 400 250]);
    
    % creates a dialog box to input some parameters
    %
    
    inp2_field=uicontrol('Style','edit',...
        'Position',[.80 .40 .12 .10],...
        'Units','normalized','String',num2str(nustep),...
        'callback',@callbackfun_001);
    
    close_button=uicontrol('Style','Pushbutton',...
        'Position', [.60 .05 .15 .15 ],...
        'Units','normalized','callback',@callbackfun_002,'String','Cancel');
    
    go_button=uicontrol('Style','Pushbutton',...
        'Position',[.25 .05 .15 .15 ],...
        'Units','normalized',...
        'callback',@callbackfun_003,...
        'String','Go');
    
    
    txt2 = text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[0. 0.40 0 ],...
        'FontSize',ZmapGlobal.Data.fontsz.m,...
        'FontWeight','bold',...
        'String','Please input number of movie-frames:');
    
    set(gcf,'visible','on')
    
    function callbackfun_001(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        nustep=str2double(inp2_field.String);
        inp2_field.String=num2str(nustep);
    end
    
    function callbackfun_002(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        zmapmenu;
    end
    
    function callbackfun_003(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        zmap_message_center();
        runcias;
    end
    
end
