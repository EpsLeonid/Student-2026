function [s, p, r, d] = trapezoidal_filter_Hossain(v, k, l, M)
% % Process the input signal v through a trapezoidal filter using formulas from Group B (Hossain).
% % Input parameters: v - input signal vector, k, l, M - filter parameters.
% % Output: Four arrays representing intermediate and final signals: s, p, r, d.

v = v(:);
% % Convert the input vector v into a column vector to standardize indexing and shifting operations.
N = length(v);
% % N is the total number of signal samples, used to prevent out-of-bound errors during array shifting.

vk = zeros(N,1);
vl = zeros(N,1);
vkl = zeros(N,1);
% % Initialize three zero-filled arrays of length N to store delayed versions of the signal:
% % vk  - stores v(n-k), shifted by k samples.
% % vl  - stores v(n-l), shifted by l samples.
% % vkl - stores v(n-k-l), shifted by k+l samples.

if k < N
    vk(k+1:N) = v(1:N-k);
end

if l < N
    vl(l+1:N) = v(1:N-l);
end

if (k+l) < N
    vkl(k+l+1:N) = v(1:N-k-l);
end

% % Calculate d(n) using Formula B: d(n) = v(n) - v(n-k) - v(n-l) + v(n-k-l)
d = v - vk - vl + vkl;

% % Calculate p(n) using the built-in cumulative sum function (cumsum) for recursion
p = cumsum(d);

% % Calculate r(n) using the formula: r(n) = p(n) + M * d(n)
r = p + M .* d;

% % Calculate the final output signal s(n) as the cumulative sum of r(n)
s = cumsum(r);
end
