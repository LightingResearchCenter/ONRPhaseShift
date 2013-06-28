function millerPlot(datetime, AI, CS, axes1)
%MILLERPLOT Creates overlapping area plots of activity index and circadian
%stimulus for a 24 hour period.
%   time is in MATLAB date time series format
%   AI is activity index from a Daysimeter or Dimesimeter
%   CS is Circadian Stimulus from a Daysimeter or Dimesimeter
%   days is number of days experiment ran for

TI = datetime - datetime(1); % time index in days from start

% Reshape data into columns of full days
% ASSUMES CONSTANT SAMPLING RATE
dayIdx = find(TI >= 1,1,'first') - 1;
extra = rem(length(TI),dayIdx)-1;
CS(end-extra:end) = [];
AI(end-extra:end) = [];
CS = reshape(CS,dayIdx,[]);
AI = reshape(AI,dayIdx,[]);

% Average data across days
mCS = mean(CS,2);
mAI = mean(AI,2);

% Trim time index
TI = TI(1:dayIdx);
% Convert time index into hours from start
hour = TI*24;

% Find start time offset from midnight
delta = -find(datetime >= ceil(datetime(1)),1,'first');
% Appropriately offset the data
mCS = circshift(mCS,delta);
mAI = circshift(mAI,delta);

% Create area plots
% Define axes
set(axes1,'Box','off','TickDir','out');
set(axes1,'XTick',0:2:24);
xlim(axes1,[0 24]);
% ymax = ceil(max([max(AI),max(CS)])/.5)*.5;
ymax = 1;
ylim(axes1,[0 ymax]);
hold(axes1,'all');

% Plot AI
area1 = area(axes1,hour,mAI,'LineStyle','none');
set(area1,...
    'FaceColor',[0.2 0.2 0.2],'EdgeColor','none',...
    'DisplayName','Activity Index');

% Plot CS
plot1 = plot(axes1,hour,mCS);
set(plot1,...
    'Color',[0.6 0.6 0.6],'LineWidth',2,...
    'DisplayName','Circadian Stimulus');

% Create legend
legend(axes1,'Location','NorthOutside','Orientation','horizontal');

% Create x-axis label
xlabel('hour');

end

