% =========================================================================
% Main Project: Modeling in MATLAB
% =========================================================================

clear;      % clear workspace variables from old data
clc;        % clear command window
close all;  % close all open figures

%% ==================== Tasks 1 and 2 ====================
% initial data:
A = 1;          % amplitude
tau1 = 16;      % exponential decay time constant
tau2 = 5;       % rise time constant

% discrete time scale: from -10 to 100 with a step of 1 sample
t = -10:1:100;

% function call (Task 1)
y = generate_signal_yakunin(t, A, tau1, tau2);


%% ================== Task 1: Triangular Filter =======================
% initial data (Formulas B):
k = 7;          % triangle rise time (samples)
l = 7;          % triangle decay time (samples)
M = 16;         % decay compensation parameter (corresponds to tau1 = 16)

% call of the digital filtering m-function (Task 3)
s = triangular_filter_yakunin(y, k, l, M);


%% ================= Plotting =====================
% create figure window
figure('Name', 'Simulation: Variant 8', 'Position', [120, 80, 850, 700]);

% Plot 1: Original pulse y(t)
subplot(2, 1, 1);
plot(t, y, 'b-', 'LineWidth', 2);
grid on;
xlim([-10, 100]);                          % Remove excess margin to -20 on the left

title('Tasks 1–2: Original Pulse y(t)', ...
      'Color', 'w', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Time t (samples)', 'Color', 'w', 'FontSize', 11, 'FontWeight', 'bold');
ylabel('Amplitude y(t)',   'Color', 'w', 'FontSize', 11, 'FontWeight', 'bold');
legend('y(t) [\tau_1 = 16, \tau_2 = 5]', 'Location', 'northeast', 'TextColor', 'w');


% Plot 2: Filtered pulse s(n) 
subplot(2, 1, 2);
plot(t, s, 'r-', 'LineWidth', 2);
grid on;
xlim([-10, 100]);                          % Synchronize scale with the upper plot

title('Task 3: Triangular Filter Output s(n) [k=7, l=7, M=16]', ...
      'Color', 'w', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Time t (sample index n)', 'Color', 'w', 'FontSize', 11, 'FontWeight', 'bold');
ylabel('Amplitude s(n)',            'Color', 'w', 'FontSize', 11, 'FontWeight', 'bold');
legend('s(n) — shaped triangular pulse', 'Location', 'northeast', 'TextColor', 'w');