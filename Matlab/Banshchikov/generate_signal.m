function [t, y] = generate_signal(t1, t2, t_start, t_end, dt)
    % generate_signal - Generates a bi-exponential pulse signal
    %
    % Input parameters:
    %   t1, t2  - Time constants (tau1, tau2)
    %   t_start - Start time of the interval
    %   t_end   - End time of the interval
    %   dt      - Time step
    %
    % Output parameters:
    %   t - Time vector
    %   y - Signal output array

    A = 1; % Signal amplitude defined by assignment rules
    
    % Create time vector from t_start to t_end with step dt
    t = t_start:dt:t_end;
    
    % Initialize output array with zeros (for t < 0)
    y = zeros(size(t));
    
    % Find indices where t >= 0
    idx = (t >= 0);
    
    % Calculate formula values for t >= 0
    y(idx) = A * (exp(-t(idx) / t1) - exp(-t(idx) / t2));
end