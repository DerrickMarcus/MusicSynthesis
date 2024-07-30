% src/exp8.m

close all;
clc;

load('./resources/Guitar.MAT');

Fs = 8e3;

figure;

% method 1
waveform_1 = wave2proc;
len_1 = round(length(waveform_1) / 10);
spectrum_1 = abs(fft(waveform_1(1:len_1)));
subplot(3, 1, 1);
plot((0:len_1 - 1) * Fs / len_1, spectrum_1);
title('Frequency Spectrum of Method 1');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

% method 2
waveform_2 = wave2proc;
len_2 = round(length(waveform_2));
spectrum_2 = abs(fft(waveform_2));
subplot(3, 1, 2);
plot((0:len_2 - 1) * Fs / len_2, spectrum_2);
title('Frequency Spectrum of Method 2');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

% method 3
waveform_3 = repmat(wave2proc, [20, 1]);
len_3 = length(waveform_3);
spectrum_3 = abs(fft(waveform_3));
subplot(3, 1, 3);
plot((0:len_3 - 1) * Fs / len_3, spectrum_3);
title('Frequency Spectrum of Method 3');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

saveas(gcf, '../report/fig8.png');

% find base waves and harmonic waves
[peaks, locs] = findpeaks(abs(spectrum_3), 'MinPeakHeight', 0.01 * max(abs(spectrum_3)));
peaks = [abs(spectrum_3(1)); peaks(1:end / 2)];
peaks = peaks / peaks(2);
locs = [0; locs(1:end / 2)];
locs = locs * Fs / len_3;
% disp(locs);
% disp(peaks);

f_A = 220;
freq = f_A * 2 .^ (-1:1/12:2 -1/12);

[~, base] = min(abs(freq - locs(2)));
fprintf('Fundamental Frequency: %.3f Hz\n', freq(base));

for i = 1:length(locs)

    if i == 1
        fprintf('DC component, Amplitude: %.3f\n', peaks(i));
    else
        fprintf('Harmoic %d, Amplitude: %.3f\n', i - 1, peaks(i));
    end

end

% for i = 1:length(locs)
%     fprintf('Harmoic %d, Frequency: %.3f Hz, Amplitude: %.3f\n', i, freq(base) * i, peaks(i));
% end
