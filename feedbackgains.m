%% Clear Workspace

clear; clc; close all;

%% Import Data

% Import all data
load('cleandata.mat');

% Import cases
case1 = cleandata.case_P75_D26_1;
case2 = cleandata.case_P75_D26_2;
case3 = cleandata.case_P75_D26_3;

% Torque constant
tau = 25.5;         % [mN * m / A]

%% Case 1

% Plot cases
time1 = (case1(89:end, 1) - case1(89, 1)) / 1000;
pos_reference1 = case1(89:end, 2);
pos_measured1 = case1(89:end, 3);
current1 = case1(89:end, 4);

% Plot position reference and measured data
figure;
hold on;
plot(time1, pos_reference1, 'b-', 'DisplayName', 'Reference Position');
plot(time1, pos_measured1, 'r--', 'DisplayName', 'Measured Position');

% Metadata
xlabel('Time (s)');
ylabel('Position (units)');
title('Position Comparison');
legend show;
grid on;

%% Case 2

% Plot cases
time2 = (case2(89:end, 1) - case2(89, 1)) / 1000;
pos_reference2 = case2(89:end, 2);
pos_measured2 = case2(89:end, 3);
current2 = case2(89:end, 4);

% Plot position reference and measured data
figure;
hold on;
plot(time2, pos_reference2, 'b-', 'DisplayName', 'Reference Position');
plot(time2, pos_measured2, 'r--', 'DisplayName', 'Measured Position');

% Metadata
xlabel('Time (s)');
ylabel('Position (units)');
title('Position Comparison');
legend show;
grid on;

%% Case 3

% Plot cases
time3 = (case3(89:end, 1) - case3(89, 1)) / 1000;
pos_reference3 = case3(89:end, 2);
pos_measured3 = case3(89:end, 3);
current3 = case3(89:end, 4);

% Plot position reference and measured data
figure;
hold on;
plot(time3, pos_reference3, 'b-', 'DisplayName', 'Reference Position');
plot(time3, pos_measured3, 'r--', 'DisplayName', 'Measured Position');

% Metadata
xlabel('Time (s)');
ylabel('Position (units)');
title('Position Comparison');
legend show;
grid on;