function subject9fix
%% Fix source file
fileName = '\\root\projects\ONR PhaseShift\dimesimeterData\Subject09_04Mar2013_Dime300wrist.txt';
sourceData = importFile(fileName);
% Copy data but not time
idx1 = 5824;
idx2 = 6241;
tempData = sourceData(idx1:end,3:6);
% Fill gap with 0 values
gapSize = numel(idx1:idx2);
sourceData.Lux(idx1:idx2) = 0;
sourceData.CLA(idx1:idx2) = 0;
sourceData.CS(idx1:idx2) = 0;
sourceData.Activity(idx1:idx2) = 0;
% Shorten tempData
tempData(numel(tempData.Lux) - gapSize + 1:end,:) = [];
% Recombine tempData shifted to new position
sourceData(idx2+1:end,3:6) = tempData;


%% Import the index file
indexFile = '\\root\projects\ONR PhaseShift\dimesimeterData\index.xlsx';
[subject,reference,protocol,baselineStart,baselineEnd,...
    interventionStart,interventionEnd,wakeTime,bedTime] = importIndex(indexFile);
%% Process file
addLux = 40; % Light Goggle presciption
addCLA = 623.6594955128721; % Light Goggle presciption
% Decompose file name
fileParts = regexpi('Subject09_04Mar2013_Dime300wrist.txt',...
    'Subject(\d\d)_(\d\d\w\w\w\d\d\d\d)_','tokens');
fileSubject = fileParts{1}{1};
fileDate = datenum(fileParts{1}{2},'ddmmmyyyy');
idx = strcmp(subject,fileSubject);
crossRef = find(idx,1,'first');
fileRef = reference(crossRef);
fileProtocol = protocol(crossRef);

fileWeek = 'intervention';
fileStart = interventionStart(crossRef);
fileEnd = interventionEnd(crossRef);
fileWake = wakeTime(crossRef);
fileBed = bedTime(crossRef);
% % Modify CS to include prescription
% [sourceData.CLA,sourceData.Lux,sourceData.CS] = ...
%     modLuxCLA(sourceData.Time,sourceData.CLA,sourceData.Lux,...
%     fileWake,fileBed,fileProtocol,addCLA,addLux);

% Trim data to experiment length
idx1 = sourceData.Time >= fileStart & sourceData.Time <= fileEnd;
sourceData = sourceData(idx1,:);

% Save data
outputDir = '\\root\projects\ONR PhaseShift\dimesimeterData';
outputName = fullfile(outputDir,[fileRef{1},'_',...
    datestr(fileStart,'yymmdd'),'-',...
    datestr(fileEnd,'yymmdd'),'_sub',fileSubject,'_',...
    fileProtocol{1},'_',fileWeek,'.mat']);
save(outputName,'sourceData');

end