function runner = use_deterministic_rand()
% Returns a function handle that runs a function with rand temporarily overridden
%
% Usage:
%   fake_rand = with_fake_rand();
%   result = fake_rand(@() my_function());
    
    this_file_path = mfilename('fullpath');
    testing_dir = fileparts(this_file_path);
    rand_dir = fullfile(testing_dir, '..', 'deterministic_rand');  % adjust if needed
    
    runner = @run_with_fake_rand;

    function cleanup_rand(dir)
        rmpath(dir);
        disp('restoring rand to inbuilt rand.')
    end

    function out = run_with_fake_rand(f, varargin)
        % Save and override path
        disp('!!!!! overriding inbuilt rand with rand that only returns 0.5 !!!!!!!')
        addpath(rand_dir, '-begin');
        cleanup = onCleanup(@() cleanup_rand(rand_dir));  % ensure restore
        
        % Run target function with fake rand
        out = f(varargin{:});
    end


end