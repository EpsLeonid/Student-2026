% =========================================================================
% Kunc Bogdan, FT-62M
% VARIANT: 4 (Trapezoidal Filter)
% =========================================================================

clear; % Clear all variables from the MATLAB workspace
clc;   % Clear command window screen

%% --- BLOCK 1: INITIAL PARAMETERS CONFIGURATION ---
amplitude = 1;       % Signal amplitude constant (A = 1)
t1 = 16;             % Time constant tau_1 for exponential rise/fall
t2 = 5;              % Time constant tau_2 for exponential rise/fall

% Define the time vector from -10 to 100 with a strict step of 1
time_axis = -10:1:100;

%% --- BLOCK 2: INPUT SIGNAL GENERATION ---
% Call external function to compute the piecewise exponential signal array
input_signal = calculate_signal(time_axis, amplitude, t1, t2);

% Create a figure window for the original time-domain waveform
figure('Name', 'Input Signal Analysis', 'Color', 'white');
plot(time_axis, input_signal, 'LineWidth', 2, 'Color', 'b'); % Plot curve in blue
grid on;                                                    % Enable grid lines
xlabel('Time t');                                           % X-axis label
ylabel('Amplitude y(t)');                                   % Y-axis label
title('Generated Input Signal (Variant 4)');                  % Main plot title

%% --- BLOCK 3: FILTER PARAMETERS DEFINITION ---
k_val = 9;           % Filter parameter k for Variant 4
l_val = 5;           % Filter parameter l for Variant 4
M_val = 16;          % Scaling parameter M for Variant 4

%% --- BLOCK 4: DIGITAL FILTERING EXECUTION ---
% Pass the input waveform and filter parameters to the recursive processing function
filtered_output = trapezoidal_filter(input_signal, k_val, l_val, M_val);

%% --- BLOCK 5: RESULTS VISUALIZATION ---
% Create a separate figure window for the filtered output signal
figure('Name', 'Filtered Signal Output', 'Color', 'white');
plot(filtered_output, 'LineWidth', 2, 'Color', 'r'); % Plot filtered curve in red
grid on;                                             % Enable grid lines
xlabel('Sample Index n');                            % X-axis label (discrete samples)
ylabel('Output s(n)');                               % Y-axis label
title('Trapezoidal Filtered Signal (Variant 4)');      % Main plot title

disp('Simulation and plotting completed successfully.'); % Log message to console