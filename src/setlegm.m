
% make dialog interface for the fixing of the legend
%


%
global dep1 dep2 dep3 a

report_this_filefun(mfilename('fullpath'));

% TOFIX these global variables are out of sync with the newer method of tracking divisions
switch ZmapGlobal.Data.mainmap_plotby
case 'mag'
    % creates a dialog box to input some parameters
    %
    dep3 = max(ZG.a.Magnitude);
    dep1 = min(ZG.a.Magnitude);
    dep2 = (dep1+dep3)*2/3;
    dep1 = (dep1+dep3)*1/3;

    dlg_title='Legend Magnitude Breaks';
    prompt={'First magnitude division (smallest):','Second magnitude division:','Third magnitude division (largest):'};
    defaultans = {num2str(dep1), num2str(dep2), num2str(dep3)};
    answer = inputdlg(prompt, dlg_title, 1, defaultans);
    if ~isempty(answer)
        for i=1:3
            % convert from string
            answer{i} = str2double(answer{i});
        end
        ZG=ZmapGlobal.Data;ZG.mainmap_plotby='mag'; %redundant?
        dep1=answer{1};
        dep2=answer{2};
        dep3=answer{3};
    else
        welcome;
    end

case 'depth'
    % creates a dialog box to input some parameters
    %
    % divide depths into 3 categories
    dep1 = 0.3*max(ZG.a.Depth);
    dep2 = 0.6*max(ZG.a.Depth);
    dep3 = max(ZG.a.Depth);

    dlg_title='Legend Depth Breaks';
    prompt={'First depth division (shallowest, km):',...
        'Second depth division (km):',...
        'Third magnitude division (deepest, km):'};
    defaultans = {num2str(dep1), num2str(dep2), num2str(dep3)};
    answer = inputdlg(prompt, dlg_title, 1, defaultans);
    if ~isempty(answer)
        for i=1:3
            % convert from string
            answer{i} = str2double(answer{i});
        end
        ZG=ZmapGlobal.Data;ZG.mainmap_plotby='depth'; %redundant?
        dep1=answer{1};
        dep2=answer{2};
        dep3=answer{3};
    else
        welcome;
    end
end
clear answer temp defaultans prompt dlg_title
update(mainmap())



