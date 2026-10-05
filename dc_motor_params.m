%% dc_motor_params.m
% DC Motor Speed Control - System Parameters Configuration
% This script defines physical constants, builds the transfer function,
% and initializes workspace variables required for Simulink and analysis.

clear; clk = clc; close all;

%% 1. Physical Parameter Definitions
% Replace these values with your lab benchmarks if necessary.
R = 2.0;      % Armature resistance (Ohms)
L = 0.5;      % Armature inductance (Henries)
J = 0.02;     % Rotor moment of inertia (kg*m^2)
b = 0.1;      % Motor viscous friction constant (N*m*s)
K_t = 0.01;   % Torque constant (N*m/A)
K_e = 0.01;   % Back-emf constant (V/(rad/s))

%% 2. Workspace Variables for Simulink
% These variables are loaded directly into the Simulink model workspace.
V_s = 12;            % Nominal Input voltage supply (Volts)
ref_speed = 100;     % Reference target speed (rad/s)

% Baseline Controller Gains (To be tuned later)
Kp = 1.0;
Ki = 0.0;
Kd = 0.0;

%% 3. Open-Loop Transfer Function Derivation
% Transfer Function: G(s) = Omega(s) / V(s) = K_t / [ (J*s + b)*(L*s + R) + K_t*K_e ]
s = tf('s');
num = K_t;
den = (J*s + b)*(L*s + R) + K_t*K_e;
G_motor = num / den;

%% 4. Command Window Summary
fprintf('====================================================\n');
fprintf('       DC MOTOR MODEL INITIALIZED SUCCESSFULLY       \n');
fprintf('====================================================\n');
disp('Open-Loop Motor Transfer Function (Voltage -> Speed):');
disp(G_motor);
fprintf('Variables loaded into Workspace. Ready to open Simulink.\n');
