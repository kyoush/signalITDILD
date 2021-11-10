%% Gen Lowpass-filter
clear
close all

Fs = 48000; % Hertz
order = 512; % points
Fp = 1500; % Hertz
Ap = 0.1; % dB
Ast = 60; % dB
filt = designfilt('lowpassfir',...
    "FilterOrder", order,...
    "CutoffFrequency", Fp,...
    "PassbandRipple", Ap,...
    "StopbandAttenuation", Ast,...
    "SampleRate", Fs);

n = 4096;
[z, f] = freqz(filt, n, 'whole', Fs);
semilogx(f, 20*log10(abs(z)))
xlabel_freq
grid on