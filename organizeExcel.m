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

header1 = [{[]},stage0Head,stage1Head]; % Combine parts of header1

% Prepare second header row
header2 = [{'subject'},varNames,varNames];

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
nAdvance = sum(strcmpi('advance',inputData1.protocol));
nDelay = sum(strcmpi('delay',inputData1.protocol));
outputData1 = cell(nAdvance,varCount*2+1);
outputData2 = cell(nDelay,varCount*2+1);
count1 = 1;
count2 = 1;
for i1 = 1:nSubjects
    % Subject number
    idx0 = strcmpi(subject(i1),inputData1.subject);
    if sum(strcmpi('advance',inputData1.protocol(idx0))) > 0
        outputData1{count1,1} = subject{i1};
        % stage baseline
        idx1 = idx0 & strcmpi('baseline',inputData1.stage);
        if sum(idx1) == 1
            outputData1(count1,2:varCount+1) = inputData2Cell(idx1,:);
        end
        % stage intervention
        idx2 = idx0 & strcmpi('intervention',inputData1.stage);
        if sum(idx2) == 1
            outputData1(count1,varCount+2:varCount*2+1) = inputData2Cell(idx2,:);
        end
        count1 = count1 + 1;
    else
        outputData2{count2,1} = subject{i1};
        % stage baseline
        idx1 = idx0 & strcmpi('baseline',inputData1.stage);
        if sum(idx1) == 1
            outputData2(count2,2:varCount+1) = inputData2Cell(idx1,:);
        end
        % stage intervention
        idx2 = idx0 & strcmpi('intervention',inputData1.stage);
        if sum(idx2) == 1
            outputData2(count2,varCount+2:varCount*2+1) = inputData2Cell(idx2,:);
        end
        count2 = count2 + 1;
    end
end


%% Combine headers and data
output1 = [header;outputData1];
output2 = [header;outputData2];

%% Create Excel file and write output to appropriate sheet
% Set sheet names
sheet1 = 'advance group';
sheet2 = 'delay group';
% Write to file
xlswrite(saveFile,output1,sheet1); % Create sheet1
xlswrite(saveFile,output2,sheet2); % Create sheet2

end

