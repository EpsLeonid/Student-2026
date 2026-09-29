function output_s = trapezoidal_filter(input_v, k, l, M)
% =========================================================================
% FUNCTION: trapezoidal_filter
% PURPOSE: Implements recursive trapezoidal filter algorithm (Formulas B)
% =========================================================================

    % --- BLOCK 1: INITIALIZATION & BUFFER ALLOCATION ---
    total_len = length(input_v); % Determine total number of signal samples
    
    % Preallocate memory for all intermediate filter stages and output arrays
    diff_kl = zeros(1, total_len); % Difference component array d^{k,l}(n)
    p_state = zeros(1, total_len); % First integration stage p(n)
    r_state = zeros(1, total_len); % Correction stage r(n)
    output_s = zeros(1, total_len); % Final filtered output signal s(n)

    % --- BLOCK 2: RECURSIVE FILTERING LOOP ---
    % Iterate sequentially through each sample from index 1 to the end
    for n = 1:total_len
        
        % --- Step A: Safety boundary extraction for delayed samples ---
        v_n = input_v(n); % Current sample v(n)
        
        % Safely retrieve v(n - k) with out-of-bounds boundary check
        v_nk = 0;
        if (n - k) > 0
            v_nk = input_v(n - k);
        end
        
        % Safely retrieve v(n - l) with out-of-bounds boundary check
        v_nl = 0;
        if (n - l) > 0
            v_nl = input_v(n - l);
        end
        
        % Safely retrieve v(n - k - l) with out-of-bounds boundary check
        v_nkl = 0;
        if (n - k - l) > 0
            v_nkl = input_v(n - k - l);
        end
        
        % --- Step B: Difference component calculation (Formulas B) ---
        % d^{k,l}(n) = v(n) - v(n-k) - v(n-l) + v(n-k-l)
        diff_kl(n) = v_n - v_nk - v_nl + v_nkl;
        
        % --- Step C: First integration stage p(n) ---
        % p(n) = p(n-1) + d^{k,l}(n)
        prev_p = 0;
        if (n - 1) > 0
            prev_p = p_state(n - 1); % Get previous state if available
        end
        p_state(n) = prev_p + diff_kl(n);
        
        % --- Step D: Correction stage r(n) ---
        % r(n) = p(n) + M * d^{k,l}(n)
        r_state(n) = p_state(n) + M * diff_kl(n);
        
        % --- Step E: Final integration stage s(n) ---
        % s(n) = s(n-1) + r(n)
        prev_s = 0;
        if (n - 1) > 0
            prev_s = output_s(n - 1); % Get previous output state if available
        end
        output_s(n) = prev_s + r_state(n);
        
    end
    
end