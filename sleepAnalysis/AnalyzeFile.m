function [ActualSleep,ActualSleepPercent,ActualWake,...
    ActualWakePercent,SleepEfficiency,Latency,SleepBouts,WakeBouts,...
    MeanSleepBout,MeanWakeBout] = AnalyzeFile(Time,Activity,BedTime,WakeTime)

Days = length(BedTime);

% Preallocate sleep parameters
SleepStart = cell(Days,1);
SleepEnd = cell(Days,1);
ActualSleep = cell(Days,1);
ActualSleepPercent = cell(Days,1);
ActualWake = cell(Days,1);
ActualWakePercent = cell(Days,1);
SleepEfficiency = cell(Days,1);
Latency = cell(Days,1);
SleepBouts = cell(Days,1);
WakeBouts = cell(Days,1);
MeanSleepBout = cell(Days,1);
MeanWakeBout = cell(Days,1);
% Call function to calculate sleep parameters for each day
for i = 1:Days
    try
        [SleepStart{i},SleepEnd{i},ActualSleep{i},...
            ActualSleepPercent{i},ActualWake{i},ActualWakePercent{i},...
            SleepEfficiency{i},Latency{i},SleepBouts{i},WakeBouts{i},...
            MeanSleepBout{i},MeanWakeBout{i}] = ...
            CalcSleepParams(Activity,Time,BedTime(i),WakeTime(i));
    catch err
        display(err);
    end
end

end