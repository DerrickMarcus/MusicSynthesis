% src/exp10.m

close all;
clc;

% extract harmonics
load("./resources/Guitar.MAT");
Fs = 8e3;

rw_len = length(realwave);
re_wave = resample(realwave, 10, 1);
wave_proc = zeros(rw_len, 1);

for i = 1:10
    wave_proc = wave_proc + re_wave((i - 1) * rw_len + 1:i * rw_len);
end

wave_proc = wave_proc / 10;
wave_proc = repmat(wave_proc, [10, 1]);
wave_proc = resample(wave_proc, 1, 10);

wave_proc = repmat(wave_proc, [100, 1]);
spect = fft(wave_proc);
plot(abs(spect));

[peaks, ~] = findpeaks(abs(spect), 'MinPeakHeight', 0.01 * max(abs(spect)));

harmonics = peaks(1:end / 2);
harmonics = harmonics / harmonics(1);

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
    % add harmonics
    sub_melody = sin(2 * pi * DongFangHong(i, 1) .* t * (1:length(harmonics))) * harmonics;
    sub_melody = sub_melody .* Adjust_Exp(t / duration);

    melody = [
              melody(1:end - overlap_len);
              melody(end - overlap_len + 1:end) + sub_melody(1:overlap_len);
              sub_melody(overlap_len + 1:end)
              ];

    overlap_len = overlap_time * Fs; % used in next loop

end

melody = melody / max(abs(melody));

sound(melody, Fs);
audiowrite('../results/exp10.wav', melody, Fs);

plot((0:length(melody) - 1) / Fs, melody);
title('Dong Fang Hong (guitar)');
xlabel('Time (s)');
ylabel('Amplitude');
saveas(gcf, '../report/fig10.png');
