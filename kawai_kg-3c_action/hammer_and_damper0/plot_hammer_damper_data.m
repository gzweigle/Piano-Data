% gcz, 2023
% 
% To use this file:
% 1. Install Octave or Matlab.
% 2. Type:
%      plot_hammer_damper_data
%    in the command window of Octave or Matlab.
%
% See README.md in this directory for details.
clear;

% Two columns of data.
% First column is hammer data.
% Second column is damper data.
% Data is sampled at 2000 samples per second and with 17-bits of ADC.
fprintf("Loading data file...\n");
load hammer_damper_2K_17b.txt;

hammer = hammer_damper_2K_17b(:,1);
damper = hammer_damper_2K_17b(:,2);
t = [0:length(hammer)-1]/2000;

% Measured as part of calibration process.
% First I removed these, then I computed cal values.
damper_offset = 0.3;
damper_gain = 0.58;

% First column is 1/32" increments at front of piano key.
% Divide by 16 to normalize 0 to 1.
% Second column is resulting ADC output after removing
% damper_offset and normalizing by damper_gain.
damper_cal_points = [
  0/16  0;
  1/16  0.0015;
  2/16  0.0035;
  3/16  0.0064;
  4/16  0.0115;
  5/16  0.0165;
  6/16  0.0260;
  7/16  0.0365;
  8/16  0.0570;
  9/16  0.0810;
  10/16 0.1450;
  11/16 0.2250;
  12/16 0.3650;
  13/16 0.5700;
  14/16 0.8100;
  15/16 1.0000;
];

% Calibration values for hammer.
hammer_offset = 0.69;
hammer_gain = 0.29;

% First column is 1/64" at hammer shank CNY-70 transmit emitter location.
% Divide by 10 to normalize 0 to 1.
% Second column is resulting ADC output after removing
% hammer_offset and normalizing by hammer_gain.
% Except last value was about 1/2 way to the final ruler tick.
hammer_cal_points = [
  0/10 0;
  1/10 0.015;
  2/10 0.04;
  3/10 0.11;
  4/10 0.17;
  5/10 0.28;
  6/10 0.39;
  7/10 0.57;
  8/10 0.75;
  9/10 0.9;
  19/20 1;
];

% Calibrate the hammer.
% Selected 6 for polynomial degree based on trial-and-error fitting.
fprintf("Calibrating hammer data...\n");
hammer2 = hammer - hammer_offset;
hammer2 = hammer2 / hammer_gain;
p_h = polyfit(hammer_cal_points(:,1),hammer_cal_points(:,2),6);
x_h = [0:0.0001:1];
y_h = polyval(p_h,x_h);
hammer_cal = zeros(1,length(hammer));
for k = 1:length(hammer),
  ind = min(find(y_h > hammer2(k)));
  if length(ind) > 0,
    hammer_cal(k) = x_h(ind);
  else
    hammer_cal(k) = hammer2(k);
  end;
end;

% Hack to fix small signal fitting.
hammer_cal = hammer_cal - hammer_cal(1);

% Calibrate damper.
% Selected 10 for polynomial degree based on trial-and-error fitting.
fprintf("Calibrating damper data...\n");
damper2 = damper - damper_offset;
damper2 = damper2 / damper_gain;
p_d = polyfit(damper_cal_points(:,1),damper_cal_points(:,2),10);
x_d = [0:0.0001:1];
y_d = polyval(p_d,x_d);
damper_cal = zeros(1,length(damper));
for k = 1:length(damper),
  ind = min(find(y_d > damper2(k)));
  if length(ind) > 0,
    damper_cal(k) = x_d(ind);
  else
    damper_cal(k) = damper2(k);
  end;
end;

% Hack to fix small signal fitting.
damper_cal = damper_cal - damper_cal(1);

% Plot all data.
fprintf("Plotting results...\n");
figure(1);
subplot(2,1,1);
plot(t, hammer, t, damper);
title('hammer (blue) and damper (orange) position data - uncalibrated');
ylabel('normalized position');
xlabel('time, seconds');
set(gca,"fontsize",16);
grid;
subplot(2,1,2);
plot(t, hammer_cal, t, damper_cal);
title('hammer (blue) and damper (orange) position data - calibrated');
ylabel('normalized position');
xlabel('time, seconds');
set(gca,"fontsize",16);
grid;