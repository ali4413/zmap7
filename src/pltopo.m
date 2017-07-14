% This plot a DEM map plus eq on top...

report_this_filefun(mfilename('fullpath'));
ZG=ZmapGlobal.Data;

switch(plt)

    case 'lo3'

        try
            l  = get(h1,'XLim');
        catch
            update(mainmap())
            pltopo
        end

        s1 = l(2); s2 = l(1);
        l  = get(h1,'YLim');
        s3 = l(2); s4 = l(1);
        fac = 1;

        def = {'3'};
        ni2 = inputdlg('Decimation factor for DEM data?','Input',1,def);
        l = ni2{:};
        fac = str2double(l);

        do = ['cd  ' ZG.hodi];  eval(do);

        if ~exist('pathdem', 'var')
            if exist('dem','dir')
                pathdem = fullfile(ZG.hodi, 'dem');
            else
                [file1,pathdem] = uigetfile([ '*.mat'],'Directory containing dem data? (select any file)');
            end
        end
        cd(pathdem)


        usgsdems( [s4 s3],[ s2 s1])

        [file1,path1] = uigetfile([ '*'],' Which USGS 3 arc sec data DEM ?');

        try
            [tmap, tmapleg] = usgsdem([path1 file1],fac,[s4 s3],[ s2 s1]);
        catch ME
            handle_error(ME,@do_nothing);
            plt = 'err2';
            pltopo
        end

        my = s4:1/tmapleg(1):s3+0.1;
        mx = s2:1/tmapleg(1):s1+0.1;
        [m,n] = size(tmap);
        toflag = '5';
        plt = 'plo'; pltopo;


    case 'lo30'

        try
            l  = get(h1,'XLim');
        catch
            update(mainmap())
            pltopo
        end

        s1 = l(2); s2 = l(1);
        l  = get(h1,'YLim');
        s3 = l(2); s4 = l(1);
        fac = 1;
        if abs(s4-s3) > 10 | abs(s1-s2) > 10 
            def = {'3'};
            ni2 = inputdlg('Decimation factor for DEM data?','Input',1,def);
            l = ni2{:};
            fac = str2double(l);
        end
        [tmap, tmapleg] = gtopo302(fullfile(ZG.hodi, 'dem', 'gtopo30'),fac,[s4 s3],[s2 s1]);
        cd(ZG.hodi)
        my = s4:1/tmapleg(1):s3+0.1;
        mx = s2:1/tmapleg(1):s1+0.1;
        vlon = mx;
        vlat = my;
        [m,n] = size(tmap);
        toflag = '5';
        plt = 'plo'; pltopo;

    case 'lo5'

        try
            l  = get(h1,'XLim');
        catch
            update(mainmap())
            pltopo
        end

        s1 = l(2); s2 = l(1);
        l  = get(h1,'YLim');
        s3 = l(2); s4 = l(1);
        fac = 1;
        if abs(s4-s3) > 10 | abs(s1-s2) > 10 
            def = {'3'};
            ni2 = inputdlg('Decimation factor for DEM data?','Input',1,def);
            l = ni2{:};
            fac = str2double(l);
        end

        if ~exist('tbase.bin', 'var');  plt = 'err';
            pltopo
        else

            try
                [tmap, tmapleg] = tbase(fac,[s4 s3],[ s2 s1]);
            catch ME
                handle_error(ME,@do_nothing);
                plt = 'err30';
                pltopo
            end
        end

        my = s4:1/tmapleg(1):s3+0.1;
        mx = s2:1/tmapleg(1):s1+0.1;
        [m,n] = size(tmap);
        toflag = '5';
        plt = 'plo'; pltopo;


    case 'lo2'


        if ~exist('topo_6.2.img', 'var')
            helpdlg('You do not have the topo_6.2.img database in your search path. It should be in the ./dem directory. If you have a later version of topo, please rename it to topo_6.2.img ','Error')
            return
        end

        try
            l  = get(h1,'XLim');
        catch
            update(mainmap())
            pltopo
        end


        s1 = l(2); s2 = l(1);
        l  = get(h1,'YLim');
        s3 = l(2); s4 = l(1);
        region = [s4 s3 s2 s1];

        do = ['  [tmap,vlat,vlon] = mygrid_sand(region);'];
        % end
        toflag = '2';
        eval(do);

        plt = 'plo2'; pltopo;

    case 'lo1'


        try
            l  = get(h1,'XLim');
        catch
            update(mainmap())
            pltopo
        end

        do = ['cd  ' ZG.hodi]; ; eval(do);
        if ~exist('pathdem', 'var')
            if exist('dem','dir')
                pathdem = fullfile(ZG.hodi, 'dem');
            else
                [file1,pathdem] = uigetfile([ '*.mat'],'Directory containing dem data? (select any file)');
            end
        end
        cd(pathdem)


        s1 = l(2); s2 = l(1);
        l  = get(h1,'YLim');
        s3 = l(2); s4 = l(1);
        fac = 1;
        if abs(s4-s3) > 4 | abs(s1-s2) > 4 
            def = {'3'};
            ni2 = inputdlg('Decimation factor for GLOBE DEM data?','Input',1,def);
            l = ni2{:};
            fac = str2double(l);
        end

        fname = globedems([s4 s3],[ s2 s1]);

        try
            [tmap, tmapleg] = globedem(fname{1},fac,[s4 s3],[ s2 s1]);
        catch ME
            handle_error(ME,@do_nothing);
        end

        my = s4:1/tmapleg(1):s3+0.1;
        mx = s2:1/tmapleg(1):s1+0.1;
        [m,n] = size(tmap);
        toflag = '3';
        plt = 'plo'; pltopo;

    case 'yourdem'

        try
            l  = get(h1,'XLim');
        catch
            update(mainmap())
            pltopo
        end

        s1 = l(2); s2 = l(1);
        l  = get(h1,'YLim');
        s3 = l(2); s4 = l(1);
        region = [s4 s3 s2 s1];

        % is mydem defined?
        if ~exist('mydem', 'var'); plt = 'loadmydem'; pltopo ; end
        % cut the data
        if exist('butt', 'var'); 
            if butt(1) == 'C' || butt(1) == 'H';
                return;
            end
        end
        l2 = min(find(mx >= s2));
        l1 = max(find(mx <= s1));
        l3 = max(find(my <= s3));
        l4 = min(find(my >= s4));

        toflag = '1';


        tmap = mydem(l4:l3,l2:l1);
        vlat = my(l4:l3);
        vlon = mx(l2:l1);

        [m,n] = size(tmap);
        emydem = 'y';
        plt = 'ploy'; pltopo;



    case 'plo'

        [existFlag,figNumber]=figure_exists('Topographic Map',1);

        if existFlag == 0;  ac3 = 'new'; overtopo;   end
        if existFlag == 1
            figure_w_normalized_uicontrolunits(to1)
            delete(gca); delete(gca);delete(gca)
        end

        hold on; axis off

        axes('position',[0.13,  0.13, 0.65, 0.7]);
        pcolor(mx(1:n),my(1:m),tmap); shading flat
        demcmap(tmap);
        hold on
        h1topo = gca;
        set(gca,'color',[ 0.341 0.776 1.000 ]')
        %whitebg(gcf,[0 0 0]);

        set(gca,'FontSize',12,'FontWeight','bold','TickDir','out','Ticklength',[0.02 0.02])
        set(gcf,'Color','w','InvertHardcopy','off')
        set(gcf,'renderer','zbuffer')
        set(gca,'dataaspect',[1 cosd(nanmean(ZG.a.Latitude)) 1])


    case 'plo2'
        [existFlag,figNumber]=figure_exists('Topographic Map',1);

        if existFlag == 0;  ac3 = 'new'; overtopo;   end
        if existFlag == 1
            figure_w_normalized_uicontrolunits(to1)
            delete(gca); delete(gca);delete(gca)
        end

        hold on; axis off

        axes('position',[0.13,  0.13, 0.65, 0.7]);
        if max(vlon) > 180; vlon = vlon - 360; end

        tmapleg = [30 max(vlat) min(vlon)];

        [xx,yy]=meshgrid(vlon,vlat);
        pcolor(xx,yy,tmap),shading flat;
        demcmap(tmap, 256);hold on


        %whitebg(gcf,[0 0 0]);
        set(gca,'FontSize',12,'FontWeight','bold','TickDir','out','Ticklength',[0.02 0.02])
        set(gcf,'Color','w','InvertHardcopy','off')
        xlabel('Longitude'),ylabel('Latitude')
        set(gcf,'renderer','zbuffer')
        set(gca,'dataaspect',[1 cosd(mean(ZG.a.Latitude)) 1])


    case 'ploy'
        [existFlag,figNumber]=figure_exists('Topographic Map',1);
        if existFlag == 0;  ac3 = 'new'; overtopo;   end
        if existFlag == 1
            figure_w_normalized_uicontrolunits(to1)
            delete(gca); delete(gca);delete(gca)
        end

        hold on; axis off

        axes('position',[0.13,  0.13, 0.65, 0.7]);
        pcolor(vlon,vlat,tmap); shading flat
        demcmap(tmap);
        hold on

        %whitebg(gcf,[0 0 0]);

        set(gca,'FontSize',12,'FontWeight','bold','TickDir','out','Ticklength',[0.02 0.02])
        set(gcf,'Color','w','InvertHardcopy','off')
        axis([ s2 s1 s4 s3])
        set(gcf,'renderer','zbuffer')
        set(gca,'dataaspect',[1 cosd(mean(ZG.a.Latitude)) 1])


    case 'err'  % Tbase data not found

        butt =    questdlg('Please define the path to your Terrain base 5 min DEM (tbase.bin) data', ...
            'DEM data not found!', ...
            'OK','Help','Cancel','Cancel');

        switch butt
            case 'OK'

                [file1,path1] = uigetfile([ '*.bin'],' Terrain base global 5 min grid path (tbase.bin)');

                if length(path1) < 2
                    zmap_message_center.clear_message();;done
                    return
                else
                    addpath([path1]);
                    plt = 'lo5'; pltopo;
                end
            case 'Help'
                do = [ 'web ' fullfile(ZG.hodi , 'help','plottopo.htm'),' ;' ];
                err=['errordlg('' Error while opening, please open the browser first and try again or open the file ./help/topo.hmt manually'');'];
                eval(do,err)

            case 'Cancel'
                zmap_message_center(); return

        end %swith butt

    case 'err2'  % Tbase data not found
        [file1,path1] = uigetfile([ '*.img'],' Please define the path to the file topo_6.2.img (2 min DEM)');

        if length(path1) < 2
            zmap_message_center.clear_message();;done
            return
        else
            addpath([path1]);
            plt = 'lo2'; pltopo;
        end

        %errordlg('Error loading data - sorry');

    case 'err30'  % Tbase data not found
        helpdlg(['The right GTOPO30 file could not be found - is it in the dem/gtopo30 directory?']);
        return


    case 'genhelp'  % Tbase data not found
        showweb('topo');
    case 'loadmydem'  % load mydem

        butt =    questdlg('Please load a *.mat file containing the DEM data in 2D matrix mydem, and the lat/long vextors my and mx', ...
            'DEM data not found! Load mydem ', ...
            'OK','Help','Cancel','Cancel');

        switch butt
            case 'OK'
                [file1,path1] = uigetfile([ '*.mat'],'File containing  mydem, mx, my ');
                if length(path1) < 2
                    zmap_message_center.clear_message();;done
                    return
                else
                    lopa = [path1 file1];
                    do = ['load(lopa)']; eval(do);
                    plt = 'yourdem'; pltopo;
                end
            case 'Help'
                plt = 'genhelp'; pltopo; return; return;

            case 'Cancel'
                zmap_message_center(); return; return; return

        end %swith butt

end  %



