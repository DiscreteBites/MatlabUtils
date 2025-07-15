function paths = get_paths(force_refresh)
    if nargin < 1
        force_refresh = false;
    end

    persistent cached_paths

    if isempty(cached_paths) || force_refresh
        project_root = get_project_root();
        env = load_env('.env');

        % Absolute path (do not join with root)
        paths.timit = env.TIMIT_PATH;
        
        % Relative paths
        paths.root = project_root;
        paths.xp = fullfile(project_root, env.XP_PATH);
        paths.electrodogram_output = fullfile(project_root, env.ELECTRODOGRAM_OUTPUT_PATH);
        paths.neurogram_output = fullfile(project_root, env.NEUROGRAM_OUTPUT_PATH);
        paths.complete_output = fullfile(project_root, env.COMPLETE_OUTPUT_PATH);

        cached_paths = paths;
    end

    paths = cached_paths;
end

