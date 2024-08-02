% src/exp9.m

close all;
clc;

[guitar, Fs] = audioread('./resources/fmt.wav'); % Fs=8000

%
% analyse the beat
%
figure;

subplot(5, 1, 1);
plot((0:length(guitar) - 1) / Fs, guitar);

subplot(5, 1, 2);
envelope = abs(hilbert(guitar));
cutoff_freq = 6; % cut-off frequency
[b, a] = butter(2, cutoff_freq / (Fs / 2), 'low'); % 2nd order low-pass filter
smooth_envelope = filtfilt(b, a, envelope);
plot((0:length(smooth_envelope) - 1) / Fs, smooth_envelope);

subplot(5, 1, 3);
dif = smooth_envelope(2:end) - smooth_envelope(1:end - 1);
plot((0:length(dif) - 1) / Fs, dif);

subplot(5, 1, 4);
dif = dif .* (dif > 0);
plot((0:length(dif) - 1) / Fs, dif);
hold on;

[peaks, locs] = findpeaks(dif, 'MinPeakHeight', 0.02 * max(abs(dif)), 'MinPeakDistance', Fs * 0.15);
plot(locs / Fs, peaks, 'ro');

subplot(5, 1, 5);
plot((0:length(guitar) - 1) / Fs, guitar);
hold on;

% locs = locs - Fs / 100;

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

    % start..............................................
    %
    fund_freq = sp_loc * Fs / length(spect_gt);
    [~, idx] = min(abs(std_freq - fund_freq));
    fund_freq = std_freq(idx);
    disp(fund_freq);

    temp_ampls = zeros(1, floor(Fs / 2 / fund_freq));

    for j = 1:floor(Fs / 2 / fund_freq)
        middle = j * fund_freq / Fs * length(spect_gt);
        temp_ampls(j) = max(spect_gt(round(middle * (1 - 0.05)):round(middle * (1 + 0.05))));
    end

    temp_ampls = temp_ampls / temp_ampls(1);
    disp(temp_ampls);
    %
    %  end................................................

    % candidate = (1:sp_loc);
    % candidate = candidate(spect_gt(1:sp_loc) > sp_peak / 4);

    % for j = 1:length(candidate)
    %     k = sp_loc / candidate(j);

    %     if k < 5 && 0.98 < k / round(k) && k / round(k) < 1.02
    %         result = candidate(j);
    %         break;
    %     end

    % end

    % fund_freq = (result - 1) * Fs / length(spect_gt);
    % [~, idx] = min(abs(std_freq - fund_freq));
    % fund_freq = std_freq(idx);
    % disp(fund_freq);

    % temp_ampls = zeros(1, floor(Fs / 2 / fund_freq));
    % amplss = zeros(1, floor(Fs / 2 / fund_freq));
    % locss = zeros(1, floor(Fs / 2 / fund_freq));

    % for j = 1:floor(Fs / 2 / fund_freq)
    %     range = round(result * j * (1 - 0.02)):round(result * j * (1 + 0.02));
    %     [amplss(j), locss(j)] = max(spect_gt(range));
    %     locss(j) = locss(j) + range(1) - 1;
    %     temp_ampls(j) = max(spect_gt(range));

    % end

    % temp_ampls = temp_ampls / temp_ampls(1);
    % disp(temp_ampls);

    % if i == 3
    %     % disp(fund_freq);
    %     figure;
    %     subplot(2, 1, 1);
    %     plot((-length(spect_gt) / 2:length(spect_gt) / 2 - 1) * Fs / length(spect_gt), fftshift(spect_gt));
    %     title('Frequency Spectrum');
    %     xlabel('Frequency (Hz)');
    %     ylabel('Amplitude');
    %     subplot(2, 1, 2);
    %     plot((0:length(spect_gt) / 2 - 1) * Fs / length(spect_gt), spect_gt(1:end / 2));
    %     hold on;
    %     plot(locss * Fs / length(spect_gt), amplss, 'o');
    %     title('Frequency Spectrum (0-4KHz)');
    %     xlabel('Frequency (Hz)');
    %     ylabel('Amplitude');
    %     saveas(gcf, '../report/fig9_2.png');
    % end

    if isempty(harmonics{idx})
        harmonics{idx} = temp_ampls;
    else
        harmonics{idx} = (harmonics{idx} + temp_ampls) / 2;
    end

end

for i = 1:length(std_freq)

    if isempty(harmonics{i})
        left_idx = i - 1;

        while left_idx > 0 && isempty(harmonics{left_idx})
            left_idx = left_idx - 1;
        end

        right_idx = i + 1;

        while right_idx <= length(std_freq) && isempty(harmonics{right_idx})
            right_idx = right_idx + 1;
        end

        if 0 < left_idx && right_idx <= length(std_freq)

            if size(harmonics{left_idx}, 2) > size(harmonics{right_idx}, 2)
                harmonics{right_idx} = [harmonics{right_idx}, zeros(1, size(harmonics{left_idx}, 2) - size(harmonics{right_idx}, 2))];
            else
                harmonics{left_idx} = [harmonics{left_idx}, zeros(1, size(harmonics{right_idx}, 2) - size(harmonics{left_idx}, 2))];
            end

            weight_left = (std_freq(right_idx) - std_freq(i)) / (std_freq(right_idx) - std_freq(left_idx));
            weight_right = 1 - weight_left;
            harmonics{i} = weight_left * harmonics{left_idx} + weight_right * harmonics{right_idx};
        elseif 0 < left_idx
            harmonics{i} = harmonics{left_idx};
        elseif right_idx <= length(std_freq)
            harmonics{i} = harmonics{right_idx};
        end

    end

end

save('./harmonics_exp9.mat', 'harmonics', 'std_freq');
