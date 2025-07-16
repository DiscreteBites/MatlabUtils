function [report_fn, report_end, cleanup_obj] = progress_report_init(total, log_path)
    counter = 0;
    bar_width = 40;
    start_time = tic;
    
    if nargin < 2 || isempty(log_path)
        log_fid = -1;
    else
        log_fid = fopen(log_path, 'w');
    end
    
    % Start spinner with this live line accessor
    [
        spinner_setter, ...
        spinner_end, ...
        spinner_pause, ...
        spinner_resume, ...
        spinner_cleanup ...
    ] = start_spinner();
    
    function cleanup(log_fid, line)
        % close the log file
        if log_fid > 0 && ~isempty(fopen(log_fid))  % still open
            fprintf(log_fid, '[Completed] %s\n', line);
            status = fclose(log_fid);
            if status ~= 0
                warning('Could not close log file cleanly.');
            end
        end
    end
    
    function end_handler()
        elapsed_time = toc(start_time);
        elapsed_str = sprintf('%.2fs', elapsed_time);
        
        last_line = sprintf(':) All %d files processed in %s', counter, elapsed_str);
        spinner_end(last_line);
        
        cleanup(log_fid, last_line);
    end
    
    function handler(data)
        if isfield(data, 'type') && strcmp(data.type, "status")
            counter = counter + 1;
        end
                
        if isfield(data, 'log')
            % Log output to file
            if log_fid > 0
                fprintf(log_fid, '%s\n', data.log);
            end
        end
        
        if isfield(data, 'msg')
            % Build Progresss Bar
            pct = counter / total;
            
            filled_len = floor(pct * bar_width);
            empty_len = bar_width - filled_len;
            bar = [repmat('=', 1, filled_len), repmat(' ', 1, empty_len)];
            
            % call the line setter
            spinner_setter(sprintf('[%s] %3.0f%% (%d/%d) - %s', ...
                                  bar, pct * 100, counter, total, data.msg));
        end
        
        if isfield(data, 'line')
            spinner_setter(data.line)
        end
        
        if isfield(data, 'type') && strcmp(data.type, "pause")
            spinner_pause()
        end
        
        if isfield(data, 'type') && strcmp(data.type, "resume")
            spinner_resume();
        end
    end
    
    report_fn = @handler;
    report_end = @end_handler;
    report_cleanup = onCleanup(@() cleanup(log_fid, 'exited on cleanup'));

    cleanup_obj = struct( ...
        'spinner', spinner_cleanup, ...
        'report', report_cleanup ...
    );
end