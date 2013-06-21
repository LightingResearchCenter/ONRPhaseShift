function pseudoActogram(Time,Activity,CS,Title,figure1)
%PSEUDOACTOGRAM Creates actogram like plots that also have CS plotted

% Create time index relative to midnight before start of data
TI = Time - floor(Time(1));

runTime = ceil(TI(end));

% Divide data into days independent of sampling rate
idx = cell(runTime,1);
TI1 = cell(runTime,1);
AI1 = cell(runTime,1);
CS1 = cell(runTime,1);
subTitle = cell(runTime,1);
for i1 = 1:runTime
    idx{i1} = TI >= (i1 - 1) & TI < i1;
    TI1{i1} = (TI(idx{i1}) - (i1 - 1))*24; % New time index in hours
    AI1{i1} = Activity(idx{i1});
    CS1{i1} = CS(idx{i1});
    subTitle{i1} = datestr(floor(min(Time(idx{i1}))),'mm/dd/yy');
end

% Create plot
set(figure1,'PaperUnits','inches',...
    'PaperType','usletter',...
    'PaperOrientation','portrait',...
    'PaperPositionMode','manual',...
    'PaperPosition',[0 0 8.5 11],...
    'Units','inches',...
    'Position',[0 0 8.5 11]);

title(Title);
TI2 = 0:.25:24;
for i2 = 1:runTime
    % Make sure time is unique
    [TI1{i2}, ia, ~] = unique(TI1{i2});
    AI1{i2} = AI1{i2}(ia);
    CS1{i2} = CS1{i2}(ia);
    axis1 = subplot(runTime,1,i2);
    hold(axis1);
    bar(axis1,TI2,interp1(TI1{i2},AI1{i2},TI2),'BarWidth',1,'EdgeColor','none','FaceColor',[.7,.7,.7]);
    plot(axis1,TI1{i2},CS1{i2},'Color',[0,0,0],'LineWidth',1);
    xlim([0 24]);
    ylim([0 1]);
    set(gca,'XTick',0:6:24,'YTick',0:1)
    set(gca,'YTickLabel','');
    if i2 < runTime
        set(gca,'XTickLabel','');
    end
    
    if i2 == 1
        title(Title);
    end
    ylabel(subTitle{i2});
    set(get(gca,'YLabel'),'Rotation',0);
end

legend1 = legend('Activity','CS');
set(legend1,'Orientation','horizontal','Location','Best');

end
