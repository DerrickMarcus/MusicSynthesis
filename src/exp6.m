% src/exp6.m

close all;
clc;

% load("./resources/Guitar.MAT");

[guitar, Fs] = audioread('./resources/fmt.wav');
sound(guitar, Fs);

figure;
plot((0:length(guitar) - 1) / Fs, guitar);
title('guitar');
xlabel('Time (s)');
ylabel('Amplitude');
saveas(gcf, '../report/fig6.png');
