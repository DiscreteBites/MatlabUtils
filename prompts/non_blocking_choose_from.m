function non_blocking_choose_from(callback, options, msg, title_str)
% non_blocking_choose_from	Displays a non-blocking UI list selection dialog using uifigure.
% provides a CLI based fallback
%	callback	Function handle called with index, option or 0, "" if cancelled.
%       expected signature callback(index, option)
%	options		Cell array of strings to choose from.
%	msg		(Optional) Prompt text above the list.
%	title_str	(Optional) Window title.
%
% Example:
%	opts = {'A', 'B', 'C'};
%	non_blocking_choose_from(@(x) disp(x), opts);

    if nargin < 4
        title_str = 'Select Option';
    end

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
    
    if ~has_GUI
        % CLI fallback
        while true
            [idx, str] = CLI_choose_from(options, msg);
            
            if idx == 0 || isempty(str)
                return 
            end

            callback(idx, str);
        end
    end
    
    win_x = 300;
    win_y = 300;
    win_height = 400;
    win_width = 330;
    
    top_padding = 30;
    bot_padding = 20;
    lr_padding = 20;
    text_height = 22;

    element_padding = 20;
    button_gap = 0.5 * element_padding;

    fig = figure( ...
		'Name', title_str, ...
		'Position', [win_x win_y win_width win_height], ...
		'Resize', 'off', ...
        'NumberTitle', 'off', ...  % hides "Figure 1" text
	    'MenuBar', 'none', ...     % removes File/Edit/View/etc.
	    'ToolBar', 'none' ...    % remove icon toolbar
        );
    
    prompt_y = win_height - top_padding;
	% Prompt label (like listdlg)
	uicontrol(fig, ...
        'Style', 'text', ...
		'String', msg, ...
		'Position', [ ...
            lr_padding, ...
            prompt_y, ...
            win_width - 2*lr_padding, ...
            text_height ...
       ], ...
		'HorizontalAlignment', 'left');
    
    button_width = 0.5 * (win_width - 2*lr_padding - button_gap);
    
    list_y = bot_padding + text_height + element_padding;
    list_height_fill = prompt_y - 2*element_padding - text_height;
    
	% Listbox for options
	lb = uicontrol(fig, ...
        'Style', 'listbox', ...
		'String', options, ...
		'Position', [ ...
            lr_padding, ...
            list_y, ...
            win_width - 2*lr_padding, ...
            list_height_fill ...
       ], ...
    'Callback', @(src, event) on_list_click());
    
	% OK button
	uicontrol(fig, ...
        'Style', 'pushbutton', ...
        'String', 'OK', ...
		'Position', [ ...
            lr_padding, ...
            bot_padding, ...
            button_width, ...
            text_height ...
        ], ...
		'Callback', @(src, event) on_ok());
    
	% Cancel button
	uicontrol(fig, ...
        'Style', 'pushbutton', ...
        'String', 'Cancel', ...
		'Position', [ ...
            lr_padding + button_width + button_gap, ...
            bot_padding, ...
            button_width, ...
            text_height ...
        ], ...
		'Callback', @(src, event) on_cancel());
   
    function [index, val] = get_val()
        index = 0;
        val = '';

        if ~isempty(lb) && ~isempty(lb.String)
            index = lb.Value;
	        val = lb.String{lb.Value};
        end
    end
    
    function on_ok()
        [index, option] = get_val();
        callback(index, option);
    end

    function on_cancel()    
        if isvalid(fig)
	        delete(fig);
        end
	end
    
    function on_list_click()
	    if strcmp(get(fig, 'SelectionType'), 'open')
            [index, option] = get_val();
            callback(index, option);
	    end
    end
end