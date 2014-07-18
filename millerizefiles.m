function [commonTimeArray_days,meanCsArray,varargout] = millerizefiles(filePathArray)
%MILLERIZEFILES Summary of this function goes here
%   Detailed explanation goes here


% Constants
secsPerDay = 24*60*60;

% Preallocate placeholder cell arrays
nFiles = numel(filePathArray);
templateCell1 = cell(1,nFiles);
relTimeCell_days = templateCell1;
relTimeCell_secs = templateCell1;
meanCsCell       = templateCell1;
meanClaCell      = templateCell1;
meanLuxCell      = templateCell1;
tsCsCell         = templateCell1;
tsClaCell        = templateCell1;
tsLuxCell        = templateCell1;
epochArray_secs  = zeros(1,nFiles);

for i1 = 1:nFiles
    % Load a file
    TempStruct = load(filePathArray{i1},'sourceData');
    tempTimeArray_datenum = TempStruct.sourceData.Time;
    tempCsArray = TempStruct.sourceData.CS;
    tempClaArray = TempStruct.sourceData.CLA;
    tempLuxArray = TempStruct.sourceData.Lux;
    
    % Millerize CS from file
    [relTimeCell_days{i1},meanCsCell{i1}] = millerize(tempTimeArray_datenum,tempCsArray);
    [~,                   meanClaCell{i1}] = logmillerize(tempTimeArray_datenum,tempClaArray);
    [~,                   meanLuxCell{i1}] = logmillerize(tempTimeArray_datenum,tempLuxArray);
    
    % Create a timeseries object
    relTimeCell_secs{i1} = round(relTimeCell_days{i1}*secsPerDay);
    tsCsCell{i1}  = timeseries(meanCsCell{i1},relTimeCell_secs{i1});
    tsClaCell{i1} = timeseries(meanClaCell{i1},relTimeCell_secs{i1});
    tsLuxCell{i1} = timeseries(meanLuxCell{i1},relTimeCell_secs{i1});
    
    epochArray_secs(i1)  = mode(diff(relTimeCell_secs{i1}));
end

% Remove empty cells
emptyIdx = cellfun(@isempty,relTimeCell_days);
relTimeCell_days(emptyIdx) = [];
relTimeCell_secs(emptyIdx) = [];
meanCsCell(emptyIdx)       = [];
meanClaCell(emptyIdx)      = [];
meanLuxCell(emptyIdx)      = [];
tsCsCell(emptyIdx)         = [];
tsClaCell(emptyIdx)        = [];
tsLuxCell(emptyIdx)        = [];
epochArray_secs(emptyIdx)  = [];

% Create a common time array in seconds
epoch_secs = mode(epochArray_secs);
commonTimeArray_secs = (0:epoch_secs:secsPerDay-1)';

% Preallocate
templateCell = cell(size(tsCsCell));
resampledTsCsCell = templateCell;
resampledTsClaCell = templateCell;
resampledTsLuxCell = templateCell;
resampledCsCell         = templateCell;
resampledClaCell        = templateCell;
resampledLuxCell        = templateCell;
for i2 = 1:numel(tsCsCell)
    % Resample CS from each file to the common relative time array
    resampledTsCsCell{i2} = resample(tsCsCell{i2},commonTimeArray_secs);
    resampledCsCell{i2} = resampledTsCsCell{i2}.data;
    
    % Resample CLA from each file to the common relative time array
    resampledTsClaCell{i2} = resample(tsClaCell{i2},commonTimeArray_secs);
    resampledClaCell{i2} = resampledTsClaCell{i2}.data;
    
    % Resample Lux from each file to the common relative time array
    resampledTsLuxCell{i2} = resample(tsLuxCell{i2},commonTimeArray_secs);
    resampledLuxCell{i2} = resampledTsLuxCell{i2}.data;
end

% Combine the Millerized CS from all files
resampledCsMat = cell2mat(resampledCsCell);
meanCsArray    = mean(resampledCsMat,2);

resampledClaMat = cell2mat(resampledClaCell);
meanClaArray    = mean(resampledClaMat,2);

resampledLuxMat = cell2mat(resampledLuxCell);
meanLuxArray    = mean(resampledLuxMat,2);

commonTimeArray_days = commonTimeArray_secs/secsPerDay;

varargout{1} = meanClaArray;
varargout{2} = meanLuxArray;

end

