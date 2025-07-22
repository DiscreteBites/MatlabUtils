function env = load_env(filename)
    fprintf('[ml.system] Loading environment variables from: %s', filename)

    if nargin < 1
        filename = '.env';
    end

    fid = fopen(filename, 'r');
    if fid == -1
        error('Could not open .env file');
    end

    env = struct();

    while ~feof(fid)
        line = strtrim(fgetl(fid));
        if isempty(line) || startsWith(line, '#')
            continue;
        end
        tokens = regexp(line, '^(.*?)=(.*)$', 'tokens');
        if ~isempty(tokens)
            key = strtrim(tokens{1}{1});
            val = strtrim(tokens{1}{2});
            val = strrep(val, '"', '');  % remove quotes
            val = strrep(val, '''', '');
            env.(key) = val;
        end
    end
    fclose(fid);
    
    disp('[ml.system] Environment variables loaded')
end