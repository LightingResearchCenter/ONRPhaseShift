function publicationfigures
%PUBLICATIONFIGURES Summary of this function goes here
%   Detailed explanation goes here

% Specify the project directory
projectDir = '\\root\projects\ONR-PhaseShift\dimesimeterData';
saveDir = '\\root\projects\ONR-PhaseShift\graphics\fromGeoff\single plots';

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

earlyAdvanceWake = wakeTime(earlyAdvanceIdx);
earlyDelayWake   = wakeTime(earlyDelayIdx);
lateAdvanceWake  = wakeTime(lateAdvanceIdx);
lateDelayWake    = wakeTime(lateDelayIdx);

earlyAdvanceBed = bedTime(earlyAdvanceIdx);
earlyDelayBed   = bedTime(earlyDelayIdx);
lateAdvanceBed  = bedTime(lateAdvanceIdx);
lateDelayBed    = bedTime(lateDelayIdx);

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
%% Figure 1: Early Group - Advancing Light-Dark Pattern
% Constants
wakeTimeArray = [datenum(0,0,0,6,36,0);datenum(0,0,0,5,06,0)];
sleepTimeArray = [datenum(0,0,0,23,06,0);datenum(0,0,0,21,36,0)];
cbtMin = datenum(0,0,0,03,48,0);
dlmo = datenum(0,0,0,20,48,0);
interventionWake = earlyAdvanceWake;
interventionBed  = earlyAdvanceBed;

% Select files
fileIdx = false(size(filePathArray));
for i1 = 1:numel(earlyAdvanceSubject)
    tempIdx = fileSubjectArray == earlyAdvanceSubject(i1);
    fileIdx = fileIdx | tempIdx;
end
filePathArrayBaseline = filePathArray(fileIdx & baselineIdx);
filePathArrayIntervention = filePathArray(fileIdx & interventionIdx);

figTitle = 'Advancing Light-Dark Pattern';
savePath = fullfile(saveDir,'Early Group Advancing.pdf');

createfigure(filePathArrayBaseline,filePathArrayIntervention,wakeTimeArray,sleepTimeArray,cbtMin,dlmo,savePath,figTitle,'advancing',interventionWake,interventionBed)


%% Figure 2: Early Group - Delaying Light-Dark Pattern
% Constants
wakeTimeArray = [datenum(0,0,0,6,38,0);datenum(0,0,0,5,08,0)];
sleepTimeArray = [datenum(0,0,0,23,12,0);datenum(0,0,0,21,42,0)];
cbtMin = datenum(0,0,0,03,59,0);
dlmo = datenum(0,0,0,20,59,0);
interventionWake = earlyDelayWake;
interventionBed  = earlyDelayBed;

% Select files
fileIdx = false(size(filePathArray));
for i1 = 1:numel(earlyDelaySubject)
    tempIdx = fileSubjectArray == earlyDelaySubject(i1);
    fileIdx = fileIdx | tempIdx;
end
filePathArrayBaseline = filePathArray(fileIdx & baselineIdx);
filePathArrayIntervention = filePathArray(fileIdx & interventionIdx);

figTitle = 'Delaying Light-Dark Pattern';
savePath = fullfile(saveDir,'Early Group Delaying.pdf');

createfigure(filePathArrayBaseline,filePathArrayIntervention,wakeTimeArray,sleepTimeArray,cbtMin,dlmo,savePath,figTitle,'delaying',interventionWake,interventionBed)


%% Figure 3: Late Group - Advancing Light-Dark Pattern
% Constants
wakeTimeArray = [datenum(0,0,0,9,09,0);datenum(0,0,0,7,39,0)];
sleepTimeArray = [datenum(0,0,0,01,00,0);datenum(0,0,0,23,32,0)];
cbtMin = datenum(0,0,0,04,31,0);
dlmo = datenum(0,0,0,21,31,0);
interventionWake = lateAdvanceWake;
interventionBed  = lateAdvanceBed;

% Select files
fileIdx = false(size(filePathArray));
for i1 = 1:numel(lateAdvanceSubject)
    tempIdx = fileSubjectArray == lateAdvanceSubject(i1);
    fileIdx = fileIdx | tempIdx;
end
filePathArrayBaseline = filePathArray(fileIdx & baselineIdx);
filePathArrayIntervention = filePathArray(fileIdx & interventionIdx);

figTitle = 'Advancing Light-Dark Pattern';
savePath = fullfile(saveDir,'Late Group Advancing.pdf');

