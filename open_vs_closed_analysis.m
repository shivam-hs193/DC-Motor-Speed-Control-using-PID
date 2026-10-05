%% open_vs_closed_analysis.m
% DC Motor Speed Control - Open-Loop vs. Closed-Loop Analysis
% This script analyzes and compares the uncompensated open-loop system 
% with the unity feedback closed-loop system using step response metrics.

% Ensure workspace has the motor parameters loaded
if ~exist('G_motor', 'var')
    run('dc_motor_params.m');
end

%% 1. Define Closed-Loop System (Without Controller)
% Closed-Loop System: T(s) = G(s) / [1 + G(s)]
% This represents the system with direct feedback but no PID gains applied yet.
T_closed = feedback(G_motor, 1);

%% 2. Generate Step Response Data
% Simulate for 5 seconds to observe transient behavior and steady-state error
t = 0:0.01:5;
[y_open, t_open]   = step(ref_speed * G_motor, t);
[y_closed, t_closed] = step(ref_speed * T_closed, t);

%% 3. Calculate Step Info Metrics
info_open   = stepinfo(G_motor);
info_closed = stepinfo(T_closed);

% Calculate Steady-State Values and Errors manually for reference speed
ss_open    = dcgain(G_motor) * ref_speed;
ss_closed  = dcgain(T_closed) * ref_speed;
ess_open   = ref_speed - ss_open;
ess_closed = ref_speed - ss_closed;

%% 4. Plotting Results
figure('Name', 'Open-Loop vs. Closed-Loop Response', 'NumberTitle', 'off');
plot(t, ref_speed * ones(size(t)), 'k--', 'LineWidth', 1.5); hold on;
plot(t_open, y_open, 'r-', 'LineWidth', 2);
plot(t_closed, y_closed, 'b-', 'LineWidth', 2);

grid on;
title('DC Motor Speed Control: Open-Loop vs. Closed-Loop Step Response', 'FontSize', 12);
xlabel('Time (seconds)', 'FontSize', 11);
ylabel('Speed \omega (rad/s)', 'FontSize', 11);
legend('Target Reference Speed', 'Open-Loop Response', 'Closed-Loop Response (No Gain)', 'Location', 'Southeast');
set(gca, 'FontSize', 10);

%% 5. Display Performance Comparison in Command Window
fprintf('\n====================================================\n');
fprintf('     PERFORMANCE COMPARISON (Target: %d rad/s)       \n', ref_speed);
fprintf('====================================================\n');
fprintf('%-25s | %-15s | %-15s\n', 'Metric', 'Open-Loop', 'Closed-Loop');
fprintf('----------------------------------------------------\n');
fprintf('%-25s | %-15.2f | %-15.2f\n', 'Steady-State Speed', ss_open, ss_closed);
fprintf('%-25s | %-15.2f | %-15.2f\n', 'Steady-State Error (e_ss)', ess_open, ess_closed);
fprintf('%-25s | %-15.4f | %-15.4f\n', 'Rise Time (sec)', info_open.RiseTime, info_closed.RiseTime);
fprintf('%-25s | %-15.4f | %-15.4f\n', 'Settling Time (sec)', info_open.SettlingTime, info_closed.SettlingTime);
fprintf('%-25s | %-15.2f%%| %-15.2f%%\n', 'Overshoot (%%)', info_open.Overshoot, info_closed.Overshoot);
fprintf('====================================================\n');
