function y = my_function_Hossain(t, A, tau1, tau2)
% % Generate the input signal based on the given analytical formula.
% % Input parameters: t - time vector, A - amplitude, tau1, tau2 - time constants.
% % Output: y - array containing the calculated signal values.

y = zeros(size(t));
% % Initialize the output array with zeros of the same size as t.
% % This ensures y = 0 for t < 0 and preallocates memory for performance.

idx = (t >= 0); 
% % Create a logical index mask where idx is true for t >= 0 and false for t < 0.

y(idx) = A .* (exp(-t(idx)./tau1) - exp(-t(idx)./tau2));
% % Apply the formula only to the elements where t >= 0 using the logical mask.
% % Note: .* and ./ are used for element-by-element array multiplication and division.
end
