% gcz 2023

% To use this file:
% 1. Install Octave or Matlab.
% 2. Type:
%      plot_data_and_velocity
%    in the command window of Octave or Matlab.

% The code below is written without abstraction
% in order to clearly illustrate the steps
% for each data set.

clear;

bits = 2^23;  % Only using half ADC range, see above.

printf("Welcome to the KG-3C sample data analysis.\n");
printf("... loading data ....\n");

% Load the samples.
load hammer_2K_24b_fast.txt;
load hammer_8K_24b_fast.txt;
load hammer_16K_24b_fast.txt;
load hammer_2K_24b_slow.txt;
load hammer_8K_24b_slow.txt;
load hammer_16K_24b_slow.txt;

printf("Done loading data.\n");

% Normalize to [0, 1].
hammer_2K_24b_fast = hammer_2K_24b_fast / bits;
hammer_8K_24b_fast = hammer_8K_24b_fast / bits;
hammer_16K_24b_fast = hammer_16K_24b_fast / bits;
hammer_2K_24b_slow = hammer_2K_24b_slow / bits;
hammer_8K_24b_slow = hammer_8K_24b_slow / bits;
hammer_16K_24b_slow = hammer_16K_24b_slow / bits;

% Useful things to have around.
rate2K = 2000;
rate8K = 8000;
rate16K = 16000;
len2K = size(hammer_2K_24b_fast)(1);
len8K = size(hammer_8K_24b_fast)(1);
len16K = size(hammer_16K_24b_fast)(1);
time2K = [0:len2K-1]/rate2K;
time8K = [0:len8K-1]/rate8K;
time16K = [0:len16K-1]/rate16K;

% Display the rise times.
i0 = min(find(hammer_2K_24b_fast > 0.5));
i1 = min(find(hammer_2K_24b_fast > 0.8));
rise_time_2K_24b_fast = time2K(i1) - time2K(i0);
i0 = min(find(hammer_8K_24b_fast > 0.5));
i1 = min(find(hammer_8K_24b_fast > 0.8));
rise_time_8K_24b_fast = time8K(i1) - time8K(i0);
i0 = min(find(hammer_16K_24b_fast > 0.5));
i1 = min(find(hammer_16K_24b_fast > 0.8));
rise_time_16K_24b_fast = time16K(i1) - time16K(i0);
i0 = min(find(hammer_2K_24b_slow > 0.5));
i1 = min(find(hammer_2K_24b_slow > 0.8));
rise_time_2K_24b_slow = time2K(i1) - time2K(i0);
i0 = min(find(hammer_8K_24b_slow > 0.5));
i1 = min(find(hammer_8K_24b_slow > 0.8));
rise_time_8K_24b_slow = time8K(i1) - time8K(i0);
i0 = min(find(hammer_16K_24b_slow > 0.5));
i1 = min(find(hammer_16K_24b_slow > 0.8));
rise_time_16K_24b_slow = time16K(i1) - time16K(i0);
printf("Rise time for 2K, fast strike = %f milliseconds.\n",rise_time_2K_24b_fast*1000);
printf("Rise time for 8K, fast strike = %f milliseconds.\n",rise_time_8K_24b_fast*1000);
printf("Rise time for 16K, fast strike = %f milliseconds.\n",rise_time_16K_24b_fast*1000);
printf("Rise time for 2K, slow strike = %f milliseconds.\n",rise_time_2K_24b_slow*1000);
printf("Rise time for 8K, slow strike = %f milliseconds.\n",rise_time_8K_24b_slow*1000);
printf("Rise time for 16K, slow strike = %f milliseconds.\n",rise_time_16K_24b_slow*1000);

% Approximation of the envelope velocity.

% Digital derivative to compute velocity.
% The filter is [1 -1] convolved with a boxcar.
% The boxcar is to remove some noise.
% Lengthen filter based on sample rate to keep
% noise attenuation independent of sample rate.
M2K = 10; b2K = [1 zeros(1,M2K) -1]; D2K = round(length(b2K)/2);
M8K = 40; b8K = [1 zeros(1,M8K) -1]; D8K = round(length(b8K)/2);
M16K = 80; b16K = [1 zeros(1,M16K) -1]; D16K = round(length(b16K)/2);

