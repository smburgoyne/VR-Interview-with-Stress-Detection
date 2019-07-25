%% % ECGgraphandHRTcalcFinal.m 

% Purpose: Use Acquired ECG Signals and process the raw ADC data 
% to visualize QRS waves and measure heart rate.
% Author: Tana Konda
% Date: April 17 2018
% Course: CIS4914, University of Florida
% Comments: Written for Senior Project to process change in heart rate from ECG signals
% collected by Bitalino board and generate graph images to be displayed by
% website. Also calculate heart rate for each scene. 

% PLEASE NOTE:
% lines 114-155 are mostly taken from the ExampleECGBitalino.m file in the
% Bitalino toolbox. Copyright (c) 2017, MathWorks Instrument Control Toolbox Team 
% link: https://www.mathworks.com/matlabcentral/fileexchange/53983-bitalino-toolbox

%% Plot the Acquired Data
% manually copy paste from name of h5 and txt files
h5name = 'opensignals_98D331B210CE_2018-04-09_15-18-34.h5';
fid = fopen('2018-04-09-03-17.txt');

% rest is automated

% load dataset in
ECG_raw = h5read(h5name,'/98:D3:31:B2:10:CE/raw/channel_3');
ECG_raw = ECG_raw';
ECG_raw = double(ECG_raw);

% get timestamp from dataset
datetime.setDefaultFormats('default','yyyy-MM-dd HH:mm:ss');
timestamp = h5readatt(h5name,'/98:D3:31:B2:10:CE','time');
[Y, M, D, H, MN, S] = datevec(timestamp{1});
if(H>12)
    H = H-12;
end
time_stamp = strcat(num2str(H),':',num2str(MN),':',num2str(round(S)));
datestamp = h5readatt(h5name,'/98:D3:31:B2:10:CE','date');
DataStartTime = datetime([ datestamp{1} ' ' time_stamp]);


% figure out duration of collection period using samples & frequency 
freq = h5readatt(h5name,'/98:D3:31:B2:10:CE','sampling rate');
numberofsamples = h5readatt(h5name,'/98:D3:31:B2:10:CE','nsamples');
durationinsec = double(numberofsamples) / double(freq); % in seconds. 
durationinmin = durationinsec / 60; % in minutes.

xlimit0 = 0;
xlimit1 = 0;
xlimit2 = 0;
decisions = zeros(1,5); % can't make more than 5 picks in our game.
decisioncount = 0;

% read timestamps
tline = fgetl(fid);
linecount = 0;
while ischar(tline)
    linecount=linecount+1;
    C = textscan(tline,'%s %19c'); 
    scene = C{1};
    t = datetime(C{2});
    dt = between(DataStartTime,t);
    dt2 = time(dt);
    dt3 = seconds(dt2); % how many seconds from start to this point
    switch(linecount)
        case 1 % start selected. Venice scene goes on for 30 sec
            xlimit0 = dt3*freq;
            if(xlimit0<=0)
                xlimit0 = 1;
            end
        case 2 % start of pit room scene. Goes on for 100 sec
           xlimit1 = dt3*freq; % samples = seconds * freq
        case 3 % start of game
           xlimit2 = dt3*freq; % 3 graphs: [xlimit0 xlimit1] [xlimit1 xlimit2] [xlimit2 numberofsamples]
        otherwise % record time at which Game Decisions are made
           if(mod(linecount,2) == 0)
               decisionoccured = dt3*freq;
               decisioncount = decisioncount+1;
               decisions(1,decisioncount) = decisionoccured;
           end
    end
    tline = fgetl(fid);
end
fclose(fid);

%% Process the Data to Make Measurements and Visualize Signals
% we calculate mean HRT for 4 timeframes: Venice scene, Pit scene, Office
% scene and Overall.
myqrs = zeros(1,4);
myheartrate = zeros(1,4);

for j=1:4
ECG_selection = zeros(numberofsamples,1);
p = 0.1;
pd = 60;
    switch(j)
        case 1
            % [xlimit0 xlimit1] normal scene
            ECG_selection= ECG_raw(xlimit0:xlimit1, 1);
        case 2
            % [xlimit1 xlimit2] pit scene
            ECG_selection = ECG_raw(xlimit1:xlimit2, 1);
        case 3
            % [xlimit2 numberofsamples] office scene
            ECG_selection = ECG_raw(xlimit2:numberofsamples, 1);
            p = 0.09; % needs to be slightly more accomodating due to long duration of this scene.
        case 4
            % [1 numberofsamples]
            ECG_selection = ECG_raw;
    end
% Scale the signal per the specifications of the ECG sensor
ECG_adj = ((((ECG_selection./((2.^10)-1))-0.5) .* 3.3)./ 1100) .* 1000; % data plotted

%% Code referenced from ExampleECGBitalino.m
% Filter the scaled signal using a Savitzky-Golay filter.
ECG_data = sgolayfilt(ECG_adj, 7, 41); % this reduces the noise in the signal.

