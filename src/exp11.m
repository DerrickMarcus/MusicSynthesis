% src/exp11.m

close all;
clc;

Fs = 8e3;

load('./harmonics_exp9.mat');

f_A = [220; 440];
freq = f_A * 2 .^ (0:1/12:1 -1/12);

DongFangHong = [
                freq(2, 4), 1;

                freq(2, 4), 0.5;
                freq(2, 6), 0.5;

                freq(1, 11), 2;
                freq(1, 9), 1;

                freq(1, 9), 0.5;
                freq(1, 6), 0.5;

                freq(1, 11), 2;
                ];

beat = 0.5;

melody = [];

overlap_len = 0;

for i = 1:size(DongFangHong, 1)
    self_time = DongFangHong(i, 2) * beat;
    overlap_time = self_time / 10;
    duration = self_time + overlap_time;

    t = linspace(0, duration, duration * Fs)';

    [~, idx] = min(abs(std_freq - DongFangHong(i, 1)));
    % idx = find(std_freq == DongFangHong(i, 1));
    harmo = harmonics{idx};
    sub_melody = sin(2 * pi * DongFangHong(i, 1) * t * (1:length(harmo))) * harmo';
    sub_melody = sub_melody .* Adjust_Exp(t / duration);

    melody = [
              melody(1:end - overlap_len);
              melody(end - overlap_len + 1:end) + sub_melody(1:overlap_len);
              sub_melody(overlap_len + 1:end)
              ];

    overlap_len = overlap_time * Fs; % used in next loop

end

% melody = melody / max(abs(melody));

sound(melody, Fs);
audiowrite('../results/exp11.wav', melody, Fs);

plot((0:length(melody) - 1) / Fs, melody);
title('Dong Fang Hong (guitar)');
xlabel('Time (s)');
ylabel('Amplitude');
saveas(gcf, '../report/fig11.png');
