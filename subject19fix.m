clear
%% Fix source file
fileName = '\\root\projects\ONR PhaseShift\dimesimeterData\Subject19_01Apr2013_Dime300wrist.txt';
sourceData = importFile(fileName);
clear fileName;
sourceData(2045:15138,2:6) = sourceData(1630:14723,2:6);
sourceData.Lux(1630:2044) = 0;
sourceData.CLA(1630:2044) = 0;
sourceData.CS(1630:2044) = 0;
sourceData.Activity(1630:2044) = 0;
dT = sourceData.Time(2) - sourceData.Time(1);
sourceData.Time(1:15138) = sourceData.Time(1):dT:sourceData.Time(1)+dT*15137;
dS = sourceData.Seconds(2) - sourceData.Seconds(1);
sourceData.Seconds(1:15138) = sourceData.Seconds(1):dS:sourceData.Seconds(1)+dS*15137;
clear dT dS
%% Import the index file
indexFile = '\\root\projects\ONR PhaseShift\dimesimeterData\index.xlsx';
[subject,reference,protocol,baselineStart,baselineEnd,...
    interventionStart,interventionEnd,wakeTime,bedTime] = importIndex(indexFile);
%% Process file
addCS = 0.455014217914063; % Light Goggle CS presciption
% Decompose file name
fileSubject = '19';
fileDate = datenum('01Apr2013','ddmmmyyyy');
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
    sourceData.CS = modCS(sourceData.Time,sourceData.CS,...
        fileWake,fileBed,fileProtocol,addCS);
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