t = 1:length(ECG_data);
[~, locs_Rwave] = findpeaks(ECG_data,'MinPeakHeight',p,...
                                    'MinPeakDistance',pd);
% Remove Edge Wave Data                                
locs_Rwave(locs_Rwave < 100 | locs_Rwave > (length(ECG_data) - 100)) = [];
locs_Qwave = zeros(length(locs_Rwave),1);
locs_Swave = zeros(length(locs_Rwave),1);
locs_Qpre  = zeros(length(locs_Rwave),1);
locs_Spost = zeros(length(locs_Rwave),1);
QRS = zeros(length(locs_Rwave),1);

% Find Q and S waves in the signal
for ii = 1:length(locs_Rwave)
    window = ECG_data((locs_Rwave(ii)-80):(locs_Rwave(ii)+80));
    [d_peaks, locs_peaks] = findpeaks(-window, 'MinPeakDistance',40);
    [d,i] = sort(d_peaks, 'descend');
    locs_Qwave(ii) = locs_peaks(i(1))+(locs_Rwave(ii)-80);
    locs_Swave(ii) = locs_peaks(i(2))+(locs_Rwave(ii)-80);
    [d_QRS, locs_QRS] = findpeaks(window, 'MinPeakDistance', 10);
    [max_d, max_i] = max(d_QRS);
    if(max_i==1 || max_i==length(locs_QRS))
        max_i = length(locs_QRS)-2;
    end
    locs_Q_flat = locs_QRS(max_i-1);
    locs_S_flat = locs_QRS(max_i+1);
    locs_Qpre(ii)  = locs_Q_flat+(locs_Rwave(ii)-80);
    locs_Spost(ii) = locs_S_flat+(locs_Rwave(ii)-80);    
    QRS(ii) = locs_S_flat - locs_Q_flat;
end

% Calculate the heart rate
myqrs(1,j) = median(QRS);
myheartrate(1,j) = 60 ./ (median(diff(locs_Rwave)) ./ 100);

locs_all = [locs_Qwave; locs_Rwave; locs_Swave; locs_Qpre; locs_Spost];
ECG_all  = ECG_data(locs_all);

[d,i] = sort(locs_all);
ECG_sort = ECG_all(i);

end

%% Visualize the Raw Data and Measured Heart Rate
fig1 = figure('Name','Raw Data');
plot(ECG_raw);
fig2 = figure('Name','ECG Graph');
hold on
plot(t,ECG_data);

% image became crowded with QRS markers so only kept R marker since RR
% interval is the most important for HRT calculation anyway.

% plot(locs_Qwave,ECG_data(locs_Qwave),'rs','MarkerFaceColor','g','MarkerSize',3);
plot(locs_Rwave,ECG_data(locs_Rwave),'rv','MarkerFaceColor','r','MarkerSize',3);
% plot(locs_Swave,ECG_data(locs_Swave),'rs','MarkerFaceColor','b','MarkerSize',3);
% plot(locs_Qpre, ECG_data(locs_Qpre), 'r>','MarkerFaceColor','c','MarkerSize',3);
% plot(locs_Spost,ECG_data(locs_Spost),'r<','MarkerFaceColor','m','MarkerSize',3);
grid on

% Adjust the plot to show normal scene data
ylim([-1 Inf]);
xlim([xlimit0 xlimit1]);

% make images bigger and increase the scale of X
x0=10;
y0=10;
width=1500;
height=656; 
set(gcf,'units','points','position',[x0,y0,width,height])

% add legend
title(sprintf('QRS = %f ms,  Heart Rate = %f / min', myqrs(1,1), myheartrate(1,1)));
xlabel('Samples'); ylabel('Voltage(mV)')
% legend('ECG signal','Q-wave','R-wave','S-wave','Q-pre','S-post');
legend('ECG signal','R-wave');
saveas(fig2,'ECG_1_normal.jpg')  % here you save the figure

% Adjust the plot to show pit scene data
xlim([xlimit1 xlimit2]);
title(sprintf('QRS = %f ms,  Heart Rate = %f / min', myqrs(1,2), myheartrate(1,2)));

saveas(fig2,'ECG_1_pit.jpg')  % here you save the figure

% Adjust the plot to show office scene data
xlim([xlimit2 numberofsamples]);
title(sprintf('QRS = %f ms,  Heart Rate = %f / min', myqrs(1,3), myheartrate(1,3)));

% add decision lines here

for i=1:decisioncount
    xval = decisions(1,i);
    plot([xval xval], ylim,'Color','k','LineStyle','-.','DisplayName','Decision') % Plot Vertical Line
end

saveas(fig2,'ECG_1_office.jpg')  % here you save the figure

% Adjust the plot to show office scene data
xlim([0 numberofsamples]);
title(sprintf('QRS = %f ms,  Heart Rate = %f / min', myqrs(1,4), myheartrate(1,4)));

saveas(fig2,'ECG_1_overall.jpg')  % here you save the figure