createfigure(filePathArrayBaseline,filePathArrayIntervention,wakeTimeArray,sleepTimeArray,cbtMin,dlmo,savePath,figTitle,'advancing',interventionWake,interventionBed)

%% Figure 4: Late Group - Delaying Light-Dark Pattern
% Constants
wakeTimeArray = [datenum(0,0,0,9,13,0);datenum(0,0,0,7,43,0)];
sleepTimeArray = [datenum(0,0,0,00,49,0);datenum(0,0,0,23,19,0)];
cbtMin = datenum(0,0,0,04,37,0);
dlmo = datenum(0,0,0,21,37,0);
interventionWake = lateDelayWake;
interventionBed  = lateDelayBed;

% Select files
fileIdx = false(size(filePathArray));
for i1 = 1:numel(lateDelaySubject)
    tempIdx = fileSubjectArray == lateDelaySubject(i1);
    fileIdx = fileIdx | tempIdx;
end
filePathArrayBaseline = filePathArray(fileIdx & baselineIdx);
filePathArrayIntervention = filePathArray(fileIdx & interventionIdx);

figTitle = 'Delaying Light-Dark Pattern';
savePath = fullfile(saveDir,'Late Group Delaying.pdf');

createfigure(filePathArrayBaseline,filePathArrayIntervention,wakeTimeArray,sleepTimeArray,cbtMin,dlmo,savePath,figTitle,'delaying',interventionWake,interventionBed)

end

%%
function createfigure(filePathArrayBaseline,filePathArrayIntervention,wakeTimeArray,sleepTimeArray,cbtMin,dlmo,savePath,figTitle,advanceDelay,interventionWake,interventionBed)

wakeTimeStr = cellstr(datestr(wakeTimeArray,'HH:MM'));
sleepTimeStr = cellstr(datestr(sleepTimeArray,'HH:MM'));

% Millerize and combine CS from files
[commonTimeArrayBaseline_days,meanCsArrayBaseline] = millerizefiles(filePathArrayBaseline);
[commonTimeArrayIntervention_days,meanCsArrayIntervention] = millerizefiles(filePathArrayIntervention);

% Plot data
hFigure = figure('Renderer','painters');
hold on;
hPlota = plot(commonTimeArrayBaseline_days,meanCsArrayBaseline);
hPlotb = plot(commonTimeArrayIntervention_days,-meanCsArrayIntervention);
formatplot(hPlota);
formatplot(hPlotb);
hAxes = gca;
formataxes(hAxes,figTitle)
baseline(hAxes)
intervention(hAxes)
wakesleepannotation(hAxes,wakeTimeStr,sleepTimeStr)
if strcmp(advanceDelay,'advancing')
    advancing(hAxes,wakeTimeArray(2),sleepTimeArray(2),interventionWake,interventionBed)
else
    delaying(hAxes,wakeTimeArray(2),sleepTimeArray(2),interventionWake,interventionBed)
end

textarrow([cbtMin,cbtMin],[hAxes.YLim(2)*.25,0],['CBT_{min} ',datestr(cbtMin,'HH:MM')])
textarrow([dlmo,dlmo],[hAxes.YLim(2)*.25,0],['DLMO ',datestr(dlmo,'HH:MM')])

saveas(hFigure,savePath);
end

%%
function formatplot(hPlot)
hPlot.Color = [0,0,0]/255;
end

%%
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
hAxes.YLim = [-0.7,0.7];
hAxes.YTick = -0.7:0.1:0.7;
hAxes.YTickLabel = abs(hAxes.YTick);

% Close in box around plot
boxX = [hAxes.XLim(1),hAxes.XLim(2),hAxes.XLim(2)];
boxY = [hAxes.YLim(2),hAxes.YLim(2),hAxes.YLim(1)];
line(boxX,boxY,'Color','k')

% Create line at 0
line(hAxes.XLim,[0,0],'Color','k')

end

%%
function baseline(hAxes)
x = hAxes.XLim(2)+.025;
y = hAxes.YLim(2)/2;
hText = text(x,y,'Baseline');
hText.HorizontalAlignment = 'center';
hText.VerticalAlignment = 'top';
hText.Rotation = 90;

end

%%
function intervention(hAxes)
x = hAxes.XLim(2)+.025;
y = hAxes.YLim(1)/2;
hText = text(x,y,'Intervention');
hText.HorizontalAlignment = 'center';
hText.VerticalAlignment = 'top';
hText.Rotation = 90;

end

%%
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

%%
function advancing(hAxes,wakeTime,sleepTime,interventionWake,interventionBed)
idx = interventionBed < .5;
interventionBed(idx) = interventionBed(idx) + 1;

