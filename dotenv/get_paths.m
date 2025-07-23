function paths = get_paths(force_refresh)
    if nargin < 1
        force_refresh = false;
    end

    persistent cached_paths

    if isempty(cached_paths) || force_refresh
        project_root = get_project_root();
        paths = struct();

        files = {'.env', '.env.local'};
        for file_idx = 1: numel(files)
            env = load_env(files{file_idx});
            
            fields = fieldnames(env);
            
            for i = 1:numel(fields)
                key = fields{i};
            
                % Skip *_TYPE keys
                if endsWith(key, '_TYPE')
                    continue
                end
                
                val = env.(key);
                mode_key = key + "_TYPE";
            
                if isfield(env, mode_key)
                    mode = lower(strtrim(env.(mode_key)));
                else
                    % Default fallback
                    mode = is_absolute_path(val) * 'a' + ~is_absolute_path(val) * 'r';
                end
            
                out_key = lower(key);  % normalize key

                switch mode
                case 'a'
                    paths.(out_key) = val;
                case 'r'
                    paths.(out_key) = fullfile(project_root, val);
                otherwise
                    error("Invalid mode '%s' for key '%s'. Use 'a' or 'r'.", mode, key);
                end
            end
        end
        cached_paths = paths;
    end
    paths = cached_paths;
end