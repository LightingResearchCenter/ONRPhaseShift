function publicationfigures
%PUBLICATIONFIGURES Summary of this function goes here
%   Detailed explanation goes here

% Specify the project directory
projectDir = '\\root\projects\ONR-PhaseShift\dimesimeterData';
saveDir = '\\root\projects\ONR-PhaseShift\graphics\fromGeoff';

% Find .mat files
Listing = dir(fullfile(projectDir,'*.mat'));
listingCell = struct2cell(Listing)';

% Specify and import the index file
indexPath = fullfile(projectDir,'index.xlsx');
[subject,reference,protocol,baselineStart,baselineEnd,...
    interventionStart,interventionEnd,wakeTime,bedTime,chronotype] = ...
    importindex2(indexPath);

% Group subjects from index
advanceProtocolIdx = strcmp('advance',protocol);
delayProtocolIdx   = strcmp('delay',protocol);
earlyChronotypeIdx = strcmp('early',chronotype);
lateChronotypeIdx  = strcmp('late',chronotype);

earlyAdvanceIdx = earlyChronotypeIdx & advanceProtocolIdx;
earlyDelayIdx   = earlyChronotypeIdx & delayProtocolIdx;
lateAdvanceIdx  = lateChronotypeIdx  & advanceProtocolIdx;
lateDelayIdx    = lateChronotypeIdx  & delayProtocolIdx;

earlyAdvanceSubject = subject(earlyAdvanceIdx);
earlyDelaySubject   = subject(earlyDelayIdx);
lateAdvanceSubject  = subject(lateAdvanceIdx);
lateDelaySubject    = subject(lateDelayIdx);

% Decompose file names
fileNameArray = listingCell(:,1);
fileSubjectArray = str2double(regexprep(fileNameArray,'.*sub(\d\d).*','$1'));
fileConditionArray = regexprep(fileNameArray,'.*[advance|delay]_(.*)\.mat','$1');
baselineIdx = strcmp(fileConditionArray,'baseline');
interventionIdx = strcmp(fileConditionArray,'intervention');
filePathArray = fullfile(projectDir,fileNameArray);

close all
set(0,'DefaultAxesFontName','Arial');
set(0,'DefaultTextFontName','Arial');
%% Figure 1: Early Chronotypes - Advancing Light-Dark Pattern
% Constants
wakeTimeArray = datenum(0,0,0,[6;5],[36;06],0);
wakeTimeStr = cellstr(datestr(wakeTimeArray,'HH:MM'));
sleepTimeArray = datenum(0,0,0,[23;21],[06;36],0);
sleepTimeStr = cellstr(datestr(sleepTimeArray,'HH:MM'));
cbtMin = datenum(0,0,0,03,48,0);
dlmo = datenum(0,0,0,20,48,0);

% Select files
fileIdx = false(size(filePathArray));
for i1 = 1:numel(earlyAdvanceSubject)
    tempIdx = fileSubjectArray == earlyAdvanceSubject(i1);
    fileIdx = fileIdx | tempIdx;
end
filePathArrayBaseline = filePathArray(fileIdx & baselineIdx);
filePathArrayIntervention = filePathArray(fileIdx & interventionIdx);

% Millerize and combine CS from files
[commonTimeArrayBaseline_days,meanCsArrayBaseline] = millerizefiles(filePathArrayBaseline);
[commonTimeArrayIntervention_days,meanCsArrayIntervention] = millerizefiles(filePathArrayIntervention);

% Plot data
hFigure = figure('Renderer','painters');
hold on;
hPlota = plot(commonTimeArrayBaseline_days,meanCsArrayBaseline);
hPlotb = plot(commonTimeArrayIntervention_days,-meanCsArrayIntervention);
formatline(hPlota);
formatline(hPlotb);
hAxes = gca;
formataxes(hAxes,'Advancing Light-Dark Pattern')
baseline(hAxes)
intervention(hAxes)
wakesleepannotation(hAxes,wakeTimeStr,sleepTimeStr)
advancing(hAxes,wakeTimeArray(2),sleepTimeArray(2))

