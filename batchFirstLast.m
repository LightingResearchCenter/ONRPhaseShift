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
n1 = length(dirInfo); % Number of files to be analyzed

%% Preallocate output variables

%% Analyze files
for i1 = 1:n1
    % Load the file
    load(fullfile(inputDir,dirInfo(i1).name),'sourceData');
    fileName = regexprep(dirInfo(i1).name,'(.*)\.mat','$1');
    % Decompose the file name
    fileParts = regexpi(fileName,...
        'ref(\d*)_(\d\d\d\d\d\d)-(\d\d\d\d\d\d)_sub(\d\d)_(\w*)_(\w*)',...
        'tokens');
%     curReference{i1} = fileParts{1}{1};
    curSubject{i1} = fileParts{1}{4};
    curProtocol{i1} = fileParts{1}{5};
    curStage{i1} = fileParts{1}{6};
    % Find matching index entry
    idx = strcmpi(curSubject{i1},subject);
    %% Find first and last values
    [firstCS{i1},lastCS{i1}] = firstLast(sourceData.Time,...
        sourceData.CS,wakeTime(idx),bedTime(idx),2,3);
    [firstCLA{i1},lastCLA{i1}] = firstLast(sourceData.Time,...
        log(sourceData.CLA),wakeTime(idx),bedTime(idx),2,3);
    [firstLux{i1},lastLux{i1}] = firstLast(sourceData.Time,...
        log(sourceData.Lux),wakeTime(idx),bedTime(idx),2,3);
end

%% Save the output

end