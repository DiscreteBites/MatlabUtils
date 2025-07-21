function answer = ask_yes_no(msg, title_str)
%ASK_YES_NO Prompt a Yes/No question with GUI or CLI fallback.
%   answer = ASK_YES_NO(msg, title_str) shows a message box with Yes/No
%   buttons if GUI is available. Otherwise, falls back to CLI input.
%   Returns true for Yes, false for No.

    if nargin < 2
        title_str = 'Confirm';
    end
    
    try
        % Check for GUI availability
        if usejava('desktop') && feature('ShowFigureWindows')
            choice = questdlg(msg, title_str, 'Yes', 'No', 'Yes');
            answer = strcmp(choice, 'Yes');
        else
            error('No GUI');
        end
    catch
        % CLI fallback
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
end