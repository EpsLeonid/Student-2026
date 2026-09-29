function out_signal = calculate_signal(t_vec, A, tau1, tau2)
% =========================================================================
% FUNCTION: calculate_signal
% PURPOSE: Computes piecewise exponential signal based on physical model
% =========================================================================

    % --- BLOCK 1: MEMORY ALLOCATION ---
    % Preallocate the output signal array with zeros for optimal performance
    out_signal = zeros(size(t_vec));
    
    % --- BLOCK 2: CONDITIONAL WAVEFORM EVALUATION ---
    % Loop through every individual time point in the time vector
    for idx = 1:numel(t_vec)
        current_t = t_vec(idx); % Extract current time value
        
        % Check if the current time is within the pre-trigger region
        if current_t < 0
            out_signal(idx) = 0; % Signal is identically zero for t < 0
        else
            % Compute exponential response for t >= 0 using parameters tau1 and tau2
            out_signal(idx) = A * (exp(-current_t / tau1) - exp(-current_t / tau2));
        end
    end
    
end