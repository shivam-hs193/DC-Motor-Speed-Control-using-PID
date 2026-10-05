# DC-Motor-Speed-Control-using-PID
This project implements a complete closed-loop DC Motor Speed Control system designed and tuned using MATLAB and Simulink. 

## 📦 Project Structure
* **`dc_motor_params.m`** - Initializes physical constants (R, L, J, b) and builds the motor transfer function.
* **`dc_motor_model.slx`** - Core Simulink visual block diagram containing the closed-loop tracking architecture.
* **`open_vs_closed_analysis.m`** - Script analyzing uncompensated tracking gaps vs direct unity feedback.
* **`pid_tuning_comparison.m`** - Evaluates and compares P, PI, and PID transient response characteristics.
* **`root_locus_bode_analysis.m`** - Analytical frequency-domain proofs for absolute system stability.

## 🚀 How to Run the Project
1. Open your MATLAB working directory.
2. Run `dc_motor_params.m` to load system parameters into the active workspace.
3. Open and run `dc_motor_model.slx` to observe real-time tracking behavior on the Scope block.
4. Run individual analysis scripts to auto-generate performance comparative metrics.
