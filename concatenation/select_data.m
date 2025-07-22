function data = select_data(concat_arr, end_indices, job_idx)
    [start_idx, end_idx] = get_data_indices(end_indices, job_idx);
    
    data = concat_arr(start_idx:end_idx, :);
end

