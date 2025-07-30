function answer = choose_from(options, msg, title_str)
%CHOOSE_FROM Display a dropdown menu to choose from a list of options
%   answer = choose_from(msg, title_str, options)
%   - options: cell array of strings
%   - msg: prompt to show above dropdown
%   - title_str: window title (optional)
%   Returns the selected value, or '' if cancelled or closed.

    if nargin < 3
        title_str = 'Select Option';
    end

    answer = '';  % Default in case of cancel or close
    
    try 
        % Check for GUI availability
        if usejava('desktop') && feature('ShowFigureWindows')
                   
	        [indx, tf] = listdlg( ...
		        'PromptString', msg, ...
		        'SelectionMode', 'single', ...
		        'ListString', options, ...
		        'Name', title_str, ...
                'ListSize', [300 300]);
        
	        if tf
		        answer = options{indx};
	        end
        else
            error('No GUI');
        end
    catch
        % CLI fallback
        while true
		    fprintf('%s\n', msg);
		    for i = 1:numel(options)
			    fprintf('  [ %d ] %s\n', i, options{i});
		    end
		    fprintf('Press Enter without typing a number to cancel.\n');
		    user_input = strtrim(input('Select an option: ', 's'));
    
		    if isempty(user_input)
			    answer = '';
			    return;
		    end
            
		    choice = str2double(user_input);
		    if isnumeric(choice) && ~isnan(choice) && choice >= 1 && choice <= numel(options)
			    answer = options{choice};
			    return;
		    else
			    fprintf('Invalid input. Please enter a number between 1 and %d.\n\n', numel(options));
		    end
        end
    end

	

	
end