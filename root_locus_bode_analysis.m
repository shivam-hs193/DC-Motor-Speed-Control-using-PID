%% root_locus_bode_analysis.m
% DC Motor Speed Control - Root Locus and Bode Stability Analysis
% This script evaluates the system's stability and frequency response
% in both open-loop and closed-loop configurations.

% Ensure workspace has the motor parameters loaded
if ~exist('G_motor', 'var')
    run('dc_motor_params.m');
end

s = tf('s');

%% 1. Define Selected Tuned Controller
% Using the optimized PID parameters from the tuning script
Kp_tuned = 25.0; 
Ki_tuned = 80.0; 
Kd_tuned = 1.2;

C_pid = Kp_tuned + (Ki_tuned / s) + (Kd_tuned * s);

% Open-Loop Loop Transfer Function: L(s) = C(s) * G(s)
L_sys = C_pid * G_motor;

% Closed-Loop System
T_sys = feedback(L_sys, 1);

%% 2. Root Locus Analysis (S-Domain Pole Trajectory)
figure('Name', 'Root Locus Analysis', 'NumberTitle', 'off');
rlocus(L_sys);
grid on;
title('Root Locus of the Combined PID-Motor System, L(s)', 'FontSize', 12);

%% 3. Frequency Response Analysis (Bode Plot & Margins)
figure('Name', 'Bode Frequency Response', 'NumberTitle', 'off');
bode(L_sys);
grid on;
title('Bode Plot of Open-Loop System L(s) with Margins', 'FontSize', 12);

% Extract stability margins (Gain Margin, Phase Margin, Crossover Frequencies)
[Gm, Pm, Wcg, Wcp] = margin(L_sys);

% Convert Gain Margin from absolute to Decibels (dB)
Gm_dB = 20 * log10(Gm);

%% 4. Closed-Loop Pole Verification
cl_poles = pole(T_sys);

%% 5. Display Stability Report in Command Window
fprintf('\n====================================================\n');
fprintf('             FREQUENCY & STABILITY ANALYSIS         \n');
fprintf('====================================================\n');
if isinf(Gm_dB)
    fprintf('Gain Margin (Gm)       : Inf dB (System never destabilizes by gain alone)\n');
else
    fprintf('Gain Margin (Gm)       : %.2f dB at %.2f rad/s\n', Gm_dB, Wcg);
end
fprintf('Phase Margin (Pm)      : %.2f degrees at %.2f rad/s\n', Pm, Wcp);
fprintf('----------------------------------------------------\n');
fprintf('Closed-Loop System Poles:\n');
for i = 1:length(cl_poles)
    fprintf('  Pole %d: %s\n', i, num2str(cl_poles(i)));
end
fprintf('----------------------------------------------------\n');

% Determine BIBO Stability based on pole locations
if all(real(cl_poles) < 0)
    fprintf('STABILITY VERIFICATION : SYSTEM IS STABLE\n');
    fprintf('Reason: All closed-loop poles lie strictly in the Left-Half S-Plane.\n');
else
    fprintf('STABILITY VERIFICATION : SYSTEM IS UNSTABLE\n');
    fprintf('Warning: One or more closed-loop poles lie in the Right-Half S-Plane.\n');
end
fprintf('====================================================\n');
