function [subject,reference,protocol,baselineStart,baselineEnd,interventionStart,interventionEnd,wakeTime,bedTime] = importIndex(workbookFile,sheetName,startRow,endRow)
%IMPORTFILE1 Import data from a spreadsheet
%   [subject,reference,protocol,baselineStart,baselineEnd,interventionStart,interventionEnd,wakeTime,bedTime]
%   = IMPORTINDEX(FILE) reads data from the first worksheet in the
%   Microsoft Excel spreadsheet file named FILE and returns the data as
%   column vectors.
%
%   [subject,reference,protocol,baselineStart,baselineEnd,interventionStart,interventionEnd,wakeTime,bedTime]
%   = IMPORTINDEX(FILE,SHEET) reads from the specified worksheet.
%
%   [subject,reference,protocol,baselineStart,baselineEnd,interventionStart,interventionEnd,wakeTime,bedTime]
%   = IMPORTINDEX(FILE,SHEET,STARTROW,ENDROW) reads from the specified
%   worksheet for the specified row interval(s). Specify STARTROW and
%   ENDROW as a pair of scalars or vectors of matching size for
%   dis-contiguous row intervals. To read to the end of the file specify an
%   ENDROW of inf.
%
%	Date formatted cells are converted to MATLAB serial date number format
%	(datenum).
%
% Example:
%   [subject,reference,protocol,baselineStart,baselineEnd,interventionStart,interventionEnd,wakeTime,bedTime]
%   = importIndex('index.xlsx','Sheet1',2,41);
%
%   See also XLSREAD.

% Auto-generated by MATLAB on 2013/06/27 12:34:17

%% Input handling

% If no sheet is specified, read first sheet
if nargin == 1 || isempty(sheetName)
    sheetName = 1;
end

% If row start and end points are not specified, define defaults
if nargin <= 3
    startRow = 2;
    endRow = 47;
end

%% Import the data, extracting spreadsheet dates in MATLAB serial date number format (datenum)
[~, ~, raw, dateNums] = xlsread(workbookFile, sheetName, sprintf('A%d:I%d',startRow(1),endRow(1)),'' , @convertSpreadsheetDates);
for block=2:length(startRow)
    [~, ~, tmpRawBlock,tmpDateNumBlock] = xlsread(workbookFile, sheetName, sprintf('A%d:I%d',startRow(block),endRow(block)),'' , @convertSpreadsheetDates);
    raw = [raw;tmpRawBlock]; %#ok<AGROW>
    dateNums = [dateNums;tmpDateNumBlock]; %#ok<AGROW>
end
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
cellVectors = raw(:,[2,3]);
raw = raw(:,[1,4,5,6,7,8,9]);
dateNums = dateNums(:,[1,4,5,6,7,8,9]);

%% Replace date strings by MATLAB serial date numbers (datenum)
R = ~cellfun(@isequalwithequalnans,dateNums,raw) & cellfun('isclass',raw,'char'); % Find spreadsheet dates
raw(R) = dateNums(R);

%% Create output variable
data = reshape([raw{:}],size(raw));

%% Allocate imported array to column variable names
subjectTemp = data(:,1);
reference = cellVectors(:,1);
protocol = cellVectors(:,2);
baselineStart = data(:,2);
baselineEnd = data(:,3);
interventionStart = data(:,4);
interventionEnd = data(:,5);
wakeTime = data(:,6);
bedTime = data(:,7);

%% Convert subject numbers to cell vector of strings
subjectStr = num2str(subjectTemp,'%02.0f');
subject = num2cell(subjectStr,2);

