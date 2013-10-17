function firstLastCS
addpath('phasorReport');

%% Select input and output directories
startDir = fullfile([filesep,filesep],'root','projects',...
    'ONR PhaseShift');
inputDir = fullfile(startDir,'dimesimeterData');
outputDir = fullfile(startDir,'results');
dirInfo = dir(fullfile(inputDir,'ref*.mat'));

%% Process files

n1 = length(dirInfo);
for i1 = 1:n1
    % Load file and decompose file name
    load(fullfile(inputDir,dirInfo(i1).name),'sourceData');
    fileName = regexprep(dirInfo(i1).name,'(.*)\.mat','$1');
    fileParts = regexpi(fileName,...
        'ref(\d*)_(\d\d\d\d\d\d)-(\d\d\d\d\d\d)_sub(\d\d)_(\w*)_(\w*)',...
        'tokens');
    fileTitle = {['Reference: ',fileParts{1}{1},' ',...
        datestr(datenum(fileParts{1}{2},'yymmdd')),' - ',...
        datestr(datenum(fileParts{1}{3},'yymmdd'))];...
        ['Subject: ',fileParts{1}{4},' ',fileParts{1}{5},' ',fileParts{1}{6}]};
%     PhasorReport(,,sourceData.Activity,fileTitle)
    [firstCS,lastCS] = firstLast(sourceData.Time,sourceData.CS,wakeTime,bedTime,2,3)
end


end