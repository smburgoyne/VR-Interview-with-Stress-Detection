%% % EDAgraph.m 

% Purpose: Measuring  from Acquired EDA Signals
% process the raw ADC data to visualize EDA measurements.
% Author: Tana Konda
% Date: April 17 2018
% Course: CIS4914, University of Florida
% Comments: Written for Senior Project to process change in Skin Conductance from EDA signals
% collected by Bitalino board and generate graph images to be displayed by website.

%% Read the Acquired Data
% manually copy paste from name of h5 and txt file
h5name = 'opensignals_98D331B210CE_2018-04-11_13-18-48.h5';
fid = fopen('2018-04-11-01-16.txt');

% rest is automated

% load dataset in
EDA_raw = h5read(h5name,'/98:D3:31:B2:10:CE/raw/channel_2');
EDA_raw = EDA_raw';
EDA_raw = double(EDA_raw);

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
durationinsec = numberofsamples / freq; % in seconds. 
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
        case 3 % start of game / office scene
           xlimit2 = dt3*freq; % 3 graphs: [xlimit0 xlimit1] [xlimit1 xlimit2] [xlimit2 numberofsamples]
        otherwise % Record the time at which Game Decisions occur
           if(mod(linecount,2) == 0)
               decisionoccured = dt3*freq;
               decisioncount = decisioncount+1;
               decisions(1,decisioncount) = decisionoccured;
           end
    end
    tline = fgetl(fid);
end
fclose(fid);

%% Scale and Plot Data

% Scale the signal per the specifications of the ECG sensor in the Bitalino
% documentation: http://bitalino.com/datasheets/REVOLUTION_EDA_Sensor_Datasheet.pdf
EDA_adj = ((((EDA_raw./((2.^10)-1))) .* 3.3)./ 0.132) .* 10^(-6); % data to be plotted

% draw graphs
fig1 = figure('Name','Raw Data');
plot(EDA_raw);
fig2 = figure('Name','EDA Graph');
plot(EDA_adj);
xlabel('Samples'); 
ylabel('Siemens(S)');
hold on
grid on

% Adjust the plot to show normal scene data
xlim([xlimit0 xlimit1]);
legend('EDA signal');
saveas(fig2,'EDA_1_normal.jpg')  % here you save the figure

% Adjust the plot to show pit scene data
xlim([xlimit1 xlimit2]);
saveas(fig2,'EDA_1_pit.jpg')  % here you save the figure

% Adjust the plot to show office scene data
xlim([xlimit2 numberofsamples]);

% add decision lines here
for i=1:decisioncount
    xval = decisions(1,i);
    plot([xval xval], ylim,'Color','k','LineStyle','-.','DisplayName','Decision') % Plot Vertical Line
end

saveas(fig2,'EDA_1_office.jpg')  % here you save the figure

% adjust the plot to show overall data
xlim([xlimit0 numberofsamples]);
saveas(fig2,'EDA_1_overall.jpg') 