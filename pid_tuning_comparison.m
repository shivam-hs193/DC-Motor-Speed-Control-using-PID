%% pid_tuning_comparison.m
% DC Motor Speed Control - P vs. PI vs. PID Controller Comparison
% This script tests and compares three different controller designs
% using rise time, settling time, overshoot, and steady-state error.

% Ensure workspace has the motor parameters loaded
if ~exist('G_motor', 'var')
    run('dc_motor_params.m');
end

s = tf('s');
t = 0:0.005:3; % 3-second simulation time window

%% 1. Define Controller Configurations
% Case A: Proportional Only (P)
Kp_p = 15.0; 
C_p  = Kp_p;
T_p  = feedback(C_p * G_motor, 1);

% Case B: Proportional-Integral (PI)
Kp_pi = 15.0; Ki_pi = 40.0;
C_pi  = Kp_pi + (Ki_pi / s);
T_pi  = feedback(C_pi * G_motor, 1);

% Case C: Proportional-Integral-Derivative (PID)
Kp_pid = 25.0; Ki_pid = 80.0; Kd_pid = 1.2;
C_pid  = Kp_pid + (Ki_pid / s) + (Kd_pid * s);
T_pid  = feedback(C_pid * G_motor, 1);

%% 2. Generate Step Response Data
[y_p, t_p]     = step(ref_speed * T_p, t);
[y_pi, t_pi]   = step(ref_speed * T_pi, t);
[y_pid, t_pid] = step(ref_speed * T_pid, t);

%% 3. Extract Performance Metrics
info_p   = stepinfo(T_p);
info_pi  = stepinfo(T_pi);
info_pid = stepinfo(T_pid);

ess_p   = ref_speed - (dcgain(T_p) * ref_speed);
ess_pi  = ref_speed - (dcgain(T_pi) * ref_speed);
ess_pid = ref_speed - (dcgain(T_pid) * ref_speed);

%% 4. Plot Comparison Results
figure('Name', 'Controller Tuning Comparison', 'NumberTitle', 'off');
plot(t, ref_speed * ones(size(t)), 'k--', 'LineWidth', 1.5); hold on;
plot(t_p, y_p, 'r-', 'LineWidth', 2);
plot(t_pi, y_pi, 'g-', 'LineWidth', 2);
plot(t_pid, y_pid, 'b-', 'LineWidth', 2);

grid on;
title('DC Motor Speed Control: Controller Architecture Comparison', 'FontSize', 12);
xlabel('Time (seconds)', 'FontSize', 11);
ylabel('Speed \omega (rad/s)', 'FontSize', 11);
legend('Target Reference Speed', 'P Control', 'PI Control', 'PID Control', 'Location', 'Southeast');
set(gca, 'FontSize', 10);

%% 5. Display Performance Summary Matrix
fprintf('\n========================================================================\n');
fprintf('                CONTROLLER ARCHITECTURE METRIC COMPARISON                \n');
fprintf('========================================================================\n');
fprintf('%-20s | %-12s | %-12s | %-12s\n', 'Metric', 'P Only', 'PI Control', 'PID Control');
fprintf('------------------------------------------------------------------------\n');
fprintf('%-20s | %-12.2f | %-12.2f | %-12.2f\n', 'Rise Time (sec)', info_p.RiseTime, info_pi.RiseTime, info_pid.RiseTime);
fprintf('%-20s | %-12.2f | %-12.2f | %-12.2f\n', 'Settling Time (sec)', info_p.SettlingTime, info_pi.SettlingTime, info_pid.SettlingTime);
fprintf('%-20s | %-12.2f%%| %-12.2f%%| %-12.2f%%\n', 'Overshoot (%%)', info_p.Overshoot, info_pi.Overshoot, info_pid.Overshoot);
fprintf('%-20s | %-12.4f | %-12.4f | %-12.4f\n', 'Steady-State Error', ess_p, ess_pi, ess_pid);
fprintf('========================================================================\n');
