function y = generate_signal_yakunin(t, A, tau1, tau2)
% input parameters:
%   t    - time samples vector
%   A    - signal amplitude
%   tau1 - decay time constant
%   tau2 - rise time constant
% output parameter:
%   y    - resulting array of function values

    % initialize the array with zeros of the same length as vector t
    % this automatically satisfies the condition: y = 0 for t < 0
    y = zeros(size(t));
    
    % create a logical mask for indices where t >= 0
    idx = (t >= 0);
    
    % compute values according to the given formula only for t >= 0
    % element-wise division and multiplication operations (using a dot)
    y(idx) = A * (exp(-t(idx) / tau1) - exp(-t(idx) / tau2));
end