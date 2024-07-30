% src/exp6.m

close all;
clc;

% load("./resources/Guitar.MAT");

[guitar, Fs] = audioread('./resources/fmt.wav');
sound(guitar, Fs);

t = linspace(0, length(guitar) / Fs, length(guitar));

figure;
plot(t, guitar);
title('guitar');
xlabel('Time (s)');
ylabel('Amplitude');
saveas(gcf, '../report/fig6.png');
