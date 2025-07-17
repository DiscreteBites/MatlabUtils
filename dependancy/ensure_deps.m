function result = ensure_deps()
    disp('[ml.startup] Checking dependancies are installed...');
    
    % List required add-ons by display name
    requiredAddons = {
        'Signal Processing Toolbox'
        'Audio Toolbox'
    };
    
    % Check installed add-ons
    installed = matlab.addons.installedAddons;
    missing = {};
    
    for i = 1:length(requiredAddons)
        addonName = requiredAddons{i};
        if ~any(strcmp(installed.Name, addonName))
            missing{end+1} = addonName; %#ok<AGROW>
        end
    end
    
    if isempty(missing)
        disp('[ml.startup] All required add-ons are installed');
        result = 0;
    else
        msg = sprintf('The following required add-ons are missing:\n\n%s\n\nPlease open Add-On Explorer manually (Home → Add-Ons → Get Add-Ons), search for them, and install.', ...
            strjoin(missing, '\n'));
        
        fprintf('[ml.startup] %s\n', msg);
        if usejava('desktop') && feature('ShowFigureWindows')
            uiwait(msgbox(msg, 'Missing Add-Ons', 'warn'));
        else
            warning('[ml.startup] Missing Add-Ons, project may behave unexpectedly');
        end

        result = 1;
    end
end