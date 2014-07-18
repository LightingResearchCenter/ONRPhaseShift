function publicationfigures
%PUBLICATIONFIGURES Summary of this function goes here
%   Detailed explanation goes here

% Specify the project directory
projectDir = '\\root\projects\ONR-PhaseShift\dimesimeterDataNoTreatment';
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

createfigure(filePathArrayBaseline,filePathArrayIntervention,wakeTimeArray,sleepTimeArray,cbtMin,dlmo,savePath,figTitle,'advance',interventionWake,interventionBed)


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

createfigure(filePathArrayBaseline,filePathArrayIntervention,wakeTimeArray,sleepTimeArray,cbtMin,dlmo,savePath,figTitle,'delay',interventionWake,interventionBed)


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

createfigure(filePathArrayBaseline,filePathArrayIntervention,wakeTimeArray,sleepTimeArray,cbtMin,dlmo,savePath,figTitle,'advance',interventionWake,interventionBed)

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

createfigure(filePathArrayBaseline,filePathArrayIntervention,wakeTimeArray,sleepTimeArray,cbtMin,dlmo,savePath,figTitle,'delay',interventionWake,interventionBed)

end

%%
function createfigure(filePathArrayBaseline,filePathArrayIntervention,wakeTimeArray,sleepTimeArray,cbtMin,dlmo,savePath,figTitle,advanceDelay,interventionWake,interventionBed)

wakeTimeStr = cellstr(datestr(wakeTimeArray,'HH:MM'));
sleepTimeStr = cellstr(datestr(sleepTimeArray,'HH:MM'));

% Millerize and combine CS from files
[commonTimeArrayBaseline_days,meanCsArrayBaseline] = millerizefiles(filePathArrayBaseline);
[commonTimeArrayIntervention_days,meanCsArrayIntervention] = millerizefiles(filePathArrayIntervention);

% Add treatment to intervention
addCS = 0.455; % Light Goggle presciption
meanCsArrayIntervention = modifyCS(commonTimeArrayIntervention_days,meanCsArrayIntervention,wakeTimeArray(2),sleepTimeArray(2),advanceDelay,addCS);

% Plot data
hFigure = figure('Renderer','painters');
hold on;

hAxes = gca;
formataxes(hAxes,figTitle)
baseline(hAxes)
intervention(hAxes)
wakesleepannotation(hAxes,wakeTimeStr,sleepTimeStr)
plotbed(hAxes,wakeTimeArray(1),sleepTimeArray(1),'baseline');
plotbed(hAxes,wakeTimeArray(2),sleepTimeArray(2),'intervention');
if strcmp(advanceDelay,'advance')
    advancing(hAxes,wakeTimeArray(2),sleepTimeArray(2))
else
    delaying(hAxes,wakeTimeArray(2),sleepTimeArray(2))
end

textarrow([cbtMin,cbtMin],[hAxes.YLim(2)*.9,0],['CBT_{min} ',datestr(cbtMin,'HH:MM')])
textarrow([dlmo,dlmo],[hAxes.YLim(2)*.9,0],['DLMO ',datestr(dlmo,'HH:MM')])

createbox(hAxes)

hPlota = plot(commonTimeArrayBaseline_days,meanCsArrayBaseline);
hPlotb = plot(commonTimeArrayIntervention_days,-meanCsArrayIntervention);
formatplot(hPlota);
formatplot(hPlotb);

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
hAxes.Color = 'none';
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

end

function createbox(hAxes)
% Close in box around plot
x = hAxes.XLim(1);
w = hAxes.XLim(2) - x;
y = hAxes.YLim(1);
h = hAxes.YLim(2) - y;
rectangle('Position',[x,y,w,h]);

% Create line at 0
plot(hAxes.XLim,[0,0],'Color','k')
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
x = (hAxes.XLim(2) - hAxes.XLim(1))/2;
y = hAxes.YLim*.9;

str1 = {['Wake ',wakeTimeStr{1}];['Sleep ',sleepTimeStr{1}]};
hText1 = text(x,y(2),str1);
hText1.VerticalAlignment = 'top';
hText1.HorizontalAlignment = 'center';

str2 = {['Wake ',wakeTimeStr{2}];['Sleep ',sleepTimeStr{2}]};
hText2 = text(x,y(1),str2);
hText2.VerticalAlignment = 'bottom';
hText2.HorizontalAlignment = 'center';
end

%%
function advancing(hAxes,wakeTime,sleepTime)

twoHours = 2/24;
threeHours = 3/24;

gray = [96,96,96]/255;

y = hAxes.YLim(1);
h = abs(hAxes.YLim(1));
xBlueGoggles = wakeTime;

