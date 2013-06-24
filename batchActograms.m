function batchActograms
%BATCHACTOGRAMS

% Select input and output directories
startDir = fullfile([filesep,filesep],'root','projects',...
    'ONR PhaseShift','dimesimeterData');
inputDir = uigetdir(startDir,'Select folder to import.');
outputDir = uigetdir(inputDir,'Select folder to save output.');
dirInfo = dir(fullfile(inputDir,'ref*.mat'));

% Load data, generate plots, save to disk
figure1 = figure;
n1 = length(dirInfo);
for i1 = 1:n1
    load(fullfile(inputDir,dirInfo(i1).name),'sourceData');
    fileName = regexprep(dirInfo(i1).name,'(.*)\.mat','$1');
    fileParts = regexpi(fileName,...
        'ref(\d*)_(\d\d\d\d\d\d)-(\d\d\d\d\d\d)_sub(\d\d)_(\w*)_(\w*)',...
        'tokens');
    fileTitle = {['Reference: ',fileParts{1}{1},' ',...
        datestr(datenum(fileParts{1}{2},'yymmdd')),' - ',...
        datestr(datenum(fileParts{1}{3},'yymmdd'))];...
        ['Subject: ',fileParts{1}{4},' ',fileParts{1}{5},' ',fileParts{1}{6}]};
    pseudoActogram(sourceData.Time,sourceData.Activity,sourceData.CS,...
        fileTitle,figure1);
    saveas(gcf,fullfile(outputDir,fileName),'pdf')
    clf(figure1);
    clear sourceData;
end
close(figure1);

end