textarrow(hAxes,cbtMin,'CBT_{min}')
textarrow(hAxes,dlmo,'DLMO')

saveas(hFigure,fullfile(saveDir,'Early Chronotypes Advancing.pdf'));

%% Figure 2: Early Chronotypes - Delaying Light-Dark Pattern
% Constants
wakeTimeArray = datenum(0,0,0,[6;5],[38;08],0);
wakeTimeStr = cellstr(datestr(wakeTimeArray,'HH:MM'));
sleepTimeArray = datenum(0,0,0,[23;21],[12;42],0);
sleepTimeStr = cellstr(datestr(sleepTimeArray,'HH:MM'));
cbtMin = datenum(0,0,0,03,59,0);
dlmo = datenum(0,0,0,20,59,0);

% Select files
fileIdx = false(size(filePathArray));
for i1 = 1:numel(earlyDelaySubject)
    tempIdx = fileSubjectArray == earlyDelaySubject(i1);
    fileIdx = fileIdx | tempIdx;
end
filePathArrayBaseline = filePathArray(fileIdx & baselineIdx);
filePathArrayIntervention = filePathArray(fileIdx & interventionIdx);

% Millerize and combine CS from files
[commonTimeArrayBaseline_days,meanCsArrayBaseline] = millerizefiles(filePathArrayBaseline);
[commonTimeArrayIntervention_days,meanCsArrayIntervention] = millerizefiles(filePathArrayIntervention);

% Plot data
hFigure = figure('Renderer','painters');
hold on;
hPlota = plot(commonTimeArrayBaseline_days,meanCsArrayBaseline);
hPlotb = plot(commonTimeArrayIntervention_days,-meanCsArrayIntervention);
formatline(hPlota);
formatline(hPlotb);
hAxes = gca;
formataxes(hAxes,'Delaying Light-Dark Pattern')
baseline(hAxes)
intervention(hAxes)
wakesleepannotation(hAxes,wakeTimeStr,sleepTimeStr)
delaying(hAxes,wakeTimeArray(2),sleepTimeArray(2))

textarrow(hAxes,cbtMin,'CBT_{min}')
textarrow(hAxes,dlmo,'DLMO')

saveas(hFigure,fullfile(saveDir,'Early Chronotypes Delaying.pdf'));

%% Figure 3: Late Chronotypes - Advancing Light-Dark Pattern
% Constants
wakeTimeArray = datenum(0,0,0,[9;7],[09;39],0);
wakeTimeStr = cellstr(datestr(wakeTimeArray,'HH:MM'));
sleepTimeArray = datenum(0,0,0,[01;23],[00;32],0);
sleepTimeStr = cellstr(datestr(sleepTimeArray,'HH:MM'));
cbtMin = datenum(0,0,0,04,31,0);
dlmo = datenum(0,0,0,21,31,0);

% Select files
fileIdx = false(size(filePathArray));
for i1 = 1:numel(lateAdvanceSubject)
    tempIdx = fileSubjectArray == lateAdvanceSubject(i1);
    fileIdx = fileIdx | tempIdx;
end
filePathArrayBaseline = filePathArray(fileIdx & baselineIdx);
filePathArrayIntervention = filePathArray(fileIdx & interventionIdx);

% Millerize and combine CS from files
[commonTimeArrayBaseline_days,meanCsArrayBaseline] = millerizefiles(filePathArrayBaseline);
[commonTimeArrayIntervention_days,meanCsArrayIntervention] = millerizefiles(filePathArrayIntervention);

