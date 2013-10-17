function [firstCS,lastCS] = firstLast(Time,CS,wakeTime,bedTime,firstHrs,lastHrs)
%FIRSTLAST Summary of this function goes here
%   Detailed explanation goes here

% Create a time index with no date data
TI = mod(Time,1);

%% Calculate first CS after waking
% Find the end time that is the specified amount of hours after waking
afterWake = mod(wakeTime+firstHrs/24,1);
% Find the times that meet the requirements
if afterWake < wakeTime % After wake interval crosses midnight
    firstIdx = TI >= wakeTime | TI <= afterWake;
else % Interval does NOT cross midnight
    firstIdx = TI >= wakeTime & TI <= afterWake;
end
% Average the values during the specified times
firstCS = mean(CS(firstIdx));

%% Calculate last CS before bed
% Find the start time that is the specified amount of hours before bed
beforeBed = mod(bedTime-lastHrs/24,1);
% Find the times that meet the requirements
if beforeBed > bedTime % Before bed interval crosses midnight
    lastIdx = TI >= beforeBed | TI <= bedTime;
else % Interval does NOT cross midnight
    lastIdx = TI >= beforeBed & TI <= bedTime;
end
% Average the values during the specified times
lastCS = mean(CS(lastIdx));

end

