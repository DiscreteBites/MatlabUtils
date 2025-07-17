function size_report = struct_size(S)
    if ~isstruct(S)
        error('Input must be a struct.');
    end

    fields = fieldnames(S);
    size_report = struct();

    for i = 1:numel(fields)
        tmp = S.(fields{i});
        info = whos('tmp');
        size_report.(fields{i}) = sprintf('%d bytes', info.bytes);
    end
end