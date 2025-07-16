function config_str = get_parallel_params()
    mem_per_cpu = '8G';
    time = '24:00:00';
    
    config_str = sprintf('--mem-per-cpu=%s --time=%s', mem_per_cpu, time);
end

