%% Clear Workspace

clear; clc; close all;

%% Load Needed Data

% Import all data
load('cleandata.mat');

% Torque constant
tau = 25.5 / 1000;                                              % [N * m / A]

% Choosing information from base torque with 10 mN * m
time = cleandata.case_BASE10(125:510, 1) / 1000;                % [s]
time = time - time(1);
torque_commanded = cleandata.case_BASE10(125:510, 2) / 1000;    % [N * m]
omega = cleandata.case_BASE10(125:510, 3) * ((2 * pi) / 60);    % [rad / s]
current = cleandata.case_BASE10(125:510, 4);                    % [A]

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
ylabel('Torque (N * m)');
title('Real vs commanded torque (base)');
legend('Real Torque', 'Commanded Torque');

% Save figure
print(gcf, 'figs/base_torque', '-dpng', '-r300');

%% Calculate and Plot Angular Velocity

% Calculating things
omega_start = omega(1);
omega_end = omega(end);
time_start = time(1);
time_end = time(end);
alpha = abs((omega_end - omega_start) / (time_end - time_start));

% Angular acceleration fit
alphafit = polyfit(time, omega, 1);
alphaval = polyval(alphafit, time);

% Plotting angular velocity vs time
figure();
hold on;
grid on;
plot(time, omega, 'b-');
plot(time, alphaval, 'r--');

% Metadata
xlabel('Time (s)');
ylabel('Angular velocity (\omega)');
title('Angular velocity versus time (base)');
legend('Real data', 'Linear fit');

% Save figure
print(gcf, 'figs/base_omega', '-dpng', '-r300');

%% Calculate Moment of Inertia

% Assuming a constant torque over the time interval
moi = torque_average / alpha;  % [kg*m^2]
disp(['Moment of Inertia: ', num2str(moi), ' kg * m^2']);

%% Calculate MoI Statistics

% Alpha data
alphafit6 = polyfit(time, (cleandata.case_BASE6(125:510, 3) * ((2 * pi) / 60)), 1);
alphafit8 = polyfit(time, (cleandata.case_BASE8(125:510, 3) * ((2 * pi) / 60)), 1);
alphafit10 = polyfit(time, (cleandata.case_BASE10(125:510, 3) * ((2 * pi) / 60)), 1);

alphaval6 = alphafit6(1);
alphaval8 = alphafit8(1);
alphaval10 = alphafit10(1);

alphas = - [alphaval6, alphaval8, alphaval10];

% Torque data
torqueval6 = mean(tau .* cleandata.case_BASE6(125:510, 4));
torqueval8 = mean(tau .* cleandata.case_BASE8(125:510, 4));
torqueval10 = mean(tau .* cleandata.case_BASE10(125:510, 4));

torques = [torqueval6, torqueval8, torqueval10];

% Compute moment of inertia vector
moi_vector = torques ./ alphas;
moi_mean = mean(moi_vector);
moi_std = std(moi_vector);