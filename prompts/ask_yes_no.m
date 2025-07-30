function answer = ask_yes_no(msg, title_str)
%ASK_YES_NO Prompt a Yes/No question with GUI or CLI fallback.
%   answer = ASK_YES_NO(msg, title_str) shows a message box with Yes/No
%   buttons if GUI is available. Otherwise, falls back to CLI input.
%   Returns true for Yes, false for No.

    if nargin < 2
        title_str = 'Confirm';
    end
    
    answer = false;
    has_GUI = false;

    try
        % Check for GUI availability
        if usejava('desktop') && feature('ShowFigureWindows')
            has_GUI = true;
        else
            error('No GUI');
        end
    catch
       disp("No GUI: displaying CLI fallback")
    end
    
    if has_GUI
        choice = questdlg(msg, title_str, 'Yes', 'No', 'Yes');
        answer = strcmp(choice, 'Yes');
    else
        % CLI fallback
        answer = CLI_ask_yes_no(msg);
    end
end