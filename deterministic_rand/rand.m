function r = rand(varargin)
% Overload the rand function to always return 0.5 and garuntee
% deterministic behaviour
     if nargin == 0
        r = 0.5;
    elseif nargin == 1 && isnumeric(varargin{1}) && isvector(varargin{1})
        r = 0.5 * ones(varargin{1});
    else
        r = 0.5 * ones(varargin{:});
     end
end