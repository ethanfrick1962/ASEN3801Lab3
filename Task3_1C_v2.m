%% 3.1C RATE GYRO MEASUREMENTS AND CALIBRATION
% Contributors: Alonso Jimenes
% Course: ASEN 3801
% File: Task_3_1C
% Created: 2/17/26

clc;
clear; 
close all;
%% 3.1 part(C.1)
DataFiles = ["2026_02_10_002_05A02Hz", ...
             "2026_02_17_002_1A_08Hz", ...
             "2026_02_17_002_08A_04Hz"];

Data.A = readData(DataFiles(1));%% 0.5A , 0.2 Hz
Data.B = readData(DataFiles(2));%    1A , 0.8 Hz
Data.C = readData(DataFiles(3));%  0.8A , 0.4 Hz

time.A = shiftTime(Data.A(:,1));% time column vector for data ,units:[s]
time.B = shiftTime(Data.B(:,1));
time.C = shiftTime(Data.C(:,1));

gyro.A = Data.A(:,2);% Gyro rate measurement,also called Output,[rad/s] 
gyro.A = cleandata(gyro.A);% clean/smooth data out
encoder.A = rpm2rad(Data.A(:,3));% Encoder rate measuremnt,also called Input,convert [RPM] to [rad/s]

gyro.B = Data.B(:,2);
gyro.B = cleandata(gyro.B);
encoder.B = rpm2rad(Data.B(:,3));

gyro.C = Data.C(:,2);
gyro.C = cleandata(gyro.C);
encoder.C = rpm2rad(Data.C(:,3));

timeHistoryPlot(time.A, gyro.A, -encoder.A, {'Calibrated Gyro','Encoder Rate'}, ...
    'Time History of Gyro Rate & Encoder rate', '0.5A , 0.2 Hz');
print("time history ",'-dpng')
%% 3.1 part(C.2)

[k.A, bias.A, calGyro.A, yfit.A] = calibrateGyro(gyro.A, encoder.A);% get bias,k,line of best fit,calibrated output
[k.B, bias.B, calGyro.B, yfit.B] = calibrateGyro(gyro.B, encoder.B);
[k.C, bias.C, calGyro.C, yfit.C] = calibrateGyro(gyro.C, encoder.C);

plotEncoderVsGyro(encoder.A, gyro.A, yfit.A, bias.A, ...
    'Gyro Rate vs Encoder Rate', '0.5A , 0.2 Hz');
print("gyro vs endcoder",'-dpng')

timeHistoryPlot(time.A, calGyro.A, encoder.A, {'Calibrated Gyro','Encoder Rate'}, ...
    'Time History of Calibrated Gyro Rate & Encoder rate', '0.5A , 0.2 Hz');
print("time history Calibrated ",'-dpng')
%% 3.1 part(C.3)

scaleFactors = [k.A, k.B, k.C];% row matrix of scale factor for each data set
biasValues = [bias.A, bias.B, bias.C];% row matrix of bias from each data set

meanK = mean(scaleFactors); 
stdK = std(scaleFactors);
meanBias = mean(biasValues); 
stdBias = std(biasValues);

T = table(["A";"B";"C"], biasValues', scaleFactors','VariableNames', {'Run','Bias','ScaleFactor'})
%% 3.1 part(C.4)

error.B = calGyro.B - encoder.B;% Angular rate error , calibrated - encoder rate
error.C = calGyro.C - encoder.C;
% i).
timeHistoryPlot(time.B, calGyro.B, encoder.B, {'Calibrated Gyro','Encoder Rate'}, ...
    'Time History of Calibrated Gyro Rate & Encoder rate', '1A , 0.8 Hz');
print("time history calibrated data 2 ",'-dpng')

timeHistoryPlot(time.C, calGyro.C, encoder.C, {'Calibrated Gyro','Encoder Rate'}, ...
    'Time History of Calibrated Gyro Rate & Encoder rate', '0.8A , 0.4 Hz');
print("time history  calibrated data 3 ",'-dpng')
% ii).
figure() 
plot(time.B, error.B)
grid on
xlabel('Time [s]'); 
ylabel('Angular Position Error [rad]');
title('Time History of Angular Rate Error'); 
subtitle('1A , 0.8 Hz');
print("time history Rate error 2",'-dpng')

figure()
plot(time.C, error.C);
grid on
xlabel('Time [s]'); 
ylabel('Angular Position Error [rad]');
title('Time History of Angular Rate Error'); 
subtitle('0.8A , 0.4 Hz');
print("time history Rate error 3",'-dpng')

% Angular position & error
[measTheta.B, trueTheta.B, angleError.B] = AngleError(time.B, calGyro.B, encoder.B);
[measTheta.C, trueTheta.C, angleError.C] = AngleError(time.C, calGyro.C, encoder.C);

% iii).
plotAngleComparison(time.B, measTheta.B, trueTheta.B,'Measured True Angular Position', '1A , 0.8 Hz');
print("time history postion 2",'-dpng')

