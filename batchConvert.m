function errors = batchConvert
%BATCHCONVERT Convert all processed Daysimeter text files to MATLAB
%   Iterates through contents of folder

startDir = fullfile([filesep,filesep],'root','projects','ONR PhaseShift','dimesimeterData');
inputDir = uigetdir(startDir,'Select folder to import.');
outputDir = uigetdir(inputDir,'Select folder to save output.');
indexFile = fullfile(inputDir,'index.xlsx');
[subject,reference,protocol,baselineStart,baselineEnd,interventionStart,interventionEnd] = importIndex(indexFile);
dirInfo = dir(fullfile(inputDir,'Subject*'));
n1 = length(dirInfo);
errors = cell(n1,3);
for i1 = 1:n1
    fileParts = regexpi(dirInfo(i1).name,'Subject(\d\d)_(\d\d\w\w\w\d\d\d\d)_','tokens');
    fileSubject{i1} = fileParts{1}{1};
    fileDate{i1} = datenum(fileParts{1}{2},'ddmmyyyy');
    idx = strcmp(subject,fileSubject(i1));
    crossRef = find(idx,1,'first');
    fileRef{i1} = reference(crossRef);
    fileProtocol{i1} = protocol(crossRef);
    
    if fileDate{i1} > interventionStart(crossRef)
        fileWeek{i1} = 'intervention';
        fileStart{i1} = interventionStart(crossRef);
        fileEnd{i1} = interventionEnd(crossRef);
    else
        fileWeek{i1} = 'baseline';
        fileStart{i1} = baselineStart(crossRef);
        fileEnd{i1} = baselineEnd(crossRef);
    end
    
    try
                sourceData = importFile(fullfile(inputDir,dirInfo(i1).name));
    catch err
        errors{i1,1} = dirInfo(i1).name;
        errors{i1,2} = err;
        continue;
    end
    
    try
        outputName = fullfile(outputDir,[fileRef{i1}{1},'_',...
            datestr(fileStart{i1},'yymmdd'),'-',...
            datestr(fileEnd{i1},'yymmdd'),'.mat']);
        save(outputName,'sourceData');
    catch err
        errors{i1,3} = err;
        continue;
    end
    clear('sourceData');
end

end

