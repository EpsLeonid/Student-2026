clear;
clc;
close all;

% % Signal parameters from Task 1:
A = 1;
tau1 = 16;
tau2 = 5;
t = (-10:1:100)'; 
% % Generate the time vector from -10 to 100 with a step size of 1.

% % Call the function to generate the input signal v(t):
v = my_function_Hossain(t, A, tau1, tau2);

% % Trapezoidal filter parameters for Hossain:
k = 10;
l = 5;
M = 16;

% % Call the filtering function based on formulas from Group B:
[s, p, r, d] = trapezoidal_filter_Hossain(v, k, l, M);

% % Plotting the results
figure;

% % Plot Input Signal v(t)
subplot(2,1,1);
plot(t, v, 'g-', 'LineWidth', 1.5);
grid on;
xlabel('t'); ylabel('v(t)');
title('Input Signal v(n)');

% % Plot Output Signal s(t)
subplot(2,1,2);
plot(t, s, 'm-', 'LineWidth', 1.5);
grid on;
xlabel('t'); ylabel('s(n)');
title('Output Signal s(n) (Trapezoidal Filter)');

% % Save the generated plots to an image file
saveas(gcf, 'graphs_Hossain.jpg');
