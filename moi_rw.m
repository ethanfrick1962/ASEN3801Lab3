%% Clear Workspace

clear; clc; close all;

%% Load Needed Data

% Import all data
load('cleandata.mat');

% Torque constant
tau = 33.5;                                                     % [mN * m / A]

% Choosing information from base torque with 10 mN * m
time = cleandata.case_RW10(125:510, 1) / 1000;                  % [s]
time = time - time(1);
torque_commanded = cleandata.case_RW10(125:510, 2);             % [mN * m]
omega = cleandata.case_RW10(125:510, 3) * ((2 * pi) / 60);      % [rad / s]
current = cleandata.case_RW10(125:510, 4);                      % [A]

%% Calculate and Plot Torque

% Calculating things
torque_real = tau .* current;
torque_average = mean(torque_real);
torque_avgvec = torque_average * ones([length(torque_real), 1]);

% Plotting real torque vs commanded torque over time
figure();
hold on;
grid on;
plot(time, torque_real, 'black-', 'LineWidth', 1.5);
plot(time, torque_commanded, 'r--', 'LineWidth', 1.5);
plot(time, torque_avgvec, 'blue--', 'LineWidth', 1.5);

% Metadata
xlabel('Time (s)');
ylabel('Torque (mN * m)');
title('Real vs Commanded Torque');
legend('Real Torque', 'Commanded Torque');

%% Calculate and Plot Angular Velocity

% Calculating things
omega_start = omega(1);
omega_end = omega(end);
time_start = time(1);
time_end = time(end);
alpha = abs((omega_end - omega_start) / (time_end - time_start));

% Plotting angular velocity vs time
figure();
hold on;
grid on;
plot(time, omega);

% Metadata
xlabel('Time (s)');
ylabel('Angular Velocity (\omega)');
title('Angular velocity versus time');

%% Calculate Moment of Inertia

% Assuming a constant torque over the time interval
moi = torque_average / alpha;  % [g*m^2]
disp(['Moment of Inertia: ', num2str(moi), ' g*m^2']);