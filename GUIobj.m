classdef GUIobj < handle
    properties
        Mainfig
        Params
        Menu
        Button
        ButtonGroup
        RadioButton
        Slider
        Axes
        Text
        EditBox
    end
    
    methods
        function recFcn(H)
            fl = 1024;
            T = 3;
            Fs = 48000;
            bufferLen = round(T*Fs/fl);
            NFFT = 4096;
            specMatL = zeros(NFFT, bufferLen);
            specMatR = zeros(NFFT, bufferLen);
            ildArray = zeros(bufferLen, 1);
            itdArray = zeros(bufferLen, 1);
            
            time = linspace(0, T, bufferLen);
            df = Fs/NFFT;
            freq = df:df:Fs;
           
            adr = audioDeviceReader(...
                "Driver", "ASIO",...
                "Device", "Yamaha Steinberg USB ASIO",...
                "SampleRate", Fs,...
                "SamplesPerFrame", fl,...
                "NumChannels", 2);
            
            freqMax = 10000;

            imagesc(H.Axes.Lch, time, freq, specMatL);
            colormap(H.Axes.Lch, 'jet')
            caxis(H.Axes.Lch, [-40 40])
            xlim(H.Axes.Lch, [0 T])
            H.Axes.Lch.YDir = 'normal';
            ylim(H.Axes.Lch, [0 freqMax])
            yticklabels(H.Axes.Lch, {'0','5k', '10k', '15k', '20k'})
            
            imagesc(H.Axes.Rch, time, freq, specMatR);
            colormap(H.Axes.Rch, 'jet')
            caxis(H.Axes.Rch, [-40 40])
            xlim(H.Axes.Rch, [0 T])
            H.Axes.Rch.YDir = 'normal';
            ylim(H.Axes.Rch, [0 freqMax])
            yticklabels(H.Axes.Rch, {'0','5k', '10k', '15k', '20k'})
            
            plot(H.Axes.ITD, time, itdArray);
            xlim(H.Axes.ITD, [0 T])
            ylim(H.Axes.ITD, [-1000 1000])
            grid(H.Axes.ITD, 'on')
            
            plot(H.Axes.ILD, time, ildArray);
            xlim(H.Axes.ILD, [0 T])
            ylim(H.Axes.ILD, [-15 15])
            grid(H.Axes.ILD, 'on')

            order = 512; % points
            Fp = 1500; % Hertz
            Ap = 0.1; % dB
            Ast = 60; % dB
            lpfilt = designfilt('lowpassfir',...
                "FilterOrder", order,...
                "CutoffFrequency", Fp,...
                "PassbandRipple", Ap,...
                "StopbandAttenuation", Ast,...
                "SampleRate", Fs);

            win = hann(fl);
            while ~H.Button.stop.Value
                sig = adr();
                
                tmpL = H.Axes.Lch.Children.CData;
                specL = 20*log10(abs(fft(sig(:, 1).*win, NFFT)));
                H.Axes.Lch.Children.CData = [tmpL(:, 2:end) specL];
                
                tmpR = H.Axes.Rch.Children.CData;
                specR = 20*log10(abs(fft(sig(:, 2).*win, NFFT)));
                H.Axes.Rch.Children.CData = [tmpR(:, 2:end) specR];
                
%                 [r, lags] = xcorr(filter(lpfilt, sig(:, 1)), filter(lpfilt, sig(:, 2)));
                [r, lags] = xcorr(sig(:, 1), sig(:, 2));
                [~, L] = max(r);
                tmpITD = lags(L)/Fs*10^6;
                itdArray = H.Axes.ITD.Children.YData;
                H.Axes.ITD.Children.YData = [itdArray(2:end) tmpITD];
                
                tmpILD = 20*log10(rms(sig(:, 2)/rms(sig(:, 1))));
                ildArray = H.Axes.ILD.Children.YData;
                H.Axes.ILD.Children.YData = [ildArray(2:end) tmpILD];
                
                drawnow limitrate
            end
            H.Button.stop.Value = 0;
        end
    end
end