% Plot data
hFigure = figure('Renderer','painters');
hold on;
hPlota = plot(commonTimeArrayBaseline_days,meanCsArrayBaseline);
hPlotb = plot(commonTimeArrayIntervention_days,-meanCsArrayIntervention);
formatline(hPlota);
formatline(hPlotb);
hAxes = gca;
formataxes(hAxes,'Advancing Light-Dark Pattern')
baseline(hAxes)
intervention(hAxes)
wakesleepannotation(hAxes,wakeTimeStr,sleepTimeStr)
advancing(hAxes,wakeTimeArray(2),sleepTimeArray(2))

textarrow(hAxes,cbtMin,'CBT_{min}')
textarrow(hAxes,dlmo,'DLMO')

saveas(hFigure,fullfile(saveDir,'Late Chronotypes Advancing.pdf'));

%% Figure 4: Late Chronotypes - Delaying Light-Dark Pattern
% Constants
wakeTimeArray = datenum(0,0,0,[6;5],[38;08],0);
wakeTimeStr = cellstr(datestr(wakeTimeArray,'HH:MM'));
sleepTimeArray = datenum(0,0,0,[23;21],[12;42],0);
sleepTimeStr = cellstr(datestr(sleepTimeArray,'HH:MM'));
cbtMin = datenum(0,0,0,04,37,0);
dlmo = datenum(0,0,0,21,37,0);

% Select files
fileIdx = false(size(filePathArray));
for i1 = 1:numel(lateDelaySubject)
    tempIdx = fileSubjectArray == earlyDelaySubject(i1);
    fileIdx = fileIdx | tempIdx;
end
filePathArrayBaseline = filePathArray(fileIdx & baselineIdx);
filePathArrayIntervention = filePathArray(fileIdx & interventionIdx);

% Millerize and combine CS from files
[commonTimeArrayBaseline_days,meanCsArrayBaseline] = millerizefiles(filePathArrayBaseline);
[commonTimeArrayIntervention_days,meanCsArrayIntervention] = millerizefiles(filePathArrayIntervention);

% Plot data
hFigure = figure('Renderer','painters');
hold on;
hPlota = plot(commonTimeArrayBaseline_days,meanCsArrayBaseline);
hPlotb = plot(commonTimeArrayIntervention_days,-meanCsArrayIntervention);
formatline(hPlota);
formatline(hPlotb);
hAxes = gca;
formataxes(hAxes,'Delaying Light-Dark Pattern')
baseline(hAxes)
intervention(hAxes)
wakesleepannotation(hAxes,wakeTimeStr,sleepTimeStr)
delaying(hAxes,wakeTimeArray(2),sleepTimeArray(2))

textarrow(hAxes,cbtMin,'CBT_{min}')
textarrow(hAxes,dlmo,'DLMO')

saveas(hFigure,fullfile(saveDir,'Late Chronotypes Delaying.pdf'));

end

function formatline(hArea)
hArea.Color = [104,104,104]/255;

end

function formataxes(hAxes,plotTitle)
% Make the specified axes active
axes(hAxes);

% Create and format the title
hTitle = title(hAxes,plotTitle);

% Format all axes
hAxes.TickDir = 'out';
hAxes.Box     = 'off';
hAxes.GridColor = [0,0,0];
hAxes.MinorGridColor = [0,0,0];
hAxes.XColor = [0,0,0];
hAxes.YColor = [0,0,0];
hAxes.ZColor = [0,0,0];

% Label and format the x-axis
datetick(hAxes,'x','keeplimits');
hXlabel = xlabel(hAxes,'Time');
hXlabel.VerticalAlignment = 'cap';

% Label and format the y-axis
ylabel(hAxes,'Circadian Stimulus (CS)');
hAxes.YLim = [-0.5,0.5];
hAxes.YTick = -0.5:0.1:0.5;
hAxes.YTickLabel = abs(hAxes.YTick);

% Close in box around plot
boxX = [hAxes.XLim(1),hAxes.XLim(2),hAxes.XLim(2)];
boxY = [hAxes.YLim(2),hAxes.YLim(2),hAxes.YLim(1)];
line(boxX,boxY,'Color','k')

% Create line at 0
line(hAxes.XLim,[0,0],'Color','k')

