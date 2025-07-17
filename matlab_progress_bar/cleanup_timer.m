function cleanup_timer()
    timers = timerfindall;
    if ~isempty(timers)
        stop(timers);
        delete(timers);
    end
end