% src/exp1.m

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

Fs = 8e3; % sampling frequency
beat = 0.5;

sub_melody = cell(1, 1);

for i = 1:size(DongFangHong, 1)
    t = linspace(0, DongFangHong(i, 2) * beat, round(DongFangHong(i, 2) * beat * Fs))';
    sub_melody{i} = sin(2 * pi * DongFangHong(i, 1) .* t);
end

melody = cat(1, sub_melody{:});

sound(melody, Fs);
audiowrite('../results/exp1.wav', melody, Fs);

plot((0:length(melody) - 1) / Fs, melody);
title('Dong Fang Hong');
xlabel('Time (s)');
ylabel('Amplitude');
saveas(gcf, '../report/fig1.png');
