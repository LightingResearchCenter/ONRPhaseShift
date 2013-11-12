function batchAvgSleep
addpath('sleepAnalysis');

%% File handling
startDir = fullfile([filesep,filesep],'root','projects',...
    'ONR PhaseShift');
inputDir = fullfile(startDir,'dimesimeterData');
outputDir = fullfile(startDir,'results');
dirInfo = dir(fullfile(inputDir,'ref*.mat'));
workbookFile = fullfile(inputDir,'index.xlsx');
[subject,~,~,~,~,~,~,wakeTime,bedTime] = importIndex(workbookFile);

%% Assign constants
nFiles = length(dirInfo); % Number of files to be analyzed

%% Preallocate output variables
out = dataset;
% out.reference = cell(nFiles,1);
out.subject = cell(nFiles,1);
out.protocol = cell(nFiles,1);
out.stage = cell(nFiles,1);
out.sleep = cell(nFiles,1);

%% Analyze files
for i1 = 1:nFiles
    % Load the file
    load(fullfile(inputDir,dirInfo(i1).name),'sourceData');
    fileName = regexprep(dirInfo(i1).name,'(.*)\.mat','$1');
    % Decompose the file name
    fileParts = regexpi(fileName,...
        'ref(\d*)_(\d\d\d\d\d\d)-(\d\d\d\d\d\d)_sub(\d\d)_(\w*)_(\w*)',...
        'tokens');
    out.subject{i1} = fileParts{1}{4};
    out.protocol{i1} = fileParts{1}{5};
    out.stage{i1} = fileParts{1}{6};
    % Find matching index entry
    idx0 = strcmpi(out.subject{i1},subject);
    tempWake = wakeTime(idx0);
    tempBed = bedTime(idx0);
    days = unique(floor(sourceData.Time));
    if tempBed > tempWake
        tempWake = tempWake + 1;
    end
    BedTimes = days + tempBed;
    WakeTimes = days + tempWake;
    [tempSleep,~,~,~,~,~,~,~,~,~] = ...
        AnalyzeFile(sourceData.Time,sourceData.Activity,BedTimes,WakeTimes);
    out.sleep{i1} = mean(cell2mat(tempSleep));
end

%% Save the output
outputPath = fullfile(outputDir,['avgSleepOutput_',...
    datestr(now,'yy-mm-dd_HHMM'),'.mat']);
save(outputPath,'out');
% Convert to Excel
organizeExcel(outputPath);
end