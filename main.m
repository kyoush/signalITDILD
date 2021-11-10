clear; close all force;

v = get(0, 'MonitorPosition');
WIDTH = v(1, 3) * 0.8;
HEIGHT = v(1, 4) * 0.6;
X_MIN = v(1, 3) * 0.1;
Y_MIN = v(1, 4) * 0.1;

H = GUIobj;

H.Mainfig = uifigure(...
    "Position", [X_MIN Y_MIN WIDTH HEIGHT],...
    "Name", "Realtime Calc. ITD&ILD");

xm = 200; ym = HEIGHT*0.1;
w = WIDTH*0.35; h = HEIGHT*0.35;
H.Axes.Lch = uiaxes(H.Mainfig,...
    "Position", [xm ym w h]);
title(H.Axes.Lch, 'Spectrogram Rch')
ylabel(H.Axes.Lch, 'Frequency [Hz]')
xlabel(H.Axes.Lch, 'Time [s]')

xm = xm + w + 50;
H.Axes.ILD = uiaxes(H.Mainfig,...
    "Position", [xm ym w h]);
ylabel(H.Axes.ILD, ['ILD [dB]'])
xlabel(H.Axes.ILD, 'Time [s]')
ym = ym + h + 50;
H.Axes.ITD = uiaxes(H.Mainfig,...
    "Position", [xm ym w h]);
ylabel(H.Axes.ITD, ['ITD [' 956 's]'])
xlabel(H.Axes.ITD, 'Time [s]')
xm = 200;
H.Axes.Rch = uiaxes(H.Mainfig,...
    "Position", [xm ym w h]);
title(H.Axes.Rch, 'Spectrogram Lch')
ylabel(H.Axes.Rch, 'Frequency [Hz]')
xlabel(H.Axes.Rch, 'Time [s]')

tmpH = 40;
xm = 50; ym = ym + h - tmpH;
h = tmpH; w = 90;
H.Button.rec = uibutton(H.Mainfig,...
    "Text", "Rec",...
    "Position", [xm ym w h],...
    "FontName", "Arial",...
    "FontSize", 18,...
    "ButtonPushedFcn", @(obj,eve)H.recFcn);
ym = ym - h - 20;
H.Button.stop = uibutton(H.Mainfig, 'state',...
    "Position", [xm ym w h],...
    "FontName", "Arial",...
    "FontSize", 18,...
    "Text", "Stop");