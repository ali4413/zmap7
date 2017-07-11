function timeplot(nosort)
    % This .m file "timeplot" plots the events select by "circle"
    % or by other selection button as a cummultive number versus
    % time plot in window 2.
    % Time of events with a Magnitude greater than minmag will
    % be shown on the curve.  Operates on ZG.newt2, resets  b  to ZG.newt2
    %     ZG.newcat is reset to:
    %                       - "a" if either "Back" button or "Close" button is         %                          pressed.
    %                       - ZG.newt2 if "Save as Newcat" button is pressed.
    %Last modification 11/95
    
    % Updates:
    % Added callback in op5 for afterschock sequence rate change detection (07.07.03: J. Woessner)
    
    report_this_filefun(mfilename('fullpath'));
    global ZG
    global tmvar  minmag                    %for P-Value
    global par1 pplot tmp1 tmp2 tmp3 tmp4 difp loopcheck Info_p iwl2
   global cplot mess til plo2 cum statime 
    global magco selt hndl2 wls_button ml_button
    global name
    
    if ~exist('xt','var')
        xt=[]; % time series that will be used
    end
    if ~exist('as','var')
        as=[]; % z values, maybe? used by the save callback.
    end
    
    if isempty(par1) %binning
        par1=1;
    end
    
    zmap_message_center.set_info(' ','Plotting cumulative number plot...');
    
    if ~exist('nosort','var')
        nosort = 'of'  ;
    end
    
    if nosort == 'of'
        ZG.newt2.sort('Date');
    else  % f
        if t3>t2
            % logic does not make sense within ZmapCatalog.
            error('this doesn''t make sense');
        end
        
    end
    
    cumu2=[]; %predeclare this thing for the callback function
    
    if ~exist('xt','var')
        xt=[]; % time series that will be used
    end
    if ~exist('as','var')
        as=[]; % z values, maybe? used by the save callback.
    end
    
    think
    report_this_filefun(mfilename('fullpath'));
    
    % This is the info window text
    %
    ttlStr='The Cumulative Number Window                  ';
    hlpStr1= ...
        ['                                                     '
        ' This window displays the seismicity in the sel-     '
        ' ected area as a cumulative number plot.             '
        ' Options from the Tools menu:                        '
        ' Cuts in magnitude and  depth: Opens input para-     '
        '    meter window                                     '
        ' Decluster the catalog: Will ask for declustering    '
        '     input parameter and decluster the catalog.      '
        ' AS(t): Evaluates significance of seismicity rate    '
        '      changes using the AS(t) function. See the      '
        '      Users Guide for details                        '
        ' LTA(t), Rubberband: dito                            '
        ' Overlay another curve (hold): Allows you to plot    '
        '       one or several more curves in the same plot.  '
        '       select "Overlay..." and then selext a new     '
        '       subset of data in the map window              '
        ' Compare two rates: start a comparison and moddeling '
        '       of two seimicity rates based on the assumption'
        '       of a constant b-value. Will calculate         '
        '       Magnitude Signature. Will ask you for four    '
        '       times.                                        '
        '                                                     '];
    hlpStr2= ...
        ['                                                      '
        ' b-value estimation:    just that                     '
        ' p-value plot: Lets you estimate the p-value of an    '
        ' aftershock sequence.                                 '
        ' Save cumulative number cure: Will save the curve in  '
        '        an ASCII file                                 '
        '                                                      '
        ' The "Keep as newcat" button in the lower right corner'
        ' will make the currently selected subset of eartquakes'
        ' in space, magnitude and depth the current one. This  '
        ' will also redraw the Map window!                     '
        '                                                      '
        ' The "Back" button will plot the original cumulative  '
        ' number curve without statistics again.               '
        '                                                      '];
    
    
    % Find out of figure already exists
    %
    [existFlag,figNumber]=figure_exists('Cumulative Number',1);
    newCumWindowFlag=~existFlag;
    cum = figNumber;
    
    % Set up the Cumulative Number window
    
    if newCumWindowFlag
        cum = figure_w_normalized_uicontrolunits( ...
            'Name','Cumulative Number',...
            'NumberTitle','off', ...
            'NextPlot','replace', ...
            'backingstore','on',...
            'Visible','off', ...
            'Position',[ 100 100 (ZmapGlobal.Data.map_len - [100 20]) ]);
        
        matdraw
        
        selt='in';
        uimenu('Label','|','Enable','off')
        options = uimenu('Label','ZTools');
        
        uimenu(options,'Label','Cuts in time, magnitude and depth', 'Callback','inpu2;timeplot()')
        uimenu(options,'Label','Cut in Time (cursor) ', 'Callback','timesel(4);timeplot();');
        uimenu(options,'Label','Date Ticks in different format', 'Callback','newtimetick','Enable','off');
        
        uimenu (options,'Label','Decluster the catalog', 'Callback','inpudenew;')
        iwl = iwl2*365/par1;
        uimenu(options,'Label','Overlay another curve (hold)', 'Callback','ZG=ZmapGlobal.Data;ZG.hold_state2=true; ')
        uimenu(options,'Label','Compare two rates (fit)', 'Callback','dispma2')
        uimenu(options,'Label','Compare two rates ( No fit)', 'Callback','ic=0;dispma3')
        %uimenu(options,'Label','Day/Night split ', 'Callback','daynigt')
        
        op3D  =   uimenu(options,'Label','Time series ');
        uimenu(op3D,'Label','Time-depth plot ',...
            'Callback',@(~,~)TimeDepthPlotter.plot(ZG.newt2));
        uimenu(op3D,'Label','Time magnitude plot ',...
            'Callback',@(~,~)TimeMagnitudePlotter.plot(ZG.newt2));
        
        
        
        
        op4B = uimenu(options,'Label','Rate changes (beta and z-values) ');
        
        uimenu(op4B, 'Label', 'beta values: LTA(t) function',...
            'Callback', 'sta = ''bet'',newsta')
        uimenu(op4B, 'Label', 'beta values: "Triangle" Plot',...
            'Callback', ';betatriangle')
        uimenu(op4B,'Label','z-values: AS(t)function',...
            'Callback','set(gcf,''Pointer'',''watch'');sta = ''ast'';newsta')
        uimenu(op4B,'Label','z-values: Rubberband function',...
            'Callback','set(gcf,''Pointer'',''watch'');sta = ''rub'';newsta')
        uimenu(op4B,'Label','z-values: LTA(t) function ',...
            'Callback','set(gcf,''Pointer'',''watch'');sta = ''lta'';newsta')
        
        
        op4 = uimenu(options,'Label','Mc and b-value estimation');
        uimenu(op4,'Label','automatic', 'Callback','ZG=ZmapGlobal.Data;ZG.hold_state=false,selt = ''in'',; bdiff2')
        uimenu(op4,'label','Mc with time ', 'Callback','selt = ''in''; sPar = ''mc''; plot_McBwtime');
        uimenu(op4,'Label','b with depth', 'Callback','bwithde2')
        uimenu(op4,'label','b with magnitude', 'Callback','bwithmag');
        uimenu(op4,'label','b with time', 'Callback','selt = ''in''; sPar = ''b''; plot_McBwtime');
        
        
        pstring=['global freq_field1 freq_field2 freq_field3 freq_field4 freq_field5 tmp1 tmp2 tmp3 tmp4 tmm magn hpndl1 ctiplo mtpl ttcat;ttcat=ZG.newt2;'];
        ptstring=[pstring ' cltipval(2);'];
        pmstring=[pstring ' cltipval(1);'];
        
        op5 = uimenu(options,'Label','p-value estimation');
        
        %The following instruction calls a program for the computation of the parameters in Omori formula, for the catalog of which the cumulative number graph" is
        %displayed (the catalog ZG.newt2).
        uimenu(op5,'Label','Completeness in days after mainshock', 'Callback','mcwtidays')
        uimenu(op5,'Label','Define mainshock and estimate p', 'Callback','ZG=ZmapGlobal.Data;ZG.hold_state=false;inpu_main')
        %In the following instruction the program pvalcat2.m is called. This program computes a map of p in function of the chosen values for the minimum magnitude and
        %initial time.
        uimenu(op5,'Label','p as a function of time and magnitude', 'Callback','pvalcat2')
        uimenu(op5,'Label','Cut catalog at mainshock time',...
            'Callback','l = min(find( ZG.newt2.Magnitude == max(ZG.newt2.Magnitude) ));ZG.newt2 = ZG.newt2(l+1:ZG.newt2.Count,:);timeplot ')
        
        op6 = uimenu(options,'Label','Fractal dimension estimation');
        uimenu(op6,'Label','Compute the fractal dimension D', 'Callback',' E = ZG.newt2; org = 2; startfd');
        uimenu(op6,'Label','Compute D for random catalog', 'Callback',' org = 5; startfd;');
        uimenu(op6,'Label','Compute D with time', 'Callback',' org = 6; startfd;');
        uimenu(op6,'Label',' Help/Info on  fractal dimension', 'Callback',' showweb(''fractal''); ')
        
        uimenu(options,'Label','Cumlative Moment Release ', 'Callback','morel')
        
        op7 = uimenu(options,'Label','Stress Tensor Inversion Tools');
        uimenu(op7,'Label','Invert for stress-tensor - Michael''s Method ', 'Callback','doinvers_michael')
        uimenu(op7,'Label','Invert for stress-tensor - Gephart''s Method ', 'Callback','doinversgep_pc')
        uimenu(op7,'Label','Stress tensor with time', 'Callback','stresswtime')
        uimenu(op7,'Label','Stress tensor with depth', 'Callback','stresswdepth')
        uimenu(op7,'Label',' Help/Info on  stress tensor inversions', 'Callback','  showweb(''stress'') ')
        op5C = uimenu(options,'Label','Histograms');
        
        uimenu(op5C,'Label','Magnitude',...
            'Callback','global histo;hisgra(ZG.newt2.Magnitude,''Magnitude '');');
        uimenu(op5C,'Label','Depth',...
            'Callback','global histo;hisgra(ZG.newt2.Depth,''Depth '');');
        uimenu(op5C,'Label','Time',...
            'Callback','global histo;hisgra(ZG.newt2.Date,''Time '');');
        uimenu(op5C,'Label','Hr of the day',...
            'Callback','global histo;hisgra(ZG.newt2.Date.Hour,''Hr '');');
        
        
        uimenu(options,'Label','Save cumulative number curve', 'Callback',{@calSave1, xt, cumu2});
        
        uimenu(options,'Label','Save cum #  and z value', 'Callback',{@calSave7, xt, cumu2, as})
        
        %
        
        uicontrol('Units','normal','Position',[.0 .0 .1 .05],'String','Reset',...
             'Callback','nosort = ''of'';global ZG.newcat a ZG.newt2; ZG.newcat = ZG.newcat; ZG.newt2 = ZG.newcat; stri = ['' '']; stri1 = ['' '']; close(cum); timeplot(nosort)',...
            'tooltip','Resets the catalog to the original selection')
        uicontrol('Units','normal','Position',[.70 .0 .3 .05],'String','Keep as ZG.newcat',...
            'Callback','global ZG.newcat a ZG.newt2; ZG.newcat = ZG.newt2; ZG.a=ZG.newt2 ;zmap_message_center.update_catalog();update(mainmap())',...
            'tooltip','Plots this subset in the map window')
        
        ZG.hold_state2=false;
        
    end
    %end;    if figure exist
    
    if ZG.hold_state2
        cumu = 0:1:(tdiff*365/par1)+2;
        cumu2 = 0:1:(tdiff*365/par1)-1;
        cumu = cumu * 0;
        cumu2 = cumu2 * 0;
        n = ZG.newt2.Count;
        [cumu, xt] = hist(ZG.newt2.Date,(t0b:par1/365:teb));
        cumu2 = cumsum(cumu);
        
        
        hold on
        axes(ht)
        tiplot2 = plot(ZG.newt2.Date,(1:ZG.newt2.Count),'r');
        set(tiplot2,'LineWidth',2.0)
        
        
        ZG.hold_state2=false;
        return
    end
    
    figure_w_normalized_uicontrolunits(cum)
    delete(gca)
    delete(gca)
    reset(gca)
    dele = 'delete(sicum)';er = 'disp('' '')'; eval(dele,er);
    cla
    hold off
    watchon;
    
    set(gca,'visible','off','FontSize',ZmapGlobal.Data.fontsz.s,'FontWeight','normal',...
        'LineWidth',1.5,...
        'Box','on','SortMethod','childorder')
    
    if isempty(ZG.newcat), 
        ZG.newcat =a; 
    end
    
    % select big events ( > minmag)
    %
    l = ZG.newt2.Magnitude > minmag;
    big = ZG.newt2.subset(l);
    %calculate start -end time of overall catalog
    statime=[];
    par2=par1;
    t0b = min(ZG.a.Date);
    n = ZG.newt2.Count;
    teb = max(ZG.a.Date);
    ttdif=(teb - t0b); % days
    if ttdif>10                 %select bin length respective to time in catalog
        %par1 = ceil(ttdif/300);
    elseif ttdif<=10  &&  ttdif>1
        %par1 = 0.1;
    elseif ttdif<=1
        %par1 = 0.01;
    end
    
    
    if par1>=1
        tdiff = round((teb - t0b)*365/par1);
        %tdiff = round(teb - t0b);
    else
        tdiff = (teb-t0b)*365/par1;
    end
    % set arrays to zero
    cumu = 0:1:((teb-t0b)*365/par1)+2;
    cumu2 = 0:1:((teb-t0b)*365/par1)-1;
    % calculate cumulative number versus time and bin it
    n = ZG.newt2.Count;
    if par1 >=1
        [cumu, xt] = histcounts(ZG.newt2.Date,(t0b:par1/365:teb));
    else
        [cumu, xt] = histcounts((ZG.newt2.Date-ZG.newt2.Date(1)+par1/365)*365,(0:par1:(tdiff+2*par1)));
    end
    cumu2=cumsum(cumu);
    % plot time series
    %
    set(gcf,'PaperPosition',[0.5 0.5 5.5 8.5])
    rect = [0.25,  0.18, 0.60, 0.70];
    axes('position',rect)
    hold on
    set(gca,'visible','off')
    
    nu = (1:ZG.newt2.Count);
    nu(ZG.newt2.Count) = ZG.newt2.Count;
    
    tiplot2 = plot(ZG.newt2.Date, nu, 'b', 'LineWidth', 2.0);
    
    % plot end of data
    pl = plot(teb,ZG.newt2.Count,'rs');
    set(pl,'LineWidth',1.0,'MarkerSize',4,...
        'MarkerFaceColor','w','MarkerEdgeColor','r');
    
    pl = plot([max(ZG.newt2.Date),teb],[ZG.newt2.Count, ZG.newt2.Count],'k:');
    set(pl,'LineWidth',2.0);
    
    set(gca,'Ylim',[0 ZG.newt2.Count*1.05]);
    
    % plot big events on curve
    %
    if par1>=1
        if ~isempty(big)
            l = ZG.newt2.Magnitude > minmag;
            f = find( l  == 1);
            bigplo = plot(big.Date,f,'hm');
            set(bigplo,'LineWidth',1.0,'MarkerSize',10,...
                'MarkerFaceColor','y','MarkerEdgeColor','k')
            stri4 = [];
            [le1] = big.Count;
            for i = 1:le1
                s = sprintf('  M=%3.1f',big.Magnitude(i));
                stri4 = [stri4 ; s];
            end   % for i
            
        end
    end %if big
    
    if par1>=1
        xlabel('Time in years ','FontSize',ZmapGlobal.Data.fontsz.s)
    else
        statime=ZG.newt2.Date(1) - par1/365;
        xlabel(['Time in days relative to ',char(statime)],...
            'FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m)
    end
    ylabel('Cumulative Number ','FontSize',ZmapGlobal.Data.fontsz.s)
    
    title(['"', ZG.newt2.Name, '": Cumulative Earthquakes over time ' newline],'Interpreter','none'); %TOFIX I shouldn't need to use a newline here
    ht = gca;
    
    % Make the figure visible
    %
    set(gca,'visible','on','FontSize',ZmapGlobal.Data.fontsz.s,...
        'LineWidth',1.0,'TickDir','out','Ticklength',[0.02 0.02],...
        'Box','on')
    figure_w_normalized_uicontrolunits(cum);
    axes(ht);
    set(cum,'Visible','on');
    watchoff(cum)
    zmap_message_center.clear_message();
    done()
    
end