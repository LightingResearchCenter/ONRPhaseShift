clear
%% Fix source file
fileName = '\\root\projects\ONR PhaseShift\dimesimeterData\Subject33_29Apr2013_Dime299wrist.txt';
sourceData = importFile(fileName);
dT = datenum(2013,4,25,8,0,0) - sourceData.Time(8994);
sourceData.Time = sourceData.Time + dT;
dS = dT * 24 * 60 * 60;
sourceData.Seconds = sourceData.Seconds + dS;
%% Import the index file
indexFile = '\\root\projects\ONR PhaseShift\dimesimeterData\index.xlsx';
[subject,reference,protocol,baselineStart,baselineEnd,...
    interventionStart,interventionEnd,wakeTime,bedTime] = importIndex(indexFile);
%% Process file
addLux = 40; % Light Goggle presciption
addCLA = 623.6594955128721; % Light Goggle presciption
% Decompose file name
fileSubject = '33';
fileDate = datenum('29Apr2013','ddmmmyyyy');
idx = strcmp(subject,fileSubject);
crossRef = find(idx,1,'first');
fileRef = reference(crossRef);
fileProtocol = protocol(crossRef);
% Determine if week is intervention or baseline
if fileDate > interventionStart(crossRef)
    fileWeek = 'intervention';
    fileStart = interventionStart(crossRef);
    fileEnd = interventionEnd(crossRef);
    fileWake = wakeTime(crossRef);
    fileBed = bedTime(crossRef);
    % Modify CS to include prescription
    [sourceData.CLA,sourceData.Lux,sourceData.CS] = ...
        modLuxCLA(sourceData.Time,sourceData.CLA,sourceData.Lux,...
        fileWake,fileBed,fileProtocol,addCLA,addLux);
else
    fileWeek = 'baseline';
    fileStart = baselineStart(crossRef);
    fileEnd = baselineEnd(crossRef);
end

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