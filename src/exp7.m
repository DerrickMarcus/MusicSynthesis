% src/exp7.m

close all;
clc;

load("./resources/Guitar.MAT");

Fs = 8e3;

rw_len = length(realwave);

figure;

subplot(3, 1, 1);
plot((0:rw_len - 1) / Fs, realwave);
title('realwave');
xlabel('Time (s)');
ylabel('Amplitude');
% sound(realwave, Fs);

subplot(3, 1, 2);
plot((0:rw_len - 1) / Fs, wave2proc);
title('wave2proc');
xlabel('Time (s)');
ylabel('Amplitude');
% sound(wave2proc, Fs);

re_wave = resample(realwave, 10, 1);
wave_proc = zeros(rw_len, 1);

for i = 1:10
    wave_proc = wave_proc + re_wave((i - 1) * rw_len + 1:i * rw_len);
end

wave_proc = wave_proc / 10;
wave_proc = repmat(wave_proc, [10, 1]);
wave_proc = resample(wave_proc, 1, 10);

sound(wave_proc, Fs);

subplot(3, 1, 3);
plot((0:rw_len - 1) / Fs, wave_proc);
title('realwave after processing');
xlabel('Time (s)');
ylabel('Amplitude');
saveas(gcf, '../report/fig7.png');
