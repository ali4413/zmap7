classdef ZmapData < handle
    % ZmapData contains the values used globally in zmap
    % access the data via its handle, accessible via ZmapGlobal.Data
    %
    % h = ZmapGlobal.Data;          % get pointer to all the global data
    %
    % catalogcopy = h.catalog;      % get a particlar item
    % h.catalog = modified_catalog; % set the item, changes visible EVERYWHERE
    % 
    properties(Constant)
        zmap_version = '7.0'
        min_matlab_version = '9.2';
        min_matlab_release = '2017a';
        hodi = fileparts(which('zmap')); % zmap home directory
        torad  = pi / 180;
        Re = 6378.137; % radius of earth, km
        
        % positional
        fipo = get(groot,'ScreenSize') - [ 0 0 0 150];
        welcome_pos = [80, ZmapData.fipo(4) - 380]; %wex wey
        welcome_len = [340 300]; %welx, wely
        map_len = [750 650]; % winx winy
    end
    
    properties
        % catalogs
        a %
        newcat
        newt2
        %catalog % overall catalog of earthquakes
        catalog_working 
        memorized_catalogs % manually stored via Memorize/Recall
        storedcat % automatically stored catalog, used by synthetic catalogs, etc.
        
        %{
        % layers
        features=struct('volcanoes',load_volcanoes(),...
            'plates',load_plates(),...
            'coastline',load_coast('i'),...
            'faults',load_faults(),...
            'borders',load_borders('i'),...
            'rivers',load_rivers('i'),...
            'lakes',load_lakes('i'));
        %}
        %volcanoes % was vo
        %coastline % 
        features = get_features('h');
        %mainfault % fault locations
        %faults % fault locations
        well % well locations
        %plates % plate locations
        %rivers
        %lakes
        %borders % national borders
        main
        maepi % large earthquakes, determined by user cutoff
        
        % divisions
        divisions_depth
        divisions_time
        divisions_magnitude
        
        % niceties
        fontsz = FontSizeTracker;
        depth_divisions % plot each division with a different color/symbol
        magnitude_divisions % plot each division with a different color/symbol
        time_divisions % plot each division with a different color/symbol
        color_bg = [1 1 1] % was [cb1 cb2 cb3] axis background
        color_fg = [.9 .9 .9]% was [c1 c2 c3] figure backgorund
        ms6 = 6 % standard markersize %TODO change to a markersize class
        big_eq_minmag = 8  % events of this magnitude or higher are plotted & labeled
        lock_aspect = 'off';
        mainmap_grid = 'on';
        mainmap_plotby = 'depth'; % was typele
        
        % statistical stuff
        teb % time end earthquakes
        t0b % time begin earthquakes
        
        % likely to be completely removed stuff
        hold_state % was ho, contained 'hold' or 'noho'
        hold_state2 % was ho2, contained 'hold' or 'noho'
        hold_state3 % was hoc, contained 'hold' or 'noho'
        
        % directories
        out_dir % was hodo
        data_dir % was hoda
        
        
    end
    
end

function out = get_features(level)
    % imports the various features that can be
    out = containers.Map;
    
    
            % each MapFeature is something that can be overlain on the main map
            %
            out('coastline')= MapFeature('coast', @()load_coast(level), [],...
                struct('Tag','mainmap_coastline',...
                'DisplayName', 'Coastline',...
                'HitTest','off','PickableParts','none',...
                'LineWidth',1.0,...
                'Color',[0.1 0.1 0.1])...
                );
            out('borders')= MapFeature('borders', @()load_borders(level), [],...
                struct('Tag','mainmap_borders',...
                'DisplayName', 'Borders',...
                'HitTest','off','PickableParts','none',...
                'LineWidth',1.0,...
                'Color',[0.1 0.1 0.1])...
                );
            out('lakes')=MapFeature('lakes', @() load_lakes(level), [],...
                struct('Tag','mainmap_lakes',...
                'DisplayName', 'Lakes',...
                'HitTest','off','PickableParts','none',...
                'LineWidth',0.5,...
                'Color',[0.3 0.3 .8])...
                );
            out('rivers')=MapFeature('rivers', @() load_rivers(level), [],...
                struct('Tag','mainmap_rivers',...
                'DisplayName', 'Rivers',...
                'HitTest','off','PickableParts','none',...
                'LineWidth',0.5,...
                'Color',[0.7 0.7 1])...
                );
            out('volcanoes')= MapFeature('volcanoes', @load_volcanoes, [],...
                struct('Tag','mainmap_volcanoes',...
                'Marker','^',...
                'DisplayName','Volcanoes',...
                'LineWidth', 1.5,...
                'MarkerSize', 6,...
                'LineStyle','none',...
                'MarkerFaceColor','w',...
                'MarkerEdgeColor','r')...
                );
            
            out('plates') = MapFeature('plates', @load_plates, [],...
                struct('Tag','mainmap_plates',...
                'DisplayName','plate boundaries',...
                'LineWidth', 3.0,...
                'Color',[.2 .2 .5])...
                );
            
            out('faults') = MapFeature('faults', @load_faults, [],...
                struct('Tag','mainmap_faultlines',...
                    'DisplayName','main faultine',...
                    'LineWidth', 3.0,...
                    'Color','b')...
                );
            %{
            obj.Features(5) = MapFeature('wells', @load_wells, [],...
                struct('Tag','mainmap_wells',...
                    'DisplayName','Wells',...
                    'Marker','d',...
                    'LineWidth',1.5,...
                    'MarkerSize',6,...
                    'LineStyle','none',...
                    'MarkerFaceColor','k',...
                    'MarkerEdgeColor','k')...
                );            
            obj.Features(6) = MapFeature('minor_faults', @load_minorfaults, [],...
                struct('Tag','mainmap_faults',...
                    'DisplayName','faults',...
                    'LineWidth',0.2,...
                    'Color','k')...
                );
                
                %}
    %{
            features=struct('volcanoes',load_volcanoes(),...
            'plates',load_plates(),...
            'coastline',load_coast('i'),...
            'faults',load_faults(),...
            'borders',load_borders('i'),...
            'rivers',load_rivers('i'),...
            'lakes',load_lakes('i'));
        %}
end