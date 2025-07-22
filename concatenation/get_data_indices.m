function [start_idx, end_idx] = get_data_indices(end_indices, job_idx)
    if job_idx == 1
        start_idx = 1;
    else
        start_idx = end_indices(job_idx - 1) + 1;
    end
    end_idx = end_indices(job_idx);
end
