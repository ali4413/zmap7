function plot_base_events(obj)
    % PLOT_BASE_EVENTS plot all events from catalog as dots before it gets filtered by shapes, etc.
    % call once at beginning
    axm=findobj(obj.fig,'Tag','mainmap_ax');
    if isempty(axm)
        axm=axes('Units','pixels','Position',obj.MapPos_L);
    end
    
    alleq = findobj(obj.fig,'Tag','all events');
    if isempty(alleq)
        alleq=plot(axm, obj.rawcatalog.Longitude, obj.rawcatalog.Latitude,'.','color',[.76 .75 .8],'Tag','all events');
        alleq.ZData=obj.rawcatalog.Depth;
    end
    
    axm.Tag = 'mainmap_ax';
    axm.TickDir='out';
    axm.Box='on';
    axm.ZDir='reverse';
    xlabel(axm,'Longitude')
    ylabel(axm,'Latitude');
    
    MapFeature.foreach(obj.Features,'plot',axm);
    c=uicontextmenu(obj.fig,'Tag','mainmap context');
    % options for choosing a shape
    ShapePolygon.AddPolyMenu(c,obj.shape);
    ShapeCircle.AddCircleMenu(c, obj.shape);
    for j=1:numel(c.Children)
        if startsWith(c.Children(j).Tag,{'circle','poly'})
            c.Children(j).Callback={@updatewrapper,c.Children(j).Callback};
        end
    end
    uimenu(c,'Label','Clear Shape','Callback',{@updatewrapper,@(~,~)cb_shapeclear});
    uimenu(c,'Label','Define X-section','Separator','on','Callback',@(s,v)obj.cb_xsection);
    axm.UIContextMenu=c;
    
    mapoptionmenu=uimenu(obj.fig,'Label','Map Options','Tag','mainmap_menu_overlay');
    uimenu(mapoptionmenu,'Label','Set aspect ratio by latitude',...
        'callback',@toggle_aspectratio,...
        'checked',ZmapGlobal.Data.lock_aspect);
    if strcmp(ZmapGlobal.Data.lock_aspect,'on')
        daspect(axm, [1 cosd(mean(axm.YLim)) 10]);
    end
    
    uimenu(mapoptionmenu,'Label','Toggle Lat/Lon Grid',...
        'callback',@toggle_grid,...
        'checked',ZmapGlobal.Data.mainmap_grid);
    if strcmp(ZmapGlobal.Data.mainmap_grid,'on')
        grid(axm,'on');
    end
    
    function updatewrapper(s,v,f)
        f(s,v);
        obj.shape=copy(ZmapGlobal.Data.selection_shape);
        obj.cb_redraw();
    end
    
    function cb_shapeclear
        ZG=ZmapGlobal.Data;
        ZG.selection_shape=ShapeGeneral('unassigned');
        ZG.selection_shape.clearplot();
    end
    
    function toggle_aspectratio(src, ~)
        src.Checked=toggleOnOff(src.Checked);
        switch src.Checked
            case 'on'
                daspect(axm, [1 cosd(mean(axm.YLim)) 10]);
            case 'off'
                daspect(axm,'auto');
        end
        ZG = ZmapGlobal.Data;
        ZG.lock_aspect = src.Checked;
        %align_supplimentary_legends();
    end
    
    function toggle_grid(src, ~)
        src.Checked=toggleOnOff(src.Checked);
        grid(axm,src.Checked);
        %ZG = ZmapGlobal.Data;
        %ZG.lock_aspect = src.Checked;
        %align_supplimentary_legends();
        drawnow
    end
end