end


function baseline(hAxes)
x = hAxes.XLim(2)+.025;
y = hAxes.YLim(2)/2;
hText = text(x,y,'Baseline');
hText.HorizontalAlignment = 'center';
hText.VerticalAlignment = 'top';
hText.Rotation = 90;

end

function intervention(hAxes)
x = hAxes.XLim(2)+.025;
y = hAxes.YLim(1)/2;
hText = text(x,y,'Intervention');
hText.HorizontalAlignment = 'center';
hText.VerticalAlignment = 'top';
hText.Rotation = 90;

end

function wakesleepannotation(hAxes,wakeTimeStr,sleepTimeStr)
x = hAxes.XLim(1) + .025;
y = hAxes.YLim*.75;

str1 = {['Wake ',wakeTimeStr{1}];['Sleep ',sleepTimeStr{1}]};
hText1 = text(x,y(2),str1);
hText1.VerticalAlignment = 'top';
hText1.HorizontalAlignment = 'left';

str2 = {['Wake ',wakeTimeStr{2}];['Sleep ',sleepTimeStr{2}]};
hText2 = text(x,y(1),str2);
hText2.VerticalAlignment = 'bottom';
hText2.HorizontalAlignment = 'left';
end

function advancing(hAxes,wakeTime,sleepTime)
twoHours = 2/24;
threeHours = 3/24;

y = [0,0,hAxes.YLim(1),hAxes.YLim(1)];
xBlueGoggles = [wakeTime,wakeTime+twoHours,wakeTime+twoHours,wakeTime];
xOrangeGlasses = [sleepTime,sleepTime-threeHours,sleepTime-threeHours,sleepTime];
C = ones(size(y));

blue = [191,204,230]/255;
hBlueGoggles = patch(xBlueGoggles,y,C);
hBlueGoggles.FaceColor = blue;
hBlueGoggles.FaceAlpha = 0.5;
hBlueGoggles.EdgeColor = 'none';

orange = [255,217,191]/255;
hOrangeGlasses = patch(xOrangeGlasses,y,C);
hOrangeGlasses.FaceColor = orange;
hOrangeGlasses.FaceAlpha = 0.5;
hOrangeGlasses.EdgeColor = 'none';

hLegend = legend([hBlueGoggles,hOrangeGlasses],'Blue Goggles','Orange Glasses');
hLegend.Location = 'southoutside';
hLegend.Orientation = 'horizontal';
end

function delaying(hAxes,wakeTime,sleepTime)
twoHours = 2/24;
threeHours = 3/24;

y = [0,0,hAxes.YLim(1),hAxes.YLim(1)];
xBlueGoggles = [sleepTime,sleepTime-threeHours,sleepTime-threeHours,sleepTime];
xOrangeGlasses = [wakeTime,wakeTime+twoHours,wakeTime+twoHours,wakeTime];
C = ones(size(y));

blue = [191,204,230]/255;
hBlueGoggles = patch(xBlueGoggles,y,C);
hBlueGoggles.FaceColor = blue;
hBlueGoggles.FaceAlpha = 0.5;
hBlueGoggles.EdgeColor = 'none';

orange = [255,217,191]/255;
hOrangeGlasses = patch(xOrangeGlasses,y,C);
hOrangeGlasses.FaceColor = orange;
hOrangeGlasses.FaceAlpha = 0.5;
hOrangeGlasses.EdgeColor = 'none';

hLegend = legend([hBlueGoggles,hOrangeGlasses],'Blue Goggles','Orange Glasses');
hLegend.Location = 'southoutside';
hLegend.Orientation = 'horizontal';
end


function textarrow(hAxes,xValue,annotationStr)

x = [xValue,xValue];
y = [hAxes.YLim(2)*.25,0];
set(gcf,'Units','normalized');
[x,y] = axescoord2figurecoord(x,y);
annotation('textarrow',x,y,'String',annotationStr);

end
