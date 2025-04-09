topoplot([],'channelLocations.locs')
EEG = load('data_multichannel.mat');
signal = EEG.signal;
Fs = EEG.Fs;
t = EEG.t;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPECTROGRAM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s = size(signal)
f = [0.1:0.1:32];    % frequencies that spectogram will compute
W = 30*Fs;           % window is given in time(s). We need it in samples(n) 
noverlap = 29*Fs;    % noverlap is given in time(s). We need it in samples(n) 

P_sum = zeros(320,422);   % Here we will store P of all electrodes (sum of all channels)
P_front = zeros(320,422); % Here we will store P of front electrodes (sum of F7,F8,Fz,Fpz)
P_back = zeros(320,422);  

% We got the estimates between frequencies 0.1Hz and 32Hz with 0.1Hz resolution
% This is: between frequencies 1Hz and 4Hz (for example), there are 40 estimates (10:40)
% That makes 320 estimates (different frequencies). P has size 320 ests x 90362 secs
% Delta estimates (10:40),Theta ests (40:80),Alpha ests (80:120),Beta ests (120:250)

relativeDeltaAll = zeros(13,422); % Here we will store relative delta for every channel
relativeAlphaAll = zeros(13,422); % Here we will store relative alpha for every channel
totalPowerAll = zeros(13,422);    % Here we will store the total power for every channel
totalPowerFront = zeros(4,422);   % Here we will store P of front electrodes (sum of F7,F8,Fz,Fpz)
totalPowerBack = zeros(4,422);    % Here we will store P of  back electrodes (sum of P4,P34,Pz,Oz)
fr = 1, ba = 1;                   % These are indexes for front and back matrix

for i = 1:13  
       
[S,F,T,P] = spectrogram(signal(i,:), W,noverlap, f,Fs); %vector

if (i==1|| i==4 || i==3 || i==10) %These are front electrodes F7,F8,Fz,Fpz (positions got in 'channelNames')
 totalPowerFront(fr,:) = sum(P);
 fr = fr+1;   
end 

if (i==7 || i==9 || i==12 || i==13) %These are back electrodes P4,P34,Pz,Oz (positions got in 'channelNames')
 totalPowerBack(ba,:) = sum(P);
 ba = ba+1;
end 

deltaPower = P(10:40,:); 
alphaPower = P(80:120,:);

totalPower = sum(P); % vector. Every element is sum of P of all freq for a concrete time

relativeDelta = sum(P(10:40,:)) ./ sum(P);  % Get the relative delta for the #i channel
relativeAlpha = sum(P(80:120,:)) ./ sum(P); % Get the relative alpha for the #i channel

totalPowerAll(i,:) = totalPower;       % Every row is the totalPower (vector) of  the #i channel
relativeDeltaAll(i,:) = relativeDelta; % Every row is the relativeAlpha (vector) of  the #i channel
relativeAlphaAll(i,:) = relativeAlpha; % Every row is the relativeDelta (vector) of  the #i channel
end


%We are working with T (time vector in minutes)
%topoplot wants: a spectrogram vector
%P is a spectrogram matrix (spectogram vectors for every minute)
%We select minutes 2,5,7

% Problem: How to handle the asked minutes??

% I assumed T has round seconds. 
t1=1;
t2=find(T==2*60);  %Get the position in T where there is t=2 min ( * 60 to get seconds. T is in seconds)
t3=find(T==5*60);  %Get the position in T where there is t=5 min ( * 60 to get seconds. T is in seconds)
t4=find(T==7*60);  %Get the position in T where there is t=7 min ( * 60 to get seconds. T is in seconds)


subplot(1,4,1)
topoplot(log10(totalPowerAll(:,t1)),'channelLocations.locs','maplimits','maxmin');
subplot(1,4,2)
topoplot(log10(totalPowerAll(:,t2)),'channelLocations.locs','maplimits','maxmin');
title('                                        Spectrogram')
subplot(1,4,3)
topoplot(log10(totalPowerAll(:,t3)),'channelLocations.locs','maplimits','maxmin');
subplot(1,4,4)
topoplot(log10(totalPowerAll(:,t4)),'channelLocations.locs','maplimits','maxmin');

colormap(flipud(jet));

% Crear la barra de color en una posición adecuada
h = colorbar('Position', [0.92 0.15 0.02 0.7]);  % [left bottom width height]

% Ajustar los límites de la barra de color para que sean consistentes
caxis([min(log10(totalPowerAll(:))) max(log10(totalPowerAll(:)))]);

% Etiquetar la barra de color
h.Label.String = 'Potencia (uV^2/Hz)';

figure

subplot(2,1,1)
plot(T,sum(totalPowerFront));
title('Sum of Total Powers of Channels of Front')
xlabel('Time (s)')
ylabel('Power (dB)')
subplot(2,1,2)
plot(T,sum(totalPowerBack));
title('Sum of Total Powers of Channels of Back')
xlabel('Time (s)')
ylabel('Power (dB)')

figure

subplot(2,4,1)
topoplot(relativeAlphaAll(:,t1),'channelLocations.locs','maplimits',[0,1]);
subplot(2,4,2)
topoplot(relativeAlphaAll(:,t2),'channelLocations.locs','maplimits',[0,1]);
subplot(2,4,3)
topoplot(relativeAlphaAll(:,t3),'channelLocations.locs','maplimits',[0,1]);
subplot(2,4,4)
topoplot(relativeAlphaAll(:,t4),'channelLocations.locs','maplimits',[0,1]);
subplot(2,4,5)
topoplot(relativeDeltaAll(:,t1),'channelLocations.locs','maplimits',[0,1]);
subplot(2,4,6)
topoplot(relativeDeltaAll(:,t2),'channelLocations.locs','maplimits',[0,1]);
subplot(2,4,7)
topoplot(relativeDeltaAll(:,t3),'channelLocations.locs','maplimits',[0,1]);
subplot(2,4,8)
topoplot(relativeDeltaAll(:,t4),'channelLocations.locs','maplimits',[0,1]);
