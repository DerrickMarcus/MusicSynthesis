% src/exp9.m

close all;
clc;

[guitar, Fs] = audioread('./resources/fmt.wav'); % Fs=8000

%
% analyse the beat
%
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

[peaks, locs] = findpeaks(dif, ...
    'MinPeakHeight', 0.015 * max(abs(dif)), ...
    'MinPeakDistance', Fs * 0.15);
hold on;
plot(locs / Fs, peaks, 'ro');

locs = locs - Fs / 20; % adjust the location of the beat

subplot(6, 1, 6);
plot((1:length(guitar)) / Fs, guitar);
hold on;

for i = 1:length(locs)
    line([locs(i), locs(i)] / Fs, ylim, 'Color', 'red', 'LineStyle', '-');
end

saveas(gcf, '../report/fig9_1.png');

%
% analyse the tunes
%
std_freq = 220 * 2 .^ (-1:1/12:2); % standard frequencies

harmonics = cell(1, length(std_freq));

for i = 1:length(locs)

    if i == length(locs)
        wave_gt = guitar(locs(i):end);
    else
        wave_gt = guitar(locs(i):locs(i + 1));
    end

    wave_gt = repmat(wave_gt, [100, 1]);
    spect_gt = abs(fft(wave_gt));

    [sp_peak, sp_loc] = max(spect_gt);
    candidate = (1:sp_loc);
    candidate = candidate(spect_gt(1:sp_loc) > sp_peak / 4);

    for j = 1:length(candidate)
        k = sp_loc / candidate(j);

        if k < 5 && abs(k / round(k) - 1) < 0.05
            result = candidate(j);
            break;
        end

    end

    fund_freq = (result - 1) * Fs / length(spect_gt);
    [~, idx] = min(abs(std_freq - fund_freq));
    fund_freq = std_freq(idx);

    temp_ampls = zeros(1, floor(Fs / 2 / fund_freq));

    for j = 1:floor(Fs / 2 / fund_freq)
        range = round(result * j * (1 - 0.02)):round(result * j * (1 + 0.02));
        temp_ampls(j) = max(spect_gt(range));
    end

    temp_ampls = temp_ampls / temp_ampls(1);

    if isempty(harmonics{idx})
        harmonics{idx} = temp_ampls;
    else
        harmonics{idx} = (harmonics{idx} + temp_ampls) / 2;
    end

end

for i = 1:length(std_freq)

    if isempty(harmonics{i})

        for j = 1:max(i - 1, length(std_freq) - i)

            if (i > j && ~isempty(harmonics{i - j}))
                harmonics(i) = harmonics(i - j);
                break;
            elseif (i + j <= length(std_freq) && ~isempty(harmonics{i + j}))
                harmonics(i) = harmonics(i + j);
                break;
            end

        end

    end

end

save('./harmonics_exp9.mat', 'harmonics', 'std_freq');
