% src/exp2.m

close all;
clc;

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

Fs = 8e3;
beat = 0.5;

melody_1 = [];
melody_2 = [];

overlap_len = 0;

for i = 1:size(DongFangHong, 1)
    self_time = DongFangHong(i, 2) * beat;
    overlap_time = self_time / 10;
    duration = self_time + overlap_time;

    t = linspace(0, duration, duration * Fs)';
    sub_1 = sin(2 * pi * DongFangHong(i, 1) .* t) .* Adjust_Linear(t / duration);
    sub_2 = sin(2 * pi * DongFangHong(i, 1) .* t) .* Adjust_Exp(t / duration);

    melody_1 = [
                melody_1(1:end - overlap_len);
                melody_1(end - overlap_len + 1:end) + sub_1(1:overlap_len);
                sub_1(overlap_len + 1:end)
                ];

    melody_2 = [
                melody_2(1:end - overlap_len);
                melody_2(end - overlap_len + 1:end) + sub_2(1:overlap_len);
                sub_2(overlap_len + 1:end)
                ];

    overlap_len = overlap_time * Fs; % used in next loop

end

sound(melody_1, Fs);
audiowrite('../results/exp2_1.wav', melody_1, Fs);

plot((0:length(melody_1) - 1) / Fs, melody_1);
title('Dong Fang Hong');
xlabel('Time (s)');
ylabel('Amplitude');
saveas(gcf, '../report/fig2_1.png');

sound(melody_2, Fs);
audiowrite('../results/exp2_2.wav', melody_2, Fs);

plot((0:length(melody_2) - 1) / Fs, melody_2);
title('Dong Fang Hong');
xlabel('Time (s)');
ylabel('Amplitude');
saveas(gcf, '../report/fig2_2.png');