plotAngleComparison(time.C, measTheta.C, trueTheta.C,'Measured True Angular Position', '0.8A , 0.4 Hz');
print("time history postion 3",'-dpng')

% iv).
figure()
plot(time.B, angleError.B)
grid on
xlabel('Time [s]'); 
ylabel('Angular Position Error [rad]');
title('Time History of Angular Position Error'); 
subtitle('1A , 0.8 Hz');
print("time history position error 2",'-dpng')

figure()
plot(time.C, angleError.C)
grid on
xlabel('Time [s]'); 
ylabel('Angular Position Error [rad]');
title('Time History of Angular Position Error'); 
subtitle('0.8A , 0.4 Hz');
print("time history position error 3",'-dpng')

% v).
% Angular position error as a fn of encoder rate
pErr.B = polyfit(encoder.B, angleError.B, 1);% polyfit
yfitErr.B = polyval(pErr.B, encoder.B);% line of best fit y values

figure()
plot(encoder.B, yfitErr.B)
    hold on
    plot(encoder.B, yfitErr.B, 'r-','LineWidth',1.15)
    grid on
    xlabel('Encoder Rate [rad/s]')
    ylabel('Angular Position Error [rad]')
    title('Angular Position Error vs Encoder Rate')
    subtitle( '1A , 0.8 Hz');
print("Angular pos fn 2",'-dpng')

pErr.C = polyfit(encoder.C, angleError.C, 1);% polyfit
yfitErr.C = polyval(pErr.C, encoder.C);% line of best fit y values

figure()
plot(encoder.C, yfitErr.C)
    hold on
    plot(encoder.C, yfitErr.C, 'r-','LineWidth',1.15)
    grid on
    xlabel('Encoder Rate [rad/s]')
    ylabel('Angular Position Error [rad]')
    title('Angular Position Error vs Encoder Rate')
    subtitle( '1A , 0.8 Hz');
print("Angular pos fn 3",'-dpng')
%% Functions
function Data = readData(filename)
    Data = rmmissing(readmatrix(filename));% reads  file and removes missing data
end
function cleandata = cleandata(data)
cleandata = smoothdata(data,'sgolay',12);% smooths data using matlab built in fn
end
%
function timeVec = shiftTime(timeRaw)
    timeVec = timeRaw;
    timeVec(2:end) = timeRaw(2:end) - timeRaw(2); % shift time to start at zero
end
%
function encoderRad = rpm2rad(encoderRPM)
    encoderRad = encoderRPM * (2*pi/60); % convert [RPM] to [rad/s]
end
%
function timeHistoryPlot(time, data1, data2, labels, titleTxt, subtitleTxt)
    % Plot two lines over time
    figure();
    plot(time, data1, '-', 'LineWidth', 1.15);
    hold on
    plot(time, data2, '--', 'LineWidth', 1.15);
    grid on
    xlabel('Time [s]');
    ylabel('Rate [rad/s]');
    title(titleTxt);
    if exist('subtitleStr','var')
        subtitle(subtitleTxt)
    end
    legend(labels)
    hold off
end
%
function plotEncoderVsGyro(encoderRate, gyroOut, yfit, bias, titleStr, subtitleStr)
    % Plot gyro vs encoder rate with linear fit and bias line
    figure();
    plot(encoderRate, gyroOut, '.', 'MarkerSize', 10)
    hold on
    plot(encoderRate, yfit, '--r', 'LineWidth', 1.15)
    plot(encoderRate, bias*ones(size(encoderRate)), '--k', 'LineWidth', 1.15)
    grid on
    xlabel('Encoder Rate [rad/s]')
    ylabel('Gyro Output [rad/s]')
    title(titleStr)
    if exist('subtitleStr','var')
        subtitle(subtitleStr)
    end
    legend('Data','Adjusted Scale Factor K','Bias')
    hold off
end
%
function [k, bias, calGyro, yfit] = calibrateGyro(gyroOut, encoderRate)   
    p = polyfit(encoderRate, gyroOut, 1);
    k = p(1); % slope
    bias = p(2);% y-intercept
    calGyro = (gyroOut - bias)/k;
    yfit = polyval(p, encoderRate);% line of best fit y values
end
%
function [measTheta, trueTheta, angleError] = AngleError(time, calGyro, encoderRate)
    measTheta = cumtrapz(time, calGyro);% integrate calibrated gyro rate to get measured posn.
    trueTheta = cumtrapz(time, encoderRate);% integrate encoder rate to get true posn.
    angleError = measTheta - trueTheta;
end
%
function plotAngleComparison(time, thetaMeas, thetaTrue, titleTxt, subtitletxt)
    figure();
    plot(time, thetaMeas, '-', 'LineWidth', 1.5)
    hold on
    plot(time, thetaTrue, '--', 'LineWidth', 1.5)
    grid on
    xlabel('Time [s]')
    ylabel('Angular Position [rad]')
    title(titleTxt)
    if exist('subtitleStr','var')
        subtitle(subtitletxt);
    end
    legend('Measured Angle','True Angle');
    hold off
end
%
%

