function batchReport
addpath('phasorReport');

%% Select input and output directories
startDir = fullfile([filesep,filesep],'root','projects',...
    'ONR PhaseShift','dimesimeterData');
inputDir = uigetdir(startDir,'Select folder to import.');
outputDir = uigetdir(fullfile(inputDir,'phasorReports'),'Select folder to save output.');
dirInfo = dir(fullfile(inputDir,'ref*.mat'));

%% Create figure
figure1 = figure(1);
paperPosition = [0 0 8.5 11];
set(figure1,'PaperUnits','inches',...
    'PaperType','usletter',...
    'PaperOrientation','portrait',...
    'PaperPositionMode','manual',...
    'PaperPosition',paperPosition,...
    'Units','inches',...
    'Position',paperPosition);

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
    % Create Plot
    PhasorReport(sourceData.Time,sourceData.CS,sourceData.Activity,fileTitle)
    saveas(figure1,fullfile(outputDir,fileName),'pdf')
    clf(figure1);
end
close(figure1);

end