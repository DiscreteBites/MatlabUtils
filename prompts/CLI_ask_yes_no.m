function answer = CLI_ask_yes_no(msg)
%CLI_ask_yes_no Prompt a Yes/No question with GUI or CLI fallback.
%   answer = ASK_YES_NO(msg, title_str) shows a message box with Yes/No
%   buttons if GUI is available. Otherwise, falls back to CLI input.
%   Returns true for Yes, false for No.
    while true
        user_input = lower(strtrim(input([msg ' (y/n): '], 's')));
        if any(strcmp(user_input, {'y', 'yes'}))
            answer = true;
            break;
        elseif any(strcmp(user_input, {'n', 'no'}))
            answer = false;
            break;
        else
            fprintf('Please enter y or n.\n');
        end
    end
end

