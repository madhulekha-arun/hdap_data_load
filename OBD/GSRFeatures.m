function [ Feature_Struc ] = GSRFeatures( E4 )
gsrSignal = E4.EDA.data;
ts = E4.EDA.ts;
fs = E4.EDA.fs;

%% filter GSR signal
% Denoise signal
X = abs(gsrSignal);
lev = 6; wavelet = 'sym8';
XD = wden(X,'rigrsure','s','one',lev,wavelet);

figure
plot(gsrSignal); hold on;
plot(XD);
title(['Denoised GSR Level ', num2str(lev)]); 
xlabel('Time (Sec)'); ylabel('Conductance (\muS)');
legend('Original','Denoised');

fc = 0.0004;
ORDER = 2;
Ap = 0.5;
As = 60;
fwc = fc./(fs./2);
[b1,a1] = ellip(ORDER, Ap, As,fwc,'high');

% figure
% freqz(b1,a1);
y = filter(b1,a1,XD);

figure
plot(y);
title('High-pass Filter'); xlabel('Time (Sec)'); ylabel('Conductance (\muS)');
%% Inspect Features
epochLen = 120.*fs;  %  Epoch Length is 120 seconds

% Find Peaks for SCR
SCLall = XD-y;
[~,pkLoc] = findpeaks(y,fs,'MinPeakProminence',0.05,'MinPeakDistance',2,'MinPeakHeight',0.001);
%converting to seconds
pkLoc = pkLoc.*fs;
% to get in seconds
t = [0:numel(y)-1]./fs;
figure
plot(t,y); hold on;

plot(t(pkLoc),y(pkLoc),'r*');
xlabel('Time (Sec)'); ylabel('Conductance (\muS)'); title('Skin Conductance Response on Raw Signal');

% Spectral Analysis
fc = 0.01;
ORDER = 4;
Ap = 0.5;
As = 60;
fwc = fc./(fs./2);
[b2,a2] = ellip(ORDER, Ap, As,fwc,'high');
% figure
% freqz(b,a);
y2 = filter(b2,a2,XD);


% SCL and SCR and SPEC
SCL = [];
SCR = [];
SPEC = [];
f = [];
POWER = [];
j = 1;
for i = 1:epochLen:length(SCLall)-epochLen-1
    SCL(j) = mean(SCLall(i:i+epochLen-1));               % SCL Level
    SCR(j) = sum((pkLoc >= i & pkLoc <= i+epochLen-1));  % SCR Count
    
    [SPEC{j}, f{j}] = pwelch(y2(i:i+epochLen-1),120,60,120,fs);
    if ~isnan(SPEC{j})
        POWER(j) = trapz(SPEC{j}(f{j}>=0.045 & f{j}<=0.25));
    end
    j = j+1;
end
%% Plot SCR and SCL
time = ts + seconds(0:epochLen:length(SCL).*epochLen-1);
%time = seconds(0:epochLen:length(SCL).*epochLen-1);
time.TimeZone = 'America/New_York';

figure
plot(time,SCL);
xlabel('Time'); ylabel('Conductance \muS'); title('Skin Conductance Level');

figure
plot(time,SCR);
xlabel('Time'); ylabel('SCR Count'); title('Skin Response Counts');

% figure
% plot(f{202},10*log10(abs(SPEC{202})))
% xlabel('Frequency (Hz)')
% ylabel('Magnitude (dB)')

figure
plot(time,POWER);
xlabel('Time'); title('Power of Signal Between 0.045 - 0.25 Hz');


end

