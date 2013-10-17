function batchFirstLast
addpath('phasorReport');

%% File handling
startDir = fullfile([filesep,filesep],'root','projects',...
    'ONR PhaseShift');
inputDir = fullfile(startDir,'dimesimeterData');
outputDir = fullfile(startDir,'results');
dirInfo = dir(fullfile(inputDir,'ref*.mat'));
workbookFile = fullfile(inputDir,'index.xlsx');
[subject,~,~,~,~,~,~,wakeTime,bedTime] = importIndex(workbookFile);

%% Assign constants
firstHrs = 2; % Number of hours after waking
lastHrs = 3; % Number of hours before bed
nFiles = length(dirInfo); % Number of files to be analyzed

%% Preallocate output variables
out = dataset;
% out.reference = cell(nFiles,1);
out.subject = cell(nFiles,1);
out.protocol = cell(nFiles,1);
out.stage = cell(nFiles,1);
out.firstCS = cell(nFiles,1);
out.lastCS = cell(nFiles,1);
out.firstCLA = cell(nFiles,1);
out.lastCLA = cell(nFiles,1);
out.firstLux = cell(nFiles,1);
out.lastLux = cell(nFiles,1);

%% Analyze files
for i1 = 1:nFiles
    % Load the file
    load(fullfile(inputDir,dirInfo(i1).name),'sourceData');
    fileName = regexprep(dirInfo(i1).name,'(.*)\.mat','$1');
    % Decompose the file name
    fileParts = regexpi(fileName,...
        'ref(\d*)_(\d\d\d\d\d\d)-(\d\d\d\d\d\d)_sub(\d\d)_(\w*)_(\w*)',...
        'tokens');
%     out.reference{i1} = fileParts{1}{1};
    out.subject{i1} = fileParts{1}{4};
    out.protocol{i1} = fileParts{1}{5};
    out.stage{i1} = fileParts{1}{6};
    % Find matching index entry
    idx = strcmpi(out.subject{i1},subject);
    %% Find first and last values
    [out.firstCS{i1},out.lastCS{i1}] = firstLast(sourceData.Time,...
        sourceData.CS,wakeTime(idx),bedTime(idx),firstHrs,lastHrs);
    [out.firstCLA{i1},out.lastCLA{i1}] = firstLast(sourceData.Time,...
        log(sourceData.CLA),wakeTime(idx),bedTime(idx),firstHrs,lastHrs);
    [out.firstLux{i1},out.lastLux{i1}] = firstLast(sourceData.Time,...
        log(sourceData.Lux),wakeTime(idx),bedTime(idx),firstHrs,lastHrs);
end

%% Save the output
outputPath = fullfile(outputDir,['firstLastOutput_',...
    datestr(now,'yy-mm-dd_HHMM'),'.mat']);
save(outputPath,'out');
% Convert to Excel
organizeExcel(outputPath);
end