if sleepTime > 1
    xOrangeGlasses = sleepTime-threeHours;
    w = 1-xOrangeGlasses;
    hOrangeGlasses = rectangle('Position',[xOrangeGlasses,y,w,h]);
    hOrangeGlasses.FaceColor = gray;
    hOrangeGlasses.EdgeColor = 'none';
    
    xOrangeGlasses = 0;
    w = mod(sleepTime,1);
    hOrangeGlasses = rectangle('Position',[xOrangeGlasses,y,w,h]);
    hOrangeGlasses.FaceColor = gray;
    hOrangeGlasses.EdgeColor = 'none';
    
else
    xOrangeGlasses = sleepTime-threeHours;
    w = threeHours;
    hOrangeGlasses = rectangle('Position',[xOrangeGlasses,y,w,h]);
    hOrangeGlasses.FaceColor = gray;
    hOrangeGlasses.EdgeColor = 'none';
end

w = twoHours;
hBlueGoggles = rectangle('Position',[xBlueGoggles,y,w,h]);
hBlueGoggles.FaceColor = gray;
hBlueGoggles.EdgeColor = 'none';

xBlue = wakeTime + twoHours/2;
xOrange = sleepTime - threeHours/2;
lighttext(hAxes,xBlue,xOrange)
end

%%
function delaying(hAxes,wakeTime,sleepTime)
twoHours = 2/24;
threeHours = 3/24;

gray = [96,96,96]/255;

y = hAxes.YLim(1);
h = abs(hAxes.YLim(1));
xOrangeGlasses = wakeTime;

if sleepTime > 1
    xBlueGoggles = sleepTime-threeHours;
    w = 1 - xBlueGoggles;
    hBlueGoggles = rectangle('Position',[xBlueGoggles,y,w,h]);
    hBlueGoggles.FaceColor = gray;
    hBlueGoggles.EdgeColor = 'none';

    xBlueGoggles = 0;
    w = mod(sleepTime,1);
    hBlueGoggles = rectangle('Position',[xBlueGoggles,y,w,h]);
    hBlueGoggles.FaceColor = gray;
    hBlueGoggles.EdgeColor = 'none';
else
    xBlueGoggles = sleepTime-threeHours;
    w = threeHours;
    hBlueGoggles = rectangle('Position',[xBlueGoggles,y,w,h]);
    hBlueGoggles.FaceColor = gray;
    hBlueGoggles.EdgeColor = 'none';
end

w = twoHours;
hOrangeGlasses = rectangle('Position',[xOrangeGlasses,y,w,h]);
hOrangeGlasses.FaceColor = gray;
hOrangeGlasses.EdgeColor = 'none';

xBlue = sleepTime - threeHours/2;
xOrange = wakeTime + twoHours/2;
lighttext(hAxes,xBlue,xOrange)
end

%%
function lighttext(hAxes,xBlue,xOrange)

y = 0.9*hAxes.YLim(1);

hBlue = text(xBlue,y,{'Blue';'Light';'Glasses'});
hBlue.VerticalAlignment = 'bottom';
hBlue.HorizontalAlignment = 'center';

hOrange = text(xOrange,y,{'Orange';'Glasses'});
hOrange.VerticalAlignment = 'bottom';
hOrange.HorizontalAlignment = 'center';

end

%%
function textarrow(x,y,annotationStr)
set(gcf,'Units','normalized');

hText = text(x(1),y(1),annotationStr);
hText.Units = 'normalized';
hText.HorizontalAlignment = 'center';
hText.VerticalAlignment = 'top';

[x,y] = axescoord2figurecoord(x,y);
y(1) = y(1)-.05;
hArrow = annotation('arrow',x,y);

end


%%
function plotbed(hAxes,wakeTime,sleepTime,week)

gray = [192,192,192]/255;

switch week
    case 'baseline'
        yMax = hAxes.YLim(2);
    case 'intervention'
        yMax = hAxes.YLim(1);
end
y = min([0,yMax]);
h = abs(yMax);

if sleepTime > wakeTime
    xBed = sleepTime;
    w = 1 - xBed;
    hBed = rectangle('Position',[xBed,y,w,h]);
    hBed.FaceColor = gray;
    hBed.EdgeColor = 'none';

    xBed = 0;
    w = wakeTime;
    hBed = rectangle('Position',[xBed,y,w,h]);
    hBed.FaceColor = gray;
    hBed.EdgeColor = 'none';
else
    xBed = sleepTime;
    w = wakeTime - sleepTime;
    hBed = rectangle('Position',[xBed,y,w,h]);
    hBed.FaceColor = gray;
    hBed.EdgeColor = 'none';
end


end