% The shank at the sensor location moves approximately
% 5/16 of an inch when traveling the normalized distance
% (0 to 1 on vertical axis).
% Sensor location velocity:
% (5/16 inch * .0254 inches/meter) = the distance covered in meters.
% The hammer head moves approximately 2 inches.
% Hammer location velocity:
% (2 inches * .0254 inches/meter) = the distance covered in meters.
% Velocity can be checked by dx/dt with a ruler on the hammer position plots.
velocity_2K_24b_fast = filter(b2K,[1],hammer_2K_24b_fast) * 2 * 0.0254 * rate2K / (M2K+2);
velocity_8K_24b_fast = filter(b8K,[1],hammer_8K_24b_fast) * 2 * 0.0254 * rate8K / (M8K+2);
velocity_16K_24b_fast = filter(b16K,[1],hammer_16K_24b_fast) * 2 * 0.0254 * rate16K / (M16K+2);
velocity_2K_24b_slow = filter(b2K,[1],hammer_2K_24b_slow) * 2 * 0.0254 * rate2K / (M2K+2);
velocity_8K_24b_slow = filter(b8K,[1],hammer_8K_24b_slow) * 2 * 0.0254 * rate8K / (M8K+2);
velocity_16K_24b_slow = filter(b16K,[1],hammer_16K_24b_slow) * 2 * 0.0254 * rate16K / (M16K+2);

% Remove the filter initialization transient, for plots.
velocity_2K_24b_fast(1:length(b2K)) = zeros(length(b2K),1);
velocity_8K_24b_fast(1:length(b8K)) = zeros(length(b8K),1);
velocity_16K_24b_fast(1:length(b16K)) = zeros(length(b16K),1);
velocity_2K_24b_slow(1:length(b2K)) = zeros(length(b2K),1);
velocity_8K_24b_slow(1:length(b8K)) = zeros(length(b8K),1);
velocity_16K_24b_slow(1:length(b16K)) = zeros(length(b16K),1);

% Plot the hammer position with respect to time.
figure(1);
plot(time2K, hammer_2K_24b_fast);
title('KG-3C 2Ksps 24b fast strike');
xlabel('time, seconds');
ylabel('position, normalized');
set(gca,"fontsize",18);
grid;
figure(2);
plot(time8K, hammer_8K_24b_fast);
title('KG-3C 8Ksps 24b fast strike');
xlabel('time, seconds');
ylabel('position, normalized');
set(gca,"fontsize",18);
grid;
figure(3);
plot(time16K, hammer_16K_24b_fast);
title('KG-3C 16Ksps 24b fast strike');
xlabel('time, seconds');
ylabel('position, normalized');
set(gca,"fontsize",18);
grid;
figure(4);
plot(time2K, hammer_2K_24b_slow);
title('KG-3C 2Ksps 24b slow strike');
xlabel('time, seconds');
ylabel('position, normalized');
set(gca,"fontsize",18);
grid;
figure(5);
plot(time8K, hammer_8K_24b_slow);
title('KG-3C 8Ksps 24b slow strike');
xlabel('time, seconds');
ylabel('position, normalized');
set(gca,"fontsize",18);
grid;
figure(6);
plot(time16K, hammer_16K_24b_slow);
title('KG-3C 16Ksps 24b slow strike');
xlabel('time, seconds');
ylabel('position, normalized');
set(gca,"fontsize",18);
grid;

% Plot the hammer velocity with respect to time.
% Use delay value to shift the velocity curves
% to remove the filter delay.
figure(7);
plot(time2K(1:end-D2K), velocity_2K_24b_fast(D2K+1:end));
title('KG-3C 2Ksps 24b fast strike');
xlabel('time, seconds');
ylabel('velocity, meters per second');
set(gca,"fontsize",18);
grid;
figure(8);
plot(time8K(1:end-D8K), velocity_8K_24b_fast(D8K+1:end));
title('KG-3C 8Ksps 24b fast strike');
xlabel('time, seconds');
ylabel('velocity, meters per second');
set(gca,"fontsize",18);
grid;
figure(9);
plot(time16K(1:end-D16K), velocity_16K_24b_fast(D16K+1:end));
title('KG-3C 16Ksps 24b fast strike');
xlabel('time, seconds');
ylabel('velocity, meters per second');
set(gca,"fontsize",18);
grid;
figure(10);
plot(time2K(1:end-D2K), velocity_2K_24b_slow(D2K+1:end));
title('KG-3C 2Ksps 24b slow strike');
xlabel('time, seconds');
ylabel('velocity, meters per second');
set(gca,"fontsize",18);
grid;
figure(11);
plot(time8K(1:end-D8K), velocity_8K_24b_slow(D8K+1:end));
title('KG-3C 8Ksps 24b slow strike');
xlabel('time, seconds');
ylabel('velocity, meters per second');
set(gca,"fontsize",18);
grid;
figure(12);
plot(time16K(1:end-D16K), velocity_16K_24b_slow(D16K+1:end));
title('KG-3C 16Ksps 24b slow strike');
xlabel('time, seconds');
ylabel('velocity, meters per second');
set(gca,"fontsize",18);
grid;