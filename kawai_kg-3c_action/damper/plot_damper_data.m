% gcz, 2023
% 
% To use this file:
% 1. Install Octave or Matlab.
% 2. Type:
%      plot_damper_data
%    in the command window of Octave or Matlab.

clear;
load damper_2K_17b_fast_and_slow.txt;
d = damper_2K_17b_fast_and_slow;
t = [0:length(d)-1]/2000;

% Compute rise time as over this position range.
p0 = 0.4;
p1 = 0.8;

% Plot all data.
figure(1);
plot(t,d);
title('damper position data');
ylabel('normalized position');
xlabel('time, seconds');

% Print list of rise times.
fprintf("Damper Rise Times\n");
state = 0;
for i = 2:length(d),
  switch state
    case 0
      % Found start of a rising edge.
      if d(i) > p0 && d(i-1) < p0,
        start_time = t(i);
        state = 1;
      end;
    case 1
      % False hammer data.
      if d(i) < p0 && d(i-1) > p0,
        state = 0;
      end;
      % Got to 80% of max, so display rise time.
      if d(i) > p1 && d(i-1) < p1,
        fprintf("start time = %f, end time = %f, delta = %f seconds\n",
        start_time, t(i), t(i) - start_time);
        state = 0;
      end;
  end;
end;

% Print list of fall times.
fprintf("Damper Fall Times\n");
state = 0;
for i = 2:length(d),
  switch state
    case 0
      % Found start of a falling edge.
      if d(i) < p1 && d(i-1) > p1,
        start_time = t(i);
        state = 1;
      end;
    case 1
      % Got to 40% of max, so display fall time.
      if d(i) < p0 && d(i-1) > p0,
        fprintf("start time = %f, end time = %f, delta = %f seconds\n",
        start_time, t(i), t(i) - start_time);
        state = 0;
      end;
  end;
end;