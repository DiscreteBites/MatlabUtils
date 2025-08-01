classdef Concatenator < handle
    properties (Access = private)
        allocator    % function handle, e.g., @zeros, @false
        fixed_dims   % dimensions beyond the first
        total_rows = 0
        blocks = {}  % cell array to store blocks
    end
    
    methods
        function obj = Concatenator(allocator_func, varargin)
            % Constructor
            % allocator_func: e.g., @zeros
            % varargin: fixed trailing dimensions
            obj.allocator = allocator_func;

            if isempty(varargin)
                obj.fixed_dims = {1};  % default to column vector (n x 1)
            else
                obj.fixed_dims = varargin;
            end
        end
        
        function addBlock(obj, block)
            % Validate block shape
            expected_size = obj.fixed_dims{:};
            
            % only consider 2nd dim onwards
            block_sizes = size(block);
            block_sizes = block_sizes(2:end); 

            if ~isequal(block_sizes, expected_size)
                error('Block dimensions do not match fixed dimensions.');
            end
            
            obj.blocks{end+1} = block;
            obj.total_rows = obj.total_rows + size(block, 1);
        end
        
        function [out, indices] = concat(obj)
            % Preallocate final array
            out = obj.allocator(obj.total_rows, obj.fixed_dims{:});
            
            % Fill in
            num_blocks = numel(obj.blocks);
            row_cursor = 1;
            indices = zeros(1, num_blocks);
            for i = 1:num_blocks
                block = obj.blocks{i};
                n_rows = size(block, 1);
                row_end = row_cursor+n_rows-1;
                
                indices(i) = row_end;
                out(row_cursor:row_end, :) = block;
                
                row_cursor = row_cursor + n_rows;
            end
        end
    end
end