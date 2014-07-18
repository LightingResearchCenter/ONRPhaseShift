function newCS = modifyCS(time,oldCS,wake,bed,protocol,addCS)
%MODLuxCLA Add or remove Circadian Stimulus to match experiment conditions
%   time is the time stamp of data samples in MATLAB datenum format
%   oldCS is CS measurement from Daysimeter
%   wake is the subject's scheduled wake time in fraction of a day
%   bed is the subject's scheduled bed time in fraction of a day
%   protocol is 'advance' or 'delay'
%   addCS is the additional CS that is to be combined (0 - 0.7)

%% Prepare wake and bed times
wakeStart = wake;
bedEnd = bed;
% Find wake and bed time boundaries based on offset
wakeEnd = mod(wakeStart + 2/24,1); % + 2 hours post wake
bedStart = mod(bedEnd - 3/24,1);   % - 3 hours pre bed
% Convert time to fractions of a day
fracTime = mod(time,1);
% Find indices of time during post wake treatment interval
if wakeStart > wakeEnd % Check for date rollover
    wakeTimes = fracTimes >= wakeStart | fracTimes <= wakeEnd;
else
    wakeTimes = fracTime >= wakeStart & fracTime <= wakeEnd;
end
% Find indices of time during pre bed treatment interval
if bedEnd < bedStart % Check for date rollover
    bedTimes = fracTime >= bedStart | fracTime <= bedEnd;
else
    bedTimes = fracTime >= bedStart & fracTime <= bedEnd;
end

%% Modify CLA and Lux based on protocol
newCS = oldCS; % Initialize new CS
if strcmpi(protocol,'advance')
    newCS(wakeTimes) = addCS;
    newCS(bedTimes) = 0;
elseif strcmpi(protocol,'delay')
    newCS(wakeTimes) = 0;
    newCS(bedTimes) = addCS;
else
    error('Unknown protocol please use ''advance'' or ''delay''');
end

end

