function last_len = print_overwrite(msg, last_len)
    % Backspace over the previous message
    fprintf(repmat('\b', 1, last_len));

    % Update stored length
    last_len = length(msg);

    % Print new message
    fprintf('%s', msg);

    % Flush
    drawnow;
end