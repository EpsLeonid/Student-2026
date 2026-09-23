function s = apply_filter(v, k, l, M)
    % apply_filter - Performs triangular filtering (Formulas B)
    %
    % Purpose: Transforms bi-exponential input signal v(n) into triangular pulse s(n).
    %
    % Input parameters:
    %   v - Input signal array
    %   k - Shaping parameter for the first edge phase
    %   l - Shaping parameter for the second edge phase
    %   M - Decay compensation parameter
    %
    % Output parameter:
    %   s - Final filtered signal array

    N = length(v); % Input signal length
    
    % Pre-allocate memory for intermediate and output arrays
    d_kl = zeros(1, N);
    p    = zeros(1, N);
    r    = zeros(1, N);
    s    = zeros(1, N);

    % Helper function to safely fetch v(n - offset)
    % Handles MATLAB 1-based indexing (returns 0 for n - offset <= 0)
    get_v = @(n, offset) (n - offset >= 1) * v(max(1, n - offset));

    % Iterative implementation of the recursive filter
    for n = 1:N
        % Step 1: Calculate first difference d^(k,l)(n) = v(n) - v(n-k) - v(n-l) + v(n-k-l)
        v_curr = v(n);
        v_nk   = get_v(n, k);
        v_nl   = get_v(n, l);
        v_nkl  = get_v(n, k + l);
        
        d_kl(n) = v_curr - v_nk - v_nl + v_nkl;

        % Step 2: First integration stage p(n) = p(n-1) + d^(k,l)(n)
        if n == 1
            p(n) = d_kl(n);
        else
            p(n) = p(n - 1) + d_kl(n);
        end

        % Step 3: Decay compensation r(n) = p(n) + M * d^(k,l)(n)
        r(n) = p(n) + M * d_kl(n);

        % Step 4: Second integration stage s(n) = s(n-1) + r(n)
        if n == 1
            s(n) = r(n);
        else
            s(n) = s(n - 1) + r(n);
        end
    end
end