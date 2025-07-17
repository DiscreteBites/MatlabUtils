function [report_fn, report_end, cleanup_obj] = progress_report_init(total, options)
    counter = 0;
    bar_width = 40;
    start_time = tic;
    
    use_spinner = false;
    
    if nargin == 2 
        if isfield(options, 'use_spinner') 
            use_spinner = options.use_spinner;
        end
    end
    % Start spinner with this live line accessor

    function [set_line, end_line, pause_line, resume_line, clean] = iohandler()
        if use_spinner
            [
                set_line, ...
                end_line, ...
                pause_line, ...
                resume_line, ...
                clean ...
            ] = start_spinner();
        else
            set_line = @(line) disp(line);
            end_line = @(line) disp(line);
            pause_line = @() [];
            resume_line = @() [];
            clean = [];
        end
    end

    [set_line, end_line, pause_line, resume_line, clean] = iohandler();
 
    function end_handler()
        elapsed_time = toc(start_time);
        elapsed_str = sprintf('%.2fs', elapsed_time);
        
        last_line = sprintf(':) All %d files processed in %s', counter, elapsed_str);
        end_line(last_line);
    end
    
    function handler(data)
        if isfield(data, 'type') && strcmp(data.type, "status")
            counter = counter + 1;
        end

        if isfield(data, 'msg')
            % Build Progresss Bar
            pct = counter / total;
            
            filled_len = floor(pct * bar_width);
            empty_len = bar_width - filled_len;
            bar = [repmat('=', 1, filled_len), repmat(' ', 1, empty_len)];
            
            % call the line setter
            set_line(sprintf('[%s] %3.0f%% (%d/%d) - %s', ...
                                  bar, pct * 100, counter, total, data.msg));
        end
        
        if isfield(data, 'line')
            set_line(data.line)
        end
        
        if isfield(data, 'type') && strcmp(data.type, "pause")
            pause_line()
        end
        
        if isfield(data, 'type') && strcmp(data.type, "resume")
            resume_line();
        end
    end
    
    report_fn = @handler;
    report_end = @end_handler;
    cleanup_obj = struct( ...
        'spinner', clean ...
    );
end