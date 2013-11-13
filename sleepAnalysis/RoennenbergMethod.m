function [SO,SE,SD,WD] = RoennenbergMethod(Activity,Time,bedTime,wakeTime)
%ROENNENBERGMETHOD Calculates sleep parameters using Roennenberg method
%   Combines Actiware sleep algorithim with Roennenberg sleep parameters

%% Trim data to within the analysis plus a buffer
buffer = 5/(60*24); % 5 minute buffer
idx = Time >= (bedTime - buffer) & Time <= (wakeTime + buffer);
Time = Time(idx);
if numel(Time) == 0
    error('bed time and wake time out of bounds');
end
Activity = Activity(idx);

%% Determine if the analysis ends on a weekday
dayNumber = weekday(Time(end));
if dayNumber == 1 || dayNumber == 7
    WD = false;
else
    WD = true;
end

%% Attempt to apply a gaussian filter to Activity
try
    Activity = gaussian(Activity,4);
catch err
    warning(err.message);
end

%% Convert time to seconds from start of first day
Time = (Time - floor(Time(1)))*24*60*60;

%% Calculate the sampling epoch to the nearest second
tempTime1 = Time(2:end);
tempTime2 = circshift(Time,1);
tempTime2(1) = [];
epoch = round(mean(abs(tempTime1-tempTime2)));

%% Find the sleep state (SS)
SS = FindSleepState(Activity,'auto',3);

%% Find sleep onset (SO) and sleep end (SE)
% Find sleep state in a 10 minute window
n10 = ceil(600/epoch); % Number of points in a 10 minute interval
n5 = floor((n10)/2);
AS = ~SS; % Active state (AS)
AS10 = AS; % Initialize 10 minute active state (AS10)
for i1 = -n5:n5
    AS10 = AS10 + circshift(AS,i1);
end
SS10 = AS10 <= 1; % Create 10 minute sleep state (SS10)
Time2 = Time;

% Remove first and last 10 minutes
last = numel(Time2);
Time2((last-n5):last) = [];
SS10((last-n5):last) = [];
Time2(1:n5) = [];
SS10(1:n5) = [];

% Find sleep onset (SO)
idxO = find(SS10,true,'first');
SO = Time2(idxO);

% Find sleep end (SE)
idxE = find(SS10,true,'last');
SE = Time2(idxE);

%% Calculate sleep duration (SD) in seconds
SD = abs(SE - SO);

end