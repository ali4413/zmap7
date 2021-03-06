function view_bdepth(lab1, valueMap) 
    % view_maxz plots the maxz LTA values calculated
    % with maxzlta.m or other similar values as a color map
    % needs valueMap, gx, gy, stri
    %
    % define size of the plot etc.
    %
%     
%          The Z-Value Map Window                         
%                                                     
%               This window displays seismicity rate changes    
%               as z-values using a color code. Negative        
%               z-values indicate an increase in the seismicity'
%               rate, positive values a decrease.               
%               Some of the menu-bar options are                
%               described below:                                
%                                                               
%               Threshold: You can set the maximum size that    
%                 a volume is allowed to have in order to be    
%                 displayed in the map. Therefore, areas with   
%                 a low seismicity rate are not displayed.      
%                 edit the size (in km) and click the mouse     
%                 outside the edit window.                      
%              FixAx: You can chose the minimum and maximum     
%                      values of the color-legend used.         
%              Polygon: You can select earthquakes in a         
%               polygon either by entering the coordinates or   
%               defining the corners with the mouse            
%                  
%              Circle: Select earthquakes in a circular volume:'
%                    Ni, the number of selected earthquakes can'
%                    be edited in the upper right corner of the'
%                    window.                                    
%               Refresh Window: Redraws the figure, erases      
%                     selected events.                          
%             
%               zoom: Selecting Axis -> zoom on allows you to   
%                     zoom into a region. Click and drag with   
%                     the left mouse button. type <help zoom>   
%                     for details.                              
%               Aspect: select one of the aspect ratio options  
%               Text: You can select text items by clicking.The'
%                     selected text can be rotated, moved, you  
%                     can change the font size etc.             
%                     Double click on text allows editing it.   
                    
    % turned into function by Celso G Reyes 2017
    
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals

    report_this_filefun();
    
    % Find out if figure already exists
    %
    bmap=findobj('Name','b-value-depth-ratio-map');
    
    use_old_win = false;
    % This is the info window text
    
    % Set up the Seismicity Map window Enviroment
    %
    if isempty(bmap) || ~use_old_win
        bmap = figure_w_normalized_uicontrolunits( ...
            'Name','b-value-depth-ratio-map',...
            'NumberTitle','off', ...
            'NextPlot','new', ...
            'backingstore','on',...
            'Visible','off', ...
            'Position',position_in_current_monitor(ZG.map_len(1), ZG.map_len(2)));
        % make menu bar
        
        uicontrol('Units','normal',...
            'Position',[.0 .93 .08 .06],'String','Info ',...
            'callback',@callbackfun_001);
        
        create_my_menu();
        
        ZG.tresh_km = nan; re4 = valueMap;
        
        colormap(jet)
        ZG.tresh_km = nan; minpe = nan; Mmin = nan;
        
    end   % This is the end of the figure setup
    
    % Now lets plot the color-map of the z-value
    %
    figure(bmap);
    delete(findobj(bmap,'Type','axes'));
    % delete(sizmap);
    reset(gca)
    cla
    set(gca,'NextPlot','replace')
    watchon;
    set(gca,'visible','off','FontSize',ZmapGlobal.Data.fontsz.s,'FontWeight','bold',...
        'FontWeight','bold','LineWidth',1.5,...
        'Box','on','SortMethod','childorder')
    
    rect = [0.18,  0.10, 0.7, 0.75];
    rect1 = rect;
    
    % find max and min of data for automatic scaling
    %
    ZG.maxc = max(valueMap(:));
    ZG.maxc = fix(ZG.maxc)+1;
    ZG.minc = min(valueMap(:));
    ZG.minc = fix(ZG.minc)-1;
    
    % Find percentage above and below 1.0
    disp('HELP!!!!!!');
    under_1 = valueMap < 1.0;
    equal_1 = valueMap == 1.0;
    over_1 = valueMap > 1.0;
    
    total_num = length(valueMap);
    p_under = under_1/total_num;
    p_equal = equal_1/total_num;
    p_over = over_1/total_num;
    
    % set values gretaer ZG.tresh_km = nan
    %
    re4 = valueMap;
    re4(r > ZG.tresh_km) = nan;
    re4(Prmap < minpe) = nan;
    re4(old1 <  Mmin) = nan;
    
    % plot image
    %
    orient landscape
    %set(gcf,'PaperPosition', [0.5 1 9.0 4.0])
    
    axes('position',rect)
    set(gca,'NextPlot','add')
    pco1 = pcolor(gx,gy,re4);
    
    axis([ min(gx) max(gx) min(gy) max(gy)])
    axis image
    set(gca,'NextPlot','add')
    
    shading(ZG.shading_style);
    
    % make the scaling for the recurrence time map reasonable
    if lab1(1) =='T'
        re = valueMap(~isnan(valueMap));
        caxis([min(re) 5*min(re)]);
    end

    fix_caxis.ApplyIfFrozen(gca); 
    
    title([name ';  '   num2str(t0b) ' to ' num2str(teb) ],'FontSize',ZmapGlobal.Data.fontsz.s,...
        'Color','r','FontWeight','bold')
    
    xlabel('Longitude [deg]','FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.s)
    ylabel('Latitude [deg]','FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.s)
    
    % plot overlay
    %
    set(gca,'NextPlot','add')
    zmap_update_displays();
    ploeq = plot(ZG.primeCatalog.Longitude,ZG.primeCatalog.Latitude,'k.');
    set(ploeq,'Tag','eq_plot','MarkerSize',ZG.ms6,'Marker',ty,'Color',ZG.someColor,'Visible','on')
    
    
    
    set(gca,'visible','on','FontSize',ZmapGlobal.Data.fontsz.s,'FontWeight','bold',...
        'FontWeight','bold','LineWidth',1.5,...
        'Box','on','TickDir','out')
    h1 = gca;
    hzma = gca;
    
    %lab1 = 'b-value-depth-ratio:';
    
    % Create a colorbar
    %
    h5 = colorbar('horiz');
    set(h5,'Pos',[0.35 0.05 0.4 0.02],...
        'FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.s,'TickDir','out')
    
    rect = [0.00,  0.0, 1 1];
    axes('position',rect)
    axis('off')
    %  Text Object Creation
    txt1 = text(...
        'Units','normalized',...
        'Position',[ 0.33 0.06 0 ],...
        'HorizontalAlignment','right',...
        'FontSize',ZmapGlobal.Data.fontsz.s,....
        'FontWeight','bold',...
        'String',lab1);
    ni_txt = text('Position', [.39 .12],'String',[num2str(ni_plot),' events per grid node.']);
    bval_txt =  text('Position', [.34 .96],'String',['Overall b-value depth ratio = ' num2str(depth_ratio)]);
    %bval2_txt =  text('Position', [.63 .95],'String',depth_ratio);
    
    dbrange1 = num2str(top_zonet);
    dbrange2 = num2str(top_zoneb);
    dbrange3 = num2str(bot_zonet);
    dbrange4 = num2str(bot_zoneb);
    mid_txt = text('Position', [.20 .915],'String', ['Top and bottom zones for ratio calculation(km):' dbrange1,' to ',dbrange2 ,' and ' dbrange3,' to ',dbrange4]);
    %mid2_txt = text('Position', [.685 .915],'String', [dbrange1,' to ',dbrange2 ,' and ' dbrange3,' to ',dbrange4]);
    
    
    % Make the figure visible
    %
    set(gca,'FontSize',ZmapGlobal.Data.fontsz.s,'FontWeight','bold',...
        'FontWeight','bold','LineWidth',1.5,...
        'Box','on','TickDir','out')
    figure(bmap);
    %sizmap = signatur('ZMAP','',[0.01 0.04]);
    %set(sizmap,'Color','k')
    axes(h1)
    watchoff(bmap)
    %whitebg(gcf,[ 0 0 0 ])
    
    
    %% ui functions
    function create_my_menu()
        add_menu_divider();
        
        add_symbol_menu('eq_plot');
        options = uimenu('Label',' Select ');
        uimenu(options,'Label','Refresh ','MenuSelectedFcn',@callbackfun_002)
        uimenu(options,'Label','Select EQ in Circle',...
            'MenuSelectedFcn',@callbackfun_003)
        
        op1 = uimenu('Label',' Maps ');
        
        adjmenu =  uimenu(op1,'Label','Adjust Map Display Parameters');
        uimenu(adjmenu,'Label','Adjust Rmax cut',...
            'MenuSelectedFcn',@callbackfun_004)
        uimenu(adjmenu,'Label','Adjust goodness of fit cut',...
            'MenuSelectedFcn',@callbackfun_005)
        
        
        uimenu(op1,'Label','Depth Ratio Map',...
            'MenuSelectedFcn',@callbackfun_013)
        
        uimenu(op1,'Label','Utsu Probability Map',...
            'MenuSelectedFcn',@callbackfun_014)
        
        uimenu(op1,'Label','Top Zone b value Map',...
            'MenuSelectedFcn',@callbackfun_015)
        
        uimenu(op1,'Label','Bottom Zone b value Map',...
            'MenuSelectedFcn',@callbackfun_016)
        
        uimenu(op1,'Label','% of nodal EQs within top zone',...
            'MenuSelectedFcn',@callbackfun_017)
        
        uimenu(op1,'Label','% of nodal EQs within bottom zone',...
            'MenuSelectedFcn',@callbackfun_018)
        
        uimenu(op1,'Label','resolution Map',...
            'MenuSelectedFcn',@callbackfun_019)
        uimenu(op1,'Label','Histogram ','MenuSelectedFcn',@(~,~)zhist())
        
        add_display_menu(1);
    end
    
    %% callback functions
    
    function callbackfun_001(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        web(['file:' hodi '/zmapwww/chp11.htm#996756']) ;
    end
    
    function callbackfun_002(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        use_old_win = 1;
        view_bdepth(lab1, valueMap);
    end
    
    function callbackfun_003(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        h1 = gca;
        met = 'rd';
        ZG=ZmapGlobal.Data;
        ZG.hold_state=false;
        cirbva_bdepth2;
        watchoff(bmap);
    end
    
    function callbackfun_004(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        asel = 'rmax';
        adjub();
        view_bdepth(lab1, valueMap);
    end
    
    function callbackfun_005(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        asel = 'gofi';
        adjub();
        use_old_win = 1;
        view_bdepth(lab1, valueMap);
    end
    
    function callbackfun_013(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        lab1='b ratio';
        valueMap = old;
        view_bdepth(lab1, valueMap);
    end
    
    function callbackfun_014(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        lab1='Probability';
        valueMap = Prmap;
        view_bdepth;
    end
    
    function callbackfun_015(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        lab1='Top Zone b value';
        valueMap = top_b;
        view_bdepth(lab1, valueMap);
    end
    
    function callbackfun_016(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        lab1='Bottom Zone b value';
        valueMap = bottom_b;
        view_bdepth(lab1, valueMap);
    end
    
    function callbackfun_017(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        lab1='% of nodal EQs within top zone';
        valueMap = per_top;
        view_bdepth(lab1, valueMap);
    end
    
    function callbackfun_018(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        lab1='% of nodal eqs within bottom zone';
        valueMap = per_bot;
        view_bdepth(lab1, valueMap);
    end
    
    function callbackfun_019(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        lab1='Radius in [km]';
        valueMap = r;
        view_bdepth(lab1, valueMap);
    end
    
    function adjub()
        report_this_filefun();
        
        
        prompt={'Enter the maximum radius cut-off:','Enter the minimum Utsu probability '};
        def={'nan','nan'};
        dlgTitle='Input Map Selection Criteria';
        lineNo=1;
        answer=inputdlg(prompt,dlgTitle,lineNo,def);
        re4 = valueMap;
        
        ZG.tresh_km = str2double(answer{2,1}) ;
        minpe = str2double(answer{1,1}) ;
        
        if ZG.tresh_km >= 0
            valueMap(Prmap < ZG.tresh_km) = 1;
        elseif minpe >= 0
            valueMap(r >= minpe) = 1;
        end
        
        ca = caxis;
        
        ve = ca(1):(ca(2)-ca(1))/64:ca(2);
        
        i = find(abs(ve-1) == min(abs(ve-1)) );
        
        col = jet;
        col(i,:) = [0.8 0.8 0.8] ;
        col(i-1,:) = [0.8 0.8 0.8] ;
        col(i+1,:) = [0.8 0.8 0.8] ;
        
        colormap(col);
    end
end

