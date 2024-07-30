% src/exp9.m

close all;
clc;

[guitar, Fs] = audioread('./resources/fmt.wav'); % Fs=8000

% analyse the beat
figure;

subplot(6, 1, 1);
plot((1:length(guitar)) / Fs, guitar);

sq = guitar .^ 2;
subplot(6, 1, 2);
plot((1:length(sq)) / Fs, sq);

con = conv(sq, barthannwin(round(Fs / 10)));
subplot(6, 1, 3);
plot((1:length(con)) / Fs, con);

dif = con(2:end) - con(1:end - 1);
subplot(6, 1, 4);
plot((1:length(dif)) / Fs, dif);

dif = dif .* (dif > 0);
subplot(6, 1, 5);
plot((1:length(dif)) / Fs, dif);

[peaks, locs] = findpeaks(dif, 'MinPeakHeight', 0.01 * max(abs(dif)), 'MinPeakDistance', Fs / 5);
locs = locs / Fs;
hold on;
plot(locs, peaks, 'ro');

subplot(6, 1, 6);
plot((1:length(guitar)) / Fs, guitar);
hold on;
plot(locs, zeros(size(locs)), 'ro');

saveas(gcf, "../report/fig9_1.png");

% analyse the tunes
wave_gt = repmat(guitar, [100, 1]);
spect_gt = abs(fft(wave_gt));

figure;

subplot(2, 1, 1);
plot((0:length(spect_gt) - 1) * Fs / length(spect_gt), spect_gt);
title('Frequency Spectrum of Guitar');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

f_A = 220;
std_freq = f_A * 2 .^ (-1:1/12:2 -1/12); % standard frequencies

[peak, loc] = max(spect_gt);
candidate = (1:loc);
candidate = candidate(spect_gt(1:loc) > peak / 4);

for i = 1:length(candidate)
    k = loc / candidate(i);

    if k < 5 && abs(k / round(k) - 1) < 0.005
        result = candidate(i);
        break;
    end

end

fund_freq = (result - 1) * Fs / length(spect_gt);
[~, idx] = min(abs(std_freq - fund_freq));
fund_freq = std_freq(idx);

harmonics = zeros(1, floor(Fs / 2 / fund_freq));
ampls = zeros(1, floor(Fs / 2 / fund_freq));
locs = zeros(1, floor(Fs / 2 / fund_freq));

for i = 1:floor(Fs / 2 / fund_freq)
    range = round(result * i * (1 - 0.02)):round(result * i * (1 + 0.02));
    [ampls(i), locs(i)] = max(spect_gt(range));
    locs(i) = locs(i) + range(1) - 1;
    harmonics(i) = max(spect_gt(range));
end

harmonics = harmonics / harmonics(1);

subplot(2, 1, 2);
plot((0:length(spect_gt) / 2 - 1) * Fs / length(spect_gt), spect_gt(1:end / 2));
hold on;
plot(locs * Fs / length(spect_gt), ampls, 'ro');
title('Frequency Spectrum of Guitar (0-4KHz)');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

saveas(gcf, '../report/fig9_2.png');

save('./harmonics_exp9.mat', 'harmonics');
