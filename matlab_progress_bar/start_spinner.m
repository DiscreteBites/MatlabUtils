function [set_line, end_fn, pause_fn, resume_fn, cleanup] = start_spinner()
    spinner_chars = ['|', '/', '-', '\'];
    spinner_idx = 1;
    last_len = 0;
    is_printing = false;

    line_buffer = '';
    is_consumed = false;
    
    graceful_stop = false;
    is_paused = false;
    
    old_timers = timerfind('Tag', 'start_spinner');
    delete(old_timers);
    
    t = timer( ...
        'ExecutionMode', 'fixedSpacing', ...
        'Period', 0.15, ...
        'BusyMode', 'drop', ...
        'TimerFcn', @tick, ...
        'Tag', 'start_spinner' ...
    );
    
    start(t);
    
    function tick(~, ~)
        if graceful_stop && is_consumed
            pause();
        end
        
        if isempty(line_buffer)
            return;
        end
        
        if is_printing
            return;
        end
        is_printing = true;
        
        spinner = spinner_chars(spinner_idx);
        spinner_idx = mod(spinner_idx, length(spinner_chars)) + 1;
        
        format_line = sprintf('%s %s', spinner, line_buffer);
        last_len = print_overwrite(format_line, last_len);
        
        is_consumed = true;
        is_printing = false;
    end
    
    function clean_timer()
        if isvalid(t)
            pause();
            delete(t);
        end
    end
    
    function end_spinner(final_msg)
        clean_timer();
        
        if isempty(final_msg)
            final_msg = ':) Done!';
        end

        fprintf('\n%s\n', final_msg);
        is_consumed = true;
    end
    
    function await_pause()
        if is_paused
            return
        end
        
        graceful_stop = true;
    end
    
    function pause()
        stop(t)
        is_paused = true;
    end
    
    function resume()
        graceful_stop = false;
        if isvalid(t)
            start(t);
            is_paused = false;
        end
    end
    
    function line_handler(line)
        line_buffer = line;
        is_consumed = false;
        
        if is_paused
            format_line = sprintf('* %s', line_buffer);
            last_len = print_overwrite(format_line, last_len);
            is_consumed = true;
        end
    end
    
    set_line = @line_handler;
    pause_fn = @await_pause;
    resume_fn = @resume;
    end_fn = @end_spinner;
    cleanup = onCleanup(@() clean_timer());
end