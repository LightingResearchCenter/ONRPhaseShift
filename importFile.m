function [sourceData,sourceMeta] = importFile(fileName)
%IMPORTFILE Import numeric data from a text file as a matrix.
%   SOURCEDATA = IMPORTFILE(FILENAME) Reads
%   data from text file FILENAME for the default selection.
%
% Example:
%   sourceData =
%   importFile('Dime303wrist_Subject23_11Apr2013processed.txt');
%
%    See also TEXTSCAN.

%% Initialize variables.
delimiter = '\t';
startRow = 2;
endRow = inf;

%% Read columns of data as strings:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%f%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(fileName,'r');

%% Read columns of data according to format string.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Extract meta data from file name
meta = regexp(fileName,'Dime(\d\d\d)wrist_Subject(\d\d)_(\d\d\w\w\w\d\d\d\d)','tokens');

%% Create output variable
sourceData = dataset;
sourceData.Seconds = cell2mat(dataArray(:, 1));
sourceData.Time = cell2mat(dataArray(:, 2));
sourceData.Lux = cell2mat(dataArray(:, 3));
sourceData.CLA = cell2mat(dataArray(:, 4));
sourceData.CS = cell2mat(dataArray(:, 5));
sourceData.Activity = cell2mat(dataArray(:, 6));
sourceMeta = struct;
sourceMeta.Device = meta{1}{1};
sourceMeta.Subject = meta{1}{2};
sourceMeta.StartDate = datenum(meta{1}{3},'ddmmmyyyy');

