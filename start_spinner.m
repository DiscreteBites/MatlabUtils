function [set_line, end_fn, pause_fn, resume_fn, cleanup] = start_spinner()
    spinner_chars = ['|', '/', '-', '\'];
    spinner_idx = 1;
    last_len = 0;
    is_printing = false;

    line_buffer = '';
    is_consumed = false;
    
    graceful_stop = false;
    
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
    
    function line_handler(line)
        line_buffer = line;
        is_consumed = false;
    end
    
    function tick(~, ~)
        if graceful_stop && is_consumed
            stop(t)
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
            stop(t);
            delete(t);
        end
    end
    
    function end_spinner()
        clean_timer();
        
        final_msg = sprintf('\n%s\n', line_buffer);
        if isempty(final_msg)
            final_msg = ':) Done!';
        end
        
        fprintf(final_msg);
        is_consumed = true;
    end
    
    function pause_spinner()
        graceful_stop = true;
    end
    
    function resume_spinner()
        graceful_stop = false;
        if isvalid(t)
            start(t);
        end
    end
    
    set_line = @line_handler;
    pause_fn = @pause_spinner;
    resume_fn = @resume_spinner;
    end_fn = @end_spinner;
    cleanup = onCleanup(@() clean_timer());
end