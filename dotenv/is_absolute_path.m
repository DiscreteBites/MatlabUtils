function tf = is_absolute_path(p)
    if ispc
        % Windows: absolute if it starts with a drive letter like C:\ or C:/
        tf = ~isempty(regexp(p, '^[A-Za-z]:[\\/]', 'once'));
    else
        % Unix/macOS: absolute if it starts with a forward slash
        tf = startsWith(p, '/');
    end
end