twoHours = 2/24;
threeHours = 3/24;

yBlue   = [hAxes.YLim(1)*.8,0];
yOrange = [hAxes.YLim(1)*.8,0];
xBlue   = wakeTime+twoHours/2;
xOrange = sleepTime-threeHours/2;

textarrow([xBlue,xBlue],yBlue,'Blue Glasses')
textarrow([xOrange,xOrange],yOrange,'Orange Glasses')


black = [0,0,0]/255;

y = [0,0,hAxes.YLim(1)*.7,hAxes.YLim(1)*.7];
C = ones(size(y));
xBlueGoggles = [min(interventionWake),max(interventionWake)+twoHours,max(interventionWake)+twoHours,min(interventionWake)];
if max(interventionBed) > 1
    xOrangeGlasses = [1,min(interventionBed)-threeHours,min(interventionBed)-threeHours,1];
    hOrangeGlasses = patch(xOrangeGlasses,y,C);
    hOrangeGlasses.FaceColor = black;
    hOrangeGlasses.FaceAlpha = 0.5;
    hOrangeGlasses.EdgeColor = 'none';
    
    xOrangeGlasses = [mod(max(interventionBed),1),0,0,mod(max(interventionBed),1)];
    hOrangeGlasses = patch(xOrangeGlasses,y,C);
    hOrangeGlasses.FaceColor = black;
    hOrangeGlasses.FaceAlpha = 0.5;
    hOrangeGlasses.EdgeColor = 'none';
    
else
    xOrangeGlasses = [max(interventionBed),min(interventionBed)-threeHours,min(interventionBed)-threeHours,max(interventionBed)];
    hOrangeGlasses = patch(xOrangeGlasses,y,C);
    hOrangeGlasses.FaceColor = black;
    hOrangeGlasses.FaceAlpha = 0.5;
    hOrangeGlasses.EdgeColor = 'none';
end

hBlueGoggles = patch(xBlueGoggles,y,C);
hBlueGoggles.FaceColor = black;
hBlueGoggles.FaceAlpha = 0.5;
hBlueGoggles.EdgeColor = 'none';



end

%%
function delaying(hAxes,wakeTime,sleepTime,interventionWake,interventionBed)

idx = interventionBed < .5;
interventionBed(idx) = interventionBed(idx) + 1;

twoHours = 2/24;
threeHours = 3/24;

yBlue   = [hAxes.YLim(1)*.8,0];
yOrange = [hAxes.YLim(1)*.8,0];
xBlue   = sleepTime-threeHours/2;
xOrange = wakeTime+twoHours/2;

textarrow([xBlue,xBlue],yBlue,'Blue Glasses')
textarrow([xOrange,xOrange],yOrange,'Orange Glasses')

black = [0,0,0]/255;

y = [0,0,hAxes.YLim(1)*.7,hAxes.YLim(1)*.7];
C = ones(size(y));

xOrangeGlasses = [min(interventionWake),max(interventionWake)+twoHours,max(interventionWake)+twoHours,min(interventionWake)];
if max(interventionBed) > 1
    xBlueGoggles = [1,min(interventionBed)-threeHours,min(interventionBed)-threeHours,1];
    hBlueGoggles = patch(xBlueGoggles,y,C);
    hBlueGoggles.FaceColor = black;
    hBlueGoggles.FaceAlpha = 0.5;
    hBlueGoggles.EdgeColor = 'none';

    xBlueGoggles = [mod(max(interventionBed),1),0,0,mod(max(interventionBed),1)];
    hBlueGoggles = patch(xBlueGoggles,y,C);
    hBlueGoggles.FaceColor = black;
    hBlueGoggles.FaceAlpha = 0.5;
    hBlueGoggles.EdgeColor = 'none';
else
    xBlueGoggles = [max(interventionBed),min(interventionBed)-threeHours,min(interventionBed)-threeHours,max(interventionBed)];
    hBlueGoggles = patch(xBlueGoggles,y,C);
    hBlueGoggles.FaceColor = black;
    hBlueGoggles.FaceAlpha = 0.5;
    hBlueGoggles.EdgeColor = 'none';
end

hOrangeGlasses = patch(xOrangeGlasses,y,C);
hOrangeGlasses.FaceColor = black;
hOrangeGlasses.FaceAlpha = 0.5;
hOrangeGlasses.EdgeColor = 'none';

end

%%
function textarrow(x,y,annotationStr)
set(gcf,'Units','normalized');
[x,y] = axescoord2figurecoord(x,y);
annotation('textarrow',x,y,'String',annotationStr);

end
