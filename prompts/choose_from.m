function [index, answer] = choose_from(options, msg, title_str)
%CHOOSE_FROM Display a dropdown menu to choose from a list of options
%   answer = choose_from(msg, title_str, options)
%   - options: cell array of strings
%   - msg: prompt to show above dropdown
%   - title_str: window title (optional)
%   Returns the selected value, or '' if cancelled or closed.

    if nargin < 3
        title_str = 'Select Option';
    end

    index = 0;
    answer = '';
    
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
        [idx, tf] = listdlg( ...
            'PromptString', msg, ...
            'SelectionMode', 'single', ...
            'ListString', options, ...
            'Name', title_str, ...
            'ListSize', [300 300]);
    
        if tf
            index = idx;
            answer = options{idx};
        end
    else
        % CLI fallback
         [index, answer] = CLI_choose_from(options, msg);
    end
end