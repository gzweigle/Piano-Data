% gcz 2023

% See README.md in this directory for data details.

% The following file demonstrates analysis of 
% position and velocity.

clear;

load samples.txt;
len = size(samples)(1);

sample_rate = 8000;
time = [0:len-1]/sample_rate;

% Digital filter approximating a derivative to compute velocity.
% The filter is [1 -1] convolved with a boxcar filter.
% The boxcar is to remove some noise.
M = 10;
b = [1 zeros(1,M) -1];
D = round(length(b)/2);  % Filter delay in units of samples.

% The shank at the sensor location moves approximately
% 5/16 of an inch when traveling the normalized distance
% (0 to 1 on vertical axis).
% Sensor location velocity:
% (5/16 inch * .0254 inches/meter) = the distance covered in meters.
%
% The hammer head moves approximately 2 inches.
% Hammer location velocity:
% (2 inches * .0254 inches/meter) = the distance covered in meters.
%
% Velocity can be sanity checked by dx/dt with a ruler on the plots.
%
dx = filter(b,[1],samples) * 2 * 0.0254 * sample_rate / (M+2);
% Remove the filter initialization transient.
dx(1:length(b),:) = zeros(length(b),size(dx)(2));

% Plot the hammer positions with respect to time.
figure(1);
plot(time,samples);
title('Renner action hammer samples');
xlabel('time, seconds');
ylabel('position, normalized');
set(gca,"fontsize",18);
grid;

% Plot the hammer position and an approximation of the velocity
% with respect to time.  Use the delay value (D) to shift the
% velocity curves in time. This removes the filter delay and
% enables comparing hammer position with associated velocity.
%
% The point where hammer  flies off jack toward string is
% when the velocity peaks and starts to decrease. When the
% hammer hits the string the velocity is zero.
%
figure(2);
subplot(2,2,1);
plot(time,samples(:,1),time(1:end-D),dx(D+1:end,1));
xlabel('time, seconds');
ylabel('position and velocity (m/s)');
set(gca,"fontsize",18);
grid;
subplot(2,2,2);
plot(time,samples(:,2),time(1:end-D),dx(D+1:end,2));
xlabel('time, seconds');
ylabel('position and velocity (m/s)');
set(gca,"fontsize",18);
grid;
subplot(2,2,3);
plot(time,samples(:,3),time(1:end-D),dx(D+1:end,3));
xlabel('time, seconds');
ylabel('position and velocity (m/s)');
set(gca,"fontsize",18);
grid;
subplot(2,2,4);
plot(time,samples(:,4),time(1:end-D),dx(D+1:end,4));
xlabel('time, seconds');
ylabel('position and velocity (m/s)');
set(gca,"fontsize",18);
grid;