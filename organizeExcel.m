function organizeExcel(inputFile)
%ORGANIZEEXCEL Organize input data and save to Excel
%   Format for Mariana
load(inputFile);
saveFile = regexprep(inputFile,'\.mat','\.xlsx');
inputData = out;
clear out;

%% Determine variable names
varNames = get(inputData,'VarNames');
% Remove subject, stage, and protocol from varNames
varNameIdx = strcmpi(varNames,'subject') | strcmpi(varNames,'stage') | strcmpi(varNames,'protocol');
varNames(varNameIdx) = [];
% Count the number of variables
varCount = length(varNames);

%% Create header labels
% Prepare first header row
stage0Txt = 'baseline';
stage0Mat = repmat(stage0Txt,varCount,1);
stage0Head =  mat2cell(stage0Mat,ones(1,varCount),length(stage0Txt))';

stage1Txt = 'intervention';
stage1Mat = repmat(stage1Txt,varCount,1);
stage1Head =  mat2cell(stage1Mat,ones(1,varCount),length(stage1Txt))';

header1 = [{[]},{[]},stage0Head,stage1Head]; % Combine parts of header1

% Prepare second header row
header2 = [{'subject'},{'protocol'},varNames,varNames];

% Combine headers
header = [header1;header2];

%% Organize data
% Seperate subject and stage from rest of inputData
inputData1 = dataset;
inputData1.subject = inputData.subject;
inputData1.stage = inputData.stage;
inputData1.protocol = inputData.protocol;

% Copy inputData and remove subject, stage, and protocol
inputData2 = inputData;
inputData2.subject = [];
inputData2.stage = [];
inputData2.protocol = [];

% Convert inputData2 to cells
inputData2Cell = dataset2cell(inputData2);
inputData2Cell(1,:) = []; % Remove variable names

% Identify unique subject numbers
subject = unique(inputData1.subject);

% Organize subject data by stage
nSubjects = length(subject);
outputData1 = cell(nSubjects,varCount*2+2);
for i1 = 1:nSubjects
    % Subject number
    outputData1{i1,1} = subject{i1};
    idx0 = strcmpi(subject(i1),inputData1.subject);
    % Protocol
    tempProtocol = inputData1.protocol(idx0);
    outputData1{i1,2} = tempProtocol{1};
    % stage baseline
    idx1 = idx0 & strcmpi('baseline',inputData1.stage);
    if sum(idx1) == 1
        outputData1(i1,3:varCount+2) = inputData2Cell(idx1,:);
    end
    % stage intervention
    idx2 = idx0 & strcmpi('intervention',inputData1.stage);
    if sum(idx2) == 1
        outputData1(i1,varCount+3:varCount*2+2) = inputData2Cell(idx2,:);
    end
end


%% Combine headers and data
output1 = [header;outputData1];

%% Create Excel file and write output to appropriate sheet
% Set sheet names
sheet1 = 1;
% Write to file
xlswrite(saveFile,output1,sheet1); % Create sheet1

end

