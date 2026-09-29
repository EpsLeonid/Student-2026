function [s, p, r, d] = triangular_filter_yakunin(v, k, l, M)
% triangular filter (formulas B, variant 8)
% input parameters:
%   v - input signal vector y(t)
%   k - triangle rise parameter (for var. 8: k = 7)
%   l - triangle decay parameter (for var. 8: l = 7)
%   M - decay compensation parameter (for var. 8: M = 16)
%
% output parameters:
%   s - final filtered signal s(n)
%   p - intermediate signal after the first integrator
%   r - signal after the decay compensation block (deconvolution / HPD)
%   d - double difference signal d^{k,l}(n)

    % vectorization
    is_col = iscolumn(v);  % check whether the input vector is a column or a row. The result is stored in the is_col flag
    v = v(:)'; % transforms the vector into a row vector
    N = length(v); % total number of signal points

    % preallocating memory for arrays 
    d = zeros(1, N);  % double difference array d^{k,l}(n)
    p = zeros(1, N);  % first accumulator array 
    r = zeros(1, N);  % intermediate signal after deconvolution
    s = zeros(1, N);  % output signal after the second accumulator

    % step-by-step filtering
    for n = 1:N
        % -------------------------------------------------------------
        % Step 1: Calculation of d^{k,l}(n) according to equation (1) of the article:
        % two consecutive differentiation blocks (DS-blocks)
        % -------------------------------------------------------------
        v_n = v(n);
        
        % accounting for delay by k samples (if n-k < 1, the value is 0):
        if (n - k >= 1)
            v_nk = v(n - k);
        else
            v_nk = 0;
        end
        
        % accounting for delay by l samples:
        if (n - l >= 1)
            v_nl = v(n - l);
        else
            v_nl = 0;
        end
        
        % accounting for total delay by (k+l) samples:
        if (n - k - l >= 1)
            v_nkl = v(n - k - l);
        else
            v_nkl = 0;
        end
        
        % eq. 1
        % second difference extracts changes in the input signal:
        d(n) = v_n - v_nk - v_nl + v_nkl;

        % -------------------------------------------------------------
        % Step 2: First digital integrator:
        % p(n) = p(n-1) + d^{k,l}(n), n >= 0
        % -------------------------------------------------------------
        if (n - 1 >= 1)
            p_prev = p(n - 1);
            s_prev = s(n - 1);
        else
            p_prev = 0;
            s_prev = 0;
        end
        p(n) = p_prev + d(n);

        % -------------------------------------------------------------
        % Step 3: Deconvolution / decay compensation:
        % r(n) = p(n) + M * d^{k,l}(n)
        % the term M*d(n) compensates for the exponential decay exp(-t/16)
        % -------------------------------------------------------------
        r(n) = p(n) + M * d(n);

        % -------------------------------------------------------------
        % Step 4: Second digital integrator:
        % s(n) = s(n-1) + r(n), n >= 0
        % integrates the signal r(n), forming a triangular pulse
        % -------------------------------------------------------------
        s(n) = s_prev + r(n);
    end
    % restore original orientation
    if is_col
        s = s(:); p = p(:); r = r(:); d = d(:);
    end
end