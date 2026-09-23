% Main project script
clc; clear; close all;

% --- Tasks 1 & 2: Parameters and initial signal generation ---
t1 = 16;
t2 = 5;
t_start = -10;
t_end = 100;
dt = 1;

% Call m-function to generate the input signal
[t, y] = generate_signal(t1, t2, t_start, t_end, dt);

% Plot initial signal
figure('Name', 'Task 1 and 2: Initial Signal');
plot(t, y, 'b-', 'LineWidth', 1.5);
grid on;
title('Bi-exponential Pulse Signal y(t)');
xlabel('Time t');
ylabel('Amplitude y');

% --- Task 3: Variant 2 (Triangular Filter, Formulas B) ---
k = 5;
l = 5;
M = 16;

% Call m-function for triangular filtering
s = apply_filter(y, k, l, M);

% Plot final filtered signal
figure('Name', 'Task 3: Filtered Signal Output');
plot(t, s, 'r-', 'LineWidth', 1.5);
grid on;
title('Filtered Signal s(n) (Triangular Filter, Variant 2)');
xlabel('Time t (index n)');
ylabel('Amplitude s');