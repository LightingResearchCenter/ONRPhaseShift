function batchActograms
%BATCHACTOGRAMS

% Select input and output directories
startDir = fullfile([filesep,filesep],'root','projects','ONR PhaseShift','dimesimeterData');
inputDir = uigetdir(startDir,'Select folder to import.');
outputDir = uigetdir(inputDir,'Select folder to save output.');
dirInfo = dir(fullfile(inputDir,'ref*.mat'));

% Load data, generate plots, save to disk
figure1 = figure;
n1 = length(dirInfo);
for i1 = 1:n1
    load(fullfile(inputDir,dirInfo(i1).name),'sourceData');
    fileName = regexprep(dirInfo(i1).name,'(.*)\.mat','$1');
    pseudoActogram(sourceData.Time,sourceData.Activity,sourceData.CS,fileName,figure1);
    saveas(gcf,fullfile(outputDir,fileName),'pdf')
    clf(figure1);
    clear sourceData;
end
close(figure1);

end

