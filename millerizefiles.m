function [commonTimeArray_days,meanCsArray] = millerizefiles(filePathArray)
%MILLERIZEFILES Summary of this function goes here
%   Detailed explanation goes here


% Constants
secsPerDay = 24*60*60;

% Preallocate placeholder cell arrays
nFiles = numel(filePathArray);
relTimeCell_days = cell(1,nFiles);
relTimeCell_secs = cell(1,nFiles);
meanCsCell       = cell(1,nFiles);
timeSeriesCell   = cell(1,nFiles);
epochArray_secs  = zeros(1,nFiles);

for i1 = 1:nFiles
    % Load a file
    TempStruct = load(filePathArray{i1},'sourceData');
    tempTimeArray_datenum = TempStruct.sourceData.Time;
    tempCsArray = TempStruct.sourceData.CS;
    
    % Millerize CS from file
    [relTimeCell_days{i1},meanCsCell{i1}] = millerize(tempTimeArray_datenum,tempCsArray);
    
    % Create a timeseries object
    relTimeCell_secs{i1} = round(relTimeCell_days{i1}*secsPerDay);
    timeSeriesCell{i1}   = timeseries(meanCsCell{i1},relTimeCell_secs{i1});
    
    epochArray_secs(i1)  = mode(diff(relTimeCell_secs{i1}));
end

% Remove empty cells
emptyIdx = cellfun(@isempty,relTimeCell_days);
relTimeCell_days(emptyIdx) = [];
relTimeCell_secs(emptyIdx) = [];
meanCsCell(emptyIdx)       = [];
timeSeriesCell(emptyIdx)   = [];
epochArray_secs(emptyIdx)  = [];

% Create a common time array in seconds
epoch_secs = mode(epochArray_secs);
commonTimeArray_secs = (0:epoch_secs:secsPerDay-1)';

% Preallocate
resampledTimeSeriesCell = cell(size(timeSeriesCell));
resampledCsCell         = cell(size(timeSeriesCell));
for i2 = 1:numel(timeSeriesCell)
    % Resample CS from each file to the common relative time array
    resampledTimeSeriesCell{i2} = resample(timeSeriesCell{i2},commonTimeArray_secs);
    resampledCsCell{i2} = resampledTimeSeriesCell{i2}.data;
end

% Combine the Millerized CS from all files
resampledCsMat = cell2mat(resampledCsCell);
meanCsArray    = mean(resampledCsMat,2);
commonTimeArray_days = commonTimeArray_secs/secsPerDay;
end

