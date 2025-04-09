%pr02
%bandpass filter for the extraction of delta, theta, alpha, beta waves

load('data_2.mat');

signal_d = filter(deltaFilter,signal);   % signal_d has only delta signals
signal_t = filter(thetaFilter,signal);   % signal_t has only theta signals
signal_a = filter(alphaFilter,signal);   % signal_a has only alpha signals
signal_b = filter(betaFilter,signal);    % signal_b has only beta signals

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Problem #1: 1 point of the curve appears each W=30*Fs    %
%  (this explains why it doesn't fit perfectly, right?)    %                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
W=30*Fs; %window size is 30s --> in samples --> samples = t*Fs

%yupper envolop--> points of the curve joining local maximum peaks (1 point per W=30s)
%ylower envolop--> points of the curve joining local minimum peaks (1 point per W=30s)
[yupper, ylower] = envelope(signal,W,'rms');    % raw signal envelops
[yupper_d, ylower_d] = envelope(signal_d,W,'rms');  % delta signal envelops
[yupper_t, ylower_t] = envelope(signal_t,W,'rms');  % tetha signal envelops
[yupper_a, ylower_a] = envelope(signal_a,W,'rms');  % alpha signal envelops
[yupper_b, ylower_b] = envelope(signal_b,W,'rms');  % beta signal envelops

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Problem #2: I don't undestand where I must put set(gca,'ylim',[-0.03 0.03])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(5,1,1);
set(gca,'ylim',[-0.03 0.03])
plot(t,signal);
hold on 
plot(t,yupper,'r');
hold on 
plot(t,ylower,'r');
title('Raw Signal');

subplot(5,1,2);
set(gca,'ylim',[-0.03 0.03])
plot(t,signal_d);
hold on 
plot(t,yupper_d,'r');
hold on 
plot(t,ylower_d,'r');
title('Delta Waves');

subplot(5,1,3);
set(gca,'ylim',[-0.03 0.03])
plot(t,signal_t);
hold on 
plot(t,yupper_t,'r');
hold on 
plot(t,ylower_t,'r');
title('Theta Waves');

subplot(5,1,4);
set(gca,'ylim',[-0.03 0.03])
plot(t,signal_a);
hold on 
plot(t,yupper_a,'r');
hold on 
plot(t,ylower_a,'r');
title('Alpha Waves');

subplot(5,1,5);
set(gca,'ylim',[-0.03 0.03])
plot(t,signal_b);
hold on 
plot(t,yupper_b,'r');
hold on 
plot(t,ylower_b,'r');
title('Beta Waves');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPECTROGRAM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f = [0.1:0.1:32];    % frequencies that spectogram will compute
W = 30*Fs;           % window is given in time(s). We need it in samples(n) 
noverlap = 29*Fs;    % noverlap is given in time(s). We need it in samples(n) 
[S,F,T,P] = spectrogram(signal, W,noverlap, f,Fs);

% We got the estimates between frequencies 0.1Hz and 32Hz with 0.1Hz resolution
% This is: between frequencies 1Hz and 4Hz (for example), there are 40 estimates (10:40)
% That makes 320 estimates (different frequencies). P has size 320 ests x 90362 secs
% Delta estimates (10:40),Theta ests (40:80),Alpha ests (80:120),Beta ests (120:250)

totalPower = sum(P);     % vector. Every element is sum of P of all freq for a concrete time

%See Notes1: We are substracting from P the frequencies of interest.
deltaPower = sum(P(10:40,:)); 
thetaPower = sum(P(40:80,:));
alphaPower = sum(P(80:120,:));
betaPower = sum(P(120:250,:));

relativeDelta = deltaPower ./ totalPower;
relativeTheta = thetaPower ./ totalPower;
relativeAlpha = alphaPower ./ totalPower;
relativeBeta = betaPower ./ totalPower;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  SPECTRAL ENTROPY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SE = [];
Nf = length(F);

for i=1:length(P)   %length(P) is lenght of times (not freqs)
    Pn = P(:,i)/sum(P(:,i));                  %normalization --> this way sum(Pn(:,i)) = 1;
    SE(i) = -sum(Pn.*log2(Pn)) / log2(Nf);
       
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Problem #3: What is Nf (frequency bins)?                                    %
% I assumed it was the total number of estimates (320)     This is correct:-D %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%plotting
figure
subplot(3,1,1);
imagesc(T/60,F,log10(P),[-7 -3]);  % this command plots the spectogram
axis xy                            % reflects image vertically
title('Power Spectral Density Estimates');
subplot(3,1,2);
hold on
set(gca,'ylim',[0 1])
plot(T,relativeDelta,'r');
plot(T,relativeTheta,'g');
plot(T,relativeAlpha,'b');
plot(T,relativeBeta,'m');
legend('delta','theta','alpha','beta');
title('Relative Powers');
ylabel('Power (%)');
xlabel('Time (s)');
hold off
subplot(3,1,3);
plot(T,SE);
title('Spectral Entropy');
ylabel('Spectral Entropy (%)');
xlabel('Time (s)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ask about the exam                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

