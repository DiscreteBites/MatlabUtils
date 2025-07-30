function [index, answer] = CLI_choose_from(options, msg)
%CLI_choose_from    Display a text prompt to choose from a list of options
%   answer = choose_from(msg, title_str, options)
%   - options: cell array of strings
%   - msg: prompt to show above dropdown
%   - title_str: window title (optional)
%   Returns the selected value, or '' if cancelled or closed.
    
    index = 0;
    answer = '';
    
    while true
        fprintf('%s\n', msg);
        for i = 1:numel(options)
	        fprintf('  [ %d ] %s\n', i, options{i});
        end
        fprintf('Press Enter without typing a number to cancel.\n');
        user_input = strtrim(input('Select an option: ', 's'));

        if isempty(user_input)
	        return;
        end
        
        choice = str2double(user_input);
        if isnumeric(choice) && ~isnan(choice) && choice >= 1 && choice <= numel(options)
            index = choice;
	        answer = options{choice};
	        return;
        else
	        fprintf('Invalid input. Please enter a number between 1 and %d.\n\n', numel(options));
        end
    end
end

