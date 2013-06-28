function errors = batchConvert
%BATCHCONVERT Convert all processed Daysimeter text files to MATLAB
%   Iterates through contents of folder

%% Select input and output locations
startDir = fullfile([filesep,filesep],'root','projects',...
    'ONR PhaseShift','dimesimeterData');
inputDir = uigetdir(startDir,'Select folder to import.');
outputDir = uigetdir(inputDir,'Select folder to save output.');
%% Import the index file
indexFile = fullfile(inputDir,'index.xlsx');
[subject,reference,protocol,baselineStart,baselineEnd,...
    interventionStart,interventionEnd,wakeTime,bedTime] = importIndex(indexFile);
%% Search input directory for files
dirInfo = dir(fullfile(inputDir,'Subject*'));
%% Process file
% Preallocate variables
n1 = length(dirInfo);
errors = cell(n1,4);
addCS = 0.455014217914063; % Light Goggle CS presciption
for i1 = 1:n1
    errors{i1,1} = dirInfo(i1).name;
    % Import data
    try
        sourceData = importFile(fullfile(inputDir,dirInfo(i1).name));
    catch err
        errors{i1,2} = err;
        continue;
    end
    % Decompose file name
    fileParts = regexpi(dirInfo(i1).name,...
        'Subject(\d\d)_(\d\d\w\w\w\d\d\d\d)_','tokens');
    fileSubject = fileParts{1}{1};
    fileDate = datenum(fileParts{1}{2},'ddmmmyyyy');
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
    try
    idx1 = sourceData.Time >= fileStart & sourceData.Time <= fileEnd;
    catch err
        errors{i1,3} = err;
        continue;
    end
    sourceData = sourceData(idx1,:);
    
    % Save data
    try
        outputName = fullfile(outputDir,[fileRef{1},'_',...
            datestr(fileStart,'yymmdd'),'-',...
            datestr(fileEnd,'yymmdd'),'_sub',fileSubject,'_',...
            fileProtocol{1},'_',fileWeek,'.mat']);
        save(outputName,'sourceData');
    catch err
        errors{i1,4} = err;
        continue;
    end
    clear('sourceData');
end

end

