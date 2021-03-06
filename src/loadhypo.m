function loadhypo(choice) 
    % read hypoellipse and other formated  data into a matrix a that can be used
    % in zmap!
    %
    % Stefan Wiemer; 6/95
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    
    report_this_filefun();
    % This is the info window text
    %
    titstr='The Data Input Window                        ';
    hlpStr= ...
        ['                                                '
        ' Allows you to import data into zmap. At this   '
        ' You can either import the data as ASCII colums '
        ' separated by blanks or as hypoellipsee.        '
        ' It is however possible to modify the input     '
        ' parameter such that you can read almost every  '
        ' catalog format! You have to define the position'
        ' of each of the variables (e.g Year:            '
        ' Column 1 to 2). The default values are         '
        ' hypoellipse (first 36 charcters only).         '
        ' You can read more than 36 characters, but it   '
        ' will take longer. It is usefull to cut the     '
        ' hypo datafile at line 36 (UNIX cut -c 1-36 ...)'
        ' You can costumize the file                     '
        ' /src/loadhypo.m and create a new input variable'
        ' file similar to hypo_de.m. See the Users Guide '
        ' for more details.                              '
        ' To load an ASCII file seperated by blanks      '
        ' switch the popup Menu FORMAT to ASCII COLUMNS. '];
    
    if choice=='hypo_de'
        % initialize a bunch of variables
        
        nu = 36;
        y1 = 1;
        y2 = 2;
        mo1 = 3;
        mo2 = 4;
        da1 = 5;
        da2 = 6;
        hr1 = 7;
        hr2 = 8;
        mi1 = 9;
        mi2 = 10;
        la1 = 15;
        la2 = 16;
        no = 17;
        we = 25;
        lo1 = 22;
        lo2 = 24;
        lm1 = 18;
        lm2 = 21;
        lmc = 10000;
        ln1 = 26;
        ln2 = 29;
        lnc = 10000;
        de1 = 30;
        de2 = 34;
        cde = 100;
        ma1 = 35;
        ma2 = 36;
        mac = 10;
        
        choice = 'initf';
    end
    
    if choice == 'initf'
        
        
        % add a new label to the list
        labelList=['Hypoellipse | Ascii columns'];
        
        % add a new option for your own data file format like that
        % if in2 = 3
        % myfor_de     % this read the parameter from the file myfor_de.m
        % end
        
        
        if in2 == 1
            hypo_de
        end
        if in2 == 2
            close;
            loadasci('earthquakes','of');
            return
        end
        
        % set up the figure
        lohy=findobj('Type','Figure','-and','Name','Data Input');
        
        
        % Set up the window Enviroment
        %
        if isempty(lohy)
            
            lohy = figure_w_normalized_uicontrolunits(...
                'Units','centimeter','pos',[0 0 18 16],...
                'Name','Data Input',...
                'visible','on',...
                'NumberTitle','off',...
                'Color',color_fbg,...
                'NextPlot','add');
            axis off
        end  % if figure exist
        
        figure(lohy);
        clf
        
        uicontrol('BackGroundColor',[0.9 0.9 0.9],'Style','Frame',...
            'Position',[0.6 1.5   17  12.5],...
            'Units','centimeter');
        
        uicontrol('Style','text',...
            'Position',[1 15.0   3  0.8],...
            'Units','centimeter','String','Format:');
        
        fmtList=['Hypoellipse | Ascii columns'];
        labelPos = [6 15.0 3 0.8];
        hFmts=uicontrol(...
            'Style','popup',...
            'Units','centimeter',...
            'Position',labelPos,...
            'String',fmtList,...
            'callback',@callbackfun_001);
        
        labelList2=['Lat/Lon in minutes | Lat/Lon in decimals (0-99)'];
        labelPos2 = [11 11.0 6 0.8];
        hndl2=uicontrol(...
            'Style','popup',...
            'Units','centimeter',...
            'Position',labelPos2,...
            'String',labelList2,...
            'BackgroundColor','y');
        
        uicontrol('Style','text',...
            'Position',[11 15.0   4  0.8],...
            'Units','centimeter','String','No. of Characters:');
        
        uicontrol('BackGroundColor',color_fbg ,'Style','text',...
            'Position',[1 14   3  0.8],...
            'Units','centimeter','String','Parameter:');
        
        uicontrol('BackGroundColor',color_fbg ,'Style','text',...
            'Position',[5 14   4  0.8],...
            'Units','centimeter','String','Column No ? to ?');
        
        uicontrol('BackGroundColor',color_fbg ,'Style','text',...
            'Position',[10 14   2  0.8],...
            'Units','centimeter','String','Divide by:');
        
        
        inpnu=uicontrol('Style','edit',...
            'Position',[16 15.0   1  0.8],...
            'Units','centimeter','String',num2str(nu),...
            'callback',@callbackfun_002);
        
        h1 = 13;
        inpy1=uicontrol('Style','edit',...
            'Position',[6 h1   1  0.8],...
            'Units','centimeter','String',num2str(y1),...
            'callback',@callbackfun_003);
        
        inpy2=uicontrol('Style','edit',...
            'Position',[8 h1   1  0.8],...
            'Units','centimeter','String',num2str(y2),...
            'callback',@callbackfun_004);
        
        uicontrol('Style','text',...
            'Position',[1 h1   3  0.8],...
            'Units','centimeter','String','Year');
        
        h2 = 12;
        inpmo1=uicontrol('Style','edit',...
            'Position',[6 h2   1  0.8],...
            'Units','centimeter','String',num2str(mo1),...
            'callback',@callbackfun_005);
        
        inpmo2=uicontrol('Style','edit',...
            'Position',[8 h2   1  0.8],...
            'Units','centimeter','String',num2str(mo2),...
            'callback',@callbackfun_006);
        
        uicontrol('Style','text',...
            'Position',[1 h2   3  0.8],...
            'Units','centimeter','String','Month');
        
        h3 = 11;
        inpda1=uicontrol('Style','edit',...
            'Position',[6 h3   1  0.8],...
            'Units','centimeter','String',num2str(da1),...
            'callback',@callbackfun_007);
        
        inpda2=uicontrol('Style','edit',...
            'Position',[8 h3   1  0.8],...
            'Units','centimeter','String',num2str(da2),...
            'callback',@callbackfun_008);
        
        uicontrol('Style','text',...
            'Position',[1 h3   3  0.8],...
            'Units','centimeter','String','Day');
        
        h4 = 10;
        inphr1=uicontrol('Style','edit',...
            'Position',[6 h4   1  0.8],...
            'Units','centimeter','String',num2str(hr1),...
            'callback',@callbackfun_009);
        
        inphr2=uicontrol('Style','edit',...
            'Position',[8 h4   1  0.8],...
            'Units','centimeter','String',num2str(hr2),...
            'callback',@callbackfun_010);
        
        uicontrol('Style','text',...
            'Position',[1 h4   3  0.8],...
            'Units','centimeter','String','Hour');
        h4 = 9;
        inpmi1=uicontrol('Style','edit',...
            'Position',[6 h4   1  0.8],...
            'Units','centimeter','String',num2str(mi1),...
            'callback',@callbackfun_011);
        
        inpmi2=uicontrol('Style','edit',...
            'Position',[8 h4   1  0.8],...
            'Units','centimeter','String',num2str(mi2),...
            'callback',@callbackfun_012);
        
        uicontrol('Style','text',...
            'Position',[1 h4   3  0.8],...
            'Units','centimeter','String','Minute');
        
        
        h4 = 8;
        inpla1=uicontrol('Style','edit',...
            'Position',[6 h4   1  0.8],...
            'Units','centimeter','String',num2str(la1),...
            'callback',@callbackfun_013);
        
        inpla2=uicontrol('Style','edit',...
            'Position',[8 h4   1  0.8],...
            'Units','centimeter','String',num2str(la2),...
            'callback',@callbackfun_014);
        
        uicontrol('Style','text',...
            'Position',[1 h4   3  0.8],...
            'Units','centimeter','String','Latitude');
        
        h4 = 7;
        inplm1=uicontrol('Style','edit',...
            'Position',[6 h4   1  0.8],...
            'Units','centimeter','String',num2str(lm1),...
            'callback',@callbackfun_015);
        
        inplm2=uicontrol('Style','edit',...
            'Position',[8 h4   1  0.8],...
            'Units','centimeter','String',num2str(lm2),...
            'callback',@callbackfun_016);
        inplmc=uicontrol('Style','edit',...
            'Position',[10 h4   1.5  0.8],...
            'Units','centimeter','String',num2str(lmc),...
            'callback',@callbackfun_017);
        
        uicontrol('Style','text',...
            'Position',[1 h4   3  0.8],...
            'Units','centimeter','String','Lat minute');
        
        h4 = 6;
        inplo1=uicontrol('Style','edit',...
            'Position',[6 h4   1  0.8],...
            'Units','centimeter','String',num2str(lo1),...
            'callback',@callbackfun_018);
        
        inplo2=uicontrol('Style','edit',...
            'Position',[8 h4   1  0.8],...
            'Units','centimeter','String',num2str(lo2),...
            'callback',@callbackfun_019);
        
        uicontrol('Style','text',...
            'Position',[1 h4   3  0.8],...
            'Units','centimeter','String','Longitude');
        
        h4 = 5;
        inpln1=uicontrol('Style','edit',...
            'Position',[6 h4   1  0.8],...
            'Units','centimeter','String',num2str(ln1),...
            'callback',@callbackfun_020);
        
        inpln2=uicontrol('Style','edit',...
            'Position',[8 h4   1  0.8],...
            'Units','centimeter','String',num2str(ln2),...
            'callback',@callbackfun_021);
        
        inplnc=uicontrol('Style','edit',...
            'Position',[10 h4   1.5  0.8],...
            'Units','centimeter','String',num2str(lnc),...
            'callback',@callbackfun_022);
        
        uicontrol('Style','text',...
            'Position',[1 h4   3  0.8],...
            'Units','centimeter','String','Long minute');
        
        h4 = 4;
        inpde1=uicontrol('Style','edit',...
            'Position',[6 h4   1  0.8],...
            'Units','centimeter','String',num2str(de1),...
            'callback',@callbackfun_023);
        
        inpde2=uicontrol('Style','edit',...
            'Position',[8 h4   1  0.8],...
            'Units','centimeter','String',num2str(de2),...
            'callback',@callbackfun_024);
        
        inpdec=uicontrol('Style','edit',...
            'Position',[10 h4   1.5  0.8],...
            'Units','centimeter','String',num2str(cde),...
            'callback',@callbackfun_025);
        
        uicontrol('Style','text',...
            'Position',[1 h4   3  0.8],...
            'Units','centimeter','String','Depth');
        
        h4 = 3;
        inpma1=uicontrol('Style','edit',...
            'Position',[6 h4   1  0.8],...
            'Units','centimeter','String',num2str(ma1),...
            'callback',@callbackfun_026);
        
        inpma2=uicontrol('Style','edit',...
            'Position',[8 h4   1  0.8],...
            'Units','centimeter','String',num2str(ma2),...
            'callback',@callbackfun_027);
        inpmac=uicontrol('Style','edit',...
            'Position',[10 h4   1.5  0.8],...
            'Units','centimeter','String',num2str(mac),...
            'callback',@callbackfun_028);
        
        uicontrol('Style','text',...
            'Position',[1 h4   3  0.8],...
            'Units','centimeter','String','Magnitude');
        
        
        h4 = 13;
        inplaC1=uicontrol('Style','edit',...
            'Position',[16 h4   1  0.8],...
            'Units','centimeter','String',num2str(no),...
            'callback',@callbackfun_029);
        
        uicontrol('Style','text',...
            'Position',[11 h4   3  0.8],...
            'Units','centimeter','String','Latitude N/S');
        
        h4 = 12;
        inplaC2=uicontrol('Style','edit',...
            'Position',[16 h4   1  0.8],...
            'Units','centimeter','String',num2str(we),...
            'callback',@callbackfun_030);
        
        uicontrol('Style','text',...
            'Position',[11 h4   3  0.8],...
            'Units','centimeter','String','Longitude E/W');
        
        
        uicontrol('Style','Pushbutton',...
            'Position',[3 0.2 1.5 1         ],...
            'Units','centimeter',...
            'callback',@callbackfun_031,...
            'String','Go');
        
        uicontrol('Style','Pushbutton',...
            'Position',[ 5 0.2 1.5 1        ],...
            'Units','centimeter',...
            'callback',@callbackfun_032,...
            'String','Info');
        
        uicontrol('Style','Pushbutton',...
            'Position',[ 8 0.2 1.5 1        ],...
            'Units','centimeter',...
            'callback',@callbackfun_033,...
            'String','Close');
        
    end
    
    if choice == 'readd'
        
        % read the data file
        
        [file1,path1] = uigetfile(fullfile(ZmapGlobal.Data.Directories.data ,'*'),' Earthquake Datafile');
        if length(file1) < 2
            return
        end
        % read the first three lines as a test...
        fid = fopen([path1 file1],'r');
        msg.infodisp('Loading data...hang on',' ');
        so = fscanf(fid,'%c',[nu+1, inf]);
        fclose(fid);
        so = so';
        disp('First Three rows - does it look right?')
        so(1:3,:)
        
        
        n = max([y1,y2,mi1,mi1,mo1,mo2,da1,da2,de1,de1,ma1,ma2,hr1,hr2,lo1,lo2,la1,la2,lm1,lm2,ln1,ln2]);
        for  i = 1:n
            so(:,i) = strrep(so(:,i)',' ','0')';
        end
        
        yr = str2double(so(:,y1:y2));
        mo = str2double(so(:,mo1:mo2));
        da = str2double(so(:,da1:da2));
        hr = str2double(so(:,hr1:hr2));
        mi= str2double(so(:,mi1:mi2));
        lat= str2double(so(:,la1:la2));
        l = so(:,no) == 'S';
        lat(l) = -lat(l);
        lon= str2double(so(:,lo1:lo2));
        l = so(:,we) == 'W';
        lon(l) = -lon(l);
        latm= str2num(so(:,lm1:lm2))/lmc;
        lonm= str2num(so(:,ln1:ln2))/lnc;
        lonm(l) = -lonm(l);
        dep= str2num(so(:,de1:de2))/cde;
        mag= str2num(so(:,ma1:ma2))/mac;
        
        if get(hndl2,'Value') == 1
            latm = latm*10/6;
            lonm = lonm*10/6;
        end
        
        a = [lon+lonm lat+latm yr mo da mag dep hr mi];
        
        % eliminate zero events
        l = ZG.primeCatalog.Date.Month == 0 | ZG.primeCatalog.Longitude ==0 | ZG.primeCatalog.Latitude ==0;
        a(l,:) = [];
        
        if length(a(1,:))== 7
            ZG.primeCatalog.Date = decyear(a(:,3:5));
        elseif length(a(1,:))==9       %if catalog includes hr and minutes
            ZG.primeCatalog.Date = decyear(a(:,[3:5 8 9]));
        end
        a = ZmapCatalog.from(a);
        ZG.primeCatalog.sort('Date');
        
        ZG.CatalogOpts.BigEvents.MinMag = max(ZG.primeCatalog.Magnitude) -0.2;       %  as a default
        
        %  ask for input parameters
        %
        watchoff
        close(lohy)
        clear so is yr da mag dep hr mi lat latm lon lonm mo
        ZG=ZmapGlobal.Data;
        ZG.mainmap_plotby='depth';
        do = 'view';
        mycat=ZG.primeCatalog; % points to same thing!
        app = range_selector(mycat);
        waitfor(app);
        ZG.maepi=mycat.subset(mycat.Magnitude >=ZG.CatalogOpts.BigEvents.MinMag);
    end
    
    function callbackfun_001(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        in2=hFmts.Value;
        loadhypo('initfun',in2);
    end
    
    function callbackfun_002(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        nu=str2double(inpnu.String);
        inpnu.String=num2str(nu);
    end
    
    function callbackfun_003(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        y1=str2double(inpy1.String);
        inpy1.String=num2str(y1);
    end
    
    function callbackfun_004(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        y2=str2double(inpy2.String);
        inpy2.String=num2str(y2);
    end
    
    function callbackfun_005(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        mo1=str2double(get(inpmo1,'String'));
        set(inpmo1,'String',num2str(mo1));
    end
    
    function callbackfun_006(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        mo2=str2double(inpmo2.String);
        inpmo2.String=num2str(mo2);
    end
    
    function callbackfun_007(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        da1=str2double(get(inpda1,'String'));
        set(inpda1,'String',num2str(da1));
    end
    
    function callbackfun_008(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        da2=str2double(inpda2.String);
        inpda2.String=num2str(da2);
    end
    
    function callbackfun_009(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        hr1=str2double(get(inphr1,'String'));
        set(inphr1,'String',num2str(hr1));
    end
    
    function callbackfun_010(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        hr2=str2double(inphr2.String);
        inphr2.String=num2str(hr2);
    end
    
    function callbackfun_011(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        mi1=str2double(get(inpmi1,'String'));
        set(inpmi1,'String',num2str(mi1));
    end
    
    function callbackfun_012(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        mi2=str2double(inpmi2.String);
        inpmi2.String=num2str(mi2);
    end
    
    function callbackfun_013(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        la1=str2double(get(inpla1,'String'));
        set(inpla1,'String',num2str(la1));
    end
    
    function callbackfun_014(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        la2=str2double(inpla2.String);
        inpla2.String=num2str(la2);
    end
    
    function callbackfun_015(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        lm1=str2double(get(inplm1,'String'));
        set(inplm1,'String',num2str(lm1));
    end
    
    function callbackfun_016(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        lm2=str2double(inplm2.String);
        inplm2.String=num2str(lm2);
    end
    
    function callbackfun_017(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        lmc=str2double(inplmc.String);
        inplmc.String=num2str(lmc);
    end
    
    function callbackfun_018(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        lo1=str2double(get(inplo1,'String'));
        set(inplo1,'String',num2str(lo1));
    end
    
    function callbackfun_019(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        lo2=str2double(inplo2.String);
        inplo2.String=num2str(lo2);
    end
    
    function callbackfun_020(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        ln1=str2double(get(inpln1,'String'));
        set(inpln1,'String',num2str(ln1));
    end
    
    function callbackfun_021(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        ln2=str2double(inpln2.String);
        inpln2.String=num2str(ln2);
    end
    
    function callbackfun_022(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        lnc=str2double(inplnc.String);
        inplnc.String=num2str(lnc);
    end
    
    function callbackfun_023(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        de1=str2double(get(inpde1,'String'));
        set(inpde1,'String',num2str(de1));
    end
    
    function callbackfun_024(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        de2=str2double(inpde2.String);
        inpde2.String=num2str(de2);
    end
    
    function callbackfun_025(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        cde=str2double(inpdec.String);
        inpdec.String=num2str(cde);
    end
    
    function callbackfun_026(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        ma1=str2double(get(inpma1,'String'));
        set(inpma1,'String',num2str(ma1));
    end
    
    function callbackfun_027(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        ma2=str2double(inpma2.String);
        inpma2.String=num2str(ma2);
    end
    
    function callbackfun_028(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        mac=str2double(inpmac.String);
        inpmac.String=num2str(mac);
    end
    
    function callbackfun_029(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        no=str2double(get(inplaC1,'String'));
        set(inplaC1,'String',num2str(no));
    end
    
    function callbackfun_030(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        we=str2double(get(inplaC2,'String'));
        set(inplaC2,'String',num2str(we));
    end
    
    function callbackfun_031(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        
        loadhypo('readd');
    end
    
    function callbackfun_032(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        zmaphelp(titstr,hlpStr);
    end
    
    function callbackfun_033(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        close;
        
    end
    
    
end
