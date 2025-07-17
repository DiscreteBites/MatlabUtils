function root = get_project_root()
    try
        proj = matlab.project.rootProject;
        root = proj.RootFolder;
    catch
        % Fallback if not in a .prj project
        root = fileparts(mfilename('fullpath'));
    end
end